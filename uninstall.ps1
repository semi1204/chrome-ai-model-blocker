# One-line bootstrap uninstaller for Windows.
#   irm https://raw.githubusercontent.com/semi1204/chrome-ai-model-blocker/master/uninstall.ps1 | iex
$ErrorActionPreference = 'Stop'

$repo = 'semi1204/chrome-ai-model-blocker'
$ref  = if ($env:REF) { $env:REF } else { 'master' }
$zip  = "https://codeload.github.com/$repo/zip/refs/heads/$ref"

$tmp = Join-Path $env:TEMP ("camb-" + [guid]::NewGuid())
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
    $zipPath = Join-Path $tmp 'src.zip'
    Invoke-WebRequest -Uri $zip -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $tmp -Force
    $src = (Get-ChildItem -Path $tmp -Directory | Select-Object -First 1).FullName
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $src 'windows\uninstall.ps1')
}
finally {
    Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
