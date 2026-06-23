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

## Install

### macOS
```sh
macos/install.sh
```

### Linux
```sh
linux/install.sh          # writes the managed policy via sudo
```

### Windows (PowerShell)
```powershell
# Run in a normal (non-admin) PowerShell window
powershell -ExecutionPolicy Bypass -File windows\install.ps1
```

## Uninstall

```sh
macos/uninstall.sh        # macOS
linux/uninstall.sh        # Linux
powershell -ExecutionPolicy Bypass -File windows\uninstall.ps1   # Windows
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
