# Execution State — Open Claw

`docs/ai/STATE.md` is the **primary operational source of truth** for PLAN in the open--claw repo.
PLAN reads this before reasoning about blockers, fallbacks, next actions, and cross-repo effects.

---

## Current State Summary

> Last updated: 2026-03-14
> Last verified runtime: 2026-03-11
> Mirror source: AI-Project-Manager/docs/ai/STATE.md

### Phase Status (Open Claw)
| Phase | Status | Closed |
|-------|--------|--------|
| Phase 1 — Gateway Boot + First Agent Chat | COMPLETE | 2026-03-08 |
| **Phase 2 — First Live Integration** | **OPEN** | — |

### Phase 2 Exit Criteria (mirrors AI-PM Phase 6C)
- [x] Audit log captures actions
- [x] Hybrid model routing configured
- [x] WhatsApp channel operational
- [x] Telegram secured, Signal disabled
- [x] exec-policy.json deployed (4 require-approval rules)
- [x] gog OAuth complete (Gmail read access verified)
- [ ] **First integration connected and tested** (weather skill)
- [ ] **Approval gate tested for simulated high-risk action**

### Runtime Snapshot (as of 2026-03-11)
- Gateway: 127.0.0.1:18789, systemd managed, Node v22.22.0, pnpm 10.23.0
- Skills: 18/58 ready; Channels: WhatsApp (linked), Telegram (secured), Signal (disabled)
- Windows nodes: 0 connected (Molty removed)

### Archived Entries
Historical entries are archived in AI-Project-Manager/docs/ai/archive/. This file retains full history for open--claw-specific evidence.

---

## State Log

<!-- AGENT appends entries below this line after each execution block. -->

## 2026-03-07 — Documentation drift cleanup: upstream OpenClaw alignment

### Summary

- Updated wrapper docs to align runtime commands with upstream OpenClaw: onboarding now points to `openclaw onboard --install-daemon`, service verification to `openclaw gateway status`, health to `openclaw health`, and Control UI access to `openclaw dashboard`.
- Updated local environment and secret docs to match upstream env precedence instead of treating `~/.openclaw/.env` as the only supported source.
- Relocated the old handoff snapshot to `docs/ai/context/handoff-2026-02-23-phase1.md` and replaced `docs/ai/HANDOFF.md` with a short non-canonical pointer.
- Archived the old integration plan at `open-claw/docs/archive/INTEGRATIONS_PLAN-2026-02-18.md` and replaced `open-claw/docs/INTEGRATIONS_PLAN.md` with an archive notice.

### Evidence

| Check | Result | Detail |
| --- | --- | --- |
| Setup notes normalized | **PASS** | `open-claw/docs/SETUP_NOTES.md` now documents upstream-supported entrypoints and pinned runtime requirements |
| Blocked items normalized | **PASS** | `open-claw/docs/BLOCKED_ITEMS.md` now uses the upstream onboarding and gateway verification flow |
| Vault/env docs normalized | **PASS** | `open-claw/docs/VAULT_SETUP.md` now reflects upstream env precedence and auth-profile nuance |
| Handoff demoted from canonical status | **PASS** | Historical snapshot moved to `docs/ai/context/handoff-2026-02-23-phase1.md`; `docs/ai/HANDOFF.md` replaced with current pointer doc |
| Redundant integration plan archived | **PASS** | Historical content moved to `open-claw/docs/archive/INTEGRATIONS_PLAN-2026-02-18.md` |
| Live legacy memory mapping removed | **PASS** | `open-claw/docs/CODING_AGENT_MAPPING.md` now references `openmemory` |
| Plan wording aligned | **PASS** | `docs/ai/PLAN.md` updated to use `gateway status`, `health`, and dashboard wording |

### Remaining historical drift

- Older entries in this file still mention superseded memory-server names and startup wording because they are historical execution evidence.
- The archived handoff snapshot intentionally preserves older decisions and commands as a time-capsule record.

### What's next

1. Use upstream `vendor/openclaw/docs/*` as the runtime source of truth when wrapper docs need refreshes.
2. Treat `docs/ai/HANDOFF.md` as a redirect only; use `PLAN.md` and `STATE.md` for current status.

## 2026-02-18 — Phase 0, STEP 0: Preflight

### Evidence
| Check | Result | Detail |
|-------|--------|--------|
| WSL path | **PASS** | `/mnt/d/github/open--claw` exists |
| git | **PASS** | v2.43.0 |
| sequential-thinking | **PASS** | Responded to single thought |
| serena | **PASS** | `activate_project` + `list_dir` succeeded (project: `open-claw` at `D:\github\open-claw`) |
| Context7 | **PASS** | `/openclaw/openclaw` resolved, 4730 snippets |
| Exa Search | **PASS** | Architecture article returned |
| Memory Tool | **PASS** | `search_memories` returned empty (expected, no prior data) |
| firecrawl-mcp | **SKIPPED** | Exa works; only one of Exa/firecrawl required |

### Abort check
- sequential-thinking: PASS → no abort
- serena: PASS → no abort
- Exa Search: PASS → no abort (firecrawl not needed)

### What's next
- STEP 1: Git Initialization

## 2026-02-18 — Phase 0, STEP 1: Git Initialization

### Changes
- `git init` on `/mnt/d/github/open--claw`
- Local git config set (user: ynotf, email: ynotf@users.noreply.github.com)
- All 20 files staged and committed

### Evidence
- **git init**: **PASS** — empty repo created on `master`
- **Secret scan**: **PASS** — no patterns (sk-, ghp_, AIza, AKIA, token=, password=) found
- **git commit**: **PASS** — `0172c45 chore: initial scaffold — cursor workflow, module docs, memory contract`
- **git status**: **PASS** — clean working tree

### What's next
- STEP 2: Clone Vendor Repo

## 2026-02-18 — Phase 0, STEP 2: Clone Vendor Repo

### Changes
- Created `vendor/` directory
- Shallow-cloned `openclaw/openclaw` into `vendor/openclaw/` (5984 files)
- `vendor/` already in `.gitignore` — no commit needed

### Evidence
- **mkdir vendor**: **PASS**
- **git clone --depth=1**: **PASS** — 5984 files checked out
- **vendor/openclaw/package.json**: **PASS** — exists
- **vendor/ in .gitignore**: **PASS** — already present at line 15
- **git status**: **PASS** — vendor/ properly excluded

### What's next
- STEP 3: Repo Analysis

## 2026-02-18 — Phase 0, STEP 3: Repo Analysis

### Changes
- Mapped vendor/openclaw/ structure via WSL ls + Context7 + Exa Search
- Extracted architecture, security, skills, setup, cost data from Context7 and Exa
- Stored 3 key architecture observations in Memory Tool

### Evidence
- **serena activate_project**: **PASS** — open-claw project active
- **Context7 query-docs (architecture)**: **PASS** — gateway config, security, skills docs returned
- **Context7 query-docs (setup)**: **PASS** — WSL/pnpm install docs returned
- **Exa Search (security)**: **PASS** — formal verification, sandboxing, tool policy docs returned
- **Exa Search (cost)**: **PASS** — detailed pricing data from Hostinger + SaladCloud articles
- **Memory Tool add_memory (3x)**: **PASS** — all queued for background processing

### Key findings
- **Entrypoint**: `openclaw.mjs` → `dist/entry.js` (Node.js 22+, pnpm monorepo)
- **Config**: `~/.openclaw/openclaw.json` (JSON5), `.env` for secrets
- **Gateway**: WebSocket on `:18789`, loopback-only default, token/password auth
- **Channels**: WhatsApp (Baileys QR), Telegram, Discord, Slack, Signal, iMessage, Teams, Line + 20 more via extensions
- **Agent**: Pi Agent Core (`src/agents/piembeddedrunner.ts`), RPC streaming, multi-agent routing
- **Skills**: 52 skills in `skills/`, `SKILL.md` frontmatter, hot-loadable
- **Extensions**: 38 in `extensions/` (channels, memory backends, auth helpers)
- **Security**: loopback bind, token auth, Docker sandboxing, tool policy deny/allow, pairing DM gating, TLA+ formal models
- **Cost**: Free software; API $1-150/mo; VPS $5-50/mo; supports self-hosted models

### What's next
- STEP 4: Documentation (5 blueprint docs)

## 2026-02-18 — Phase 0, STEP 4: Documentation

### Changes
- Created `open-claw/docs/ARCHITECTURE_MAP.md` — repo structure, gateway, agent, channels, skills, config, module mapping
- Created `open-claw/docs/SETUP_NOTES.md` — WSL prereqs, Node 22, pnpm, dev loop, path mapping
- Created `open-claw/docs/SECURITY_MODEL.md` — vault, audit, approvals, sandbox, credential policy, secret scanning
- Created `open-claw/docs/INTEGRATIONS_PLAN.md` — Gmail/SMS/WhatsApp/calendar/contacts/banking approach
- Created `open-claw/docs/COST_MODEL.md` — AI model pricing, channel costs, infrastructure, routing, caps

### Evidence
- **ARCHITECTURE_MAP.md**: **PASS** — created with structure from STEP 3 analysis
- **SETUP_NOTES.md**: **PASS** — created from Context7 Windows/WSL docs
- **SECURITY_MODEL.md**: **PASS** — created from Exa security docs + Context7 config
- **INTEGRATIONS_PLAN.md**: **PASS** — mapped INTEGRATIONS.md targets to OpenClaw adapters
- **COST_MODEL.md**: **PASS** — pricing from Exa (Hostinger + SaladCloud articles)

### What's next
- STEP 5: Validation

## 2026-02-18 — Phase 0, STEP 5: Validation

### Evidence
- **Duplicate filename scan**: **PASS** — 0 case-insensitive duplicates (excluding vendor/, .git/)
- **Dangling reference check**: **PASS** — all referenced files exist in repo
- **Secret scan**: **PASS** — no token-like patterns found (excluding vendor/, .git/)

### What's next
- STEP 6: Finalize

## 2026-02-18 — Phase 0, STEP 6: Finalize

### Changes
- Updated `docs/ai/PLAN.md`: Phase 0 marked complete, Phase 1 + Phase 2 exit criteria drafted
- Full evidence log in STATE.md (this file)
- Final commit with all blueprint docs

### Phase 0 Summary
| Step | Status | Key Evidence |
|------|--------|-------------|
| STEP 0 Preflight | **PASS** | WSL, git, 5/5 MCP tools responded |
| STEP 1 Git Init | **PASS** | Commit `0172c45`, clean tree, no secrets |
| STEP 2 Clone Vendor | **PASS** | 5984 files, package.json exists, vendor/ gitignored |
| STEP 3 Repo Analysis | **PASS** | Structure mapped, docs extracted, 3 memories stored |
| STEP 4 Documentation | **PASS** | 5 blueprint docs created in open-claw/docs/ |
| STEP 5 Validation | **PASS** | 0 duplicates, 0 dangling refs, 0 secrets |
| STEP 6 Finalize | **PASS** | Phase 1 plan drafted, final commit |

### Deliverables
- `vendor/openclaw/` — shallow clone (gitignored)
- `open-claw/docs/ARCHITECTURE_MAP.md` — repo structure, gateway, agent, channels, skills, config
- `open-claw/docs/SETUP_NOTES.md` — WSL prereqs, Node 22, pnpm, dev loop, path mapping
- `open-claw/docs/SECURITY_MODEL.md` — auth, sandbox, tool policy, credential policy, formal verification
- `open-claw/docs/INTEGRATIONS_PLAN.md` — Gmail/SMS/WhatsApp/calendar/contacts/banking approach
- `open-claw/docs/COST_MODEL.md` — AI model pricing, channel costs, infra, routing, caps
- Git history: 3 commits (scaffold, [gitignore unchanged], blueprints)
- Phase 1 + Phase 2 plan drafted in `docs/ai/PLAN.md`

### What's next
- Phase 1: Development Environment & Gateway Boot (awaiting PLAN tab prompt)

---

## 2026-02-18 — Phase 1A, STEP 1: Environment

### Changes
- Installed nvm 0.40.1 in WSL
- Installed Node.js v22.22.0 via nvm
- Installed pnpm 10.30.0 via corepack

### Evidence
- **node --version**: **PASS** — v22.22.0 (≥22 required)
- **pnpm --version**: **PASS** — 10.30.0 (≥9 required)
- **WSL distro**: Ubuntu 24.04.3 LTS

### What's next
- STEP 2: Build (pnpm install, build, ui:build)

## 2026-02-18 — Phase 1A, STEP 2: Build

### Changes
- Moved build to native Linux FS (`~/openclaw-build/`) due to NTFS 9p EACCES rename issue
- `pnpm install` completed (1012 packages, 2m 58.5s)
- `pnpm build` completed (TypeScript + plugin SDK + hook metadata + export templates)
- `pnpm ui:build` completed (161 modules, control-ui assets built)

### Evidence
- **pnpm install**: **PASS** — exit 0, "Done in 2m 58.5s" (1 retry for network timeout)
- **pnpm build**: **PASS** — exit 0, dist/ generated
- **pnpm ui:build**: **PASS** — exit 0, control-ui/index.html + assets built
- **Build location**: `~/openclaw-build/` (native ext4, symlinked from plan references)
- **Note**: `/mnt/d/` NTFS mount has EACCES on pnpm atomic renames; native FS used for build

### What's next
- STEP 3: Onboard + Gateway

## 2026-02-18 — Phase 1A, STEP 3: Onboard + Gateway

### Status: BLOCKED

No model API key available. `~/.openclaw/` directory does not exist.

### Evidence
- **~/.openclaw/.env**: **BLOCKED** — file not found
- **~/.openclaw/ dir**: **BLOCKED** — directory not found
- **onboard**: **SKIPPED** — requires API key per plan instructions
- **gateway start**: **SKIPPED** — depends on onboard
- **health check**: **SKIPPED** — depends on gateway
- **playwright screenshot**: **SKIPPED** — depends on gateway

### To unblock
1. `wsl bash -c 'mkdir -p ~/.openclaw'`
2. Create `~/.openclaw/.env` with: `ANTHROPIC_API_KEY=sk-ant-...` or `OPENAI_API_KEY=sk-...`
3. Run: `cd ~/openclaw-build && pnpm openclaw onboard`
4. Configure: gateway.bind=loopback, gateway.auth.mode=token, skip all channels
5. Start: `pnpm openclaw start`
6. Verify: `curl -s http://127.0.0.1:18789/health`

