---
name: whatsapp-official
description: WhatsApp Business Cloud API integration (official Meta API, NOT Baileys). Supports template messages, media, and business-verified messaging.
---

# WhatsApp Official (Business Cloud API) Skill

## Status: BLOCKED
Meta Business not verified. WhatsApp Business API access not provisioned.

## Why Official API (Not Baileys)
OpenClaw ships with a built-in WhatsApp adapter using the Baileys library (unofficial,
reverse-engineered protocol). This skill uses the **official WhatsApp Business Cloud API**
from Meta instead, which:
- Is TOS-compliant and production-safe
- Supports business-verified sender identity
- Provides delivery receipts and read receipts via webhook
- Supports template messages (pre-approved by Meta)
- Has official rate limits and SLA

## Configuration Template
```env
# Add to ~/.openclaw/.env
WHATSAPP_BUSINESS_PHONE_ID=123456789012345
WHATSAPP_BUSINESS_TOKEN=EAAxxxxxxxx
WHATSAPP_VERIFY_TOKEN=your-webhook-verify-token
```

## Webhook Configuration
- Callback URL: `https://<gateway-public-url>/webhooks/whatsapp-business`
- Verify Token: must match `WHATSAPP_VERIFY_TOKEN`
- Subscribe to: messages, message_delivery_updates

## Meta Business Verification
Required steps:
1. Create Meta Business account
2. Create app in Meta for Developers
3. Add WhatsApp product to app
4. Complete business verification (documents required)
5. Register phone number for WhatsApp Business
6. Get permanent access token

## Approval Gate
**All outbound messages require approval unless replying within 24h window.**
- Template messages (outside 24h window) always require approval
- Free-form replies within 24h customer-service window: configurable

## Capabilities
- Send text messages (approval-gated)
- Send template messages (pre-approved by Meta)
- Send media (images, documents, audio)
- Receive inbound messages via webhook
- Read receipts and delivery status

## Unblock Steps
1. Create Meta Business account at https://business.facebook.com
2. Create developer app at https://developers.facebook.com
3. Complete business verification
4. Register WhatsApp Business phone number
5. Generate permanent access token
6. Add credentials to `~/.openclaw/.env`
7. Configure webhook in Meta dashboard
8. Disable Baileys adapter: `openclaw config set channels.whatsapp.enabled false`
9. Run `openclaw config set skills.entries.whatsapp-official.enabled true`
