# OpenClaw — Blocked Items

Items below are blocked pending user action unless explicitly marked resolved. The agent cannot unblock the remaining items alone because they require credentials, account creation, or external configuration.

## 1. Gateway Boot

**Status**: Resolved on ChaosCentral as of 2026-03-07.

**Execution evidence**:

1. Redacted credential probe confirmed provider keys in `~/.openclaw/.env`.
2. Supported non-interactive onboarding completed from the Linux build copy:
   - `cd ~/openclaw-build && pnpm openclaw onboard --non-interactive --accept-risk --mode local --workspace ~/.openclaw/workspace --auth-choice apiKey --gateway-port 18789 --gateway-bind loopback --install-daemon --daemon-runtime node --skip-channels --skip-skills --json`
3. Gateway verification passed:
   - `cd ~/openclaw-build && pnpm openclaw gateway status`
   - `cd ~/openclaw-build && pnpm openclaw health`
4. Control UI rendered at the local dashboard URL reported by `pnpm openclaw dashboard --no-open` (`http://127.0.0.1:18789/` in the verified ChaosCentral run).

**Residual caveat**:

- Prefer `cd ~/openclaw-build && pnpm openclaw dashboard --no-open` because it prints a tokenized Control UI URL (`#token=...`) that can authenticate the browser session without manual token pasting. If that URL is unavailable, fall back to `pnpm openclaw config get gateway.auth.token`.

## 2. Gmail Inbox Skill

**Blocked**: Google Cloud project not created.

**User action**:

1. Go to <https://console.cloud.google.com> and create a project.
2. Enable Gmail API and Pub/Sub API.
3. Configure the OAuth consent screen.
4. Create OAuth 2.0 credentials.
5. Complete the OAuth flow and store the refresh token outside the repo.
6. Create the Pub/Sub topic and push subscription.
7. Expose the webhook endpoint if needed.

## 3. Domain Email Skill

**Blocked**: IMAP/SMTP credentials not provided.

**User action**:

1. Obtain IMAP/SMTP server details for the domain mailbox.
2. Generate an app-specific password if required.
3. Store the credentials outside the repo through env, `.env`, or the wrapper's chosen secret mechanism.

## 4. SMS Twilio Skill

**Blocked**: Twilio credentials not provided.

**User action**:

1. Create a Twilio account at <https://www.twilio.com>.
2. Purchase a phone number.
3. Store Account SID, Auth Token, and From Number outside the repo.
4. Configure the webhook URL in Twilio.

## 5. WhatsApp Business Cloud API (Wrapper Preference)

**Blocked**: Meta Business is not verified for the wrapper's preferred WhatsApp path.

Important note:

- Upstream OpenClaw supports the built-in WhatsApp adapter via Baileys.
- This wrapper currently prefers the official Meta Business Cloud API path for policy reasons.
- Treat this as a local wrapper decision, not an upstream OpenClaw requirement.

**User action**:

1. Create a Meta Business account at <https://business.facebook.com>.
2. Create a developer app at <https://developers.facebook.com>.
3. Add the WhatsApp product.
4. Complete business verification.
5. Register the phone number.
6. Generate the access token and store it outside the repo.

## 6. Google Calendar Skill

**Blocked**: Google Cloud project not created.

**User action**:

1. Use the same Google Cloud project as Gmail or create a new one.
2. Enable Google Calendar API.
3. Add the required scopes.
4. Reuse or refresh OAuth credentials.

## 7. Google Contacts Skill

**Blocked**: Google Cloud project not created.

**User action**:

1. Use the same Google Cloud project as Gmail/Calendar.
2. Enable People API.
3. Add the required scopes.
4. Reuse or refresh OAuth credentials.

## 8. Cost Caps Configuration

**Blocked**: No live usage baseline yet.

**User action**:

1. Unblock Gateway Boot first.
2. Let the gateway run long enough to establish a usage baseline.
3. Configure token and spend limits in `openclaw.json` and provider consoles.

## Unblock Priority

| Priority | Item | Dependency | Effort |
| --- | --- | --- | --- |
| **P1** | Google Cloud (#2, #6, #7) | One project covers all three | 30 min |
| **P1** | Cost Caps (#8) | Depends on #1 | 5 min |
| **P2** | Domain Email (#3) | Server credentials | 10 min |
| **P2** | Twilio (#4) | Account + phone number | 15 min |
| **P3** | WhatsApp Business (#5) | Meta verification | 1-2 weeks |
