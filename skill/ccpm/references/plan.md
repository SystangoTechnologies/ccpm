# Plan — Capture Requirements

This phase turns an idea into a structured PRD, then converts the PRD into a technical epic ready for decomposition.

---

## Writing a PRD

**Trigger**: User wants to plan a new feature, product requirement, or area of work.

### Preflight
- Check if `prds/<name>.md` already exists — if so, confirm overwrite before proceeding.
- Ensure `prds/` directory exists; create it if not.
- Feature name must be kebab-case (lowercase, letters/numbers/hyphens, starts with a letter). If not: "❌ Feature name must be kebab-case. Example: user-auth, payment-v2"

### Process

Conduct a genuine brainstorming session before writing anything. Ask the user:
- What problem does this solve?
- Who are the users affected?
- What does success look like?
- What's explicitly out of scope?
- What are the constraints (tech, time, resources)?

Then write `prds/<name>.md` with this frontmatter and structure:

```markdown
---
name: <feature-name>
description: <one-line summary>
status: backlog
created: <run: date -u +"%Y-%m-%dT%H:%M:%SZ">
---

# PRD: <feature-name>

## Executive Summary
## Problem Statement
## User Stories
## Functional Requirements
## Non-Functional Requirements
## Success Criteria
## Constraints & Assumptions
## Out of Scope
## Dependencies
```

**Quality gates before saving:**
- No placeholder text in any section
- User stories include acceptance criteria
- Success criteria are measurable
- Out of scope is explicitly listed

**After creation**: Confirm "✅ PRD created: `prds/<name>.md`" and suggest: "Ready to create technical epic? Say: parse the <name> PRD"

---

## Parsing a PRD into a Technical Epic

**Trigger**: User wants to convert an existing PRD into a technical implementation plan.

### Preflight
- Verify `prds/<name>.md` exists with valid frontmatter (name, description, status, created).
- Check if `epics/<name>/epic.md` already exists — confirm overwrite if so.

### Process

Read the PRD fully, then produce `epics/<name>/epic.md`. The epic **body must use only** the sections below (same titles and order as the Jira Epic template). Pull content from the PRD; do not add extra markdown sections to `epic.md`. Implementation detail belongs in `T###.md` after decomposition, not in the epic file.

```markdown
---
name: <feature-name>
tracker: jira
status: backlog
created: <run: date -u +"%Y-%m-%dT%H:%M:%SZ">
updated: <same as created>
progress: 0%
prd: prds/<name>.md
jira_key: (will be set on sync)
jira_url: (will be set on sync)
---

# [Brief description of the epic]

## Epic Description

## Objective/Goal

## Value/Benefits

## In Scope/Out of scope

## Dependencies

## Links

## Parent
```

**Jira summary (title):** use the first `#` heading as the epic issue summary when syncing — a **short, human-readable epic name** only. Do **not** prefix with `EPIC:` or `[Project/Area] |`; project/area is understood from context (e.g. epic folder, Jira project).

**Epic Description:** Brief overview of the work; what the epic aims to achieve in broad terms.

**Objective/Goal:** Business goal or outcome (e.g. strategic pillar, OKR).

**Value/Benefits:** Why the epic matters to stakeholders.

**In Scope/Out of scope:** High-level what must be done for the epic to be complete, and what is excluded.

**Dependencies:** Other epics, teams, externals; in Jira use linked work items (`is blocked by`, `is child of`, etc.).

**Links:** e.g. initiative PRD, Figma (as web links in Jira).

**Parent:** Required — product roadmap initiative this epic links to (record key or URL for sync).

**Key constraints:**
- The epic’s first `#` heading must be a **concise epic title** (no `EPIC:` or `[Project/Area] |` prefix).
- Do not add sections beyond the template (no architecture / technical-planning blocks in `epic.md`).
- Aim for ≤10 work items when decomposing — prefer simplicity over completeness.

**After creation**: Confirm "✅ Epic created: `epics/<name>/epic.md`" and suggest: "Ready to decompose into tasks? Say: decompose the <name> epic"

---

## Editing a PRD or Epic

Read the file first, make targeted edits preserving all frontmatter. Update the `updated` frontmatter field with current datetime.
