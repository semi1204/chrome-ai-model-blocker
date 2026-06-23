#!/bin/sh
# Install the Chrome AI model blocker on macOS.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
AGENT_DIR="$HOME/Library/LaunchAgents"
PLIST="$AGENT_DIR/com.user.chrome-block-ai-model.plist"

mkdir -p "$BIN_DIR" "$AGENT_DIR"

# 1. Block: set the Chrome policy (0=allowed, 1=disabled/no download).
defaults write com.google.Chrome GenAILocalFoundationalModelSettings -int 1
echo "policy set: GenAILocalFoundationalModelSettings=$(defaults read com.google.Chrome GenAILocalFoundationalModelSettings)"

# 2. Delete now (if present).
sh "$SCRIPT_DIR/chrome-block-ai-model.sh" || true

# 3. Install the watcher script + LaunchAgent.
install -m 0755 "$SCRIPT_DIR/chrome-block-ai-model.sh" "$BIN_DIR/chrome-block-ai-model.sh"
sed "s#__HOME__#$HOME#g" "$SCRIPT_DIR/com.user.chrome-block-ai-model.plist" > "$PLIST"

launchctl unload "$PLIST" 2>/dev/null || true
launchctl load -w "$PLIST"

echo "installed. watcher:"
launchctl list | grep chrome-block-ai-model || echo "  (load it manually if missing)"
echo "Restart Chrome, then check chrome://policy"
