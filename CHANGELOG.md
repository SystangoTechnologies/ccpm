# CCPM Changelog

## [2025-01-24] - Major cleanup & Jira-focused release

### Overview
Resolved the majority of open **Jira** backlog items for this effort, modernized command syntax, improved documentation, and aligned the workflow with **Jira** as the primary tracker (Atlassian MCP). This release focuses on stability, usability, and clearer local-vs-tracker boundaries.

### Added
- **Local mode support**
  - Offline-friendly workflow for PRD and epic work before any Jira sync
  - Core planning commands operate on repo-local files under `prds/` and `epics/`
  - Clear distinction between local-only steps and Jira-dependent sync steps

- **Jira-ready initialization**
  - Enhanced `init.sh` to scaffold repo-root directories and remind operators to connect Atlassian MCP before sync
  - Standard layout for epics, tasks, and `tracker-mapping.md` after sync

- **Context creation accuracy safeguards**
  - Mandatory self-verification checkpoints in context-related commands
  - Evidence-based analysis requirements and explicit assumption flagging where verification is still needed

### Changed
- **Modernized command syntax**
  - PM scripts and references use concise bash-first execution
  - Reduced token usage and improved compatibility across Agent Skills harnesses

- **README and conventions**
  - Clarified PRD vs epic terminology
  - **Project paths** documented at repo root: `prds/`, `epics/`, optional `docs/` for new general documentation
  - Workflow, examples, and prerequisites centered on **Jira** as the tracker of record

### Research & platform notes
- **Multi-tracker analysis**
  - Evaluated CLI and API options (including Linear and Jira); current skill standardizes on **Jira** via MCP

- **GitLab support research**
  - Documented GitLab CLI patterns for teams that might add a parallel integration later

### Clarified limitations
- **Windows shell compatibility** — documented POSIX expectations for scripts; workarounds noted where applicable
- **Codex CLI integration** — noted in multi-harness architecture guidance
- **Parallel worker behavior** — coordinator vs executor roles documented

### Security
- **Privacy documentation** — scrubbed sensitive example repository references from docs

### Proposed follow-ups
- **Bug handling workflow** — attach linked bug work items from completed Jira issues without losing context

### Tracker / delivery metrics
- **Closed**: majority of planned Jira items for this milestone
- **Active proposals**: extended bug-link automation (design complete, pending implementation)
- **Remaining**: minor backlog grooming items

### Technical details
- **Files touched**: core skill references, scripts, and root documentation
- **Backward compatibility**: maintained for existing `epics/` and `prds/` layouts
- **Dependencies**: Atlassian MCP for Jira when syncing; optional `git` for your own repo practices (CCPM sync does not create worktrees or run dev execution)

### Next steps
1. Gather feedback on the proposed bug-attachment flow in Jira
2. Optional GitLab tracker path if demand warrants a second adapter
3. Expanded validation and eval coverage

---

*This release stabilizes the Jira-first CCPM path: specs in the repo, delivery state in Jira, and fast local scripts for PM status and standups.*
