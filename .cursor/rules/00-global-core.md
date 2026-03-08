# 00 — Global Core (non-negotiables)

## Tab separation

Five tabs only: PLAN / AGENT / DEBUG / ASK / ARCHIVE.

| Tab     | Role                     | Edits files? | Runs commands? |
|---------|--------------------------|--------------|----------------|
| PLAN    | Architect / Strategist   | No           | No             |
| AGENT   | Executor / Implementer   | Yes          | Yes            |
| DEBUG   | Investigator / Forensics | No           | No             |
| ASK     | Scratchpad / Exploration | No           | No             |
| ARCHIVE | Compressor / Handoff     | Docs only    | No             |

Planning and execution are never mixed in the same tab.

## Evidence-first

- No guessing. Evidence before code.
- If blocked, stop and list what is missing explicitly.

## PASS/FAIL discipline

- Every tool call and command reports PASS or FAIL.
- FAIL must include: exact command/tool, error output, proposed next step.
- Do not continue silently after failure.

## State updates

`docs/ai/STATE.md` is the **primary operational source of truth** for PLAN. PLAN must read it before reasoning about blockers, fallbacks, next actions, and cross-repo effects.

AGENT must update `docs/ai/STATE.md` after every execution block using the enforced section template defined in `10-project-workflow.md`. Every section is required; write `None` or `N/A` if a section has nothing to report. Do not omit sections.

## No unauthorized refactors

- Changes that exceed "local fix" require a refactor plan approved via PLAN.
- No broad reformatting mixed with logic changes.

## Self-consistency checklist (REQUIRED before completing any phase)

Before marking a phase or scaffold task complete, AGENT must verify:

- [ ] No duplicate files differing only by case (run a case-insensitive filename scan)
- [ ] Every path referenced in rules and docs exists in the repo
- [ ] No secrets, tokens, or credentials committed (scan for common token prefixes used by GitHub, OpenAI, AWS, and similar services; also check for authorization header values and API key assignments)
- [ ] No circular references between rule docs
- [ ] `docs/ai/STATE.md` is updated with PASS/FAIL evidence for this phase

Report each check as PASS or FAIL with brief evidence.
