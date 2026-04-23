---
name: ccpm
description: "CCPM — spec-driven project management for PM work: PRD → Epic → Jira-aligned work items → sync and track. Use for planning, decomposition, Jira ticket hygiene (templates, DOR/DOD), status, and reporting. Not for writing application code, running dev environments, or execution workflows. Do NOT use for: debugging code, implementing features, reviewing PRs, or raw Jira clicks with no PM context."
---

# CCPM - Cursor Project Manager

A **PM-focused** workflow: requirements and epics live in markdown; Jira is the tracker of record for sync, status, and delivery visibility.

## Core Philosophy

Requirements live in files, not heads. Work flows from **PRD** to **epic** to **structured work items** (`T###.md`), then to **Jira** for the team to execute elsewhere. This skillset stays on **planning, structure, sync, and track** — not on coding or dev execution.

No blank Jira tickets: follow the org **Jira ticket structure** template (section titles and order), links, and dependencies.

## File Conventions

Before doing anything, read `references/conventions.md` for paths, frontmatter, and Jira rules.

### Canonical root directories

- `prds/` for PRDs
- `epics/<feature>/` for `epic.md`, `T###.md`, and `tracker-mapping.md`
- `docs/` for supplementary documentation (optional)

## The four phases

### 1. Plan — Capture requirements

**When**: Define a feature, product requirement, or scope.  
**Read**: `references/plan.md`  
**Covers**: PRDs, PRD → epic, DOR-style inputs (scope, dependencies, links).

### 2. Structure — Break it down

**When**: An epic exists and needs concrete work items.  
**Read**: `references/structure.md`  
**Covers**: Decomposition into Story / Task / Sub-task / Bug files, dependencies, `parallel` / `conflicts_with` for **planning** (who could work in parallel), not for running agents.

### 3. Sync — Push to Jira

**When**: Local epic and `T###.md` files should become Jira issues, or issues need closing / epic completion / bug capture.  
**Read**: `references/sync.md`  
**Covers**: Epic + child issue creation, frontmatter keys, `tracker-mapping.md`, closing issues, completing epics, reporting bugs into the backlog.

### 4. Track — Know where things stand

**When**: Status, standup, next, blocked, search, validate.  
**Read**: `references/track.md`  
**Covers**: Script-first reporting from local + Jira metadata.

---

## Script-first rule

| What the user wants | Script to run |
|---|---|
| Project status | `bash references/scripts/status.sh` |
| Standup report | `bash references/scripts/standup.sh` |
| List all epics | `bash references/scripts/epic-list.sh` |
| Show epic details | `bash references/scripts/epic-show.sh <name>` |
| Epic status | `bash references/scripts/epic-status.sh <name>` |
| List PRDs | `bash references/scripts/prd-list.sh` |
| PRD status | `bash references/scripts/prd-status.sh` |
| Search | `bash references/scripts/search.sh <query>` |
| What's in progress | `bash references/scripts/in-progress.sh` |
| What's next | `bash references/scripts/next.sh` |
| What's blocked | `bash references/scripts/blocked.sh` |
| Validate | `bash references/scripts/validate.sh` |

Use the LLM for reasoning-heavy PM work: drafting PRDs, decomposing epics, drafting Jira-ready descriptions, interpreting status.

## Jira ticket policy

Epic, Story, Task, Sub-task, and Bug **titles, section order, and required fields**: see **`references/conventions.md`**. In particular: **no** “Local CCPM …” lines in Jira bodies; **Task/Sub-task** summaries start with **`FE:` / `BE:` / `Mobile:`** when surface-specific; **Task/Sub-task** blockers = YAML **`depends_on`** + Jira **`createIssueLink`** only (no `## Dependencies` in descriptions); **Story** optional sections use plain headings (**Designs**, **Technical Note**, etc.) — **omit** the section if empty, and **never** put `(optional)` in the heading.

### Quality gates

- **DOR (before sync)**: required template fields, dependencies/links, no placeholder text.
- **DOD (before close)**: acceptance criteria satisfied per process, Jira reflects done, dependencies and links updated as needed.

---

## Quick reference

```
Plan a feature:     "create a PRD for X"
Parse to epic:      "turn the X PRD into an epic"
Decompose:          "break down the X epic into tasks"
Sync to Jira:       "sync the X epic to Jira"
Create a story:     "create story from epic X for Y"
Create a task:      "create internal task for X"
Validate:           "validate" / "validate DOR for T001"
Check status:       "what's our status" / "standup"
What's next:        "what should we pull next" / "what's blocked"
Complete epic:      "complete the X epic"
Report a bug:       "log a bug for task T001" / "follow-up from PROJ-42"
```

## Required downstream references

- `references/conventions.md`
- `references/plan.md`
- `references/structure.md`
- `references/sync.md`
- `references/track.md`
- `references/scripts/*.sh`