### What's next
- Phase 1B: STEP 4 (Context7 lookups)

## 2026-02-18 — Phase 1B, STEPS 4–5: Research

### Evidence
- **Context7 (SKILL.md format)**: **PASS** — frontmatter: `name` + `description` required, optional `homepage`, `metadata.openclaw`
- **Context7 (extension API)**: **PASS** — `api.registerChannel()`, `api.registerTool()`, `api.registerProvider()`, discovery via `openclaw.extensions` in package.json
- **Context7 (config schema)**: **PASS** — full reference: gateway, agents, channels, session, tools, cron, bindings
- **serena/file reads (skill discovery)**: **PASS** — skills scanned from bundled `skills/`, workspace `~/.openclaw/workspace/skills/`, extra dirs via `skills.load.extraDirs`
- **serena/file reads (approval flow)**: **PASS** — found in `src/wizard/` (onboarding) + `src/plugins/types.ts` (registration API)
- **serena/file reads (audit)**: **PASS** — `src/security/audit.ts` with findings model: checkId, severity, title, detail, remediation
- **serena/file reads (extensions)**: **PASS** — `src/plugins/registry.ts`: registerTool, registerChannel, registerProvider

### Key findings for skill stubs
- SKILL.md requires `---` frontmatter with `name:` and `description:`
- Optional: `homepage:`, `metadata.openclaw:` (emoji, requires, install)
- Skills can have `scripts/`, `references/`, `assets/` subdirs
- Extensions need `openclaw.plugin.json` manifest or `package.json` with `openclaw.extensions`
- Audit system produces structured findings with severity levels

### What's next
- STEP 6: Create 8 skill stubs

## 2026-02-18 — Phase 1B, STEPS 6–9: Scaffold + Validation

### Changes (STEP 6)
Created 8 skill stubs in `open-claw/skills/`:
- `gmail-inbox/SKILL.md` — BLOCKED: Google Cloud project not created
- `domain-email/SKILL.md` — BLOCKED: IMAP/SMTP credentials not provided
- `sms-twilio/SKILL.md` — BLOCKED: Twilio credentials not provided
- `whatsapp-official/SKILL.md` — BLOCKED: Meta Business not verified
- `google-calendar/SKILL.md` — BLOCKED: Google Cloud project not created
- `google-contacts/SKILL.md` — BLOCKED: Google Cloud project not created
- `mem0-bridge/SKILL.md` — READY (requires mem0 MCP server)
- `approval-gate/SKILL.md` — READY (framework, requires approval channel)

### Changes (STEP 7)
- `open-claw/configs/openclaw.template.json5` — full config template with 3-tier model routing
- `open-claw/docs/VAULT_SETUP.md` — 1Password/Bitwarden CLI, startup scripts, rotation checklist
- `open-claw/docs/BLOCKED_ITEMS.md` — 8 blocked items with exact user actions to unblock

### Changes (STEP 8)
- Verified `.cursor/rules/` covers project conventions (4 rule files)
- Created `open-claw/docs/CODING_AGENT_MAPPING.md` — OpenClaw coding agent ↔ dev module mapping

### Evidence (STEP 9)
- **Secret scan**: **PASS** — no real secret patterns in repo (excluding vendor/)
- **SKILL.md frontmatter**: **PASS** — 8/8 have valid `name:` and `description:` fields
- **File paths**: **PASS** — all 12 new files exist

### What's next
- STEP 10: Finalize

## 2026-02-18 — Phase 1, STEP 10: Finalize

### Memory Tool
- **WARN**: Memory Tool MCP server disconnected mid-session
- Decisions documented in BLOCKED_ITEMS.md and skill SKILL.md files instead
- Key decisions: WhatsApp official API only, 3-tier model routing, approval gates for all outbound

### Phase 1 Summary
| Step | Status | Key Evidence |
|------|--------|-------------|
| STEP 1 Environment | **PASS** | Node 22.22.0, pnpm 10.30.0 |
| STEP 2 Build | **PASS** | install/build/ui:build all exit 0 (native Linux FS) |
| STEP 3 Onboard | **BLOCKED** | No API key in ~/.openclaw/.env |
| STEP 4 Context7 | **PASS** | SKILL.md format, extension API, config schema documented |
| STEP 5 serena | **PASS** | Skill discovery, audit, extension loading analyzed |
| STEP 6 Skills | **PASS** | 8 skill stubs created with valid frontmatter |
| STEP 7 Configs | **PASS** | Template config + VAULT_SETUP + BLOCKED_ITEMS created |
| STEP 8 Cursor | **PASS** | Rules verified, coding-agent mapping documented |
| STEP 9 Validation | **PASS** | 0 secrets, 8/8 valid frontmatter, all paths exist |
| STEP 10 Finalize | **PASS** | Memory (WARN: disconnected), STATE updated, Phase 2 drafted |

### Deliverables
- Build artifacts: `~/openclaw-build/dist/` (Node 22, pnpm, fully built)
- 8 skill stubs: `open-claw/skills/{gmail-inbox,domain-email,sms-twilio,whatsapp-official,google-calendar,google-contacts,mem0-bridge,approval-gate}/SKILL.md`
- Config template: `open-claw/configs/openclaw.template.json5`
- New docs: VAULT_SETUP.md, BLOCKED_ITEMS.md, CODING_AGENT_MAPPING.md
- Git: commit `feat: Phase 1 — gateway boot + integration scaffold`
- Phase 2 plan drafted in PLAN.md

### What's next
- Phase 2: First Live Integration (awaiting user to unblock Gateway + provide credentials)

## 2026-02-19 — Model Routing Rule Added

### Changes
- Created `.cursor/rules/15-model-routing.md` — model selection policy for all tabs
- Updated `.cursor/rules/10-project-workflow.md` — added "Rules in effect" list referencing 15-model-routing.md

### Why thinking-class vs non-thinking-class matters
Thinking-class models (GPT-5.2 High, GPT-5.2 Extra High, GPT-5.2 Codex High, GPT-5.2 Codex High Fast, GPT-5.2 Codex Fast) perform extended internal reasoning before responding. This is critical for PLAN and DEBUG where catching architectural flaws, security gaps, or root causes before implementation prevents expensive rework. Non-thinking-class models (Sonnet 4.6, Sonnet 4.5, Sonnet 4, Opus 4.6, Opus 4.5) are faster and better suited to AGENT execution where the plan is already decided. Fast utility models (GPT-5.2 Fast, GPT-5.2 Low) are reserved for ASK and ARCHIVE where reasoning depth adds no value.

### Default tab assignments
| Tab | Default Model | Class |
|-----|--------------|-------|
| PLAN | GPT-5.2 High | thinking-class |
| AGENT | Sonnet 4.6 | non-thinking-class |
| DEBUG | GPT-5.2 High | thinking-class |
| ASK | GPT-5.2 Fast | fast utility |
| ARCHIVE | GPT-5.2 Low | fast utility |

### Escalation rules summary
- **Rule A (AGENT, hard stop)**: multi-module refactor, auth/security changes, new architecture, rule changes, nondeterministic debugging → must switch to GPT-5.2 Codex High and halt
- **Rule B (PLAN, soft)**: security boundary, cost model, multi-system integration design → recommend GPT-5.2 Extra High, may proceed if declined
- **Rule C (ASK, hard stop at turn 3)**: unresolved after 2 turns → must switch to GPT-5.2 High and halt

### Evidence
- **.cursor/rules/15-model-routing.md**: **PASS** — created
- **.cursor/rules/10-project-workflow.md**: **PASS** — "Rules in effect" list added

### What's next
- Phase 2: First Live Integration (still awaiting API key)

---

## 2026-02-23 — Phase 1 Environment & Config Hardening

### Changes
- Executed Phase 1 AGENT prompt (environment verification, pnpm pinning, secret scan)
- Pinned pnpm to **10.23.0** via `corepack prepare pnpm@10.23.0 --activate` (matches `vendor/openclaw/package.json` `packageManager` field)
- Confirmed `.gitignore` covers all required patterns: `.env*`, `node_modules/`, `vendor/`, build artifacts
- Secret scan on all tracked files (excluding `vendor/`, `.git/`) — no hardcoded secrets found

### MCP Preflight Results
| Tool | Status | Evidence |
|------|--------|----------|
| sequential-thinking | **PASS** | Minimal call returned thought response |
| serena | **PASS** | `activate_project open-claw` succeeded |
| Context7 | **PASS** | Resolved `/openclaw/openclaw` library ID (4730 snippets, High reputation) |
| Exa Search | **PASS** | Fetched openclaw installer internals doc (2026-02-20) |
| Memory Tool (mem0) | **FAIL** | Server `user-Memory Tool` not in active MCP list — documented inline instead |
| GitHub MCP | **PASS** | `search_repositories` returned `ynotfins/open--claw` (id: 1162000439) |

### Environment Evidence
| Check | Result |
|-------|--------|
| WSL path `/mnt/d/github/open--claw` | **PASS** — exists |
| `git --version` | **PASS** — git 2.43.0 |
| `node --version` | **PASS** — v22.22.0 (≥22 required) |
| `vendor/openclaw` `packageManager` | **PASS** — `pnpm@10.23.0` |
| `corepack prepare pnpm@10.23.0 --activate` | **PASS** — pnpm now at 10.23.0 |
| `.gitignore` coverage | **PASS** — all required patterns present |
| Secret scan (hardcoded keys/tokens) | **PASS** — no matches |

### Durable facts (stored inline — Memory Tool unavailable)
- Node.js version: v22.22.0 (managed via nvm)
- pnpm version: 10.23.0 (pinned via corepack, derived from vendor/openclaw packageManager field)
- pnpm pinning approach: `corepack prepare pnpm@10.23.0 --activate` in WSL with nvm loaded

### What's next
- Phase 1: **PASS** — environment hardened and verified
- Phase 2: First Live Integration — blocked on API key provision (see `BLOCKED_ITEMS.md`)

---

## 2026-02-23 — Memory Tool MCP Verification & Backfill

### Changes
- Verified Memory Tool MCP connectivity: server `user-Memory Tool` is now **reachable**
- Root cause of prior failure: transient MCP session drop (server was registered but not connected); reconnected without config change
- Stored 4 durable facts backfilled from Phase 1 (were missed due to outage):
  1. Node.js v22.22.0 managed via nvm in WSL
  2. pnpm pinned to 10.23.0 via corepack
  3. pnpm pinning command: `corepack prepare pnpm@10.23.0 --activate`
  4. GitHub repo: `ynotfins/open--claw`, branch `master`
  5. Gateway boot blocker: needs API key in `~/.openclaw/.env`

### Evidence
| Check | Status | Detail |
|-------|--------|--------|
| `memory-tool` CLI in WSL | **FAIL** | No CLI binary — Memory Tool is an MCP server, not a shell tool (expected) |
| `CallMcpTool search_memories` | **PASS** | Returned `{"results": []}` (empty, correct — no prior facts stored) |
| `CallMcpTool add_memory` × 4 | **PASS** | All 4 facts queued (status: PENDING, event IDs logged) |
| Memory Tool server identifier | `user-Memory Tool` | Confirmed via `SERVER_METADATA.json` |

### What's next
- Memory Tool: **PASS** — callable and storing facts
- Phase 2: First Live Integration — still blocked on API key provision

---

## 2026-02-23 — Restart Preparation

### Changes
- Updated `docs/ai/HANDOFF.md`:
  - Corrected date (was 2026-02-18, now 2026-02-23)
  - Corrected pnpm version (was 10.30.0, now 10.23.0 — pinned)
  - Updated git history to HEAD commit `336a648`
  - Updated phase status table (Phase 1A ✅, Memory Tool ✅)
  - Added `15-model-routing.md` to repo structure
  - Updated Memory Tool MCP status from ⚠️ to ✅
  - Added **Section 10: Restart Checklist** with WSL/node/pnpm/git verification commands, MCP minimal tests, and model routing reminder
  - Renumbered old Section 10 (Known Gotchas) to Section 11
- All durable facts in Memory Tool confirmed stored (4 facts, queued as PENDING)

### Evidence
| Check | Status |
|-------|--------|
| HANDOFF.md accuracy review | **PASS** — 5 stale entries corrected |
| Restart checklist added | **PASS** — Section 10 in HANDOFF.md |
| STATE.md up to date | **PASS** — this entry |

### Current project state at restart
| Item | Value |
|------|-------|
| HEAD commit | `336a648` |
| Branch | `master` (in sync with origin) |
| Node | v22.22.0 |
| pnpm | 10.23.0 (pinned) |
| Gateway | 🔴 NOT STARTED — blocked on API key |
| Phase 2 | 🔴 NOT STARTED |
| Unblock required | User provides API key → `~/.openclaw/.env` |

### What's next
- Phase 2: First Live Integration
- Pre-condition: User provides `ANTHROPIC_API_KEY` or `OPENAI_API_KEY`
- After key is set: run Phase 2 AGENT prompt (boot gateway → first integration → approval gate test)

---

## 2026-02-23 — GitHub Rename Alignment (open-claw → open--claw)

### Changes
- GitHub repo renamed by user from `open-claw` to `open--claw` (double-dash, matches local workspace)
- Updated `origin` remote URL: `open-claw.git` → `open--claw.git`
- Fixed 2 stale `ynotfins/open-claw` references in `STATE.md`
- Fixed 2 stale `open-claw` path references in `HANDOFF.md` (serena section + gotchas table)
- Updated Memory Tool: stored corrected repo name fact (flagged the rename)

### Evidence — Phase A
| Step | Command | Status | Output |
|------|---------|--------|--------|
| A1 | `git remote -v` (before) | **PASS** | `open-claw.git` confirmed (old) |
| A2 | `remote set-url origin open--claw.git` | **PASS** | exit 0 |
| A3 | `git remote -v` (after) | **PASS** | both fetch+push = `open--claw.git` ✓ |
| A4 | `git fetch --all --prune` | **PASS** | exit 0, clean |
| A5 | `git push` | **PASS** | "Everything up-to-date" |
| Doc scan | grep `ynotfins/open-claw` in tracked files | **PASS** | 2 stale refs found + fixed |
| Doc scan | grep GitHub URLs in remaining files | **PASS** | no further stale refs |
| Memory Tool | `add_memory` corrected repo name | **PASS** | queued (event_id: 5950d9e4) |

