# Development Workflow SOP ⚡

## The Systematic Approach

**Principle**: *"Move at breakneck speed but lock every advancement"* - Tony

## 🔄 Core Development Cycle

### 1. **Before Starting Any Task**
```bash
# Check current state
git status
grep -r "TODO\|FIXME\|HACK" . --exclude-dir=node_modules

# Read recent memory
cat memory/$(date +%Y-%m-%d).md
cat memory/$(date -d "yesterday" +%Y-%m-%d).md 2>/dev/null || true

# Update system state  
echo "Starting: [TASK_NAME]" >> SYSTEM_STATE.md
```

### 2. **During Development**
- **Small Changes Only**: One logical unit at a time
- **Document Immediately**: Update relevant .md files as you go
- **Test Each Change**: Verify it works before moving on
- **Memory Logging**: Add significant decisions to daily memory file

### 3. **After Each Advancement**  
```bash
# Document the change
echo "## $(date): [CHANGE_DESCRIPTION]" >> memory/$(date +%Y-%m-%d).md

# Update system state
vim SYSTEM_STATE.md  # Update status, add to changelog

# Commit immediately 
git add -A
git commit -m "🎯 [AREA]: [CHANGE_DESCRIPTION]

✅ What changed:
- [Specific change 1]
- [Specific change 2]

✅ Verification:
- [How you tested it]

🔒 RESTORE POINT: [Current capability level]"

# Push regularly (every 3-5 commits)
git push origin main
```

### 4. **Session Cleanup**
- Update MEMORY.md with session learnings (main sessions only)
- Commit any uncommitted changes
- Update SYSTEM_STATE.md with final status

## 📋 SOP Templates

### Commit Message Format
```
🎯 [AREA]: [BRIEF_DESCRIPTION]

✅ What changed:
- Specific change 1
- Specific change 2  

✅ Verification:
- How you tested it
- What still works

[📋 Context: Why this change was made]
[⚠️ Caution: Any risks or dependencies]
[🔒 RESTORE POINT: Current capability description]
```

### Daily Memory Format
```markdown
# YYYY-MM-DD - Daily Memory Log

## 🎯 Key Decisions Made
- Decision 1 with reasoning
- Decision 2 with context

## 🔧 Infrastructure Changes  
- Change 1: impact and verification
- Change 2: paths/configs updated

## 🚨 Issues Encountered
- Issue 1: symptoms, attempted fixes, resolution
- Issue 2: current status, next steps

## 📋 Next Priorities
1. HIGH: [immediate blocker]
2. MEDIUM: [important but not urgent]  

## 🧠 Lessons Learned
- Learning 1: what didn't work, what does
- Learning 2: better approach discovered

## 🔄 System State
- Git Status: [clean/pending changes]
- Key Metrics: [performance/status indicators]
- Tool Status: [what's working/broken]
```

### System State Updates
```markdown
## 🔄 Change Log (Latest First)
- **YYYY-MM-DD HH:MM**: [Change description] - [Impact/Status]
- **YYYY-MM-DD HH:MM**: [Previous change] - [Verification notes]
```

## 🎯 Quality Gates

### Before Commit
- [ ] Change is tested and working
- [ ] Documentation updated (README, SOPs, etc.)  
- [ ] System state reflects current reality
- [ ] Commit message follows template
- [ ] No debug code or temp files included

### Before Push
- [ ] Local tests pass
- [ ] No secrets in commit history
- [ ] Related documentation updated
- [ ] Team dependencies considered

### Before Session End
- [ ] All changes committed  
- [ ] SYSTEM_STATE.md updated
- [ ] Daily memory file written
- [ ] Next priorities documented
- [ ] Any learnings captured

## 🚨 Emergency Procedures

### If Something Breaks
1. **STOP** - Don't make it worse
2. **Document** - What broke, when, what you were doing
3. **Revert** - `git revert <commit>` or `git reset --hard <known-good-commit>`
4. **Analyze** - Why did it break? Add to .learnings/ERRORS.md
5. **Fix** - Small, tested change
6. **Verify** - Confirm fix works and didn't break anything else

### If Lost/Confused  
1. **Read** - SYSTEM_STATE.md, recent memory files
2. **Check** - `git log --oneline -10` for recent changes
3. **Status** - `git status` and uncommitted changes
4. **Ask** - Tony if context is missing

---
*This SOP is living documentation. Update it as we learn better ways!*