# chrome-ai-model-blocker

Stop Google Chrome from downloading its multi-gigabyte **on-device AI model**
(the "Optimization Guide On Device Model", a.k.a. Gemini Nano) and reclaim the
disk space it uses.

The model is stored in `OptGuideOnDeviceModel` inside Chrome's user-data
directory and can grow to **4 GB+**. Even after you delete it, Chrome
re-downloads it. This project does two things:

1. **Block** – sets Chrome's `GenAILocalFoundationalModelSettings` policy to
   `1` (disabled) so the model is never downloaded.
2. **Delete** – installs a small background watcher that removes the model
   directory if it ever reappears (belt-and-suspenders).

## What it touches

| OS | Model directory | Policy mechanism | Watcher |
|----|-----------------|------------------|---------|
| macOS | `~/Library/Application Support/Google/Chrome/OptGuideOnDeviceModel` | `defaults` (`com.google.Chrome`) | launchd LaunchAgent |
| Linux | `~/.config/google-chrome/OptGuideOnDeviceModel` | `/etc/opt/chrome/policies/managed/*.json` | systemd user `.path` unit |
| Windows | `%LOCALAPPDATA%\Google\Chrome\User Data\OptGuideOnDeviceModel` | `HKCU\SOFTWARE\Policies\Google\Chrome` | Scheduled Task |

It also removes `OptGuideOnDeviceClassifierModel` (a smaller companion model).

> Restart Chrome after installing. Verify the policy at `chrome://policy`
> (look for `GenAILocalFoundationalModelSettings = 1`).

## Install (one line)

### macOS / Linux
```sh
curl -fsSL https://raw.githubusercontent.com/semi1204/chrome-ai-model-blocker/master/install.sh | sh
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/semi1204/chrome-ai-model-blocker/master/install.ps1 | iex
```

> On Linux the installer uses `sudo` to write the managed policy file.

## Uninstall (one line)

### macOS / Linux
```sh
curl -fsSL https://raw.githubusercontent.com/semi1204/chrome-ai-model-blocker/master/uninstall.sh | sh
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/semi1204/chrome-ai-model-blocker/master/uninstall.ps1 | iex
```

## Manual install (from a clone)

```sh
git clone https://github.com/semi1204/chrome-ai-model-blocker
cd chrome-ai-model-blocker
macos/install.sh     # or: linux/install.sh
# Windows: powershell -ExecutionPolicy Bypass -File windows\install.ps1
```

## Notes / trade-offs

- The **policy** is the real fix; the watcher is only a fallback for cases
  where the policy is ignored. With the policy in place the watcher should
  almost never have anything to delete.
- Deleting the model while Chrome is running may fail (file locks, especially
  on Windows). The policy prevents the download regardless, so this is
  harmless — the leftover is cleaned up on the next run after Chrome closes.
- This disables Chrome's built-in on-device AI features (e.g. the local
  writing assistant / Gemini Nano). Cloud-based features are unaffected.
- Only deletes Chrome's AI model directories. No user profiles, history,
  passwords, or other data are touched.

## License

MIT
