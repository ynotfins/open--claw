# Agent Handoff — Open Claw

**Date**: 2026-02-18  
**Handing off after**: Phase 0 (complete) + Phase 1 (partial — 1 blocker)  
**Next action**: Phase 2 — First Live Integration (BLOCKED on API key)

---

## 1. What This Project Is

**Open Claw** is a modular AI assistant platform built on top of [OpenClaw](https://github.com/openclaw/openclaw) (the open-source self-hosted AI agent). It orchestrates code development, communication, and workflow automation through a unified system with five Cursor workflow tabs: PLAN / AGENT / DEBUG / ASK / ARCHIVE.

The project is **not** OpenClaw itself — it *wraps and configures* OpenClaw for specific use cases (Gmail, calendar, contacts, SMS, WhatsApp, banking) with an approval-gated, audited, security-first approach.

---

## 2. Current State at Handoff

### Git History
```
752805b  feat: Phase 1 — gateway boot + integration scaffold      ← HEAD
c2ab1a4  docs: Phase 0 complete — architecture analysis and blueprints
0172c45  chore: initial scaffold — cursor workflow, module docs, memory contract
```

### Phase Status
| Phase | Status |
|-------|--------|
| Phase 0 — Project Kickoff | ✅ COMPLETE |
| Phase 1A — Gateway Boot | ⚠️ PARTIAL (1 blocker) |
| Phase 1B — Integration Scaffold | ✅ COMPLETE |
| Phase 2 — First Live Integration | 🔴 NOT STARTED |

### The Single Blocker
**No model API key has been configured.** `~/.openclaw/` does not exist.

This is the only thing blocking the gateway. Fix:
```bash
wsl bash -c 'mkdir -p ~/.openclaw && echo "ANTHROPIC_API_KEY=sk-ant-YOUR_KEY" > ~/.openclaw/.env && chmod 600 ~/.openclaw/.env'
```

---

## 3. Repo Structure

```
D:\github\open--claw\                    ← WSL: /mnt/d/github/open--claw/
├── .cursor/rules/                       ← 4 project rule files (read these)
│   ├── 00-global-core.md
│   ├── 05-global-mcp-usage.md
│   ├── 10-project-workflow.md
│   └── 20-project-quality.md
├── AGENTS.md                            ← Agent operating contract (start here)
├── docs/ai/
│   ├── STATE.md                         ← Full execution log (AGENT writes here)
│   ├── PLAN.md                          ← Active plan with phases
│   ├── ARCHIVE.md                       ← Compressed past decisions
│   ├── HANDOFF.md                       ← This file
│   ├── CURSOR_WORKFLOW.md
│   ├── memory/
│   │   ├── MEMORY_CONTRACT.md
│   │   ├── DECISIONS.md
│   │   └── PATTERNS.md
│   └── tabs/TAB_BOOTSTRAP_PROMPTS.md
├── open-claw/
│   ├── docs/                            ← All project blueprints
│   │   ├── ARCHITECTURE_MAP.md          ← OpenClaw hub-and-spoke explained
│   │   ├── SETUP_NOTES.md               ← WSL + Node + pnpm setup
│   │   ├── SECURITY_MODEL.md            ← Auth, sandbox, tool policy
│   │   ├── INTEGRATIONS_PLAN.md         ← Gmail/WhatsApp/Calendar approach
│   │   ├── COST_MODEL.md                ← Pricing and routing tiers
│   │   ├── VAULT_SETUP.md               ← Secret management (1Password/Bitwarden)
│   │   ├── BLOCKED_ITEMS.md             ← 8 blocked items + unblock steps  ← READ THIS
│   │   ├── CODING_AGENT_MAPPING.md      ← OpenClaw coding-agent ↔ dev module
│   │   ├── MODULES.md                   ← Module boundaries
│   │   ├── INTEGRATIONS.md              ← Integration targets
│   │   ├── REQUIREMENTS.md
│   │   └── VISION.md
│   ├── skills/                          ← 8 skill stubs (SKILL.md each)
│   │   ├── gmail-inbox/         🔴 BLOCKED: Google Cloud project
│   │   ├── domain-email/        🔴 BLOCKED: IMAP/SMTP credentials
│   │   ├── sms-twilio/          🔴 BLOCKED: Twilio credentials
│   │   ├── whatsapp-official/   🔴 BLOCKED: Meta Business verification
│   │   ├── google-calendar/     🔴 BLOCKED: Google Cloud project
│   │   ├── google-contacts/     🔴 BLOCKED: Google Cloud project
│   │   ├── mem0-bridge/         🟡 READY: needs mem0 MCP server running
│   │   └── approval-gate/       🟡 READY: needs approval channel configured
│   └── configs/
│       └── openclaw.template.json5      ← Full config with 3-tier routing
└── vendor/openclaw/                     ← Gitignored shallow clone
```

---

## 4. Key Technical Facts

### Build Environment
- **WSL Distro**: Ubuntu 24.04.3 LTS
- **Node**: v22.22.0 (installed via nvm at `/home/ynotf/.nvm/`)
- **pnpm**: 10.30.0 (installed via corepack)
- **Build location**: `~/openclaw-build/` on native Linux ext4 FS
  - **Critical**: Do NOT build on `/mnt/d/` — NTFS 9p mount causes EACCES on pnpm atomic renames
  - The `vendor/openclaw/` clone is on NTFS (gitignored); the working build is in `~/openclaw-build/`

### nvm PATH Issue
In non-login WSL shells, `node` is not on PATH. Always prefix:
```bash
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && node ...'
# or
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && cd ~/openclaw-build && pnpm ...'
```

### Git Identity (local to this repo)
```
user.name  = ynotf
user.email = ynotf@users.noreply.github.com
```

### OpenClaw Architecture (vendor)
- **Gateway**: WebSocket on `127.0.0.1:18789`, loopback-only default, token auth
- **Entrypoint**: `openclaw.mjs` → `dist/entry.js`
- **Config**: `~/.openclaw/openclaw.json` (JSON5)
- **Secrets**: `~/.openclaw/.env` (never in repo, chmod 600)
- **Channels**: 14 built-in + 38 extensions (WhatsApp Baileys is built-in but we disable it — use official API only)
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

---

## 5. Blocked Items (Priority Order)

See `open-claw/docs/BLOCKED_ITEMS.md` for full details on all 8. Priority:

| Priority | Item | What's Needed | Time |
|----------|------|---------------|------|
| **P0** | Gateway Boot | Any API key (Anthropic/OpenAI) | 5 min |
| **P1** | Google Cloud | One project covers Gmail + Calendar + Contacts | 30 min |
| **P1** | Cost Caps | Depends on P0 (need baseline usage) | 5 min |
| **P2** | Domain Email | IMAP/SMTP server credentials | 10 min |
| **P2** | Twilio SMS | Account + purchased phone number | 15 min |
| **P3** | WhatsApp Business | Meta business verification (takes days) | 1-2 weeks |

---

## 6. MCP Tool Status

| Tool | Status | Notes |
|------|--------|-------|
| sequential-thinking | ✅ Available | |
| serena | ✅ Available | Project `open-claw` active (path: `D:\github\open-claw`) — note the path differs from our workspace |
| Context7 | ✅ Available | Library ID: `/openclaw/openclaw` (4730 snippets) |
| Exa Search | ✅ Available | Good for docs.openclaw.ai content |
| Memory Tool | ⚠️ Intermittent | Disconnected mid-session in Phase 1. Retry on next session. |
| playwright | ✅ Available | Not yet used — needed for Control UI screenshot in Phase 2 |
| firecrawl-mcp | ✅ Available | Not needed while Exa works |
| github | ✅ Available | Not yet used |

---

## 7. Phase 2 — What the Next Agent Must Do

### Pre-condition (user must provide)
User provides at least one model API key before the agent runs Phase 2.

### Phase 2 Steps (once unblocked)

**STEP 1 — Boot Gateway**
```bash
wsl bash -c 'mkdir -p ~/.openclaw && cat ~/.openclaw/.env'   # verify key exists
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw onboard'
# Onboard config: gateway.bind=loopback, gateway.auth.mode=token, skip all channels
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw start &'
wsl bash -c 'sleep 3 && curl -s http://127.0.0.1:18789/health'
# Use playwright to screenshot http://127.0.0.1:18789/openclaw
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
# Run OpenClaw's built-in security audit
wsl bash -c 'source /home/ynotf/.nvm/nvm.sh && cd ~/openclaw-build && pnpm openclaw doctor'
# Verify: loopback bind, token auth, sandbox active, no secrets in config
```

**STEP 5 — Commit**
```
feat: Phase 2 — gateway live + first integration connected
```

### Phase 2 Exit Criteria (from PLAN.md)
- [ ] Gateway running on loopback with token auth
- [ ] Health check 200 at `http://127.0.0.1:18789/health`
- [ ] Control UI screenshot captured
- [ ] At least one integration fully connected end-to-end
- [ ] Approval gate tested and passing
- [ ] Audit log captures full action chain
- [ ] Cost tracking active
- [ ] `docs/ai/STATE.md` updated with Phase 2 evidence

---

## 8. Conventions the Next Agent Must Follow

1. **All commands in WSL** with path `/mnt/d/github/open--claw`
2. **Source nvm** before any node/pnpm command: `source /home/ynotf/.nvm/nvm.sh`
3. **Build always in `~/openclaw-build/`** — never `/mnt/d/` for pnpm operations
4. **Update `docs/ai/STATE.md`** after each execution block with PASS/FAIL evidence
5. **Secret scan** before every commit: `grep -rPn "(sk-[a-zA-Z0-9]{20,}|ghp_|AIza|AKIA)" ...`
6. **MCP-first**: use serena, Context7, Exa before falling back to manual file reads
7. **No secrets in repo, ever** — `~/.openclaw/.env` is the only valid secrets location
8. **Approval gates**: never implement an outbound action without a gate in the design

---

## 9. Files to Read First (Recommended Order)

1. `AGENTS.md` — operating contract
2. `.cursor/rules/00-global-core.md` — non-negotiable behaviors
3. `docs/ai/STATE.md` — full execution log
4. `docs/ai/PLAN.md` — what's planned
5. `open-claw/docs/BLOCKED_ITEMS.md` — what's blocked and how to unblock
6. `open-claw/docs/ARCHITECTURE_MAP.md` — OpenClaw structure
7. `open-claw/configs/openclaw.template.json5` — config starting point

---

## 10. Known Gotchas

| Gotcha | Solution |
|--------|----------|
| `node: command not found` in WSL | `source /home/ynotf/.nvm/nvm.sh` first |
| `EACCES rename` on pnpm install | Build in `~/openclaw-build/`, never `/mnt/d/` |
| Memory Tool disconnects | Retry; if still down, document decisions in repo docs |
| serena activates `D:\github\open-claw` (no double-dash) | This is correct — serena path differs from Cursor workspace path |
| WhatsApp Baileys temptation | It's built-in and easy, but we've decided: official API only |
| `openclaw onboard` is interactive | Cannot be scripted — must be run in a real terminal |
