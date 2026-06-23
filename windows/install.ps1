# Install the Chrome AI model blocker on Windows (no admin required; uses HKCU).
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$binDir    = Join-Path $env:LOCALAPPDATA 'chrome-ai-model-blocker'
$worker    = Join-Path $binDir 'chrome-block-ai-model.ps1'
$taskName  = 'ChromeBlockAIModel'

New-Item -ItemType Directory -Force -Path $binDir | Out-Null
Copy-Item (Join-Path $scriptDir 'chrome-block-ai-model.ps1') $worker -Force

# 1. Block: per-user policy (0=allowed, 1=disabled/no download).
$policyKey = 'HKCU:\SOFTWARE\Policies\Google\Chrome'
New-Item -Path $policyKey -Force | Out-Null
New-ItemProperty -Path $policyKey -Name 'GenAILocalFoundationalModelSettings' `
    -Value 1 -PropertyType DWord -Force | Out-Null
Write-Host "policy set: GenAILocalFoundationalModelSettings=1 ($policyKey)"

# 2. Delete now (if present).
& $worker

# 3. Watcher: scheduled task at logon + hourly.
$action  = New-ScheduledTaskAction -Execute 'powershell.exe' `
    -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$worker`""
$triggers = @(
    (New-ScheduledTaskTrigger -AtLogOn),
    (New-ScheduledTaskTrigger -Once -At (Get-Date) `
        -RepetitionInterval (New-TimeSpan -Hours 1))
)
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $triggers `
    -Settings $settings -Force | Out-Null

Write-Host "installed. scheduled task '$taskName' registered."
Write-Host "Restart Chrome, then check chrome://policy"
