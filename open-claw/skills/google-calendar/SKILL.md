---
name: google-calendar
description: Google Calendar integration for reading events, creating meetings, and providing daily agenda summaries via cron.
---

# Google Calendar Skill

## Status: BLOCKED
Google Cloud project not yet created. OAuth consent screen and credentials not configured.

## Required OAuth Scopes
- `https://www.googleapis.com/auth/calendar.readonly` — read events and calendars
- `https://www.googleapis.com/auth/calendar.events` — create, update, delete events

## Cron Configuration
Daily agenda summary at 7:00 AM:
```bash
openclaw cron add \
  --name "Daily agenda" \
  --cron "0 7 * * *" \
  --tz "America/New_York" \
  --session main \
  --message "Summarize today's calendar events and flag conflicts." \
  --announce \
  --channel whatsapp
```

## Approval Gate
- **Read operations**: no approval required
- **Event creation**: requires approval (shows event details, attendees, time)
- **Event modification/deletion**: requires approval
- **No bulk operations** without per-event approval

## Capabilities
- List today's events (time, title, attendees, location)
- List upcoming events (configurable range)
- Search events by keyword, date range, attendee
- Create new events (approval-gated)
- Update existing events (approval-gated)
- Delete events (approval-gated)
- Check free/busy status for scheduling

## Unblock Steps
1. Create Google Cloud project (shared with gmail-inbox if applicable)
2. Enable Google Calendar API
3. Configure OAuth consent screen
4. Create OAuth 2.0 credentials
5. Store refresh token in `~/.openclaw/.env` as `GOOGLE_OAUTH_REFRESH_TOKEN`
6. Run `openclaw config set skills.entries.google-calendar.enabled true`
7. Configure cron job for daily agenda
