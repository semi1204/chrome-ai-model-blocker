#!/bin/sh
# Remove the Chrome AI model blocker on macOS.
set -e

BIN_DIR="$HOME/.local/bin"
PLIST="$HOME/Library/LaunchAgents/com.user.chrome-block-ai-model.plist"

launchctl unload "$PLIST" 2>/dev/null || true
rm -f "$PLIST"
rm -f "$BIN_DIR/chrome-block-ai-model.sh"

# Re-allow the model (delete the policy key).
defaults delete com.google.Chrome GenAILocalFoundationalModelSettings 2>/dev/null || true

echo "uninstalled. Restart Chrome to re-enable the on-device model."
