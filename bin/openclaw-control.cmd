@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\scripts\openclaw\Invoke-ControlPlaneOpenClaw.ps1" %*
set "_EXIT=%ERRORLEVEL%"
endlocal & exit /b %_EXIT%
