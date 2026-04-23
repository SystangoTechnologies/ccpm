# Track — Know Where Things Stand

Tracking operations use bash scripts directly for speed and consistency. The LLM is not needed for these — just run the script and present the output.

---

## Script-First Rule

All tracking operations have a corresponding bash script. Run the script; do not reconstruct the output manually.

Scripts live in `references/scripts/` relative to this skill, but need to run from the **project root** (where `prds/` and `epics/` live). Run them as:

```bash
bash <skill_path>/references/scripts/<script>.sh [args]
```

Or if ccpm is installed project-locally:
```bash
bash ccpm/scripts/pm/<script>.sh [args]
```

---

## Project Status

**Trigger**: "what's our status", "project status", "overview"

```bash
bash references/scripts/status.sh
```

Shows: active epics, open issues count, recent activity.

---

## Standup Report

**Trigger**: "standup", "daily standup", "what did we do", "morning update"

```bash
bash references/scripts/standup.sh
```

Shows: what was completed yesterday, what's in progress today, any blockers.

---

## List Epics

**Trigger**: "list epics", "show epics", "what epics do we have"

```bash
bash references/scripts/epic-list.sh
```

---

## Show Epic Details

**Trigger**: "show the <name> epic", "epic details for <name>"

```bash
bash references/scripts/epic-show.sh <name>
```

---

## Epic Status

**Trigger**: "status of the <name> epic", "how far along is <name>"

```bash
bash references/scripts/epic-status.sh <name>
```

Shows: task completion breakdown, blocking issues.

---

## List PRDs

**Trigger**: "list PRDs", "what PRDs do we have", "show backlog"

```bash
bash references/scripts/prd-list.sh
```

---

## PRD Status

**Trigger**: "PRD status", "which PRDs are parsed", "what's in backlog"

```bash
bash references/scripts/prd-status.sh
```

---

## Search

**Trigger**: "search for <query>", "find issues about <topic>", "look for <term>"

```bash
bash references/scripts/search.sh "<query>"
```

Searches local task files, PRDs, and epics for the query term.

---

## What's In Progress

**Trigger**: "what's in progress", "what are we working on", "active work"

```bash
bash references/scripts/in-progress.sh
```

---

## What's Next

**Trigger**: "what should I work on next", "what's next", "next priority"

```bash
bash references/scripts/next.sh
```

Shows highest-priority open tasks with no blocking dependencies.

---

## What's Blocked

**Trigger**: "what's blocked", "any blockers", "what can't we move on"

```bash
bash references/scripts/blocked.sh
```

---

## Validate Project State

**Trigger**: "validate", "check project state", "is everything consistent"

```bash
bash references/scripts/validate.sh
```

Checks: frontmatter consistency, orphaned files, missing Jira links, dependency integrity. For DOR/DOD against Jira templates, see `conventions.md` (template section titles/order only; `ticket_type` on `T###.md`).

---

## When Scripts Fail

If a script fails or the output needs interpretation (e.g., an error in the output, or the user asks "what does this mean"), then step in to explain. But always run the script first — don't guess at what status/standup output would look like.

## Jira-Aware Task Identity

Tracking is local-file-first and Jira-aware:

- Local task identity is `task_id` (for example, `T001`), not remote numeric filenames.
- Jira identity is `jira_key` (for example, `PROJ-123`) and is used for remote lookups.
- Scripts should discover task files with metadata (`task_id`, `status`) and must not rely on `[0-9]*.md` naming.

If `prds/` and `epics/` directories do not exist, the project hasn't been initialized. Direct the user to run:
```bash
bash references/scripts/init.sh
```
