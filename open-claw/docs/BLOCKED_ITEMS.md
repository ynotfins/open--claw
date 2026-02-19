# OpenClaw — Blocked Items

All items below are blocked pending user action. No item can be unblocked by
the agent alone — each requires credentials, account creation, or configuration
that only the user can provide.

---

## 1. Gateway Boot (STEP 3)

**Blocked**: No model API key configured.

**User action**:
1. Choose at least one model provider (Anthropic recommended)
2. Obtain API key from provider dashboard
3. Create directory: `wsl bash -c 'mkdir -p ~/.openclaw'`
4. Create env file: `wsl bash -c 'echo "ANTHROPIC_API_KEY=sk-ant-..." > ~/.openclaw/.env && chmod 600 ~/.openclaw/.env'`
5. Run onboard: `cd ~/openclaw-build && pnpm openclaw onboard`
6. Start gateway: `pnpm openclaw start`

---

## 2. Gmail Inbox Skill

**Blocked**: Google Cloud project not created.

**User action**:
1. Go to https://console.cloud.google.com → create project
2. Enable Gmail API + Pub/Sub API
3. Configure OAuth consent screen
4. Create OAuth 2.0 credentials (desktop app)
5. Run OAuth flow to obtain refresh token
6. Add `GOOGLE_OAUTH_REFRESH_TOKEN=...` to `~/.openclaw/.env`
7. Create Pub/Sub topic + push subscription
8. Expose webhook endpoint (Tailscale funnel or ngrok)

---

## 3. Domain Email Skill

**Blocked**: IMAP/SMTP credentials not provided.

**User action**:
1. Obtain IMAP/SMTP server details for your domain email
2. Generate app-specific password (if 2FA enabled)
3. Add to `~/.openclaw/.env`:
   ```
   DOMAIN_EMAIL_HOST=imap.yourdomain.com
   DOMAIN_EMAIL_USER=assistant@yourdomain.com
   DOMAIN_EMAIL_PASS=app-specific-password
   DOMAIN_SMTP_HOST=smtp.yourdomain.com
   ```

---

## 4. SMS Twilio Skill

**Blocked**: Twilio credentials not provided.

**User action**:
1. Create Twilio account at https://www.twilio.com
2. Purchase phone number (~$1/month)
3. Note Account SID + Auth Token from Twilio console
4. Add to `~/.openclaw/.env`:
   ```
   TWILIO_ACCOUNT_SID=ACxxxxxxxx
   TWILIO_AUTH_TOKEN=your_auth_token
   TWILIO_FROM_NUMBER=+15551234567
   ```
5. Configure webhook URL in Twilio console

---

## 5. WhatsApp Official (Business Cloud API)

**Blocked**: Meta Business not verified.

**User action**:
1. Create Meta Business account at https://business.facebook.com
2. Create developer app at https://developers.facebook.com
3. Add WhatsApp product to app
4. Complete business verification (documents required — may take days)
5. Register phone number for WhatsApp Business
6. Generate permanent access token
7. Add to `~/.openclaw/.env`:
   ```
   WHATSAPP_BUSINESS_PHONE_ID=123456789012345
   WHATSAPP_BUSINESS_TOKEN=EAAxxxxxxxx
   WHATSAPP_VERIFY_TOKEN=your-webhook-verify-token
   ```

---

## 6. Google Calendar Skill

**Blocked**: Google Cloud project not created.

**User action**:
1. Use same Google Cloud project as Gmail (or create new)
2. Enable Google Calendar API
3. Add `calendar.readonly` + `calendar.events` scopes to OAuth consent
4. Use existing OAuth credentials
5. Refresh token (shared with Gmail skill if same project)

---

## 7. Google Contacts Skill

**Blocked**: Google Cloud project not created.

**User action**:
1. Use same Google Cloud project as Gmail/Calendar
2. Enable People API
3. Add `contacts.readonly` scope to OAuth consent
4. Use existing OAuth credentials

---

## 8. Cost Caps Configuration

**Blocked**: No API keys active — cannot measure or cap usage.

**User action**:
1. First, unblock item #1 (Gateway Boot with API key)
2. Run the gateway for a few days to establish usage baseline
3. Configure limits in `openclaw.json`:
   ```json5
   agents: {
     defaults: {
       limits: {
         maxTokensPerTurn: 100000,
         maxTurnsPerSession: 50,
         maxDailyTokens: 1000000,
       },
     },
   },
   ```
4. Set up provider-side spending limits as a safety net:
   - Anthropic: https://console.anthropic.com/settings/limits
   - OpenAI: https://platform.openai.com/settings/organization/limits

---

## Unblock Priority

| Priority | Item | Dependency | Effort |
|----------|------|------------|--------|
| **P0** | Gateway Boot (#1) | API key only | 5 min |
| **P1** | Google Cloud (#2, #6, #7) | One project covers all three | 30 min |
| **P1** | Cost Caps (#8) | Depends on #1 | 5 min |
| **P2** | Domain Email (#3) | Server credentials | 10 min |
| **P2** | Twilio (#4) | Account + phone number | 15 min |
| **P3** | WhatsApp Business (#5) | Meta verification (days) | 1-2 weeks |
