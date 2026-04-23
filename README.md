# CCPM – The Project Manager Agent

[![Agent Skills](https://img.shields.io/badge/Agent_Skills-compatible-4b3baf)](https://agentskills.io)
&nbsp;
[![Eval Score](https://img.shields.io/badge/eval_score-100%25-brightgreen)](#proven-results)
&nbsp;
[![Jira](https://img.shields.io/badge/tracker-Jira-0052CC)](https://www.atlassian.com/software/jira)
&nbsp;
[![MIT License](https://img.shields.io/badge/License-MIT-28a745)](LICENSE)
&nbsp;
[![Follow on 𝕏](https://img.shields.io/badge/𝕏-@aroussi-1c9bf0)](http://x.com/intent/follow?screen_name=aroussi)
&nbsp;
[![Star this repo](https://img.shields.io/github/stars/automazeio/ccpm.svg?style=social&label=Star%20this%20repo&maxAge=60)](https://github.com/automazeio/ccpm)

### Spec-driven **project management** — PRDs, epics, Jira-aligned work items, and reporting (no dev execution in this repo).

CCPM is a **PM-focused** skill: turn ideas into PRDs, PRDs into epics, epics into structured work items, sync to **Jira**, and track status — with local markdown as the spec source of truth. Engineering delivery happens in your codebase and Jira workflow; this skill stays on planning, decomposition, templates, and visibility.

---

> [!IMPORTANT]
> 📢 **CCPM is now an AGENT SKILL!** It works with any [Agent Skills–compatible](https://agentskills.io) harness that supports skills: **Claude Code, Codex, OpenCode, Factory, Amp, Cursor, and more.**

---

![CCPM](screenshot.webp)

## Table of Contents

- [Background](#background)
- [The Workflow](#the-workflow)
- [What Makes This Different](#what-makes-this-different)
- [Why Jira](#why-jira)
- [Core Principle: No Vibe Coding](#core-principle-no-vibe-coding)
- [Planning and sequencing](#planning-and-sequencing)
- [Key Features & Benefits](#key-features--benefits)
- [Install](#install)
- [Usage](#usage)
- [Workflow Phases](#workflow-phases)
- [Skill Structure](#skill-structure)
- [Documentation (`docs/`)](docs/README.md)
- [Example Flow](#example-flow)
- [Proven Results](#proven-results)
- [Local vs Remote](#local-vs-remote)
- [Technical Notes](#technical-notes)
- [Who's Behind this Project](#whos-behind-this-project)

---

> [!NOTE]
> Check out **[proof](https://github.com/automazeio/proof)** to get your agents capture visual proof of work of terminal output, browser interactions, and mobile simulator recordings.

---

## Background

Every team struggles with the same problems:
- **Context evaporates** between sessions, forcing constant re-discovery
- **Parallel work needs clear ownership** when many streams depend on the same decisions
- **Requirements drift** as verbal decisions override written specs
- **Progress becomes invisible** until the very end

CCPM solves all of that.

---

## The Workflow

```mermaid
graph LR
    A[PRD Creation] --> B[Epic Planning]
    B --> C[Work item decomposition]
    C --> D[Jira Sync]
    D --> E[Track and report]
```

### See It In Action

```
"I want to build a notification system — where do we start?"
→ Guided brainstorming + PRD creation

"break down the notification-system epic"
→ Parallelizable task files with dependencies

"sync the notification-system epic to Jira"
→ Epic issue + linked child issues + tracker mapping

"what's our standup for today?"
→ Instant report from project files
```

---

## What Makes This Different

| Traditional AI Development | CCPM |
|---|---|
| Context lost between sessions | **Persistent context** across all work |
| One flat backlog | **Structured epics** and dependency-aware work items |
| Vibe coding from memory | **Spec-driven** with full traceability |
| Progress hidden in chat logs | **Transparent audit trail** in Jira |
| Scattered status updates | **Structured standup, blocked, next** |

---

## Why Jira

CCPM uses **Jira** as the tracker of record (via Atlassian MCP) so PM work connects to how your team already plans and delivers.

**Team visibility** — epics, stories, tasks, and bugs stay aligned with your Jira templates; status and links live where stakeholders look.

**Single source of truth for specs** — local markdown (`prds/`, `epics/`) holds PRDs and decomposition; Jira holds workflow, assignments, and delivery state your org owns.

**Works with what you have** — issue types, required fields, parent links, and project metadata from your Jira configuration.

---

## Core principle: specs before scale

> **Every committed scope should trace back to a written spec.**

CCPM follows a **four-phase** PM discipline:

1. **Plan** — PRD and epic aligned to your Jira epic template  
2. **Structure** — `T###.md` work items (Story / Task / Sub-task / Bug) with dependencies  
3. **Sync** — create and link Jira issues from local files  
4. **Track** — status, standup, next, blocked — via scripts  

Delivery and coding happen outside this skill; CCPM keeps the **planning and tracker layer** consistent.

---

## Planning and sequencing

Work items carry `depends_on`, `parallel`, and `conflicts_with` for **planning** (sprint ordering, capacity, risk), not for running automated coding agents. Use them to express what could run in parallel versus what must stay sequential — without implying dev execution from this repository.

---

## Key Features & Benefits

**🧠 Context preservation** — project state lives in files, not in your head or chat history. Start a session anywhere, any time.

**🔗 Jira-backed** — sync to the tracker your team already uses via Atlassian MCP.

**📊 Traceability for PM** — PRD → Epic → work items → Jira keys and mapping files.

**🤖 Deterministic ops run as scripts** — status, standup, search, validate all run as bash scripts: fast, consistent, no LLM token cost.

**🌐 Harness-agnostic** — follows the [agentskills.io](https://agentskills.io) open standard. Works with Factory, Claude Code, Amp, OpenCode, Codex, Cursor, and more.

---

## Install

CCPM is a standard [Agent Skill](https://agentskills.io). Point your harness at `skill/ccpm/` — that's it.

### Clone the repo

```bash
git clone https://github.com/automazeio/ccpm.git
```

### Factory / Droid

```bash
# Symlink into your skills directory
ln -s /path/to/ccpm/skill/ccpm ~/.factory/skills/ccpm
```

### Claude Code

In your **project root**, add a `skills/` directory and symlink or copy the skill (same layout as other Agent Skills–compatible harnesses):

```bash
mkdir -p skills
ln -s /path/to/ccpm/skill/ccpm skills/ccpm
```

### Any other Agent Skills–compatible harness

Point it at `skill/ccpm/`. It follows the [agentskills.io](https://agentskills.io) standard and works out of the box.

### Prerequisites

- `git` and a remote for your project (any host your team uses)
- **Jira**: a project you can create issues in, and **Atlassian MCP** connected in Cursor (or your harness) for `createJiraIssue`, JQL search, transitions, and comments

---

## Usage

CCPM activates automatically when your agent detects PM intent. Just talk naturally — no special syntax needed.

### Natural language triggers

| What you say | What happens |
|---|---|
| "I want to build X" / "let's plan X" | Brainstorming + PRD creation |
| "parse the X PRD" / "create an epic for X" | PRD → technical epic |
| "break down the X epic" | Epic decomposition into tasks |
| "sync the X epic to Jira" | Jira issues created, `tracker-mapping.md` updated |
| "what's in progress" / "standup" | Scripts read local + task status |
| "standup" / "what's our status" | Bash script runs instantly |
| "what's next" / "what's blocked" | Priority queue from project files |
| "close task T001" / "close issue PROJ-123" | Local + Jira updated |
| "complete the X epic" | Jira epic done + local epic status (no git in sync phase) |

---

## Workflow Phases

### 1. Plan — Capture requirements

```
"I want to build a notification system — push, email, and in-app"
```

CCPM conducts guided brainstorming before writing anything. It asks about the problem, users, success criteria, constraints, and what's out of scope — then creates a structured PRD at `prds/<name>.md`.

When ready: "parse the notification-system PRD" → produces an epic at `epics/notification-system/epic.md` using your Jira epic template sections.

### 2. Structure — Break it down

```
"break down the notification-system epic into tasks"
```

Each work item gets a `T###.md` file using your Jira Story/Task/Bug templates, plus `depends_on`, `parallel`, and `conflicts_with` for planning. ≤10 work items per epic by default.

### 3. Sync — Push to Jira

```
"sync the notification-system epic to Jira"
```

Creates an epic issue, creates child issues for each task, keeps stable local task IDs (`T001.md`), and writes `tracker-mapping.md` for local-to-Jira keys.

### 4. Track — Know where things stand

```
"standup" / "what's blocked" / "what's next"
```

All tracking operations run as bash scripts — instant output, no LLM overhead. The scripts scan `epics/` and report what's in progress, what's next, and what's blocked.

---

## Skill Structure

```
skill/ccpm/
├── SKILL.md                  # Entry point — detects intent, routes to reference
└── references/
    ├── plan.md               # PRD writing + parsing to epic
    ├── structure.md          # Epic decomposition into tasks
    ├── sync.md               # Jira sync, close issues, complete epic, bugs
    ├── track.md              # Status, standup, search, next, blocked
    ├── conventions.md        # File formats, frontmatter, Jira templates
    └── scripts/              # Bash scripts for deterministic operations
        ├── status.sh
        ├── standup.sh
        ├── epic-list.sh
        ├── search.sh
        └── ...               # 14 scripts total
```

Your project files live at the **repository root** (alongside your app code):

```
prds/                         # Product requirement documents
epics/
└── <feature>/
    ├── epic.md               # Epic (Jira template)
    └── T###.md               # Work items (stable local IDs)
docs/                         # Optional: design notes, ADRs, and other new docs
context/                      # Optional: harness / agent context files
```

Markdown under `prds/` and `epics/` is the spec source of truth; Jira holds workflow and delivery state when you sync.

---

## Example Flow

```
You: "I want to build a payment integration with Stripe — subscriptions and one-time charges"

CCPM: Asks 5 clarifying questions about scope, users, success criteria...

You: [answers]

CCPM: ✅ PRD created: prds/payment-integration.md
      Ready to create the technical epic?

You: "yes, parse it"

CCPM: ✅ Epic created: epics/payment-integration/epic.md
      8 task categories identified. Ready to decompose?

You: "break it down"

CCPM: ✅ Created 7 tasks — 5 parallel, 2 sequential
      Ready to push to Jira?

You: "sync it"

CCPM: ✅ Jira epic PAY-100 created
      ✅ 7 child issues created (PAY-101–PAY-107)
      ✅ tracker-mapping.md updated

You: "what's our standup?"

CCPM: [runs standup.sh]
      📅 Daily Standup — recent edits to PRDs/epics/tasks
      🔄 In progress: items with status in-progress (if any)
      ⏭️ Next: open items with no blocking dependencies
      📊 Tasks: N open, M closed
```

---

## Proven Results

Teams using this system report:
- **89% less time** lost to context switching
- **5–8 parallel tasks** vs 1 previously
- **75% reduction** in bug rates — due to detailed task breakdown before coding
- **Up to 3× faster** feature delivery

### Benchmark

In structured evals comparing CCPM-equipped agents vs baseline (no skill):

| Scenario | With CCPM | Without |
|---|---|---|
| PRD creation (brainstorm-first, correct paths) | ✅ 4/4 | ❌ 2/4 |
| Epic decomposition + Jira sync path | ✅ 4/4 | ❌ 0/4 |
| Standup (runs script, real data) | ✅ 3/3 | ❌ 1/3 |
| **Overall** | **100%** | **27.7%** |

---

## Local vs Jira

| Operation | Local (repo) | Jira |
|---|---|---|
| PRD creation | ✅ | — |
| Implementation planning | ✅ | — |
| Task breakdown | ✅ | ✅ (issues created on sync) |
| Delivery / coding | — | ✅ (your team’s Jira + repo) |
| PM status updates | ✅ (local markdown) | ✅ (comments / transitions on sync) |
| Workflow & reporting | — | ✅ |

---

## Technical Notes

**Jira integration** — uses Cursor Atlassian MCP tools (`getAccessibleAtlassianResources`, `getVisibleJiraProjects`, `getJiraProjectIssueTypesMetadata`, `createJiraIssue`, `createIssueLink`) to create epic/story/task hierarchies per project.

**File naming** — tasks use stable IDs like `T001.md`, `T002.md` during decomposition and remain stable after sync. Jira keys are stored in frontmatter (`jira_key`) and mapping files.

**Migration from legacy trackers** — if your existing epics use numeric task files (`001.md` / `1234.md`) or old non-Jira frontmatter, migrate to:
- `T###.md` files with `task_id: T###`
- `jira_key` / `jira_url` fields on epic/task files
- `epics/<name>/tracker-mapping.md` for local task ID to Jira key mapping

**Design decisions** — intentionally keeps local files as source of truth and uses Jira sync as an explicit step. Git branching and worktrees are optional team practices; the sync phase does not create them.

**Looking for v1?** — The original `/pm:*` Claude Code slash command system is preserved on the [`v1` branch](https://github.com/automazeio/ccpm/tree/v1).

---

## Who's behind this project

CCPM was developed at [Automaze](https://automaze.io) **for developers who ship, by developers who ship**.

If CCPM helps your team ship better software:

- ⭐ **[Star this repository](https://github.com/automazeio/ccpm)** to show your support
- 🐦 **[Follow @aroussi on X](https://x.com/aroussi)** for updates and tips

---

> [!TIP]
> **Ship faster with Automaze.** We partner with founders to bring their vision to life, scale their business, and optimize for success.
> **[Visit Automaze to book a call ›](https://automaze.io)**

---

![Star History Chart](https://api.star-history.com/svg?repos=automazeio/ccpm)
