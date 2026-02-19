---
name: google-contacts
description: Google Contacts API integration for read-only contact lookups and relationship context.
---

# Google Contacts Skill

## Status: BLOCKED
Google Cloud project not yet created. OAuth consent screen and credentials not configured.

## Required OAuth Scopes
- `https://www.googleapis.com/auth/contacts.readonly` — read contacts only

## Approval Gate
**No approval gate needed** — this is a read-only skill.
No contact creation, modification, or deletion capability.

## Capabilities
- Search contacts by name, email, phone number
- List all contacts with basic info (name, email, phone)
- Get detailed contact info (address, organization, notes, groups)
- Look up contact by phone number (useful for WhatsApp/SMS context)
- List contact groups/labels

## Privacy
- Read-only access — no writes to contacts database
- Contact data is used for context enrichment only
- Contact data is not stored in OpenClaw memory by default
- Agent can reference contacts during conversations for personalization

## Unblock Steps
1. Create Google Cloud project (shared with gmail-inbox and google-calendar)
2. Enable People API (Google Contacts)
3. Add `contacts.readonly` scope to OAuth consent screen
4. Use existing OAuth 2.0 credentials (shared with other Google skills)
5. Run `openclaw config set skills.entries.google-contacts.enabled true`
