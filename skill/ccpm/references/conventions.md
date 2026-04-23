# Conventions — File Formats, Paths & Rules

Read this before doing any file operations across all phases.

---

## Directory Structure

```
prds/
└── <feature-name>.md
epics/
├── <feature-name>/
│   ├── epic.md
│   ├── T###.md
│   ├── tracker-mapping.md
└── archived/<feature-name>/
context/
docs/
└── (optional: ADRs, guides, diagrams — see docs/README.md)
```

---

## Frontmatter Schemas

### PRD (prds/<name>.md)
```yaml
---
name: <feature-name>
description: <one-liner>
status: backlog | active | completed
created: <ISO 8601>
---
```

### Epic (epics/<name>/epic.md)
```yaml
---
name: <feature-name>
tracker: jira
status: backlog | in-progress | completed
created: <ISO 8601>
updated: <ISO 8601>
progress: 0%
prd: prds/<name>.md
jira_key: <PROJECT-123>
jira_url: https://<site>.atlassian.net/browse/<PROJECT-123>
---
```

The epic body’s first `#` line is the Jira **Epic summary/title**: a **short name only** — no `EPIC:` prefix and no `[Project/Area] |` prefix (area/project is understood elsewhere). **Body sections must match the Jira Epic template only** (headings and order): Epic Description, Objective/Goal, Value/Benefits, In Scope/Out of scope, Dependencies, Links, Parent. See `references/plan.md`.

### Task (epics/<name>/T###.md)

Jira **Task** (not a Sub-task under a story).

```yaml
---
task_id: T010
ticket_type: task
name: <Task Title>
status: open | in-progress | closed
created: <ISO 8601>
updated: <ISO 8601>
jira_key: <PROJECT-124>
jira_url: https://<site>.atlassian.net/browse/<PROJECT-124>
depends_on: []
parallel: true
conflicts_with: []
---
```

Use `ticket_type: task` for the above. Do **not** set `for_story` on tasks (that field is for **subtasks** only).

**Summary / `name` (Task and Sub-task):** Start with a **surface prefix** so work is filterable in Jira: `FE:`, `BE:`, or `Mobile:` (capitalisation as shown), then a short title — e.g. `FE: Landing route shell and layout`, `BE: Public config API for landing`, `Mobile: Marketing landing WebView shell`. Use the prefix that matches where the work primarily lands; if work is evenly split, split into separate tasks/subtasks per surface.

**Summary / `name` (Story):** Outcome-focused; **do not** prefix with `FE:` / `BE:` / `Mobile:` (those prefixes are for Task / Sub-task only).

### Subtask (epics/<name>/T###.md)

Local representation of a Jira **Sub-task** whose **parent** is a **Story** issue.

```yaml
---
task_id: T002
ticket_type: subtask
name: <Sub-task summary>
status: open | in-progress | closed
created: <ISO 8601>
updated: <ISO 8601>
jira_key: <PROJECT-125>
jira_url: https://<site>.atlassian.net/browse/<PROJECT-125>
depends_on: []
parallel: true
conflicts_with: []
for_story: T001
---
```

**Required:** `for_story` is the local `task_id` of the parent **Story** (`ticket_type: story`). The Sub-task **body** uses the **same sections as Task** (see Jira ticket structure template). Sub-task **`name`** must use the same **`FE:` / `BE:` / `Mobile:`** prefix rule as Tasks.

---

## Description hygiene (Jira-bound content)

Do **not** add any of the following inside **User Story**, **Summary**, **Description**, **Technical Requirements**, or other sections that sync to Jira:

- Lines like `Local CCPM: task_id T001 · epic <folder>`
- Footers that reference local-only paths, `task_id`, or epic folder names for “tracking”
- Any boilerplate whose only purpose is CCPM metadata

Keep issue bodies **identical to what a human would expect in Jira**: template sections and real product/engineering content only. Local IDs belong in **YAML frontmatter** and in `tracker-mapping.md`, not in the description narrative. Do not use `(optional)` or similar qualifiers **inside Markdown heading text** — optional content is expressed by **omitting** the section.

---

