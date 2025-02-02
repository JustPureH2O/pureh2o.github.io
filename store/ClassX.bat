@echo off
 
>nul 2>&1 "%SYSTEMROOT%\System32\cacls.exe" "%SYSTEMROOT%\System32\config\system"
 
 
if %errorlevel% == 0 (
    echo Admin Switched!
) else (
    echo Level Ascending... Restart
 
    powershell -command "Start-Process '%0' -Verb RunAs"
    exit
)

sc stop tdnetfilter
sc delete tdnetfilter
sc stop tdfilefilter
sc delete tdfilefilter
sc stop GATESRV
sc delete GATESRV
sc stop STUDSRV
sc delete STUDSRV

taskkill /f /t /im MasterHelper.exe
taskkill /f /t /im ProcHelper64.exe
