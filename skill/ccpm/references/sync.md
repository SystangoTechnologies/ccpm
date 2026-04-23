# Sync — Push to Jira & Track Progress

This phase covers pushing local epics and work items to Jira, keeping keys in sync, closing issues, completing epics, and capturing bugs — **PM and tracker operations only** (no dev execution or progress-from-code pipelines).

---

## Jira MCP Preflight

Always discover and validate Jira context before creating issues:

1. `getAccessibleAtlassianResources` -> select `cloudId`
2. `getVisibleJiraProjects(cloudId)` -> confirm `projectKey`
3. `getJiraProjectIssueTypesMetadata(cloudId, projectKey)` -> detect available issue types
4. `getJiraIssueTypeMetaWithFields(cloudId, projectKey, issueTypeId)` -> detect required fields and hierarchy support

If discovery fails, stop and ask the user to authenticate Atlassian MCP.

---

## Epic Sync — Push Epic + Tasks to Jira

Trigger: User wants to push a local epic and its tasks to Jira as issues.

### Preflight
- Verify `epics/<name>/epic.md` exists.
- Verify `T*.md` task files exist — if none: "❌ No tasks to sync. Decompose the epic first."

### Process

Step 1 — Discover project-adaptive hierarchy:

- Detect issue type IDs for available Jira levels (Epic, Story, Task, Subtask or project equivalents).
- Build a creation plan:
  - top level issue from `epic.md`
  - child issues from `T*.md`
  - parent field or `createIssueLink` fallback

Step 2 — Create epic issue:

- **Summary**: Use the first Markdown H1 line in `epic.md` (strip leading `#` / whitespace) as the Jira epic **summary**. It should be a **short epic title** only — no `EPIC:` or `[Project/Area] |` prefix. If there is no H1, fall back to a title derived from the epic folder name with human review.
- **Parent**: If the Jira project supports a parent/initiative field, set it from the epic body section **`## Parent`** (issue key or URL resolved to key) before or immediately after create, per `getJiraIssueTypeMetaWithFields`.

Strip frontmatter from `epic.md`, then create the top-level Jira issue:
```bash
sed '1,/^---$/d; 1,/^---$/d' epics/<name>/epic.md > /tmp/epic-body.md
# MCP: createJiraIssue(
#   cloudId, projectKey, issueTypeName=<detected_epic_type>, summary=<first H1 from epic.md>,
#   description=<epic body>, parent=<initiative key if required and supported>
# )
# -> returns epic key (e.g., PROJ-123)
```

Step 3 — Create child issues from local task files:

- Iterate `T*.md` work items in an order that respects **`depends_on`** and **story → Sub-task** ordering: create each **Story** before any `ticket_type: subtask` rows that reference it via `for_story: <that story task_id>`, so each Sub-task’s Jira **parent** can be the story’s `jira_key`.
- Parse `ticket_type`, `name`, `depends_on`, `parallel`, `conflicts_with`, `for_story`, and body content.
- **Issue type mapping:** `story` → Story (or project equivalent); `task` → Task; `subtask` → **Sub-task** (detect exact name from `getJiraProjectIssueTypesMetadata`); `bug` → Bug.
- **Parent selection:** If `ticket_type: subtask` and `for_story` is set, parent to that **story’s** Jira issue (required). If `ticket_type: story` or `ticket_type: task` or `ticket_type: bug`, parent to the **epic** (or hierarchy your metadata defines). Never attach a Sub-task to the epic while skipping its story when a story parent exists.
- Create each issue with `createJiraIssue` using the mapped issue type from `ticket_type` (if missing, stop and fix locally — do not guess).
- If parent is supported on create, set `parent`.
- Otherwise create first and connect with `createIssueLink`.

Per task:
```bash
sed '1,/^---$/d; 1,/^---$/d' <task_file> > /tmp/task-body.md
# MCP: createJiraIssue(cloudId, projectKey, issueTypeName=<detected_child_type>, summary=<task_name>, description=<task body>, parent=<optional>)
# If no parent support:
# MCP: createIssueLink(cloudId, inwardIssue=<child>, outwardIssue=<epic>, type=<selected_link_type>)
```

Step 4 — **Jira dependency links (blocked by / blocks)**

After every child issue has a **`jira_key`** in frontmatter (or in `tracker-mapping.md`):

- For each `T###.md` with non-empty `depends_on`, resolve each listed `task_id` to its **`jira_key`** (blocker issue).
- For each blocking pair, call **`createIssueLink`** (or project-supported bulk link API) so Jira’s graph matches local intent. Typical mapping:
  - inward issue = **blocked** work item (the dependent)
  - outward issue = **blocker**
  - link type = project’s **is blocked by** (or equivalent; confirm name from Jira link metadata — not all projects name it identically).
