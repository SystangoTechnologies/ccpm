# Structure — Break Down an Epic

This phase converts an epic into **work item** files (`T###.md`) with stable local IDs and dependency/parallelization metadata. Each file maps to a Jira **Story**, **Task**, **Sub-task** (optional; under a story when your project uses them), or **Bug**. Section titles and what to include follow `**references/conventions.md`** (Story optional sections only when they have content; Task/Sub-task **no** `## Dependencies` in body; no `(optional)` in headings).

**Never** put CCPM boilerplate in any section that syncs to Jira (e.g. `Local CCPM: task_id … · epic …`). IDs and epic folder names live in **frontmatter** / `tracker-mapping.md` only — see `conventions.md` (**Description hygiene**).

---

## Epic Decomposition

**Trigger**: User wants to break an epic into actionable tasks.

### Preflight

- Verify `epics/<name>/epic.md` exists with valid frontmatter.
- If task files (`T001.md`, `T002.md`, ...) already exist in the epic directory, list them and confirm deletion before recreating.
- If epic status is "completed", warn the user before proceeding.

### Process

Read the epic fully. Decide **dependency order** and, for planning only, which items could run in parallel (`parallel: true` / `conflicts_with: []` vs explicit `depends_on`) so the board reflects sequencing — this is **not** for launching dev agents.

**Decomposition angles (examples):** user-facing journeys, integrations, policy/compliance, launch/readiness, documentation, cross-team handoffs.

**Batching:** small epics: create `T###.md` files one after another; larger epics: draft in dependency order or in a few batches. Always keep each file aligned to the Jira template in `conventions.md`.

### Story vs Task vs Subtask vs Bug

- **Story** — User Story, Summary, Acceptance Criteria **always**; add Designs, Technical Note, Assumptions, Questions, or Dependencies **only with real content** and **without** `(optional)` / `(if there is a design element)` in headings (see `conventions.md`).
- **Task** — Summary, Technical Requirements / Specification, Acceptance Criteria (Definition of Done), Resources & References — **no** `## Dependencies` in the body (blockers: YAML `depends_on` + Jira links only). `**name` must start with `FE:`, `BE:`, or `Mobile:`** when surface-specific (see `conventions.md`).
- **Subtask** — same body as **Task** (no `## Dependencies`). Set `for_story: <story task_id>`; on sync, parent = that story’s Jira issue. `**name` uses the same `FE:` / `BE:` / `Mobile:` prefix rule as Task.**
- **Bug** — defect / unexpected behaviour; template: Description (incl. examples/logs/images), Steps to Reproduce, Expected Behavior, Actual Behavior.

Set `ticket_type: story | task | subtask | bug` on every `T###.md` file.

---

### Story file format (`ticket_type: story`)

```markdown
---
task_id: T001
ticket_type: story
name: <Jira summary / title — no FE:/BE:/Mobile: prefix>
status: open
created: <run: date -u +"%Y-%m-%dT%H:%M:%SZ">
updated: <same as created>
jira_key: (will be set on sync)
jira_url: (will be set on sync)
depends_on: []
parallel: true
conflicts_with: []
---

## User Story

As a <user type>,  
I want <feature/functionality>,  
So that <benefit>.

## Summary

## Acceptance Criteria
```

After the fence: add `**## Designs**`, `**## Technical Note**`, `**## Assumptions**`, and/or `## Questions` only when each has substantive content. Use those **exact** headings — do not add `(optional)` or `(if there is a design element)` to the heading text.

---

### Task file format (`ticket_type: task`)

```markdown
---
task_id: T010
ticket_type: task
name: FE: <Jira summary / title>
status: open
created: <run: date -u +"%Y-%m-%dT%H:%M:%SZ">
updated: <same as created>
jira_key: (will be set on sync)
jira_url: (will be set on sync)
depends_on: []
parallel: true
conflicts_with: []
---

## Summary

## Technical Requirements / Specification

## Acceptance Criteria (Definition of Done)

## Resources & References
```

Use `BE:` or `Mobile:` instead of `FE:` when the work is primarily backend or mobile. List blockers only in YAML `**depends_on**`; sync creates **Jira issue links** — do **not** add a `## Dependencies` section to the Task body.

---

### Subtask file format (`ticket_type: subtask`)

Same **body** sections and **headings** as **Task** (template does not define a separate Sub-task body). Required frontmatter: `for_story: <parent story task_id>`. On Jira sync, issue type = Sub-task and parent = that story.

```markdown
---
task_id: T002
ticket_type: subtask
name: FE: <Jira Sub-task summary / title>
status: open
created: <run: date -u +"%Y-%m-%dT%H:%M:%SZ">
updated: <same as created>
jira_key: (will be set on sync)
jira_url: (will be set on sync)
depends_on: []
parallel: true
conflicts_with: []
for_story: T001
---

## Summary

## Technical Requirements / Specification

## Acceptance Criteria (Definition of Done)

## Resources & References
```

---

### Bug file format (`ticket_type: bug`)

**Title (summary):** per template — short summary of the bug (example style: `[Testnet][Swap] - …`).

```markdown
---
task_id: T003
ticket_type: bug
name: <Title / summary>
status: open
created: <run: date -u +"%Y-%m-%dT%H:%M:%SZ">
updated: <same as created>
jira_key: (will be set on sync)
jira_url: (will be set on sync)
depends_on: []
parallel: false
conflicts_with: []
---

## Description

<What is wrong; include examples, logs, or images in this section per the template.>

## Steps to Reproduce

## Expected Behavior

## Actual Behavior
```

Do not add sections beyond the template (no separate “Acceptance criteria” or effort blocks on bugs).

**Task IDs**: sequential `T001.md`, `T002.md`, etc. Filenames stay stable after sync. Use `depends_on` values as task IDs.

### After Creating All Tasks

Append a summary to the epic file:

```markdown
## Tasks Created
- [ ] T001.md - <Title> (parallel: true/false)
- [ ] T002.md - <Title> (parallel: true/false)

Total tasks: N
Parallel tasks: N
Sequential tasks: N
```

**After completion**: Confirm "✅ Created N work items for epic: " and suggest: "Ready to push to Jira? Say: sync the  epic"

---

## Dependency rules

- `depends_on` lists local `task_id` values that should finish before this item starts (planning / sequencing and **Jira link creation** on sync). **Task** and **Sub-task** bodies do **not** repeat this as a `## Dependencies` section — Jira links are enough.
- **Stories** may include `## Dependencies` only when there is real narrative to capture; otherwise omit. Never use `(optional)` in the heading.
- `parallel: true` means the item could run in parallel with others from a **planning** perspective (same sprint wave, no hard ordering).
- `conflicts_with` lists items that should not be scheduled in parallel (e.g. same vendor, same approval gate, mutually exclusive scope).
- Circular dependencies are an error — check before finalizing.

