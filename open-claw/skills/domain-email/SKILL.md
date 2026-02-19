---
name: domain-email
description: IMAP/SMTP integration for custom domain email accounts, supporting inbox monitoring, reading, and composing emails.
---

# Domain Email Skill

## Status: BLOCKED
IMAP/SMTP credentials not provided. Domain email server details not configured.

## Configuration Template
```env
# Add to ~/.openclaw/.env
DOMAIN_EMAIL_HOST=imap.yourdomain.com
DOMAIN_EMAIL_PORT=993
DOMAIN_EMAIL_USER=assistant@yourdomain.com
DOMAIN_EMAIL_PASS=app-specific-password
DOMAIN_SMTP_HOST=smtp.yourdomain.com
DOMAIN_SMTP_PORT=587
```

## Approval Gate
**All outbound sends require explicit human approval.**
Same approval flow as gmail-inbox skill.

## Capabilities
- Connect via IMAP (TLS required)
- List folders (inbox, sent, drafts, custom)
- Read emails with full body and attachment metadata
- Search by sender, subject, date, flags
- Compose and send via SMTP (approval-gated)
- Reply to threads (approval-gated)
- Move/copy/flag messages

## Security
- TLS required for both IMAP and SMTP
- App-specific passwords preferred over account passwords
- Credentials stored in `~/.openclaw/.env` only
- No credential logging or exposure in audit trail

## Unblock Steps
1. Obtain IMAP/SMTP credentials for the domain email account
2. Generate an app-specific password if 2FA is enabled
3. Add credentials to `~/.openclaw/.env`
4. Run `openclaw config set skills.entries.domain-email.enabled true`
