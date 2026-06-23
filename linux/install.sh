#!/bin/sh
# Install the Chrome AI model blocker on Linux.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
UNIT_DIR="$HOME/.config/systemd/user"
POLICY_DIR="/etc/opt/chrome/policies/managed"
POLICY_FILE="$POLICY_DIR/block-ai-model.json"

mkdir -p "$BIN_DIR" "$UNIT_DIR"

# 1. Block: managed policy (0=allowed, 1=disabled/no download). Needs root.
SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"
$SUDO mkdir -p "$POLICY_DIR"
printf '{\n  "GenAILocalFoundationalModelSettings": 1\n}\n' | $SUDO tee "$POLICY_FILE" >/dev/null
echo "policy written: $POLICY_FILE"

# 2. Delete now (if present).
sh "$SCRIPT_DIR/chrome-block-ai-model.sh" || true

# 3. Install the watcher script + systemd user units.
install -m 0755 "$SCRIPT_DIR/chrome-block-ai-model.sh" "$BIN_DIR/chrome-block-ai-model.sh"
cp "$SCRIPT_DIR/chrome-block-ai-model.service" "$UNIT_DIR/"
cp "$SCRIPT_DIR/chrome-block-ai-model.path" "$UNIT_DIR/"

systemctl --user daemon-reload
systemctl --user enable --now chrome-block-ai-model.path

echo "installed. watcher status:"
systemctl --user --no-pager status chrome-block-ai-model.path | head -3 || true
echo "Restart Chrome, then check chrome://policy"
