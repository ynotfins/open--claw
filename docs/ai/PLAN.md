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
- [x] Blueprint docs created: `ARCHITECTURE_MAP`, `SETUP_NOTES`, `SECURITY_MODEL`, `INTEGRATIONS_PLAN`, `COST_MODEL`
- [x] Validation: no duplicate filenames, no dangling refs, no secrets

---

## Phase 1 — Development Environment And Gateway Boot

**Goal:** Install dependencies, build OpenClaw, run onboarding, and verify gateway connectivity.

**Exit criteria:**
- [ ] Node.js `>=22.12.0` and pnpm `10.23.0` verified in WSL
- [ ] `pnpm install` completes successfully in the Linux build copy
- [ ] `pnpm build` and `pnpm ui:build` succeed
- [ ] `openclaw onboard --install-daemon` runs successfully
- [ ] `openclaw gateway status` shows the managed gateway is reachable
- [ ] `openclaw health` succeeds
- [ ] Control UI opens at `http://127.0.0.1:18789/` or via `openclaw dashboard`
- [ ] `openclaw.json` created with secure defaults (loopback, token auth)
- [ ] No secrets committed to repo
- [ ] `docs/ai/STATE.md` updated with Phase 1 evidence

**AGENT prompt:**
<!-- Historical execution details live in STATE.md. -->

---

## Phase 1 — Gateway Boot + Integration Scaffold ✅ (partial)

**Status:** PASS — Gateway Boot completed on ChaosCentral; dashboard reachability verified with one residual token-auth caveat in the Control UI.

**Completed:**
- [x] Node.js and pnpm verified in WSL
- [x] `pnpm install` + `pnpm build` + `pnpm ui:build` succeed
- [x] 8 skill stubs created with valid `SKILL.md` frontmatter
- [x] Config template with 3-tier model routing
- [x] `VAULT_SETUP.md` + `BLOCKED_ITEMS.md` created
- [x] Validation: secrets, frontmatter, paths all clean
- [x] `openclaw onboard --install-daemon` completed via the supported non-interactive flow
- [x] `openclaw gateway status` succeeds
- [x] `openclaw health` succeeds
- [x] Control UI renders at `http://127.0.0.1:18789/` and screenshot evidence was captured

**6C.0 entry verified (2026-03-08):**
- [x] Control UI authenticated (Health: OK, tokenized URL flow confirmed)
- [x] First agent chat: model `anthropic/claude-opus-4-6`, session `64a8f306-71f0-4dc1-bba3-7f9144764ee4`
- [x] Gateway log: `isError=false`, `durationMs=4514`

**Residual item (resolved):**
- [x] Control UI token auth confirmed working via tokenized dashboard URL

---

## Phase 2 — First Live Integration (OPEN)

**Goal:** Unblock the gateway, connect the first integration, and verify end-to-end flow with an approval gate.

**Prerequisites (user must provide):**
- At least one model credential available to the local runtime
- Optionally: Google Cloud project for Gmail/Calendar/Contacts

**Exit criteria:**
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

**AGENT prompt:**
<!-- To be written by PLAN tab before Phase 2 execution. -->
