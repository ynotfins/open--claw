# Project Plan — Open Claw

## Phase 0 — Project Kickoff ✅

**Goal:** Establish project structure, tooling, and development environment for Open Claw.

**Exit criteria:**
- [x] Repository initialized with canonical Cursor workflow
- [x] Module boundaries documented in `open-claw/docs/MODULES.md`
- [x] Integration targets listed in `open-claw/docs/INTEGRATIONS.md`
- [x] Development environment requirements identified (`open-claw/docs/SETUP_NOTES.md`)
- [x] Phase 1 plan drafted (below)
- [x] Vendor repo cloned (`vendor/openclaw/`) and architecture mapped
- [x] Blueprint docs created: ARCHITECTURE_MAP, SETUP_NOTES, SECURITY_MODEL, INTEGRATIONS_PLAN, COST_MODEL
- [x] Validation: no duplicate filenames, no dangling refs, no secrets

---

## Phase 1 — Development Environment & Gateway Boot

**Goal:** Install dependencies, build OpenClaw, boot the Gateway, and verify basic connectivity.

**Exit criteria:**
- [ ] Node.js 22+ and pnpm verified in WSL
- [ ] `pnpm install` completes successfully in `vendor/openclaw/`
- [ ] `pnpm build` and `pnpm ui:build` succeed
- [ ] `openclaw onboard` runs (interactive setup)
- [ ] Gateway starts on `127.0.0.1:18789` and responds to health check
- [ ] Control UI loads in browser at `http://127.0.0.1:18789/openclaw`
- [ ] `openclaw.json` created with secure defaults (loopback, token auth)
- [ ] No secrets committed to repo
- [ ] `docs/ai/STATE.md` updated with Phase 1 evidence

**AGENT prompt:**
<!-- Executed 2026-02-18; see STATE.md for evidence -->

---

## Phase 1 — Gateway Boot + Integration Scaffold ✅ (partial)

**Status**: PASS with 1 BLOCKED item (Gateway Boot — no API key)

**Completed:**
- [x] Node.js 22+ and pnpm verified in WSL
- [x] `pnpm install` + `pnpm build` + `pnpm ui:build` succeed
- [x] 8 skill stubs created with valid SKILL.md frontmatter
- [x] Config template with 3-tier model routing
- [x] VAULT_SETUP.md + BLOCKED_ITEMS.md
- [x] Validation: secrets, frontmatter, paths all clean

**Blocked:**
- [ ] `openclaw onboard` — requires API key in `~/.openclaw/.env`
- [ ] Gateway start + health check — depends on onboard
- [ ] Control UI screenshot — depends on gateway

---

## Phase 2 — First Live Integration

**Goal:** Unblock the Gateway, connect the first integration, and verify end-to-end flow with approval gate.

**Prerequisites (user must provide):**
- At least one model API key (Anthropic or OpenAI) in `~/.openclaw/.env`
- Optionally: Google Cloud project for Gmail/Calendar/Contacts

**Exit criteria:**
- [ ] Gateway running on loopback with token auth
- [ ] Health check returns 200 at `http://127.0.0.1:18789/health`
- [ ] Control UI loads and screenshot captured
- [ ] At least one integration fully connected end-to-end
- [ ] Approval gate tested (outbound action blocked until human approves)
- [ ] Audit log captures the full action chain
- [ ] Cost tracking active for the connected integration
- [ ] Security review: no exposed secrets, sandboxing verified
- [ ] `docs/ai/STATE.md` updated with Phase 2 evidence

**AGENT prompt:**
<!-- To be written by PLAN tab before Phase 2 execution -->
