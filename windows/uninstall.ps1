# Remove the Chrome AI model blocker on Windows.
$ErrorActionPreference = 'SilentlyContinue'

$binDir   = Join-Path $env:LOCALAPPDATA 'chrome-ai-model-blocker'
$taskName = 'ChromeBlockAIModel'

Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
Remove-Item -LiteralPath $binDir -Recurse -Force

# Re-allow the model (remove the policy value).
$policyKey = 'HKCU:\SOFTWARE\Policies\Google\Chrome'
Remove-ItemProperty -Path $policyKey -Name 'GenAILocalFoundationalModelSettings'

Write-Host "uninstalled. Restart Chrome to re-enable the on-device model."