### Canonical facts post-rename
- **GitHub repo**: `ynotfins/open--claw` (double-dash)
- **Clone URL**: `https://github.com/ynotfins/open--claw.git`
- **Local workspace**: `D:\github\open--claw` / WSL: `/mnt/d/github/open--claw`
- **All three names are consistent** — no further single-dash references remain

### What's next
- Laptop reclone (if needed): `git clone https://github.com/ynotfins/open--claw.git`
- Phase 2: still blocked on API key

---

## 2026-02-23 — Filesystem MCP Installed

### Changes
- Created `.cursor/mcp.json` with `@modelcontextprotocol/server-filesystem` pointing at `D:\github\open--claw`
- File is gitignored (`.gitignore` line 10: `.cursor/mcp.json`) — not committed to repo
- Cursor must be reloaded to activate the new MCP server

### Evidence
| Check | Status | Detail |
|-------|--------|--------|
| npx package resolve | **PASS** | `@modelcontextprotocol/server-filesystem` downloaded via npx cache |
| `.cursor/mcp.json` created | **PASS** | Written to `D:\github\open--claw\.cursor\mcp.json` |
| gitignore check | **PASS** | `check-ignore` confirms excluded at `.gitignore:10` |
| Server smoke test | **PASS** | "Secure MCP Filesystem Server running on stdio" |

### Config written
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:\\github\\open--claw"]
    }
  }
}
```

### What's next (superseded — see entry below)
- Project-level `.cursor/mcp.json` was removed; Filesystem MCP moved to global config

---

## 2026-02-23 — Filesystem MCP Moved to Global Config

### Changes
- Discovered `Filesystem` MCP (`https://file-mcp-smith--bhushangitfull.run.tools`) was **already present** in global `~/.cursor/mcp.json` (line 91-95)
- Deleted project-level `D:\github\open--claw\.cursor\mcp.json` (the npx-based local install)
- Global entry uses the Smithery-hosted remote HTTP transport — no npx required

### Evidence
| Check | Status | Detail |
|-------|--------|--------|
| Global `~/.cursor/mcp.json` read | **PASS** | `Filesystem` entry confirmed at line 91 |
| Project-level `.cursor/mcp.json` deleted | **PASS** | `Test-Path` returns `False` |
| Global config untouched | **PASS** | No edits needed — entry already correct |

### What's next
- **Reload Cursor** to deactivate old project-level server and confirm global `Filesystem` is green
- Phase 2: still blocked on API key

---

## 2026-02-24 — Filesystem MCP Deterministic Setup

### Changes
- Created `docs/tooling/MCP_HEALTH.md` — full failure history + current config
- Renamed MCP entry from `filesystem` → `filesystem-windows` in `~/.cursor/mcp.json`
- Reverted args to backslash notation (`D:\github` etc.) — forward slashes caused `%3A` encoding issue
- Fixed Desktop/Documents paths to OneDrive-redirected locations
- WSL UNC root (`\\wsl.localhost\Ubuntu\mnt\d\github`) — **BLOCKED** (access denied from PowerShell)

### Evidence — Phase A
| Check | Result |
|-------|--------|
| node | v22.18.0 |
| npm | 11.7.0 |
| pnpm | 10.24.0 |
| corepack | 0.33.0 |
| WSL distro | Ubuntu |

### Evidence — Phase B
| Check | Status | Detail |
|-------|--------|--------|
| `Test-Path D:\github` | **PASS** | exists |
| `Test-Path \\wsl.localhost\Ubuntu\mnt\d\github` | **BLOCKED** | Access denied |
| Server smoke test | **PASS** | "Secure MCP Filesystem Server running on stdio" |
| Cursor registration | **PENDING** | Requires Reload Window |

### Evidence — Phase C (proof reads)
| Test | Status |
|------|--------|
| `D:\github\open--claw\README.md` | PENDING |
| `D:\github\AI-Project-Manager\AGENTS.md` | PENDING |
| WSL UNC read | BLOCKED |

### Evidence — Phase C (proof reads) — UPDATED
| Test | Status | Detail |
|------|--------|--------|
| `D:\github\open--claw\README.md` | **PASS** | Full content returned via MCP |
| `D:\github\open--claw` list | **PASS** | 9 entries listed |
| `D:\github\AI-Project-Manager\AGENTS.md` | **PASS** | Cross-project read succeeded |
| WSL UNC read | **BLOCKED** | UNC `\\wsl.localhost\Ubuntu\...` access denied |

### Key finding
- Global `~/.cursor/mcp.json` servers: visible in UI (green) but NOT callable by agent
- Project `.cursor/mcp.json` servers: registered as `project-0-open--claw-filesystem-windows` and fully callable
- Removed duplicate from global config

### Final status: **PASS** (Windows filesystem), **BLOCKED** (WSL cross-platform)

### What's next
- Phase 2: still blocked on API key
- WSL fix (optional): investigate UNC path access for cross-platform reads

---

## 2026-02-25 — Canonical sync to GitHub (ChaosCentral wins)

### Gates
| Gate | Check | Status |
|------|-------|--------|
| A1 | Inside git work tree | **PASS** |
| A1 | Branch = master | **PASS** |
| A2 | Working tree clean | **PASS** (after .vscode ignored) |
| A3 | origin = `https://github.com/ynotfins/open--claw.git` | **PASS** |
| B | fetch --all --prune | **PASS** |
| B | Divergence check | **PASS** — no divergence |

### Hashes
| Ref | SHA |
|-----|-----|
| HEAD (local) | `02cdaf23c526a75bd4dceb4a53537a302d110bb9` |
| origin/master (before push) | `bfca8fe6a3d624c538d128b38dd3cb3d1dec8142` |

### Ahead/behind: `0 1` (local 1 ahead, remote 0 ahead — safe fast-forward)

### .vscode fix
- `.vscode/` was untracked and blocking clean-tree gate
- Added `.vscode/` to `.gitignore` (IDE/OS section)
- Committed as `02cdaf2`

### Push result
- **PASS** — `bfca8fe..02cdaf2` pushed to `origin/master`
- No force push required

### What's next
- Laptop clone: `git clone https://github.com/ynotfins/open--claw.git`
- Serena roots verification on laptop
- Phase 2: still blocked on API key

## 2026-02-26 — Global MCP Setup (Laptop → ChaosCentral parity)

### Summary
Installed Node.js 24.14.0, uv 0.10.6, shell-mcp-server 0.1.0. Wrote 16-server global `mcp.json`. Created `~/.serena/serena_config.yml` with both project paths. Created `AI-Project-Manager/docs/tooling/MCP_CANONICAL_CONFIG.md`. 4 servers BLOCKED on Bitwarden secrets (user must fill). Cursor restart required to activate.

### Evidence

| Check | Status | Detail |
|-------|--------|--------|
| Node.js install | **PASS** | v24.14.0 via winget |
| uv/uvx install | **PASS** | 0.10.6 via winget (astral-sh.uv) |
| shell-mcp-server install | **PASS** | 0.1.0 via `uv tool install`; exe at `C:\Users\ynotf\.local\bin\shell-mcp-server.exe` |
| shell-mcp-server sync main() | **PASS** | `inspect.iscoroutinefunction(main) = False` — no patch needed |
| mcp.json backup | **PASS** | `.backup.20260226-171958` |
| mcp.json written (16 servers) | **PASS** | JSON parses cleanly; all server keys present |
| Conflict check (both repos) | **PASS** | No per-project mcp.json found |
| `~/.serena/serena_config.yml` | **PASS** | Created with `D:\github\open--claw` + `D:\github\AI-Project-Manager` |
| Cursor restart | **PENDING** | User must quit/reopen Cursor |
| Tool visibility | **PENDING** | Post-restart verification by user |
| 4 secret-dependent servers | **BLOCKED** | `github`, `firecrawl-mcp`, `Magic MCP`, `googlesheets-tvi8pq-94` — fill from Bitwarden |

### What's next
- User fills 4 secrets from Bitwarden into `C:\Users\ynotf\.cursor\mcp.json`
- Fully restart Cursor
- Verify all 16 servers show tools in Settings → Tools & MCP
- Update this entry with PASS/FAIL per server
- Phase 2: still blocked on API key (`~/.openclaw/.env`)

---

## 2026-02-26 — Laptop Parity + MCP/Serena Health Proof

### Summary
Verified laptop == GitHub == ChaosCentral for `open--claw`. Probed Serena config and MCP tool visibility. Logged evidence in `docs/tooling/MCP_HEALTH.md`.

### Evidence

| Check | Status | Detail |
|-------|--------|--------|
| `git status` clean tree | **PASS** | Nothing to commit, working tree clean |
| `git remote -v` canonical | **PASS** | `origin https://github.com/ynotfins/open--claw` |
| Commit `02cdaf2` present | **PASS** | In log |
| Commit `2a65835` present (HEAD) | **PASS** | HEAD is canonical sync evidence commit |
| Serena `serena_config.yml` | **BLOCKED** | File not found at `~/.serena/`; directory absent; Serena not installed on this machine |
| Serena in workspace MCP | **FAIL** | Not registered in AI-Project-Manager workspace descriptors |
| Context7 MCP | **PASS** | `resolve-library-id` succeeded: `/openclaw/openclaw` 4730 snippets |
| GitKraken MCP | **WARN** | Server reachable, 13 tools; `git_status` fails exit 128 on both repos (safe.directory inside gkcli) |
| sequential-thinking MCP | **FAIL** | Not registered in this workspace |
| Memory Tool (mem0) | **FAIL** | Not registered in this workspace |
| filesystem RO MCP | **FAIL** | Project-level config removed (2026-02-24); not active this session |
| `C:\Windows\win.ini` read | **PASS** | Content returned via native agent read |
| `D:\github\open--claw\README.md` read | **PASS** | Full content returned |

### Key findings
- Serena is **not installed** on this laptop (no `~/.serena/` directory, no MCP registration). Requires explicit install + config before it can be used.
- `serena`, `sequential-thinking`, and `Memory Tool` were previously available in the `open--claw` project workspace context. They are **not available** in the current `AI-Project-Manager` workspace.
- GitKraken MCP: safe.directory fix applied via shell (`git config --global`) but gkcli has its own git instance that still hits exit 128. Not a blocking issue for current work.
- Context7 and cursor-ide-browser are fully operational.

### What's next
- Install Serena on laptop if needed for future sessions (see fix steps in `docs/tooling/MCP_HEALTH.md`)
- Phase 2: still blocked on API key (`~/.openclaw/.env`)

---

## 2026-02-25 — OpenMemory MCP Verification

### Summary
BLOCKED. `openmemory` SSE server is registered globally but errors on startup because the `Authorization` header is blank. No tools are exposed.

### Evidence
| Check | Status | Detail |
|-------|--------|--------|
| `openmemory` key in `~/.cursor/mcp.json` | PASS | SSE entry present |
| Server startup | FAIL | `STATUS.md` = "The MCP server errored" |
| Tools registered | FAIL | 0 tool descriptors in `mcps/user-openmemory/tools/` |
| `add_memories` callable | FAIL | "Tool not found" |
| `search_memory` callable | FAIL | "Tool not found" |
| `list_memories` callable | FAIL | "Tool not found" |

### Root cause
`~/.cursor/mcp.json` `openmemory.headers.Authorization` is `""` (blank). The OpenMemory SSE endpoint rejects unauthenticated connections before completing the handshake.

