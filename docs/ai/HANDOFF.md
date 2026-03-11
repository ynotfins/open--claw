# Agent Handoff — Open Claw

**Date**: 2026-03-11
**Handing off after**: Phase 1 COMPLETE, Phase 2 in progress (WhatsApp verified, Windows node host connected)
**Next action**: Phase 2 — first integration connected, approval gate tested

Previous handoff archived at `docs/ai/archive/handoff-2026-03-08.md`.

---

## 1. What This Project Is

**Open Claw** is a modular AI assistant platform built on [OpenClaw](https://github.com/openclaw/openclaw) v2026.3.8. It orchestrates code development, communication, and workflow automation. This is the **execution** repo; governance lives in `AI-Project-Manager`.

---

## 2. Current State

### Runtime (ChaosCentral)

- **Gateway**: `127.0.0.1:18789`, WSL, systemd managed, token auth
- **WhatsApp**: linked, connected, selfChatMode, allowlist
- **Windows node host**: paired + connected ("Windows Desktop"), caps: browser, system
- **Skills**: 19/58 ready
- **Model routing**: primary `anthropic/claude-sonnet-4-20250514`, fallback `openai/gpt-4o-mini`
- **Agent**: not yet named (bootstrap pending)

### Phase Status

| Phase | Status |
|-------|--------|
| Phase 0 — Project Kickoff | COMPLETE |
| Phase 1 — Gateway Boot + Integration Scaffold | COMPLETE |
| Phase 2 — First Live Integration | **OPEN** |

### Startup

```
bws run --project-id f14a97bb-5183-4b11-a6eb-b3fe0015fedf -- pwsh -NoProfile -File "$HOME\.openclaw\start-cursor-with-secrets.ps1"
```

---

## 3. Phase 2 — What Remains

- [ ] First integration connected end-to-end
- [ ] Approval gate tested
- [ ] Audit log captures full action chain
- [ ] Cost tracking active
- [ ] Security review

**Pending user actions:**
1. Name agent via WhatsApp
2. Gmail OAuth: `gog auth credentials` + `gog auth add ynotfins@gmail.com`
3. MXRoute email: install `imap-smtp-email` + provide credentials

---

## 4. Key Facts

- REST API chat: 405 (WebSocket only on this gateway version)
- Build in `~/openclaw-build/`, never `/mnt/d/`
- Windows node host dist copied from WSL build to `D:\github\open--claw\vendor\openclaw\dist\`
- `docs/ai/archive/` — never consulted by PLAN (historical only)

---

## 5. Files to Read First

1. `AGENTS.md` — operating contract
2. `docs/ai/STATE.md` — execution log
3. `docs/ai/PLAN.md` — active plan
4. `open-claw/docs/SETUP_NOTES.md` — local runtime setup
5. `open-claw/docs/ARCHITECTURE_MAP.md` — hub-and-spoke architecture
