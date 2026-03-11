# PowerShell MCP Server Exploration ⚡

## 🎯 **Current Situation**
- **Windows Node**: Paired but disconnected → blocking exec commands
- **Tony's Suggestion**: Use Cursor's PowerShell MCP server as workaround
- **Need**: Alternative execution path while node issue is resolved

## 🔍 **Investigation Results**

### **Standard Cursor CLI Approach**
Based on research, Cursor provides:
- `cursor-agent` command for AI server interactions
- Built-in terminal with PowerShell support
- PATH configuration for global cursor commands

### **Setup Commands (If Available)**
```powershell
# Install Cursor CLI
curl https://cursor.com/install -fsS | bash

# Add to PATH
$env:PATH += ";C:\Users\$env:USERNAME\AppData\Local\Programs\cursor\resources\app\bin"

# Test installation  
cursor-agent --version
```

## 🚀 **Alternative Execution Strategies**

### **Option 1: Sessions Spawn with ACP**
Since Tony has Cursor with MCP servers configured:
```bash
# Spawn PowerShell session via ACP harness
sessions_spawn runtime="acp" task="Execute PowerShell commands for Java/APK setup"
```

### **Option 2: Browser Tool for Control UI**
Access OpenClaw Control UI to manually approve pending commands:
```bash
# Open Control UI → Nodes → Exec Approvals
browser action="open" url="http://127.0.0.1:18789"
```

### **Option 3: Local WSL Commands**
Run equivalent commands locally:
```bash
# Check Java installation locally
java -version 2>/dev/null || echo "Java not found in WSL"

# Check Android SDK paths
ls -la /mnt/c/Users/*/AppData/Local/Android/Sdk 2>/dev/null || echo "SDK not found"
```

## 📋 **Recommended Immediate Actions**

1. **Try ACP Spawn**: Test PowerShell via sessions_spawn  
2. **Parallel Node Fix**: Still work on reconnecting Windows Desktop
3. **Document Results**: Track what works for future reference

---
*Investigating Tony's PowerShell MCP suggestion systematically*