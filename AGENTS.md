# AGENTS.md — Open Claw

This repo uses a five-tab Cursor workflow: PLAN / AGENT / DEBUG / ASK / ARCHIVE.

## Authoritative rules

- `.cursor/rules/00-global-core.md` — non-negotiable behaviors
- `.cursor/rules/05-global-mcp-usage.md` — MCP tool usage policy
- `.cursor/rules/10-project-workflow.md` — tab contracts (Open Claw specific)
- `.cursor/rules/20-project-quality.md` — engineering standards (Open Claw specific)
- `docs/ai/CURSOR_WORKFLOW.md` — human-readable workflow overview

## State tracking

- `docs/ai/STATE.md` — **primary operational log**; PLAN reads this first to understand current state, blockers, fallbacks, and cross-repo effects. AGENT updates it after every execution block using the enforced template in `10-project-workflow.md`.
- `docs/ai/PLAN.md` — active plan with phases and exit criteria

## MCP policy

MCP tool usage is enforced via `.cursor/rules/05-global-mcp-usage.md`.
Tools are used for: code navigation, documentation lookup, reasoning, browser automation, web extraction, repo operations, and persistent memory.
Configuration lives outside the repo. Rules enforce behavior, not plumbing.

## Agent contract

AGENT must:
- Follow PLAN prompts exactly
- Update `docs/ai/STATE.md` after each execution block using the enforced template in `10-project-workflow.md`
- Provide PASS/FAIL evidence for every tool call and command
- Use MCP tools before falling back to manual approaches

## Project docs

- `open-claw/docs/VISION.md` — project vision
- `open-claw/docs/REQUIREMENTS.md` — initial requirements
- `open-claw/docs/MODULES.md` — module boundaries
- `open-claw/docs/INTEGRATIONS.md` — target integrations