## Dependencies: frontmatter and Jira (no Task/Sub-task body section)

- **`depends_on` in YAML** (on `T###.md`): machine-local graph — list blocking **`T###`** ids (scripts + sync ordering + link creation).
- **Task and Sub-task bodies:** do **not** include a `## Dependencies` section (no “Blocked by” / “Blocks” prose in the description). Blockers are expressed only as **`depends_on`** and as **Jira issue links** (`createIssueLink` / **is blocked by** / **blocks**).
- **Story** (and **Epic** when the template has Dependencies): you may add `## Dependencies` **only if** there is substantive prose worth keeping in Jira; prefer **Jira issue links** for actual blocking. If you include the section, use the heading **`## Dependencies`** exactly — no `(optional)` suffix.
- **Jira:** After creating issues, create **issue links** for each `depends_on` relationship, resolving each entry to the blocker’s **`jira_key`**. The link graph is the source of truth for “blocked by”, not duplicated lists inside Task/Sub-task descriptions.

---

## Jira ticket content rules

Use the organisation’s **Jira ticket structure** template: allowed **section titles** and rules below for each issue type. **Stories** always include User Story, Summary, and Acceptance Criteria; further sections (**Designs**, **Technical Note**, etc.) appear **only when they have content** (omit the heading if unused). **Tasks** / **Sub-tasks** never include `## Dependencies` in the body. No extra headings (e.g. effort estimates on epics). Tickets must not be blank.

### Epic

**When to use:** Large capability spanning multiple sprints; broken down into stories and tasks.

**Title:** concise epic name in the first `#` line of `epic.md` (no `EPIC:` / `[Project/Area] |` prefix).

**Body sections (only):** Epic Description → Objective/Goal → Value/Benefits → In Scope/Out of scope → Dependencies → Links → Parent (required: product roadmap initiative).

### Story

**When to use:** User-focused functionality in a sprint; actionable and testable.

**Body — required sections (always, in this order):** User Story → Summary → Acceptance Criteria.

**Body — add a section only when it has real content** (if there is nothing to say, **omit the entire heading** — do not leave empty shells). When present, use these **exact** headings (no `(optional)`, no `(if there is a design element)` in the title):

- `## Designs`
- `## Technical Note`
- `## Assumptions`
- `## Questions`
- `## Dependencies`

### Task

**When to use:** Value is internal to the team or system (not a user story); see Task vs Story in the template.

**Body sections (only):** Summary → Technical Requirements / Specification → Acceptance Criteria (Definition of Done) → Resources & References. **No** `## Dependencies` in the body — use YAML `depends_on` + Jira links only.

### Subtask

**When to use:** Jira **Sub-task** under a **Story** (your project’s hierarchy).

**Body sections (only):** Same as **Task** (no `## Dependencies` in the body). Local `ticket_type: subtask` + `for_story` for parent story id; sync with Sub-task issue type and story as parent.

### Bug

**When to use:** Something is not working as expected; defect or unexpected behaviour.

**Title:** Short summary of the bug (template examples may use environment/area prefixes).

**Body sections (only):** Description (including any examples, logs, images) → Steps to Reproduce → Expected Behavior → Actual Behavior.

---

## Datetime Rule

Always get real current datetime from the system:
```bash
date -u +"%Y-%m-%dT%H:%M:%SZ"
```

---

## Jira MCP Operations

Before creating Jira issues, run discovery through MCP:
```bash
# 1) getAccessibleAtlassianResources
# 2) getVisibleJiraProjects
# 3) getJiraProjectIssueTypesMetadata
# 4) getJiraIssueTypeMetaWithFields
```

Use parent when supported; otherwise use `createIssueLink`. For **dependencies**, use `createIssueLink` (or bulk link APIs) with **blocks** / **is blocked by** types so Jira’s blocker graph matches `depends_on`.

---

## Epic Progress Calculation

```bash
total=$(ls epics/<name>/T*.md 2>/dev/null | wc -l)
closed=$(grep -l '^status: closed' epics/<name>/T*.md 2>/dev/null | wc -l)
progress=$((closed * 100 / total))
```