- Also create **blocks** links in the reverse direction if your process requires both directions; otherwise one direction is enough if Jira UI shows it correctly.
- **Do not** rely on prose inside **Task** or **Sub-task** descriptions for blockers — the **issue link** is the source of truth. Do **not** add or maintain a `## Dependencies` section on those types. For **Story** (or **Epic**) only, if a `## Dependencies` section exists and should stay in sync with links, you may align prose with **Jira keys**; otherwise omit the section.

If a blocker has no `jira_key` yet, create blocker issues first (respect `depends_on` order in Step 3), then run this step.

Step 5 — Update frontmatter (no task renaming):

```bash
current_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
# Update jira_key:, jira_url:, and updated: fields in epic.md and each task file
# epic.md <- jira_key: PROJ-123
# T001.md <- jira_key: PROJ-124
sed -i.bak "/^updated:/c\\updated: $current_date" <file>
rm <file>.bak
```

Step 6 — Create `tracker-mapping.md`:
```markdown
# Jira Issue Mapping
Tracker: jira
Cloud ID: <cloudId>
Project: <projectKey>
Epic: <PROJ-123> - https://<site>.atlassian.net/browse/<PROJ-123>
Tasks:
- T001 -> <PROJ-124> - https://<site>.atlassian.net/browse/<PROJ-124>
- T002 -> <PROJ-125> - https://<site>.atlassian.net/browse/<PROJ-125>
Synced: <datetime>
```

Output:
```
✅ Synced epic <name> to Jira
  Epic: <PROJ-123>
  Tasks: N linked issues
  Dependency links: created from depends_on → Jira keys
  Next: update Jira statuses as the team delivers; keep **`depends_on`** in YAML for scripts; Task/Sub-task bodies stay **without** `## Dependencies` (blockers live as Jira links only).
```

---

## Closing an Issue

Trigger: User marks a task complete.

### Process

1. Find the local task file (`epics/*/T###.md`) and resolve `jira_key`.
2. Update frontmatter: `status: closed`, `updated: <now>`.
3. Post completion comment in Jira and transition issue to done/closed:
```bash
# MCP: add comment "Task completed — all acceptance criteria met."
# MCP: transition issue to done
```
4. Recalculate and update epic progress: `progress = closed_tasks / total_tasks * 100`

---

## Completing an Epic

Trigger: User wants to close out a completed epic in Jira and local files (code merge and git workflow are **out of scope** for this document — handle in your repo however your team works).

### Preflight
- Warn if any mapped Jira issues are still open.

### Process

1. Transition the Jira epic to done (MCP) with a comment that reflects delivery (e.g. epic completed).
2. Update `epics/<name>/epic.md` frontmatter: `status: completed`, `updated: <now>`, and `progress` if you track it.
3. Optionally move `epics/<name>/` to `epics/archived/<name>/` for housekeeping.

---

## Reporting a Bug Against a Completed Issue

Trigger: User finds a bug while testing a completed or in-progress task — e.g. "found a bug in task T001", "email validation is broken, came up while testing PROJ-42".

The workflow should stay automated: create a linked bug task without losing context from the original issue.

### Process

Step 1 — Read the original issue for context:
```bash
# MCP/JQL lookup for <original_jira_key>
```
Also read the local task file if it exists: `epics/*/T###.md`

Step 2 — Create a local bug task file:

```markdown
---
ticket_type: bug
name: <Title — short summary of the bug>
task_id: T###
status: open
created: <run: date -u +"%Y-%m-%dT%H:%M:%SZ">
updated: <same>
jira_key: (will be set on sync)
depends_on: []
parallel: false
conflicts_with: []
bug_for: <original_task_id_or_jira_key>
---

## Description

Context: found while working on / testing <original_task_id_or_jira_key> (<original title>).

What's wrong (include examples, logs, images as needed):

## Steps to Reproduce

## Expected Behavior

## Actual Behavior
```

Save to `epics/<same_epic_as_original>/T###.md`

Step 3 — Create a linked Jira issue:
```bash
# MCP: createJiraIssue(... issueTypeName=Bug ...)
# Then parent/link to original issue with createIssueLink if needed
```

The issue body should open with `Follow-up to <original_jira_key>` to keep traceability.

Step 4 — Update the local file with `jira_key` and `jira_url`.

Output:
```
✅ Bug issue created: <PROJ-222> — "Bug: <short description>"
  Linked to: <original_task_id_or_jira_key>
  Epic: <epic_name>

Next: triage in Jira and assign to the delivery team.
```