### Fix required (user action)
1. Obtain API key from [https://app.openmemory.ai](https://app.openmemory.ai) → Settings → API Keys.
2. Add `"Authorization": "Bearer <key>"` to the `openmemory` entry in `~/.cursor/mcp.json`.
3. Cursor → Reload Window → verify tools appear.

### Full log
See `docs/tooling/MCP_HEALTH.md` → "2026-02-25 — OpenMemory MCP Health Check"

---

## 2026-03-02 — OpenMemory MCP Functional Verification

### Summary
PASS. OpenMemory is fully operational from the open--claw project context. 7 tools registered, `add-memory` and `search-memory` both confirmed working.

### Evidence

| Check | Status | Detail |
|-------|--------|--------|
| Server healthy (no STATUS.md error file) | **PASS** | Server started cleanly |
| 7 tools registered | **PASS** | add-memory, search-memory, list-memories, delete-memory, delete-memories-by-namespace, update-memory, health-check |
| `add-memory` | **PASS** | Memory ingested async; id `ab8c2eca-d119-4247-98b0-c2d9099243bc` |
| `search-memory` (query: "five-tab workflow") | **PASS** | 1 result, score 0.692, exact content verified |

### Memory stored
- **Content**: `"OpenClaw governance: five-tab workflow PLAN/AGENT/DEBUG/ASK/ARCHIVE; evidence in docs/ai/STATE.md; MCP-first policy."`
- **Tags**: `namespace=open--claw`, `git_repo_name=ynotfins/open--claw`, `git_branch=master`, `memory_types=[project_info]`

### Key finding
`add-memory` requires `project_id` or `user_preference=true` — metadata alone is insufficient (returns `-32602`).

### Full log
`docs/tooling/MCP_HEALTH.md` → "2026-03-02 — OpenMemory MCP Functional Verification"

<!--
Format:

## <Date> — <Phase/Task>

### Changes
- ...

### Evidence
- **<tool/command>**: **PASS/FAIL** — <detail>

### What's next
- ...
-->

## 2026-03-07 — Gateway Boot Execution (Cross-Repo Phase 0)

### Goal
Execute the approved gateway bootstrap on ChaosCentral: verify tool health, verify the Linux build copy, confirm a redacted provider credential source, and complete onboarding plus gateway verification without exposing secrets.

### Scope
- `open--claw/docs/ai/STATE.md`
- `open--claw/docs/ai/PLAN.md`
- `open-claw/docs/BLOCKED_ITEMS.md`
- Out-of-repo runtime state under `~/.openclaw/` and `~/.config/systemd/user/`
- Cross-repo evidence mirrored in `AI-Project-Manager/docs/ai/STATE.md`

### Commands / Tool Calls
- `openmemory.search-memory` with `user_preference=true`
- `git -C D:/github/AI-Project-Manager status --short`
- `git -C D:/github/open--claw status --short`
- `openmemory.health-check`
- `github.get_file_contents` (`ynotfins/AI-Project-Manager`, `AGENTS.md`, branch `main`)
- `firecrawl_scrape` (`https://example.com`)
- `serena.activate_project` (`D:/github/AI-Project-Manager`)
- `serena.activate_project` (`D:/github/open--claw`)
- `sequential-thinking`
- `wsl bash -lc 'source ~/.nvm/nvm.sh && node -v && pnpm -v && cd ~/openclaw-build && pwd && test -f package.json && if [ ! -d node_modules ]; then pnpm install; fi && pnpm build && pnpm ui:build'`
- `wsl bash -lc 'for k in ANTHROPIC_API_KEY OPENAI_API_KEY GEMINI_API_KEY; do if [ -n "${!k}" ]; then echo "$k=<present in env>"; fi; done; if [ -f ~/.openclaw/.env ]; then awk -F= "/^(ANTHROPIC_API_KEY|OPENAI_API_KEY|GEMINI_API_KEY)=/ {print \$1\"=<present in ~/.openclaw/.env>\"}" ~/.openclaw/.env; fi'`
- `wsl bash -lc 'for k in ANTHROPIC_API_KEY OPENAI_API_KEY GEMINI_API_KEY; do v=$(printenv "$k"); if [ -n "$v" ]; then echo "$k=<present in env>"; fi; done; if [ -f ~/.openclaw/.env ]; then awk -F= "/^(ANTHROPIC_API_KEY|OPENAI_API_KEY|GEMINI_API_KEY)=/ {print \$1\"=<present in ~/.openclaw/.env>\"}" ~/.openclaw/.env; fi'`
- `wsl bash -lc 'for k in ANTHROPIC_API_KEY OPENAI_API_KEY GEMINI_API_KEY; do v=$(printenv "$k"); if [ -n "$v" ]; then echo "$k=<present in env>"; fi; done; if [ -f ~/.openclaw/.env ]; then grep -E "^(ANTHROPIC_API_KEY|OPENAI_API_KEY|GEMINI_API_KEY)=" ~/.openclaw/.env | sed "s/=.*$/=<present in ~/.openclaw/.env>/"; fi'`
- `wsl bash -lc 'source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw onboard --install-daemon'`
- `taskkill /PID 51992 /T /F`
- `wsl bash -lc 'source ~/.nvm/nvm.sh && set -a && . ~/.openclaw/.env && set +a && cd ~/openclaw-build && pnpm openclaw onboard --non-interactive --accept-risk --mode local --workspace ~/.openclaw/workspace --auth-choice apiKey --gateway-port 18789 --gateway-bind loopback --install-daemon --daemon-runtime node --skip-channels --skip-skills --json'`
- `wsl bash -lc 'source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw gateway status'`
- `wsl bash -lc 'source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw health'`
- `playwright.navigate` (`http://127.0.0.1:18789/openclaw`)
- `playwright.take_screenshot`

### Changes
- No repo files were edited before this state update.
- Confirmed a live provider credential source exists in `~/.openclaw/.env` without printing any secret values.
- Completed non-interactive onboarding and updated out-of-repo runtime state:
  - `~/.openclaw/openclaw.json`
  - `~/.config/systemd/user/openclaw-gateway.service`
- Captured dashboard evidence at `http://127.0.0.1:18789/openclaw`.

### Evidence
- `openmemory.search-memory`: **PASS** — 0 results; no prior memory changed the execution path.
- `openmemory.health-check`: **PASS** — healthy, 7 tools available.
- `github.get_file_contents`: **PASS** — returned `AGENTS.md` from `ynotfins/AI-Project-Manager`.
- `firecrawl_scrape`: **PASS** — returned `Example Domain` markdown with HTTP 200.
- `serena.activate_project` (`AI-Project-Manager`): **PASS** — project activated successfully.
- `serena.activate_project` (`open--claw`): **FAIL** — `No source files found in D:\github\open--claw`; fallback used.
- `sequential-thinking`: **PASS** — confirmed the execution order before build/boot work.
- WSL build verification: **PASS** — Node `v22.22.0`, pnpm `10.23.0`, `/home/ynotf/openclaw-build`, `pnpm build` PASS, `pnpm ui:build` PASS.
- Initial credential probe: **FAIL** — `/bin/bash: line 1: k: invalid indirect expansion`.
- First credential fallback: **FAIL** — incomplete evidence because key names were stripped by shell/`awk` quoting.
- Second credential fallback: **FAIL** — `sed: -e expression #1, char 23: unknown option to 's'`.
- Final credential probe: **PASS** — `ANTHROPIC_API_KEY=<present in ~/.openclaw/.env>` and `OPENAI_API_KEY=<present in ~/.openclaw/.env>`.
- Interactive onboarding: **FAIL** — blocked at the security confirmation prompt and could not complete unattended.
- `taskkill /PID 51992 /T /F`: **PASS** — terminated the stuck interactive onboarding process tree.
- Non-interactive onboarding retry: **PASS** — wrote config, ensured workspace/sessions, and installed the systemd user service.
- `openclaw gateway status`: **PASS** — service active, RPC probe ok, listening on `127.0.0.1:18789`.
- `openclaw health`: **PASS** — exited 0 and reported the default agent/session store.
- `playwright.navigate`: **PASS** — Control UI loaded with title `OpenClaw Control`.
- `playwright.take_screenshot`: **PASS** — captured dashboard screenshot evidence during the session.

### Verdict
READY — gateway boot is no longer blocked on missing credentials on this machine, and the managed gateway is running on loopback with token auth.

### Blockers
None

### Fallbacks Used
- `serena` on `open--claw` failed; fallback was `rg` + targeted `ReadFile`.
- The redacted credential probe required two command fallbacks before producing safe evidence.
- Interactive onboarding could not be automated; fallback was the supported non-interactive onboarding flow with `--accept-risk`.

### Cross-Repo Impact
- `AI-Project-Manager` Phase 6B now has live execution evidence and can stop treating gateway boot as blocked on a missing model credential.

### Decisions Captured
- For automated gateway bootstrap, use `openclaw onboard --non-interactive --accept-risk ...` instead of trying to script the interactive security prompt.
- When `open--claw` is effectively docs-only for Serena, proceed with `rg` + targeted reads and record the degradation explicitly.

### Pending Actions
- Update the current plan/blocker docs so they stop claiming gateway boot is blocked on a missing credential.
- Decide whether to address the `Systemd lingering is disabled` recommendation immediately or leave it as an operational hardening follow-up.

### What Remains Unverified
- Whether `pnpm openclaw dashboard` or another token-aware launch path would prefill the gateway token in the Control UI browser session.
- Whether the Google Fonts stylesheet console error in the dashboard matters operationally for local use.

### What's Next
- Narrowly update the gateway status sections in `docs/ai/PLAN.md` and `open-claw/docs/BLOCKED_ITEMS.md`, then evaluate whether a commit is safe given the pre-existing dirty worktree.

## 2026-03-07 — Gateway Boot Doc Sync And Commit Decision

### Goal
Update the runtime-facing status docs after the successful gateway boot, clean up the stray Playwright artifact, store the stable fallback pattern in memory, and decide whether a focused commit is safe.

### Scope
- `open--claw/docs/ai/STATE.md`
- `open--claw/docs/ai/PLAN.md`
- `open-claw/docs/BLOCKED_ITEMS.md`
- `AI-Project-Manager/docs/ai/PLAN.md`

### Commands / Tool Calls
- `ApplyPatch` on `open--claw/docs/ai/STATE.md`
- `ApplyPatch` on `open--claw/docs/ai/PLAN.md`
- `ApplyPatch` on `open-claw/docs/BLOCKED_ITEMS.md`
- `ApplyPatch` on `AI-Project-Manager/docs/ai/PLAN.md`
- `ReadLints` on the edited markdown files
- `Delete` on `D:/github/AI-Project-Manager/openclaw-control-ui-bootstrap.png`
- `openmemory.add-memory`
- `git -C D:/github/AI-Project-Manager status --short`
- `git -C D:/github/open--claw status --short`

### Changes
- Appended the gateway boot execution block to this repo's `docs/ai/STATE.md`.
- Updated `docs/ai/PLAN.md` so Phase 1 no longer claims Gateway Boot is blocked on a missing model credential.
- Updated `open-claw/docs/BLOCKED_ITEMS.md` so Gateway Boot is marked resolved on ChaosCentral with the remaining dashboard token caveat called out separately.
- Updated the governance-side Phase 6B note in `AI-Project-Manager/docs/ai/PLAN.md`.
- Removed the stray Playwright screenshot file from the `AI-Project-Manager` repo root.
- Stored the stable non-interactive onboarding fallback in OpenMemory.

### Evidence
- `ApplyPatch` (`open--claw/docs/ai/STATE.md`): **PASS** — execution block appended successfully.
- `ApplyPatch` (`open--claw/docs/ai/PLAN.md`): **PASS** — gateway status section updated successfully.
- `ApplyPatch` (`open-claw/docs/BLOCKED_ITEMS.md`): **PASS** — gateway boot marked resolved successfully.
- `ApplyPatch` (`AI-Project-Manager/docs/ai/PLAN.md`): **PASS** — governance-side Phase 6B note updated successfully.
- `ReadLints`: **PASS (informational)** — markdownlint reported pre-existing markdown warnings in long-running docs; nothing new blocked completion.
- `Delete`: **PASS** — removed `D:/github/AI-Project-Manager/openclaw-control-ui-bootstrap.png`.
- `openmemory.add-memory`: **PASS** — memory ingestion started asynchronously.
- Post-edit `git status` (`open--claw`): **PASS** — worktree still contains many pre-existing modified docs plus this session's doc updates.
- Post-edit `git status` (`AI-Project-Manager`): **PASS** — governance repo also remained dirty before this block.
- Commit/push decision: **SKIPPED** — not safe because this repo's `docs/ai/PLAN.md`, `docs/ai/STATE.md`, and `open-claw/docs/BLOCKED_ITEMS.md` were already dirty before execution, making a focused isolated commit unreliable.

### Verdict
READY — the runtime docs now match the verified gateway state, and the no-commit decision is documented instead of implied.

### Blockers
None

### Fallbacks Used
None

### Cross-Repo Impact
- `AI-Project-Manager` now records the same fallback-aware gateway boot state as this repo.
- Commit/push is intentionally deferred in both repos until the pre-existing dirty worktrees are reconciled.

### Decisions Captured
- Treat the interactive onboarding prompt as non-automatable in shell-only flows; prefer the documented non-interactive onboarding command for repeatable bootstrap.
- Skip commit/push when the same status files were already modified before the session and a clean focused commit cannot be separated safely.

### Pending Actions
- Verify whether `pnpm openclaw dashboard` or another token-aware path should be the default way to open the Control UI after boot.
- Decide whether to address the systemd lingering warning now or leave it as separate hardening.

### What Remains Unverified
- Whether the current governance plan should fully close Phase 6B once the launch-script/workspace behavior follow-up is complete.

### What's Next
- Start the next PLAN step from the updated state logs. The next work can target first live integration or remaining launch-script/dashboard hardening, but not from the old “missing credential” blocker assumption.

## 2026-03-07 — OpenClaw Gateway Token And WSL Shell Investigation

### Goal
Fix the stray WSL `fnm` shell-init error without disturbing the working `nvm` setup, verify the supported OpenClaw gateway-token retrieval path, and update the wrapper docs to match the observed dashboard-auth flow.

### Scope
- `D:/github/open--claw/docs/ai/STATE.md`
- `D:/github/AI-Project-Manager/docs/ai/STATE.md`
- `D:/github/open--claw/open-claw/docs/SETUP_NOTES.md`
- `D:/github/open--claw/open-claw/docs/BLOCKED_ITEMS.md`
- `~/.bashrc`
- `~/.profile`
- `~/.bash_profile`
- `C:/Users/ynotf/.openclaw/fix_bashrc.py` (temporary helper)
- `C:/Users/ynotf/.openclaw/probe_openclaw_gateway.sh` (temporary helper)

### Commands / Tool Calls
- `git status --short` (`D:/github/AI-Project-Manager`)
- `git status --short` (`D:/github/open--claw`)
- `ReadFile` on:
  - `D:/github/AI-Project-Manager/.cursor/rules/00-global-core.md`
  - `D:/github/AI-Project-Manager/.cursor/rules/05-global-mcp-usage.md`
  - `D:/github/AI-Project-Manager/.cursor/rules/10-project-workflow.md`
  - `D:/github/AI-Project-Manager/docs/ai/STATE.md`
  - `D:/github/open--claw/docs/ai/STATE.md`
  - `D:/github/open--claw/open-claw/docs/SETUP_NOTES.md`
  - `D:/github/open--claw/open-claw/docs/BLOCKED_ITEMS.md`
  - `D:/github/open--claw/vendor/openclaw/src/commands/dashboard.ts`
  - `D:/github/open--claw/vendor/openclaw/src/cli/config-cli.ts`
- `user-serena-activate_project` (`D:/github/AI-Project-Manager`)
- `user-serena-activate_project` (`D:/github/open--claw`)
- `user-serena-check_onboarding_performed`
- `user-serena-search_for_pattern`
- `rg` over `D:/github/open--claw/open-claw/docs` and `D:/github/AI-Project-Manager/docs`
- `user-filesystem_scoped-write_file`:
  - `C:/Users/ynotf/.openclaw/fix_bashrc.py`
  - `C:/Users/ynotf/.openclaw/probe_openclaw_gateway.sh`
- `user-openmemory-add-memory`
- `wsl bash --noprofile --norc -lc "python3 /mnt/c/Users/ynotf/.openclaw/fix_bashrc.py"`
- `wsl bash -lc "source ~/.nvm/nvm.sh && nvm use 22 && node -v && pnpm -v"`
- `wsl bash --noprofile --norc -lc "python3 - <<'PY' ... ~/.bashrc/.profile/.bash_profile inspection ... PY"`
- `wsl bash -lc "source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw gateway status && printf '\n---\n' && pnpm openclaw health"`
- `wsl bash /mnt/c/Users/ynotf/.openclaw/probe_openclaw_gateway.sh`
- `Remove-Item -Force "C:\Users\ynotf\.openclaw\fix_bashrc.py","C:\Users\ynotf\.openclaw\probe_openclaw_gateway.sh"`
- `ReadLints` on:
  - `D:/github/open--claw/open-claw/docs/SETUP_NOTES.md`
  - `D:/github/open--claw/open-claw/docs/BLOCKED_ITEMS.md`
  - `D:/github/AI-Project-Manager/docs/ai/STATE.md`
  - `D:/github/open--claw/docs/ai/STATE.md`
- `ApplyPatch` on:
  - `D:/github/open--claw/open-claw/docs/SETUP_NOTES.md`
  - `D:/github/open--claw/open-claw/docs/BLOCKED_ITEMS.md`
  - `D:/github/AI-Project-Manager/docs/ai/STATE.md`
  - `D:/github/open--claw/docs/ai/STATE.md`

### Changes
- Confirmed from source that `openclaw gateway` has no `token` subcommand; the supported raw-token path is `pnpm openclaw config get gateway.auth.token`.
- Confirmed from source that `pnpm openclaw dashboard --no-open` prints a tokenized dashboard URL via `#token=...`.
- Patched `~/.bashrc` so the stale `fnm` auto-switch line runs only when `fnm` is actually installed, while leaving the existing `nvm` initialization untouched.
- Updated `open-claw/docs/SETUP_NOTES.md` to document `dashboard --no-open`, `config get gateway.auth.token`, and `doctor --generate-gateway-token`.
- Updated `open-claw/docs/BLOCKED_ITEMS.md` so the dashboard-auth caveat points to the supported tokenized URL flow instead of manual token pasting as the default, and so the recorded dashboard URL matches the verified local path.
- Appended synchronized execution evidence to both repos' `docs/ai/STATE.md`.
- Removed the temporary helper scripts after verification completed.

### Evidence
- `git status --short` (`AI-Project-Manager`): **PASS** — paired governance repo was already dirty only in unrelated files; `docs/ai/STATE.md` was clean before this block.
- `git status --short` (`open--claw`): **PASS** — pre-existing dirty state limited to untracked `docs/ai/context/` and `open-claw/docs/archive/`; target docs were clean before this block.
- `ReadFile`: **PASS** — required rules, current state logs, wrapper docs, and OpenClaw source files were read before editing.
- `user-serena-activate_project` (`D:/github/AI-Project-Manager`): **PASS** — Serena activated in markdown mode for the governance repo.
- `user-serena-activate_project` (`D:/github/open--claw`): **FAIL** — `ValueError: No source files found in D:\github\open--claw`.
- `user-serena-check_onboarding_performed`: **PASS** — onboarding already available for the activated governance repo.
- `user-serena-search_for_pattern`: **PASS** — confirmed the wrapper docs lacked the narrow gateway-token command guidance being added here.
- `rg`: **PASS** — located the wrapper docs still referencing `dashboard` without the tokenized `--no-open` path.
- Initial inline shell patch attempts for `~/.bashrc`: **FAIL** — PowerShell/WSL quoting and the already-broken startup hook made the direct inline replacements unreliable.
- `user-filesystem_scoped-write_file` + `wsl bash --noprofile --norc -lc "python3 /mnt/c/Users/ynotf/.openclaw/fix_bashrc.py"`: **PASS** — `~/.bashrc` updated successfully.
- WSL shell inspection: **PASS** — `~/.profile` sources `~/.bashrc` and `~/.bash_profile` is missing, which explains why the stale `fnm` line fired in login shells.
- `wsl bash -lc "source ~/.nvm/nvm.sh && nvm use 22 && node -v && pnpm -v"`: **PASS** — Node `v22.22.0` and pnpm `10.23.0` resolved cleanly with no `fnm` error emitted.
- Source inspection of `dashboard.ts` and `config-cli.ts`: **PASS** — implementation confirms `cfg.gateway?.auth?.token ?? process.env.OPENCLAW_GATEWAY_TOKEN ?? ""`, `dashboard --no-open`, and `config get gateway.auth.token`.
- `wsl bash /mnt/c/Users/ynotf/.openclaw/probe_openclaw_gateway.sh`: **PASS** — confirmed `gateway.auth.token` is present and `dashboard --no-open` emits a tokenized dashboard URL. Secret values were intentionally redacted from repo docs.
- `wsl bash -lc "source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw gateway status && printf '\n---\n' && pnpm openclaw health"`: **PASS** — gateway runtime active, RPC probe `ok`, listener on `127.0.0.1:18789`, health output returned normally.
- `Remove-Item -Force "C:\Users\ynotf\.openclaw\fix_bashrc.py","C:\Users\ynotf\.openclaw\probe_openclaw_gateway.sh"`: **PASS** — temporary helper scripts removed after use.
- `user-openmemory-add-memory`: **FAIL then PASS** — first call failed because OpenMemory requires `user_preference` or `project_id`; retry with `user_preference=true` succeeded and started asynchronous ingestion.
- `ReadLints`: **PASS (informational)** — markdownlint reported a large pre-existing warning backlog in the long-running `STATE.md` logs; no new targeted issue from `SETUP_NOTES.md` or `BLOCKED_ITEMS.md` required action.
- `ApplyPatch` on wrapper docs + both `STATE.md` files: **PASS** — narrow documentation/state updates applied successfully.
- Commit/push: **SKIPPED** — user did not request a commit, so changes were left uncommitted.

### Verdict
READY — the shell-init issue is fixed, the supported raw-token and tokenized-URL paths are verified, and the wrapper docs now point to the correct dashboard-auth workflow.

### Blockers
None

### Fallbacks Used
- `user-serena-activate_project` failed for `D:/github/open--claw`; fallback used: `rg` + targeted `ReadFile`.
- Direct inline WSL patch commands were unreliable; fallback used: temporary helper scripts in `C:/Users/ynotf/.openclaw/` executed via `wsl bash --noprofile --norc`.
- `user-openmemory-add-memory` initially failed without scope metadata; fallback used: retry with `user_preference=true`.

### Cross-Repo Impact
- `AI-Project-Manager` now records the same verified shell/token findings as governance evidence.
- The paired repo's `docs/ai/STATE.md` stays synchronized with this runtime-facing record.

### Decisions Captured
- Treat `pnpm openclaw config get gateway.auth.token` as the canonical raw gateway-token retrieval path for the wrapper.
- Prefer `pnpm openclaw dashboard --no-open` when a browser session needs the Control UI pre-authenticated via a tokenized URL.
- Keep stale `fnm` hooks inert behind `command -v fnm` instead of removing working `nvm` initialization.

### Pending Actions
- If desired, re-open the Control UI from the printed tokenized URL and verify the browser session authenticates end-to-end.

### What Remains Unverified
- Whether launching the freshly printed tokenized dashboard URL in a browser fully clears the Control UI unauthorized state in this exact session; the command output path was verified, but the browser flow was not re-tested here.

### What's Next
- Lint the touched markdown files, then hand off the confirmed shell/token workflow along with the reusable AGENT prompt for future execution blocks.

---

## 2026-03-07 — WSL Shell + Gateway-Token Workflow Re-verification

### Goal
Re-verify the OpenClaw WSL shell init, Node environment, gateway-token retrieval, tokenized dashboard URL, and gateway health after PC restart. Confirm no regressions.

### Scope
- Runtime build: `~/openclaw-build`
- Vendor source inspected: `vendor/openclaw/src/commands/dashboard.ts`, `vendor/openclaw/src/cli/config-cli.ts`
- Files edited: `docs/ai/STATE.md`

### Commands / Tool Calls
- `grep -n 'fnm' ~/.bashrc` — shell inspection
- `wsl bash -lc "source ~/.nvm/nvm.sh && nvm use 22 && node -v && pnpm -v"` — Node environment
- `wsl bash -lc "source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw config get gateway.auth.token"` — token retrieval
- `wsl bash -lc "source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw dashboard --no-open"` — tokenized URL
- `wsl bash -lc "source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw gateway status && pnpm openclaw health"` — gateway state

### Changes
- Appended this execution block to `docs/ai/STATE.md`.
- No code, config, or shell-init changes.

### Evidence
- `~/.bashrc` fnm guard: `if command -v fnm >/dev/null 2>&1; then eval "$(fnm env --use-on-cd)"; fi` already in place at lines 126-127: **PASS — no edit needed**
- Node + pnpm: `v22.22.0` and `10.23.0` — no fnm error: **PASS**
- `pnpm openclaw config get gateway.auth.token`: token present (`<REDACTED>`): **PASS**
- `pnpm openclaw dashboard --no-open`: `Dashboard URL: http://127.0.0.1:18789/#token=<REDACTED>`, copied to clipboard: **PASS**
- `pnpm openclaw gateway status`: `Runtime: running (pid 8501)`, `RPC probe: ok`, `Listening: 127.0.0.1:18789`: **PASS**
- `pnpm openclaw health`: `Agents: main (default)`, heartbeat `30m`: **PASS**
- Non-blocking warning: service uses nvm Node, recommend `openclaw doctor --repair` when system Node 22 available: **WARN**

### Verdict
READY — all checks pass, no regressions.

### Blockers
None

### Fallbacks Used
None

### Cross-Repo Impact
- `AI-Project-Manager` records the same verified findings as governance evidence.

### Decisions Captured
- fnm guard already in place; do not modify `~/.bashrc`.
- `pnpm openclaw config get gateway.auth.token` — confirmed working.
- `pnpm openclaw dashboard --no-open` — confirmed working, emits `#token=` URL.
- Gateway runtime active and healthy on `127.0.0.1:18789`.

### Pending Actions
- Optional: `openclaw doctor --repair` to address nvm-vs-system-Node service warning.

### What Remains Unverified
- Browser-side Control UI token flow not tested.

### What's Next
- Proceed to Phase 6C or next operational step per `docs/ai/PLAN.md`.

---

## 2026-03-07 — fnm cd-hook fix + gateway-token workflow verification

### Goal
Stop fresh WSL shells from printing `Command 'fnm' not found`. Make the fnm cd-hook inert. Keep nvm Node 22 intact. Re-verify token and dashboard URL commands.

### Scope
- `~/.bashrc` (WSL home, machine-local, not repo-tracked)
- `docs/ai/STATE.md` appended

### Commands / Tool Calls
- `wsl bash --noprofile --norc -c "sed -n '115,135p' ~/.bashrc"` — read full fnm block
- `wsl bash -lc "ls -la /home/ynotf/.local/share/fnm"` — confirm binary
- Helper script via `wsl bash --noprofile --norc` — comment out `eval "$(fnm env --use-on-cd)"` at line 127
- `wsl bash -lc "source ~/.nvm/nvm.sh && nvm use 22 && node -v && pnpm -v"` — post-fix verification
- `wsl bash -lc "source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw config get gateway.auth.token"` — token
- `wsl bash -lc "source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw dashboard --no-open"` — tokenized URL
- `wsl bash -lc "source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw gateway status && pnpm openclaw health"` — gateway

### Changes
- `~/.bashrc` line 127: `eval "$(fnm env --use-on-cd)"` → `# eval "$(fnm env --use-on-cd)"  # disabled: conflicts with nvm PATH resets`

### Evidence
- Root cause: fnm binary exists at `~/.local/share/fnm/fnm` (v1.38.1). `fnm env --use-on-cd` installs a `cd` hook. `source ~/.nvm/nvm.sh` resets PATH, dropping the fnm multishell path, causing hook to fail on every `cd`.
- `.bashrc` edit applied: **PASS**
- `wsl bash -lc "source ~/.nvm/nvm.sh && nvm use 22 && node -v && pnpm -v"`: `v22.22.0` / `10.23.0`, no fnm error: **PASS**
- `pnpm openclaw config get gateway.auth.token`: token present: **PASS**
- `pnpm openclaw dashboard --no-open`: `Dashboard URL: http://127.0.0.1:18789/#token=<REDACTED>`: **PASS**
- `pnpm openclaw gateway status`: `running (pid 8501)`, `RPC probe: ok`: **PASS**
- `pnpm openclaw health`: `Agents: main (default)`: **PASS**

### Verdict
READY — fnm hook inert, nvm intact, all gateway commands working.

### Blockers
None

### Fallbacks Used
- PowerShell string escaping prevented direct `sed -i` via `wsl bash --noprofile --norc -c`. Fallback: temporary helper script at `C:/Users/ynotf/.openclaw/fix_fnm.sh`, removed after use: **PASS**

### Cross-Repo Impact
- `AI-Project-Manager/docs/ai/STATE.md` records the same evidence as governance log.

### Decisions Captured
- fnm binary exists and runs but conflicts with nvm. Fix is to disable only the cd-hook eval, not remove fnm.
- `pnpm openclaw config get gateway.auth.token` — canonical raw-token command.
- `pnpm openclaw dashboard --no-open` — canonical tokenized-URL command.
- `node openclaw.mjs gateway token` — invalid command (confirmed from terminal output).

### Pending Actions
- Optional: `openclaw doctor --repair` when system Node 22 available.
- Optional: browser Control UI auth end-to-end test.

### What Remains Unverified
- fnm fix behavior in a fully new interactive WSL session (not just `wsl bash -lc`).

### What's Next
- Proceed to Phase 6C or next operational step per `docs/ai/PLAN.md`.

---

## 2026-03-07 — Fix .bashrc syntax error (empty if/fi body) + re-verify gateway

### Goal
Fix `syntax error near unexpected token 'fi'` caused by prior fix leaving an `if/then/fi` with empty body. Re-verify all token and gateway commands.

### Scope
- `~/.bashrc` (WSL home, machine-local)
- `docs/ai/STATE.md` appended

### Commands / Tool Calls
- `wsl bash --noprofile --norc -c "bash -n /home/ynotf/.bashrc"` — syntax check pre-fix
- `wsl bash --noprofile --norc -c "cp ~/.bashrc ~/.bashrc.bak.pre_fi_fix"` — backup
- Three `sed -i` commands — comment out `if` (line 126) and `fi` (line 128)
- `wsl bash --noprofile --norc -c "bash -n /home/ynotf/.bashrc"` — syntax check post-fix
- `wsl bash -ic "echo shell-start-ok"` — interactive shell test
- `wsl bash -lc "source ~/.nvm/nvm.sh && nvm use 22 && node -v && pnpm -v"` — Node
- `wsl bash -lc "... pnpm openclaw config get gateway.auth.token"` — token
- `wsl bash -lc "... pnpm openclaw dashboard --no-open"` — tokenized URL
- `wsl bash -lc "... pnpm openclaw gateway status && pnpm openclaw health"` — gateway

### Changes
- `~/.bashrc` lines 126, 128: `if` and `fi` lines prefixed with `#`. Entire fnm auto-switch block now fully commented out.

### Evidence
- `bash -n` before: `line 128: syntax error near unexpected token 'fi'`: **FAIL (expected)**
- `bash -n` after: `SYNTAX_OK`: **PASS**
- `bash -ic "echo shell-start-ok"`: no errors: **PASS**
- `nvm use 22 && node -v && pnpm -v`: `v22.22.0` / `10.23.0`: **PASS**
- `pnpm openclaw config get gateway.auth.token`: present: **PASS**
- `pnpm openclaw dashboard --no-open`: `#token=<REDACTED>`: **PASS**
- `gateway status`: `running`, `RPC probe: ok`: **PASS**
- `health`: `Agents: main (default)`: **PASS**

### Verdict
READY — syntax error fixed, all checks pass.

### Blockers
None

### Fallbacks Used
- Helper script failed due to Windows line endings; used inline `sed -i` commands.

### Cross-Repo Impact
- `AI-Project-Manager/docs/ai/STATE.md` records the same evidence.

### Decisions Captured
- Bash `if/then/fi` with only a comment body is a syntax error. Must comment out the `if` and `fi` lines too, not just the body.

### Pending Actions
- Optional: `openclaw doctor --repair`, browser token auth test.

### What Remains Unverified
- Browser-side Control UI token flow.

### What's Next
- Proceed to Phase 6C or next operational step per `docs/ai/PLAN.md`.

---

## 2026-03-08 — Sync 13-section STATE.md template to open--claw rules

### Goal
Make open--claw's governance rules self-sufficient by adding the 13-section STATE.md entry template that was previously only defined in AI-Project-Manager.

### Scope
Files edited: `open--claw/.cursor/rules/10-project-workflow.md`, `open--claw/.cursor/rules/00-global-core.md`, `open--claw/AGENTS.md`. Repos affected: open--claw only.

### Commands / Tool Calls
- `Read` tool: AI-Project-Manager/.cursor/rules/10-project-workflow.md (source template)
- `Read` tool: open--claw/.cursor/rules/10-project-workflow.md (target)
- `Read` tool: open--claw/.cursor/rules/00-global-core.md (target)
- `Read` tool: open--claw/AGENTS.md (target)
- `StrReplace` tool: 10-project-workflow.md — inserted 13-section template block
- `StrReplace` tool: 00-global-core.md — replaced 4-bullet format with template reference
- `StrReplace` tool: AGENTS.md — updated State tracking and Agent contract sections
- `Grep` tool: secret scan across open--claw
- `Glob` tool: verified all path references in rules exist
- `git add` + `git commit` + `git push origin master`

### Changes
- `open--claw/.cursor/rules/10-project-workflow.md`: Added full 13-section STATE.md entry template with canonical-source note pointing to AI-Project-Manager.
- `open--claw/.cursor/rules/00-global-core.md`: Replaced 4-bullet state update format with template-referencing wording matching AI-PM's version.
- `open--claw/AGENTS.md`: Updated State tracking description and Agent contract bullet to reference enforced template in `10-project-workflow.md`.

### Evidence
| Check | Result | Detail |
|-------|--------|--------|
| Template inserted in 10-project-workflow.md | **PASS** | 13 sections present, canonical-source note included |
| 00-global-core.md updated | **PASS** | Now references template in 10-project-workflow.md |
| AGENTS.md updated | **PASS** | Both State tracking and Agent contract reference template |
| Case-duplicate files | **PASS** | NTFS case-insensitive; no duplicates possible |
| Path references exist | **PASS** | All 9 referenced paths verified via Glob |
| No secrets committed | **PASS** | Only match: placeholder `Bearer YOUR_KEY_HERE` in docs |
| No circular references | **PASS** | Rule chain: 00 <- 05 <- 10 <- 15/20, no cycles |
| Commit + push | **PASS** | `e5399eb` pushed to origin/master |

### Verdict
READY — open--claw now defines the same 13-section template as AI-Project-Manager.

### Blockers
None

### Fallbacks Used
None

### Cross-Repo Impact
AI-Project-Manager is unaffected. open--claw's rules now mirror AI-PM's STATE.md contract. This STATE.md entry is mirrored to both repos for traceability.

### Decisions Captured
- open--claw must define its own copy of the 13-section template (not rely on shared workspace loading AI-PM's rules).
- AI-Project-Manager remains the canonical source; open--claw's template includes a canonical-source reference.
- HH:MM timestamps deferred until Phase 6C or first ordering ambiguity.
- Cross-repo mirroring rule deferred (convention is working, LOW severity).

### Pending Actions
None

### What Remains Unverified
- Whether open--claw opened as a standalone workspace (not multi-root) correctly loads the template. This requires a manual test outside the current workspace.

### What's Next
- Proceed to Phase 6C or next operational step per `docs/ai/PLAN.md`.

---

## 2026-03-08 — Fix nvm not auto-loading after reboot (hardcoded PATH clobber)

### Goal
Make `node` and `pnpm` available automatically in fresh WSL interactive shells without manual recovery.

### Scope
- `~/.bashrc` (WSL home, machine-local)
- `docs/ai/STATE.md` appended

### Commands / Tool Calls
- `wsl bash --noprofile --norc -c "grep -n 'export PATH=' ~/.bashrc"` — find PATH exports
- `wsl bash --noprofile --norc -c "cp ~/.bashrc ~/.bashrc.bak.nvm_path_fix"` — backup
- `wsl bash --noprofile --norc -c "sed -i '133d' ~/.bashrc"` — delete hardcoded PATH
- `wsl bash --noprofile --norc -c "bash -n ~/.bashrc"` — syntax check
- `wsl bash -ic "command -v nvm && node -v && pnpm -v"` — auto-load test
- `wsl bash -ic "cd ~/openclaw-build && pnpm openclaw gateway status"` — gateway
- `wsl bash -ic "cd ~/openclaw-build && pnpm openclaw health"` — health
- `wsl bash -ic "cd ~/openclaw-build && pnpm openclaw config get gateway.auth.token"` — token
- `wsl bash -ic "cd ~/openclaw-build && pnpm openclaw dashboard --no-open"` — URL

### Changes
- `~/.bashrc` line 133 deleted — hardcoded `export PATH=...` that clobbered nvm's PATH additions after every shell init.

### Evidence
- Root cause: frozen `export PATH=...` snapshot appeared after nvm init, overwriting PATH on every `.bashrc` source.
- `bash -ic "command -v nvm && node -v && pnpm -v"`: `nvm`, `v22.22.0`, `10.23.0`: **PASS**
- Gateway status: `running (pid 366)`, `RPC probe: ok`: **PASS**
- Health: `Agents: main (default)`: **PASS**
- Token: present: **PASS**
- Dashboard URL: `#token=<REDACTED>`: **PASS**

### Verdict
READY — nvm auto-loads, gateway healthy.

### Blockers
None

### Fallbacks Used
None

### Cross-Repo Impact
- `AI-Project-Manager/docs/ai/STATE.md` records the same evidence.

### Decisions Captured
- Hardcoded PATH at EOF of `.bashrc` was the root cause of nvm failing to persist across reboots. Removed it; system PATH is inherited from WSL init.

### Pending Actions
- Optional: `openclaw doctor --repair`.

### What Remains Unverified
- Real WSL terminal window (from Windows Terminal) auto-load test not performed.

### What's Next
- Proceed to Phase 6C or next operational step per `docs/ai/PLAN.md`.

---

## 2026-03-08 18:38 — Phase 6B.2: Canonical Source Alignment + HH:MM

### Goal
Add HH:MM timestamps to STATE template, establish canonical runtime sources rule, fix Control UI URL drift, and record governance decisions from the comprehensive audit.

### Scope
Files touched: AI-PM `.cursor/rules/10-project-workflow.md`, AI-PM `docs/ai/memory/DECISIONS.md`, open--claw `.cursor/rules/10-project-workflow.md`, open--claw `open-claw/docs/SETUP_NOTES.md`, open--claw `docs/ai/PLAN.md`, both `docs/ai/STATE.md`. Both repos affected.

### Commands / Tool Calls
- `StrReplace` (6 edits across 5 files)
- `git ls-files | Sort-Object | Get-Unique` (case-duplicate scan, both repos)
- `Grep` for secret patterns (both repos)
- `git add`, `git commit`, `git push` (both repos)

### Changes
1. STATE template header changed from `<YYYY-MM-DD>` to `<YYYY-MM-DD HH:MM>` in both repos' `10-project-workflow.md`
2. Canonical runtime sources paragraph added to open--claw's `10-project-workflow.md`
3. Official docs URL added to `open-claw/docs/SETUP_NOTES.md` header
4. Control UI URL fixed in `open--claw/docs/ai/PLAN.md` (`/openclaw` → `/`)
5. Phase 6B.2 governance decisions recorded in `AI-PM/docs/ai/memory/DECISIONS.md`

### Evidence
- PASS: AI-PM template header now reads `## <YYYY-MM-DD HH:MM> — <task name>`
- PASS: open--claw template header matches
- PASS: Canonical sources paragraph added after "Project notes" section
- PASS: SETUP_NOTES.md starts with `> Official docs: https://docs.openclaw.ai/`
- PASS: PLAN.md URL changed to `http://127.0.0.1:18789/`
- PASS: DECISIONS.md appended with 8 governance decisions
- PASS: No case-duplicate files (AI-PM: 26/26, open--claw: 40/40)
- PASS: No secrets detected in either repo
- PASS: No circular rule references
- PASS: AI-PM commit `662be3f` pushed to origin/main
- PASS: open--claw commit `3a4ec1a` pushed to origin/master

### Verdict
READY — all Phase 6B.2 exit criteria met.

### Blockers
None

### Fallbacks Used
None

### Cross-Repo Impact
Both repos updated in lockstep. Template and canonical-source changes mirror across the workspace.

### Decisions Captured
Recorded in AI-PM `docs/ai/memory/DECISIONS.md`: canonical runtime sources, HH:MM adoption, ClawHub skill evaluation plan, Lobster deferral, openclaw-studio deferral, Docker deferral.

### Pending Actions
None for this phase.

### What Remains Unverified
None — all changes are documentation/governance with no runtime component.

### What's Next
Phase 6C: First live integration (requires Gateway running with ANTHROPIC_API_KEY).

---

## 2026-03-08 19:00 — Supplemental: Host Restart Verification Pattern + Evidence Density

### Goal
Execute supplemental rules for Phase 6B.2: add the "Host Restart Verification" pattern and confirm all prior deliverables satisfy enhanced evidence density requirements.

### Scope
- Pattern added to: `AI-Project-Manager/docs/ai/memory/PATTERNS.md` (canonical governance repo owns the pattern)
- STATE entries added to: both repos

### Commands / Tool Calls
See `AI-Project-Manager/docs/ai/STATE.md` for full command log.

### Changes
- `AI-Project-Manager/docs/ai/memory/PATTERNS.md`: Appended "Host Restart Verification" pattern with verification commands, expected evidence table, and caveats.
- This mirrored STATE.md entry.

### Evidence
- Execution order guard (templates before HH:MM entries): **PASS**
- All Phase 6B.2 deliverables verified: **PASS**
- Self-consistency checklist: **PASS**
- No secrets in committed files: **PASS**

### Verdict
READY

### Blockers
None

### Fallbacks Used
None

### Cross-Repo Impact
- **AI-Project-Manager** owns the "Host Restart Verification" pattern and all governance rules.
- **open--claw** mirrors the STATE template and references the pattern from AI-Project-Manager.

### Decisions Captured
See `AI-Project-Manager/docs/ai/memory/DECISIONS.md` Phase 6B.2 entry.

### Pending Actions
None

### What Remains Unverified

**Machine-local items:**
- Whether `loginctl enable-linger ynotf` is currently active.
- Cold-reboot terminal window nvm auto-load (tested via `bash -ic` in prior sessions but not a true cold-reboot window test).

**Repo-tracked items:**
- None.

### What's Next
Phase 6C: First live integration (requires Gateway running with ANTHROPIC_API_KEY).

---

## 2026-03-08 20:01 — Phase 6C.0: Gateway Liveness + First Agent Chat

### Goal
Verify gateway runtime health, authenticate to Control UI, confirm first agent chat, and close Phase 1 in this repo.

### Scope
- Phase 1 fully closed; Phase 2 marked OPEN in `docs/ai/PLAN.md`
- Machine-local: WSL gateway + Playwright browser automation
- See `AI-Project-Manager/docs/ai/STATE.md` for full command log

### Commands / Tool Calls
See `AI-Project-Manager/docs/ai/STATE.md 2026-03-08 20:01` for full evidence. Key commands:
- `wsl bash -ic "node -v && pnpm -v"` — node v22.22.0, pnpm 10.23.0
- `wsl bash -ic "cd ~/openclaw-build && pnpm openclaw gateway status"` — running, RPC probe ok
- `wsl bash -ic "cd ~/openclaw-build && pnpm openclaw health"` — agents: main (default)
- `wsl bash -ic "cd ~/openclaw-build && pnpm openclaw dashboard --no-open"` — tokenized URL obtained
- Playwright: navigate → screenshot → send prompt → wait → screenshot
- `cat ~/.openclaw/agents/main/sessions/sessions.json` — session evidence
- `tail -30 /tmp/openclaw/openclaw-2026-03-08.log` — gateway log evidence

### Changes
- `open--claw/docs/ai/PLAN.md`: Phase 1 residual caveat resolved; 6C.0 evidence block added; Phase 2 marked OPEN
- `open--claw/docs/ai/STATE.md`: this entry

### Evidence
- `node -v` → v22.22.0: **PASS**
- `pnpm -v` → 10.23.0: **PASS**
- `gateway status` → running, RPC probe ok: **PASS**
- `health` → Agents: main (default): **PASS**
- Control UI: Health OK, chat input active: **PASS**
- Agent response: `"Model: Claude Opus 4 (anthropic/claude-opus-4-6)"`: **PASS**
- Session store: sessionId `64a8f306-71f0-4dc1-bba3-7f9144764ee4`: **PASS**
- Gateway log: runId `5a47a2b6-86fd-4c0a-b0d0-770b0e3b8d0f`, `isError=false`, `durationMs=4514`: **PASS**

### Verdict
READY — Phase 1 closed. First agent chat verified. Phase 2 is next.

### Blockers
None

### Fallbacks Used
- `pnpm openclaw sessions list` not a valid command; used `sessions.json` file read instead.

### Cross-Repo Impact
- **AI-Project-Manager** (canonical governance repo): Phase 6B closed; Phase 6C unblocked. Evidence canonical there.
- **open--claw** (this repo, wrapper/runtime): Phase 1 closed; Phase 2 opened.

### Decisions Captured
See `AI-Project-Manager/docs/ai/STATE.md` — session listing fallback and accessibility-vs-visual screenshot reliability note.

### Pending Actions
None

### What Remains Unverified

**Machine-local items:**
- `loginctl enable-linger ynotf` status unknown.
- `openclaw doctor --repair` nvm/systemd warning unresolved (deferred).

**Repo-tracked items:**
- None.

### What's Next
Phase 2: First live integration — connect one external integration, test approval gate, validate audit log.

---

## 2026-03-08 20:37 — GitHub Restore Point: restore-20260308-2037-phase6c0

### Goal
Create a durable, named GitHub-backed restore point for both repos at post-Phase 6C.0 state, with HANDOFF.md updated and repo-tracked.

### Scope
- Tag created: `restore-20260308-2037-phase6c0` in this repo at `3807712`
- Canonical evidence lives in `AI-Project-Manager/docs/ai/STATE.md`

### Commands / Tool Calls
See `AI-Project-Manager/docs/ai/STATE.md 2026-03-08 20:37` for full command log.

### Changes
- `open--claw/docs/ai/HANDOFF.md`: updated to Phase 1 COMPLETE, Phase 2 OPEN; 6C.0 evidence added
- `open--claw/docs/ai/STATE.md`: this entry
- Annotated tag `restore-20260308-2037-phase6c0` at `3807712` pushed to `origin/master`

### Evidence
- open--claw HEAD SHA: `380771275f6afe4245c2da61dfa0832c1d7fcb18`
- Tag `restore-20260308-2037-phase6c0` pushed to `origin`: **PASS**
- HANDOFF.md updated: **PASS**

### Verdict
READY — restore point committed and tagged.

### Blockers
None

### Fallbacks Used
None

### Cross-Repo Impact
- **AI-Project-Manager** (canonical governance repo): owns restore point metadata, HANDOFF screenshots, and full STATE evidence.
- **open--claw** (this repo): tagged at `3807712`; HANDOFF.md updated.

### Decisions Captured
None

### Pending Actions
None

### What Remains Unverified

**Machine-local items (NOT covered by GitHub restore):**

| Item | Location | Restore action |
|---|---|---|
| Model credentials | `~/.openclaw/.env` | Manually recreate (`ANTHROPIC_API_KEY`, `OPENAI_API_KEY`) |
| Gateway config + token | `~/.openclaw/openclaw.json` | Re-run `pnpm openclaw onboard --install-daemon` |
| OpenClaw build | `~/openclaw-build/` (WSL ext4) | Re-run `pnpm install && pnpm build && pnpm ui:build` |
| Bitwarden access token | `BWS_ACCESS_TOKEN` env var | Set in PowerShell before `bws run` |
| nvm / `.bashrc` fix | `~/.bashrc` lines 125-128 | Verify after any distro reset |

**Repo-tracked items:**
- None.

### What's Next
Phase 2: First live integration — connect one external integration, test approval gate, validate audit log.

---

## 2026-03-09 19:10 — Phase 6C.1 Attempt: approval-gate + mem0-bridge (BLOCKED)

### Goal
Enable approval-gate and mem0-bridge skills in the live runtime and verify behavior.

### Verdict
BLOCKED — skills not deployed to live runtime. Config keys written but inert.

### Evidence Summary
| Check | Result |
|---|---|
| Gateway status + health | PASS — running, RPC ok, 1 session |
| `approval-gate` in `~/openclaw-build/skills/` | FAIL — not present |
| `mem0-bridge` in `~/openclaw-build/skills/` | FAIL — not present |
| `skills list` (9/50 ready) | PASS — command works; neither target skill listed |
| Config keys written | PASS — `~/.openclaw/openclaw.json` updated; inert without skill deployment |
| Gateway restart | PASS — running after restart |
| Skill loading in log | FAIL — no skill messages; runtime ignores unknown skill config |
| OpenMemory proxy at `:8766` | FAIL — Connection refused; Windows-side proxy not running in WSL |

### Blockers
1. `approval-gate` and `mem0-bridge` are **planning stubs in this repo** (`open-claw/skills/`), not deployed packages in `~/openclaw-build/skills/`. Must install via ClawHub (requires code review per DECISIONS.md) or manual copy.
2. `approval-gate` requires a paired messaging channel (`APPROVAL_CHANNEL` + `APPROVAL_TARGET`) — none configured.
3. OpenMemory proxy at `:8766` not reachable from WSL; requires Windows-side `bws run` launch.

### Cross-Repo Impact
- AI-Project-Manager: STATE.md template fixed (line 12 now has HH:MM). Full evidence entry recorded there.
- This entry is a concise mirror.

### Decisions Captured
- Skill planning stubs in `open-claw/skills/` are not auto-deployed; ClawHub or manual deployment required.
- Config keys for non-existent skills are written without error but have no runtime effect.
- Recommend pivot to a `ready` bundled skill (healthcheck, github, weather) for Phase 6C.1 instead.

### What's Next
Pivot Phase 6C.1 to a live-runtime-ready skill (`healthcheck`, `github`, or `weather`) OR unblock ClawHub install with mandatory code review for approval-gate.

---

## 2026-03-09 21:00 — Phase 0: Session Bootstrap (mirror)

### Goal
Verify system state, tooling health, and decide forward path for Phase 6C.1. Full evidence in AI-Project-Manager STATE.md.

### Verdict
READY — session bootstrap complete.

### Evidence Summary
| Check | Result |
|---|---|
| Git state (both repos) | PASS — expected branches, clean/known mods, restore tag present |
| WSL environment | PASS — Node v22.22.0, pnpm 10.23.0, ~/openclaw-build/ exists |
| Gateway | PASS — PID 24301, ports 18789 (UI) / 18792 (API) |
| MCP tools | Context7 PASS, GitHub PASS, Serena PASS (AI-PM), OpenMemory PASS. Firestore FAIL (pre-existing). |
| STATE.md currency | PASS — both repos consistent, last entry 2026-03-09 19:10 |
| Skills | PASS — 10/50 ready; healthcheck, github, weather all ✓ ready |

### Decisions Captured
- **PIVOT Phase 6C.1 to `weather` skill** as first integration test. Zero credentials, full pipeline exercise, lowest risk.
- Gateway port correction: 18789 (UI) / 18792 (API), not 3000.

### Cross-Repo Impact
- AI-Project-Manager: full 13-section entry + DECISIONS.md updated

### What's Next
PLAN cycle for Phase 1 (Phase 6C.1): weather skill integration test.

---

## Execution Block: Phase 6C.1 — SOP Docs + 12 Skills + Smoke Tests
**Timestamp:** 2026-03-09 22:50
**Agent:** AGENT

### Summary
- Created 3 SOP documents (RUNTIME_REFERENCE, SKILL_MANAGEMENT, SESSION_BOOTSTRAP_SOP)
- Installed 12 ClawHub skills (all 12 successful)
- Skills list: 19/60 ready (up from 10/50)
- Smoke tests: 5/5 Tier 1 PASS (weather, healthcheck, github, self-improving-agent, humanize-ai-text)
- Tier 2: web-search-exa BLOCKED (needs MCP config), playwright-mcp PARTIAL (needs system Chromium)
- Installed to `~/.openclaw/workspace/skills/` (workspace dir)
- Playwright + chromium downloaded to `~/.cache/ms-playwright/`

### Files Created
- `docs/ai/operations/RUNTIME_REFERENCE.md`
- `docs/ai/operations/SKILL_MANAGEMENT.md`

### Cross-Repo Impact
- AI-Project-Manager: SESSION_BOOTSTRAP_SOP.md + STATE.md + DECISIONS.md

### What's Next
1. Wire Exa MCP endpoint for web-search-exa
2. System Chromium for Playwright in WSL
3. Tier 3 credential setup (gmail, whatsapp, imap)
4. Multi-skill agent workflows

---

## Execution Block: Security — Remove Maton-Dependent Skills
**Timestamp:** 2026-03-10 00:23
**Agent:** AGENT

### Summary
- Removed `gmail` and `whatsapp-business` ClawHub skills (credential-proxying via `gateway.maton.ai`)
- Reverted `start-cursor-with-secrets.ps1`: removed MATON_API_KEY + WSL .env sync block
- Gateway restarted: 18/58 skills ready
- Added security warning to SKILL_MANAGEMENT.md

### What's Next
1. User: `pnpm openclaw configure --section channels` for built-in WhatsApp (QR scan)
2. User: Delete MATON_API_KEY from Bitwarden
3. Continue skill testing and multi-skill workflows

## 2026-03-10 01:00 — Phase 6C.2 mirror: Audit Log Verification + Hybrid Model Routing

### Goal
Enable audit logging and configure hybrid model routing on the OpenClaw gateway.

### Scope
Machine-local: `~/.openclaw/openclaw.json`. Governance: AI-Project-Manager owns full evidence. This is a mirror entry.

### Commands / Tool Calls
See AI-Project-Manager/docs/ai/STATE.md for full command log.

### Changes
- `command-logger` hook enabled in `openclaw.json`
- Model routing added: primary `anthropic/claude-sonnet-4-20250514`, fallback `openai/gpt-4o-mini`
- Weather query tested via Control UI — PASS (Open-Meteo, 59°F NYC)
- Model identity confirmed by agent — PASS

### Evidence
| Check | Result |
|---|---|
| Audit logging enabled | PASS |
| Model routing configured | PASS |
| Agent confirmed model identity | PASS |
| Weather skill test | PASS |

### Verdict
READY

### Blockers
None

### Fallbacks Used
None (see AI-PM STATE.md for details)

### Cross-Repo Impact
AI-Project-Manager: PLAN.md exit criteria updated, full STATE entry appended.

### Decisions Captured
See AI-Project-Manager/docs/ai/STATE.md.

### Pending Actions
First integration + approval gate test (Phase 6C / Phase 2 remaining criteria).

### What Remains Unverified
`commands.log` file creation after next qualifying command event.

### What's Next
Phase 2 exit criteria: first integration connected, approval gate tested.

## 2026-03-10 01:30 — Phase 6C.2 continued: WhatsApp + skill/integration audit (mirror)

Full entry in `AI-Project-Manager/docs/ai/STATE.md`.

**Summary**: WhatsApp verified fully operational (linked, running, connected, selfChatMode, allowlist). 19/58 skills ready. REST API chat returns 405 — WebSocket only (does not affect channels). `gog` installed but unauthenticated (OAuth pending). `imap-smtp-email` available on ClawHub but not installed (MXRoute credentials needed). SMS/iMessage not viable on Windows/WSL. Agent not yet named (bootstrap pending first WhatsApp message).

**Verdict**: READY — no blockers.

**Pending user actions**: (1) Name agent via WhatsApp, (2) Gmail OAuth setup in Google Cloud Console + `gog auth add`, (3) provide MXRoute credentials for `imap-smtp-email` install.

### What's Next
1. User names agent via WhatsApp
2. Gmail OAuth setup (`gog`)
3. MXRoute email integration (`imap-smtp-email`)
4. Close remaining Phase 6C exit criteria

---

## 2026-03-10 22:40 — Vendor Clone Pin: v2026.3.8

### Goal
Replace the untagged shallow vendor clone (commit b228c06, 2026-02-18) with a shallow clone pinned to the latest stable release v2026.3.8 on both Windows NTFS and WSL, then verify gateway stability at the new version.

### Scope
- `open--claw/vendor/openclaw/` (replaced, gitignored)
- `~/openclaw-build/` (WSL, replaced and rebuilt)
- `open--claw/VENDOR_PIN.md` (created, tracked)
- `open--claw/docs/ai/STATE.md` (this entry)
- `AI-Project-Manager/docs/ai/STATE.md` (mirror entry)
- `AI-Project-Manager/docs/ai/memory/DECISIONS.md` (decision logged)

### Commands / Tool Calls
- `git status --short --branch` (AI-Project-Manager) — verify clean main
- `git status --short --branch` (open--claw) — verify clean master
- `wsl bash -lc 'curl -s http://localhost:18792/'` — gateway API health
- `wsl bash -lc 'pnpm openclaw health'` — gateway health check
- `openmemory.health-check` — MCP health
- `Context7.resolve-library-id` (openclaw) — MCP health
- `github.get_file_contents` (AGENTS.md) — MCP health
- `wsl bash -lc 'pnpm openclaw skills list'` — pre-upgrade snapshot (19/58 ready)
- `wsl bash -lc 'cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.pre-v2026.3.8'` — config backup
- `wsl bash -lc 'pnpm openclaw gateway status'` — pre-upgrade status
- `git -C vendor\openclaw ls-remote --tags origin v2026.3.8` — verify tag exists (3caab92)
- `Move-Item vendor\openclaw vendor\openclaw.bak` — backup NTFS clone
- `git clone --depth=1 --branch v2026.3.8 ... vendor\openclaw` — fresh NTFS clone (8060 files)
- `git -C vendor\openclaw log --oneline -1` — verify HEAD
- `git -C vendor\openclaw rev-parse --is-shallow-repository` — verify shallow
- `Test-Path apps\android\build.gradle.kts` — verify Android app
- `Test-Path apps\shared\OpenClawKit\Package.swift` — verify shared kit
- `Get-Content package.json | Select-String version` — verify 2026.3.8
- `wsl bash -lc 'pnpm openclaw gateway stop'` — stop gateway
- `wsl bash -lc 'mv ~/openclaw-build ~/openclaw-build.bak'` — backup WSL copy
- `wsl bash -lc 'git clone --depth=1 --branch v2026.3.8 ... ~/openclaw-build'` — fresh WSL clone
- `wsl bash -lc 'pnpm install'` — install deps (1263 packages, 16s)
- `wsl bash -lc 'pnpm build'` — TypeScript build
- `wsl bash -lc 'pnpm ui:build'` — Vite UI build
- `wsl bash -lc 'cat package.json | grep version'` — verify 2026.3.8
- `wsl bash -lc 'systemctl --user restart openclaw-gateway.service'` — restart gateway
- `wsl bash -lc 'pnpm openclaw health'` — post-upgrade health
- `wsl bash -lc 'curl -s http://localhost:18792/'` — post-upgrade API
- `wsl bash -lc 'pnpm openclaw gateway status'` — post-upgrade status
- `wsl bash -lc 'pnpm openclaw skills list'` — post-upgrade skills (19/59 ready)

### Changes
- `vendor/openclaw/` — replaced with shallow clone at v2026.3.8 (tag SHA 3caab92, 8060 files)
- `~/openclaw-build/` — replaced with shallow clone at v2026.3.8, rebuilt (pnpm install + build + ui:build)
- `open--claw/VENDOR_PIN.md` — created (vendor pin metadata, clone command, upgrade/rollback procedures)
- Gateway restarted and verified at new version

### Evidence
| Check | Result | Detail |
|-------|--------|--------|
| AI-PM git status | PASS | main, clean |
| open--claw git status | PASS | master, clean |
| Gateway API pre-upgrade | PASS | curl :18792 → OK |
| Gateway health pre-upgrade | PASS | Agents: main (default) |
| Context7 MCP | PASS | Resolved openclaw library |
| github MCP | PASS | get_file_contents returned AGENTS.md |
| openmemory MCP | PASS | healthy, 7 tools |
| Pre-upgrade skills | PASS | 19/58 ready |
| Config backup | PASS | .pre-v2026.3.8 created |
| Tag v2026.3.8 exists | PASS | SHA 3caab92 |
| NTFS clone backup | PASS | Move-Item -Force |
| NTFS fresh clone | PASS | 8060 files |
| NTFS HEAD commit | PASS | 3caab92 |
| NTFS shallow | PASS | true |
| Android app present | PASS | build.gradle.kts exists |
| Shared kit present | PASS | Package.swift exists |
| NTFS version | PASS | 2026.3.8 |
| Gateway stopped | PASS | systemd service stopped |
| WSL backup | PASS | ~/openclaw-build.bak |
| WSL fresh clone | PASS | Detached HEAD 3caab92 |
| pnpm install | PASS | 1263 packages, 16s |
| pnpm build | PASS | tsdown + plugin SDK |
| pnpm ui:build | PASS | Vite built in 909ms |
| WSL version | PASS | 2026.3.8 |
| Gateway restart | PASS | systemctl restart |
| Health post-upgrade | PASS | Agents: main (default) |
| API post-upgrade | PASS | curl → OK |
| Gateway status post-upgrade | PASS | Runtime: running (pid 247862), RPC probe: ok |
| Skills post-upgrade | PASS | 19/59 ready (gained 1 from upstream, no regressions) |

### Verdict
READY — vendor clone pinned to v2026.3.8 on both copies, gateway verified stable.

### Blockers
None

### Fallbacks Used
- `Rename-Item` and `cmd /c rename` both failed on vendor clone due to broken pnpm symlinks in node_modules. Fallback: `Remove-Item` on node_modules first, then `Move-Item -Force`. PASS.
- Interactive `pnpm openclaw onboard --install-daemon` blocked at security prompt. Fallback: `systemctl --user restart openclaw-gateway.service`. PASS.

### Cross-Repo Impact
- AI-Project-Manager: STATE.md mirror entry appended, DECISIONS.md updated with vendor pin decision.

### Decisions Captured
- **Vendor pin: v2026.3.8 shallow clone** — untagged commit b228c06 was 3 weeks stale and post-dated CVE-2026-26327 fix. Shallow clone at tagged stable release provides deterministic, up-to-date vendor state. Documented in `VENDOR_PIN.md`.
- **Upgrade procedure formalized** — `VENDOR_PIN.md` documents the exact steps for future upgrades (both Windows NTFS and WSL copies).

### Pending Actions
- Remove backup directories after 24-hour verification period:
  - `Remove-Item -Recurse -Force D:\github\open--claw\vendor\openclaw.bak`
  - `wsl bash -lc 'rm -rf ~/openclaw-build.bak'`

### What Remains Unverified
- 24-hour gateway stability at v2026.3.8 (will be confirmed by continued normal usage).
- WhatsApp channel behavior at new version (pre-existing: linked but not yet agent-named).

### What's Next
1. Remove backup directories after 24-hour verification
2. Continue Phase 2 exit criteria: agent naming, Gmail OAuth, email integration

## 2026-03-11 04:10 — Windows Node Host Connected (mirror)

Full entry in `AI-Project-Manager/docs/ai/STATE.md`.

**Summary**: Windows Desktop node host connected to WSL gateway. Copied WSL `dist/` to Windows vendor dir (native build failed due to bash scripts). Token synced between Windows and WSL configs. Auto-paired on first connect. Capabilities: browser, system (system.run, system.which). Agent can now access Windows filesystem and execute native commands.

**Startup**: `cd D:\github\open--claw\vendor\openclaw && node openclaw.mjs node run --host 127.0.0.1 --port 18789 --display-name "Windows Desktop"` (gateway must be running first).

**Verdict**: PASS — paired, connected, operational.

### What's Next
1. Test Windows file access via Sparky
2. Consider `openclaw node install` for auto-start
3. Continue Phase 2 exit criteria

## 2026-03-11 04:10 — Molty (OpenClaw Windows Hub) v0.4.5 Installed

### Goal
Replace foreground Node.js node host with Molty, a persistent .NET WinUI system tray companion app providing richer node capabilities, auto-start, toast notifications, and embedded web chat.

### Architecture
```
WSL Gateway (:18789) <--WebSocket--> Molty Tray App (Windows, system tray)
                                      Caps: system, canvas, screen, camera
```

Replaces: `node openclaw.mjs node run --host 127.0.0.1 --port 18789` (foreground, terminal-bound)

### Commands / Steps Executed
1. Preflight: gateway health, token present, WebView2 v145.0.3800.97 — PASS
2. Downloaded `OpenClawTray-Setup-x64.exe` v0.4.5 from `shanselman/openclaw-windows-hub` releases (65.7 MB) — PASS
3. Stopped existing Node.js node host (PID 38812) — PASS
4. User ran installer, Molty launched as `OpenClaw.Tray.WinUI` (PID 33224) — PASS
5. Configured settings: token set, Node Mode enabled, gateway URL `ws://localhost:18789` — PASS
6. Molty registered as "Windows Node (CHAOSCENTRAL)", request ID `f6fd2b5c-...` — PASS
7. Approved device: `pnpm openclaw devices approve f6fd2b5c-...` — PASS (device ID `8af2d7db...`)
8. Added `gateway.nodes.allowCommands` (13 commands) to WSL config, restarted gateway — PASS
9. Molty reconnected after restart — PASS (logs: "Node status: Connected")
10. Test `system.run` via Molty: `echo hello` → stdout "hello", exitCode 0 — PASS
11. Test `system.notify` via Molty: toast notification sent — PASS

### Evidence
| Check | Result | Detail |
|-------|--------|--------|
| Gateway health | PASS | curl :18792 → OK |
| Molty installed | PASS | OpenClaw.Tray.WinUI at `%LOCALAPPDATA%\OpenClawTray\` |
| Node paired | PASS | ID 8af2d7db..., status: paired · connected |
| Capabilities | PASS | camera, canvas, screen, system |
| system.run test | PASS | stdout "hello", exitCode 0, 541ms |
| system.notify test | PASS | sent: true |
| Known nodes | 2 | Molty (connected), old Node.js "Windows Desktop" (disconnected) |

### Verdict
PASS — Molty v0.4.5 installed, paired, connected, and operational. System tray persistent node replaces foreground Node.js node.

### Changes Made
- Installed OpenClaw Windows Hub (Molty) v0.4.5 via setup exe
- Molty settings at `%APPDATA%\OpenClawTray\settings.json`: token, Node Mode enabled
- WSL gateway config: added `gateway.nodes.allowCommands` (13 commands)
- Old Node.js node host stopped (was PID 38812)

### Startup
Molty auto-starts from system tray. If not, launch from Start Menu or `%LOCALAPPDATA%\OpenClawTray\OpenClaw.Tray.WinUI.exe`.

### Pending
- Remove stale "Windows Desktop" node entry (old Node.js node): `pnpm openclaw devices remove 891178e9...`
- Enable auto-start in Molty Settings
- Configure exec approval policy at `%LOCALAPPDATA%\OpenClawTray\exec-policy.json`

### What's Next
1. Enable Molty auto-start with Windows
2. Remove stale old Node.js node registration
3. Test canvas, screen capture capabilities
4. Continue Phase 2 exit criteria

## 2026-03-11 05:00 — Docs Accuracy and Archive Phase 0 (mirror)

Full entry in `AI-Project-Manager/docs/ai/STATE.md`.

**Summary**: Created `docs/ai/archive/` in both repos with README. Added "never consulted" rule to `10-project-workflow.md`, `AGENTS.md`, `CURSOR_WORKFLOW.md` in both repos. Moved ephemeral files to archive. Archived and refreshed HANDOFF.md to 2026-03-11 state. Fixed duplicate Phase 1 blocks in open--claw PLAN.md.

**Verdict**: READY — all governance docs updated.

### What's Next
1. Continue Phase 2 exit criteria
2. Agent naming via WhatsApp
3. Gmail OAuth + MXRoute email setup

---
## 2026-03-11 — Fix: Telegram security + Signal disable + Molty removal

### Goal
Restore WhatsApp responsiveness and harden config after agent's Telegram setup caused gateway saturation.

### Scope
- ~/.openclaw/openclaw.json (WSL, not in git)
- ~/.openclaw/devices/paired.json (via openclaw devices remove)
- open--claw/docs/ai/STATE.md
- AI-Project-Manager/docs/ai/STATE.md (mirror)
- C:\Users\ynotf\.openclaw\start-cursor-with-secrets.ps1 (node host launch disabled)

### Commands / Tool Calls
- `pnpm openclaw health` — PASS (WhatsApp linked, Telegram ok, Signal failed)
- `pnpm openclaw nodes status` — Known: 1, Paired: 1, Connected: 0 (Windows Desktop)
- Python atomic write to ~/.openclaw/openclaw.json (3 changes)
- `cat openclaw.json | python3 -m json.tool` — JSON VALID
- `pnpm openclaw health` (post-edit) — Signal absent, Telegram ok, WhatsApp linked
- `pnpm openclaw devices remove 891178e9...6492f112` — Removed (x2: once before node reconnected, once after)
- `Stop-Process -Id 26472, 22036 -Force` — killed both node host processes
- `pnpm openclaw nodes status` — Known: 0, Paired: 0, Connected: 0
- `pnpm openclaw health` (final) — all criteria met
- start-cursor-with-secrets.ps1: node host launch block commented out

### Changes
- channels.telegram.dmPolicy: open → allowlist
- channels.telegram.allowFrom: ["*"] → ["6873660400"]
- channels.signal.enabled: true → false
- plugins.entries.signal.enabled: true → false
- gateway.nodes.allowCommands: removed (gateway.nodes now {})
- devices remove: 891178e9...6492f112 (Windows Desktop, stale) — removed twice
- Molty: stopped (Stop-Process); node host PIDs 26472 + 22036 killed
- start-cursor-with-secrets.ps1: node host auto-launch disabled (commented out)

### Evidence
| Check | Result |
|---|---|
| BLOCK 0 health | PASS — WhatsApp linked, Telegram ok, Signal failed |
| BLOCK 0 nodes | PASS — Known:1, Paired:1, Connected:0 |
| BLOCK 1 JSON VALID | PASS |
| BLOCK 1 changes verified | PASS — all 3 changes confirmed via python read-back |
| BLOCK 1 post-edit health | PASS — Signal absent, Telegram ok, WhatsApp linked |
| BLOCK 2 devices remove | PASS — Removed confirmed |
| BLOCK 3 Molty stopped | PASS — Option C applied; node host processes killed |
| BLOCK 4 health | PASS — WhatsApp linked, Telegram ok (@Sparky4bot), Signal absent |
| BLOCK 4 nodes | PASS — Known:0, Paired:0, Connected:0 |

### Verdict
PASS — all blocks complete, all criteria met.

### Blockers
None. Signal doctor warning (groupPolicy/allowlist) is cosmetic — Signal is disabled.

### Fallbacks Used
Shell tool used for all WSL commands (MCP shell-mcp not available in this context).
Node host processes killed via Stop-Process (Molty force-stop) since tray exit was not available.

### Cross-Repo Impact
Mirror entry appended to AI-Project-Manager/docs/ai/STATE.md.

### Decisions Captured
- Molty removed: decision to run gateway without a Windows node host until re-paired
- Signal disabled: signal-cli requires Java; channel was never operational
- Telegram locked to owner ID 6873660400 (dmPolicy: allowlist)
- Node host auto-launch disabled in start-cursor-with-secrets.ps1

### Pending Actions
- If Windows node capabilities (system.run, canvas, screen) are needed in future: re-install node host and re-pair
- Signal groupPolicy warning: can be cleaned up by removing signal channel config entirely or setting groupPolicy to "open"

### What Remains Unverified
Signal doctor warning (cosmetic only — channel is disabled).

### What's Next
1. Continue Phase 6C exit criteria: approval gate test, first integration
2. Agent naming via WhatsApp bootstrap conversation
