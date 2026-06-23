# Deletes Chrome's on-device AI model dirs if they reappear.
$base = Join-Path $env:LOCALAPPDATA 'Google\Chrome\User Data'
foreach ($d in 'OptGuideOnDeviceModel', 'OptGuideOnDeviceClassifierModel') {
    $target = Join-Path $base $d
    if (Test-Path $target) {
        Remove-Item -LiteralPath $target -Recurse -Force -ErrorAction SilentlyContinue
    }
}
