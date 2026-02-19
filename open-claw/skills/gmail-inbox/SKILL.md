---
name: gmail-inbox
description: Gmail integration for inbox triage, reading, and composing emails via Google Gmail API with Pub/Sub push notifications for real-time inbox monitoring.
---

# Gmail Inbox Skill

## Status: BLOCKED
Google Cloud project not yet created. OAuth consent screen and credentials not configured.

## Required OAuth Scopes
- `https://www.googleapis.com/auth/gmail.readonly` — read inbox, labels, threads
- `https://www.googleapis.com/auth/gmail.send` — compose and send emails
- `https://www.googleapis.com/auth/gmail.modify` — mark read/unread, archive, label

## Pub/Sub Webhook Configuration
Inbound email notifications require a Google Cloud Pub/Sub topic:
- Topic: `projects/<PROJECT_ID>/topics/openclaw-gmail`
- Subscription: push to Gateway webhook endpoint
- Endpoint must be publicly reachable (Tailscale funnel or ngrok)

## Approval Gate
**All outbound sends require explicit human approval.**
- Draft is presented to the user via the approval channel
- User must reply `approve` or `deny`
- Denied drafts are logged but not sent
- No auto-send, no bulk send without per-message approval

## Capabilities
- List unread emails with sender, subject, snippet
- Read full email body (text + attachments summary)
- Search inbox by query (from, subject, label, date range)
- Compose and send reply (approval-gated)
- Compose and send new email (approval-gated)
- Apply labels, archive, mark read/unread

## Unblock Steps
1. Create Google Cloud project at https://console.cloud.google.com
2. Enable Gmail API + Pub/Sub API
3. Configure OAuth consent screen (internal or external)
4. Create OAuth 2.0 credentials (desktop app type)
5. Store refresh token in `~/.openclaw/.env` as `GOOGLE_OAUTH_REFRESH_TOKEN`
6. Create Pub/Sub topic and push subscription
7. Run `openclaw config set skills.entries.gmail-inbox.enabled true`
