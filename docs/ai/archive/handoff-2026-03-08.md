# Agent Handoff — Open Claw

**Date**: 2026-03-08
**Handing off after**: Phase 1 COMPLETE (gateway boot + first agent chat verified)
**Next action**: Phase 2 — First Live Integration (requires integration credential; Google Cloud is highest-leverage unblock)

Previous handoff snapshot archived at `docs/ai/context/handoff-2026-02-23-phase1.md`.

---

## 1. What This Project Is

**Open Claw** is a modular AI assistant platform built on top of [OpenClaw](https://github.com/openclaw/openclaw). It orchestrates code development, communication, and workflow automation through a unified system with five Cursor workflow tabs: PLAN / AGENT / DEBUG / ASK / ARCHIVE.

The project **wraps and configures** OpenClaw for specific use cases (Gmail, calendar, contacts, SMS, WhatsApp, banking) with an approval-gated, audited, security-first approach.

This repo is the **execution** repo. The **governance** repo is `AI-Project-Manager`, which tracks phases, architecture, and cross-repo state.

| Repo | Role | Contains |
|------|------|----------|
| `AI-Project-Manager` | Governance | Phases, state logs, architecture docs, workflow rules, memory |
| `open--claw` | Execution | Project docs, skill stubs, configs, vendored OpenClaw runtime |

---

## 2. Current State at Handoff

### Git History

```
6ae7753  phase: close Phase 1, begin Phase 2.0 - first agent chat verified  ← HEAD
89e17d7  governance: dense STATE entry for Phase 6B.2 supplemental rules
7b720cd  state: Phase 6B.2 entry (first HH:MM-format)
3a4ec1a  governance: add HH:MM to STATE template + canonical source rule + fix Control UI URL
```

### Phase Status

| Phase | Status |
|-------|--------|
| Phase 0 — Project Kickoff | COMPLETE |
| Phase 1 — Gateway Boot + Integration Scaffold | **COMPLETE** |
| Phase 2 — First Live Integration | **OPEN** (not started — awaiting integration credential) |

### Phase 1 / 6C.0 Evidence (ChaosCentral, 2026-03-08)

- `openclaw onboard --install-daemon` completed via non-interactive flow
- `openclaw gateway status`: Runtime running (pid 366), RPC probe ok, listening 127.0.0.1:18789
- `openclaw health`: Agents: main (default), heartbeat 30m
- Control UI: authenticated via tokenized URL, Health: OK confirmed visually (screenshot captured)
- First agent chat: model `anthropic/claude-opus-4-6`, session `64a8f306-71f0-4dc1-bba3-7f9144764ee4`
- Gateway log: `runId=5a47a2b6`, `isError=false`, `durationMs=4514ms`

### Unverified

- `loginctl enable-linger ynotf` status (gateway post-logout survival)
- `openclaw doctor --repair` nvm/systemd warning (deferred stabilization)

---

## 3. Repo Structure

```
D:\github\open--claw\                    ← WSL: /mnt/d/github/open--claw/
├── .cursor/rules/
│   ├── 00-global-core.md
│   ├── 05-global-mcp-usage.md
│   ├── 10-project-workflow.md
│   ├── 15-model-routing.md              ← model inventory, tab defaults, escalation
│   └── 20-project-quality.md
├── AGENTS.md                            ← agent operating contract (start here)
├── docs/ai/
│   ├── STATE.md                         ← execution log (AGENT writes here)
│   ├── PLAN.md                          ← active plan with phases
│   ├── HANDOFF.md                       ← this file
│   ├── ARCHIVE.md
│   ├── CURSOR_WORKFLOW.md
│   ├── context/
│   │   └── handoff-2026-02-23-phase1.md ← archived Phase 1 handoff
│   ├── memory/
│   │   ├── DECISIONS.md
│   │   ├── MEMORY_CONTRACT.md
│   │   └── PATTERNS.md
│   └── tabs/
│       └── TAB_BOOTSTRAP_PROMPTS.md
├── open-claw/
│   ├── docs/                            ← project blueprints
│   │   ├── ARCHITECTURE_MAP.md          ← OpenClaw hub-and-spoke
│   │   ├── BLOCKED_ITEMS.md             ← blocked items + unblock steps  ← READ THIS
│   │   ├── CODING_AGENT_MAPPING.md
│   │   ├── COST_MODEL.md
│   │   ├── INTEGRATIONS.md
│   │   ├── INTEGRATIONS_PLAN.md
│   │   ├── MODULES.md
│   │   ├── REQUIREMENTS.md
│   │   ├── SECURITY_MODEL.md
│   │   ├── SETUP_NOTES.md               ← WSL + Node + pnpm setup + key commands
│   │   ├── VAULT_SETUP.md
│   │   ├── VISION.md
│   │   └── archive/
│   ├── skills/                          ← 8 skill stubs (SKILL.md each)
│   │   ├── gmail-inbox/         BLOCKED: Google Cloud project
│   │   ├── domain-email/        BLOCKED: IMAP/SMTP credentials
│   │   ├── sms-twilio/          BLOCKED: Twilio credentials
│   │   ├── whatsapp-official/   BLOCKED: Meta Business verification
│   │   ├── google-calendar/     BLOCKED: Google Cloud project
│   │   ├── google-contacts/     BLOCKED: Google Cloud project
│   │   ├── mem0-bridge/         READY: needs mem0 MCP server running
│   │   └── approval-gate/       READY: needs approval channel configured
│   └── configs/
│       └── openclaw.template.json5      ← config with 3-tier routing
└── vendor/openclaw/                     ← gitignored shallow clone
```

---

## 4. Key Technical Facts

### Build Environment

- **WSL Distro**: Ubuntu 24.04.3 LTS
- **Node**: v22.22.0 (installed via nvm at `/home/ynotf/.nvm/`)
- **pnpm**: 10.23.0 (pinned via `corepack prepare pnpm@10.23.0 --activate`)
- **Build location**: `~/openclaw-build/` on native Linux ext4 FS
  - Do NOT build on `/mnt/d/` — NTFS 9p mount causes EACCES on pnpm atomic renames
  - The `vendor/openclaw/` clone is on NTFS (gitignored); the working build is in `~/openclaw-build/`

### fnm Disabled

`~/.bashrc` lines 125-128 are fully commented out:
```bash
# fnm (auto switch)
# if command -v fnm >/dev/null 2>&1; then
  # eval "$(fnm env --use-on-cd)"  # disabled: conflicts with nvm PATH resets
# fi
```
The `fnm env --use-on-cd` command installs a `cd` hook that breaks when nvm resets PATH. Node is managed exclusively by nvm.

### nvm PATH Issue

In non-login WSL shells, `node` is not on PATH. Always prefix:
```bash
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && node ...'
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && cd ~/openclaw-build && pnpm ...'
```

### Gateway Token Workflow

The gateway auth token lives in `~/.openclaw/openclaw.json` under `gateway.auth.token`.

Three retrieval methods:
```bash
# 1. Raw token
source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw config get gateway.auth.token

# 2. Tokenized dashboard URL (preferred — authenticates browser automatically)
source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw dashboard --no-open

# 3. Regenerate if missing
source ~/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw doctor --generate-gateway-token
```

`node openclaw.mjs gateway token` is NOT a valid command. It errors with "too many arguments for 'gateway'."

### OpenClaw Architecture (vendor)

- **Gateway**: WebSocket on `127.0.0.1:18789`, loopback-only default, token auth
- **Entrypoint**: `openclaw.mjs` -> `dist/entry.js`
- **Config**: `~/.openclaw/openclaw.json` (JSON5)
- **Secrets**: `~/.openclaw/.env` (never in repo, chmod 600)
- **Channels**: 14 built-in + 38 extensions (WhatsApp Baileys is built-in but disabled — official API only)
- **Skills**: `SKILL.md` with YAML frontmatter (`name:` + `description:` required)
- **Extension API**: `api.registerChannel()`, `api.registerTool()`, `api.registerProvider()`
- **Plugin discovery**: `openclaw.plugin.json` manifest OR `package.json` with `openclaw.extensions`

### Model Routing (3-tier)

| Tier | Models | Use |
|------|--------|-----|
| Budget | gpt-4o-mini | Routine tasks, summaries, cron |
| Mid | gpt-4o, claude-haiku-4-5 | Balanced cost/performance |
| Premium | claude-sonnet-4-5, claude-opus-4-6 | Complex reasoning, coding |

### Security Decisions (non-negotiable)

- WhatsApp: **official Business Cloud API only** — Baileys disabled
- All outbound sends: **approval-gated** (email, SMS, WhatsApp, calendar events)
- Gateway: **loopback bind + token auth** always
- No secrets in repo, ever
- Sandbox mode: `non-main` by default

### Git Identity (local to this repo)

```
user.name  = ynotf
user.email = ynotf@users.noreply.github.com
```

---

## 5. Blocked Items (Priority Order)

See `open-claw/docs/BLOCKED_ITEMS.md` for full details. Summary:

| Priority | Item | What's Needed | Effort |
|----------|------|---------------|--------|
| **P1** | Google Cloud (#2, #6, #7) | One project covers Gmail + Calendar + Contacts | 30 min |
| **P1** | Cost Caps (#8) | Depends on gateway baseline | 5 min |
| **P2** | Domain Email (#3) | IMAP/SMTP credentials | 10 min |
| **P2** | Twilio SMS (#4) | Account + phone number | 15 min |
| **P3** | WhatsApp Business (#5) | Meta verification | 1-2 weeks |

Gateway Boot (#1) is **resolved** on ChaosCentral.

---

## 6. MCP Tool Status

| Tool | Status | Notes |
|------|--------|-------|
| sequential-thinking | PASS | Available |
| serena | WARN | `open--claw` activation returns "No source files found" — use `rg` + file reads as fallback |
| Context7 | PASS | Library ID: `/openclaw/openclaw` (4730 snippets) |
| Exa Search | PASS | Available |
| openmemory | PASS | 7 tools, add/search round-trip verified. Requires `user_preference=true` or `project_id` |
| playwright | PASS | Used for Phase 6C.0 Control UI screenshot + first agent chat |
| firecrawl-mcp | PASS | Available |
| GitHub MCP | PASS | Private repo access verified |

---

## 7. Phase 2 — What the Next Agent Must Do

### Pre-condition (user must provide)

At least one integration credential (Google Cloud project for Gmail/Calendar/Contacts is the highest-leverage unblock).

### Phase 2 Steps (once unblocked)

**STEP 1 — Verify Gateway**
```bash
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw gateway status'
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw health'
```

**STEP 2 — First Integration**
Connect whichever credential the user has provided first:
- If Google credentials: start with `gmail-inbox` or `google-calendar`
- If Telegram bot token: configure Telegram channel (easiest, built-in)
- If only API key available: configure `mem0-bridge` (no external credential needed)

**STEP 3 — Approval Gate**
- Configure `approval-gate` skill with the paired channel
- Execute one test outbound action
- Verify it blocks until approved
- Verify audit log captures the event

**STEP 4 — Security Review**
```bash
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw doctor'
```

**STEP 5 — Commit**
```
feat: Phase 2 — first integration connected + approval gate verified
```

### Phase 2 Exit Criteria (from PLAN.md)

- [ ] Gateway running on loopback with token auth
- [ ] `openclaw gateway status` succeeds
- [ ] `openclaw health` succeeds
- [ ] Control UI opens and screenshot is captured
- [ ] At least one integration fully connected end-to-end
- [ ] Approval gate tested (outbound action blocked until human approves)
- [ ] Audit log captures the full action chain
- [ ] Cost tracking active for the connected integration
- [ ] Security review: no exposed secrets, sandboxing verified
- [ ] `docs/ai/STATE.md` updated with Phase 2 evidence

---

## 8. Conventions the Next Agent Must Follow

1. **All commands in WSL** with path `/mnt/d/github/open--claw`
2. **Source nvm** before any node/pnpm command: `source /home/ynotf/.nvm/nvm.sh`
3. **Build always in `~/openclaw-build/`** — never `/mnt/d/` for pnpm operations
4. **Update `docs/ai/STATE.md`** after each execution block with PASS/FAIL evidence
5. **Mirror STATE.md** to `AI-Project-Manager/docs/ai/STATE.md` for cross-repo changes
6. **Secret scan** before every commit: `grep -rPn "(sk-[a-zA-Z0-9]{20,}|ghp_|AIza|AKIA)" ...`
7. **MCP-first**: use serena, Context7, Exa before falling back to manual file reads
8. **No secrets in repo, ever** — `~/.openclaw/.env` is the only valid secrets location
9. **Approval gates**: never implement an outbound action without a gate in the design
10. **Modular architecture**: separate ui, domain, data, utils — no >20 line monolith blocks

---

## 9. Files to Read First (Recommended Order)

1. `AGENTS.md` — operating contract
2. `.cursor/rules/00-global-core.md` — non-negotiable behaviors
3. `docs/ai/STATE.md` — full execution log
4. `docs/ai/PLAN.md` — what's planned
5. `open-claw/docs/BLOCKED_ITEMS.md` — what's blocked and how to unblock
6. `open-claw/docs/SETUP_NOTES.md` — local wrapper runtime/setup
7. `open-claw/docs/ARCHITECTURE_MAP.md` — OpenClaw structure
8. `open-claw/configs/openclaw.template.json5` — config starting point

---

## 10. Restart Checklist (Run After Every Cursor Restart)

```bash
# 1. Verify WSL path
wsl bash -c 'test -d /mnt/d/github/open--claw && echo PASS || echo FAIL'

# 2. Verify node + pnpm (nvm must be sourced)
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && node --version && pnpm --version'
# Expected: v22.22.0 / 10.23.0

# 3. Re-pin pnpm if version drifted (safe to re-run always)
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && corepack prepare pnpm@10.23.0 --activate'

# 4. Verify git status is clean
wsl bash -c 'cd /mnt/d/github/open--claw && git status && git log --oneline -3'
```

**MCP tools to verify:**

| Tool | Minimal test |
|------|-------------|
| sequential-thinking | minimal `sequentialthinking` call |
| serena | `activate_project AI-Project-Manager` (open--claw will fail — known issue) |
| Context7 | `resolve-library-id` query for `openclaw` |
| openmemory | `health-check` call |
| GitHub MCP | `search_repositories` for `ynotfins` |

---

## 11. Known Gotchas

| Gotcha | Solution |
|--------|----------|
| `node: command not found` in WSL | `source /home/ynotf/.nvm/nvm.sh` first |
| `Command 'fnm' not found` in WSL | Already fixed — lines 125-128 of `~/.bashrc` commented out |
| `fnm env --use-on-cd` installs cd hook | Conflicts with nvm PATH resets. Must be fully disabled, not just guarded |
| Empty `if/then/fi` body in bash | A comment alone is a syntax error. Comment out the entire `if/fi` structure |
| `EACCES rename` on pnpm install | Build in `~/openclaw-build/`, never `/mnt/d/` |
| `node openclaw.mjs gateway token` | NOT a valid command. Use `pnpm openclaw config get gateway.auth.token` |
| `openclaw onboard` hangs | Use `--non-interactive --accept-risk` flags |
| Dashboard URL path | Root `/` not `/openclaw`. Use `pnpm openclaw dashboard --no-open` for tokenized URL |
| serena `open--claw` activation | Returns "No source files found". Use `rg` + targeted file reads as fallback |
| openmemory search returns -32602 | Must provide `user_preference=true` or `project_id` |
| WhatsApp Baileys temptation | Built-in and easy, but decision is: official API only |
| `wsl` command from inside WSL | `wsl` is a Windows command. Run commands directly when already inside WSL |
