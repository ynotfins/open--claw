# Error Log - System Issues & Fixes ⚡

## [ERR-20260311-001] node_disconnection_blocking_exec

**Logged**: 2026-03-11T06:15:00Z
**Priority**: high  
**Status**: diagnosed
**Area**: infra

### Summary
All Windows node exec commands failing due to node disconnection, not rate limits

### Error
```
System: Exec denied (approval-required): setx JAVA_HOME
System: Exec denied (approval-required): java -version
System: Exec failed (signal SIGTERM): /mnt/c/Users/ynotf/AppData/Local/Android/Sdk
```

### Context
- Command/operation attempted: Java setup, PowerShell execution, APK build
- Input or parameters used: Standard development commands
- Environment: Windows Desktop node paired but not connected

### Root Cause Analysis
- **NOT** Claude API rate limits (those are fine: $11.73/$100, 50 RPM available)
- **NOT** OpenClaw approval rate limits  
- **ACTUAL CAUSE**: Windows Desktop node showing `"connected": false`
- Node ID: 891178e980ebe57e373035ebbfc10162d228f649b46aeda07b1ff8696492f112

### Suggested Fix
1. **Immediate**: Reconnect Windows Desktop companion app
2. **Preventive**: Set up proper allowlists for when connected (see windows-node-allowlist.json)
3. **Monitoring**: Add node connection status to regular health checks

### Metadata
- Reproducible: yes - all node exec commands fail while disconnected
- Related Files: windows-node-allowlist.json, SYSTEM_STATE.md
- See Also: Will link once resolution confirmed

---