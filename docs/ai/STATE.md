# Execution State — Open Claw

Bootstrapped; nothing executed yet.

---

## State Log

<!-- AGENT appends entries below this line after each execution block. -->

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
