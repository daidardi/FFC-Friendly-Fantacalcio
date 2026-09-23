@echo off

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0auto-upload+mail.ps1"

if errorlevel 1 pause
