# Cursor Workflow Overview — Open Claw

This document is the human-readable guide to the Cursor workflow used in the Open Claw project.

## Five-Tab Model

We use exactly five Cursor chat tabs, each with a distinct role:

| Tab     | Role                     | Edits files? | Runs commands? |
|---------|--------------------------|--------------|----------------|
| PLAN    | Architect / Strategist   | No           | No             |
| AGENT   | Executor / Implementer   | Yes          | Yes            |
| DEBUG   | Investigator / Forensics | No           | No             |
| ASK     | Scratchpad / Exploration | No           | No             |
| ARCHIVE | Compressor / Handoff     | Docs only    | No             |

See `docs/ai/tabs/TAB_BOOTSTRAP_PROMPTS.md` for the first prompt to paste into each tab.

## Where Rules Live

Authoritative (repo-tracked):
- `.cursor/rules/00-global-core.md` — non-negotiable behaviors
- `.cursor/rules/05-global-mcp-usage.md` — MCP tool usage policy
- `.cursor/rules/10-project-workflow.md` — tab contracts (Open Claw specific)
- `.cursor/rules/20-project-quality.md` — engineering standards (Open Claw specific)
- `AGENTS.md` — agent operating contract (repo root)

Developer-local (optional):
- Cursor User Rules for personal preferences (formatting, tone)
- Never put project invariants solely in user-local rules

## State and Planning

- `docs/ai/STATE.md` — current execution state; updated after every AGENT block
- `docs/ai/PLAN.md` — active plan with phases and exit criteria
- `docs/ai/ARCHIVE.md` — compressed decisions and knowledge from past sessions

## Excluded directories

- `docs/ai/archive/` — superseded docs. **Never consulted** by PLAN. Historical reference only.

## Memory

- `docs/ai/memory/MEMORY_CONTRACT.md` — policy for what gets persisted
- `docs/ai/memory/DECISIONS.md` — log of key decisions with rationale
- `docs/ai/memory/PATTERNS.md` — reusable patterns discovered during development

Memory MCP tools supplement these docs for cross-session and cross-project recall.

## Open Claw Project Docs

- `open-claw/docs/VISION.md` — project vision and goals
- `open-claw/docs/REQUIREMENTS.md` — initial requirements
- `open-claw/docs/MODULES.md` — module boundaries
- `open-claw/docs/INTEGRATIONS.md` — target integrations
