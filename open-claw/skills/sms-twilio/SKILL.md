---
name: sms-twilio
description: SMS messaging via Twilio API with rate limiting and approval gates for outbound messages.
---

# SMS Twilio Skill

## Status: BLOCKED
Twilio credentials not provided. Account SID and Auth Token not configured.

## Configuration Template
```env
# Add to ~/.openclaw/.env
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_FROM_NUMBER=+15551234567
```

## Webhook Configuration
Inbound SMS requires a Twilio webhook:
- URL: `https://<gateway-public-url>/webhooks/twilio-sms`
- Method: POST
- Gateway must be publicly reachable (Tailscale funnel or ngrok)

## Rate Limiting
- Default: **10 outbound SMS per day**
- Configurable via `skills.entries.sms-twilio.env.SMS_DAILY_LIMIT`
- Rate limit resets at midnight UTC
- Over-limit messages are queued (not dropped) and sent next day

## Approval Gate
**All outbound SMS require explicit human approval.**
- Message text and recipient displayed in approval channel
- User must reply `approve` or `deny`
- No auto-send capability

## Capabilities
- Send SMS to verified numbers (approval-gated)
- Receive inbound SMS via webhook
- List recent messages (sent/received)
- Check delivery status

## Cost
- ~$0.0075 per outbound SMS (US)
- ~$0.0075 per inbound SMS (US)
- Phone number: ~$1/month
- At 10 msgs/day default cap: ~$2.25/month

## Unblock Steps
1. Create Twilio account at https://www.twilio.com
2. Purchase a phone number
3. Note Account SID and Auth Token from console
4. Add credentials to `~/.openclaw/.env`
5. Configure webhook URL in Twilio console
6. Run `openclaw config set skills.entries.sms-twilio.enabled true`
