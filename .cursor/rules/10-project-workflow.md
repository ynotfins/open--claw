# 10 — Project Workflow (Open Claw)

> Extends: `00-global-core.md` (tab separation, evidence, state discipline)
> Extends: `05-global-mcp-usage.md` (tool-first behavior)

## Rules in effect

- `00-global-core.md` — non-negotiable behaviors
- `05-global-mcp-usage.md` — MCP tool usage policy
- `10-project-workflow.md` — tab contracts (this file)
- `15-model-routing.md` — model selection, tab defaults, escalation rules
- `20-project-quality.md` — engineering standards

## Project notes

Open Claw is a modular AI assistant platform. Development spans multiple domains
(orchestrator, memory, dev tools, comms, web). Phases should be scoped to one
module or integration at a time to keep diffs reviewable.

## PLAN output contract

PLAN must produce:
- Phases with explicit exit criteria
- Risks and unknowns
- A single AGENT prompt for the next phase
- If the phase has >5 connected steps, use a reasoning MCP tool before finalizing

## AGENT execution contract

AGENT must:
- Follow the PLAN prompt exactly — no freelancing
- Use MCP tools per `05-global-mcp-usage.md`
- Run tests and commands required by the phase
- Update `docs/ai/STATE.md` after each execution block
- Produce PASS/FAIL evidence for every tool call and command
- Stop immediately if assumptions break or requirements conflict

## STATE.md entry template (enforced — all sections required)

> Canonical source: AI-Project-Manager/.cursor/rules/10-project-workflow.md

Every AGENT execution block appended to `docs/ai/STATE.md` must use this exact structure. Omitting any section is not permitted; write `None` or `N/A` if there is nothing to report.

```markdown
## <YYYY-MM-DD> — <task name>

### Goal
One or two sentences stating what this block aimed to achieve.

### Scope
Files touched or inspected. Repos affected.

### Commands / Tool Calls
Exact shell commands and exact MCP tool names invoked (no paraphrasing).

### Changes
What was created, edited, or deleted.

### Evidence
PASS/FAIL per command/tool with brief output or error.

### Verdict
READY / BLOCKED / PARTIAL — with one-line reason.

### Blockers
List each blocker. Write `None` if unblocked.

### Fallbacks Used
MCP tools that failed and the fallback used. Write `None` if no fallbacks needed.

### Cross-Repo Impact
Effect on the paired repo, or `None`.

### Decisions Captured
Decisions made during this block that should be promoted to DECISIONS.md or memory. Write `None` if none.

### Pending Actions
Follow-up items not completed in this block.

### What Remains Unverified
Anything that was assumed but not confirmed by evidence.

### What's Next
The immediate next action for AGENT or PLAN.
```

## DEBUG output contract

DEBUG must produce:
- Ranked likely causes (most to least probable)
- Minimal fix plan (smallest diff)
- Reproduction steps with evidence
- One AGENT prompt to implement and verify the fix

## Context attachment discipline

- Attach files with intent, not habit.
- Attach the minimum set needed for the current tab's job.
- Prefer referencing paths and targeted excerpts over pasting entire files.
- If a file is attached, assume it is read fully.
