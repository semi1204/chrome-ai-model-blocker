#!/bin/sh
# Remove the Chrome AI model blocker on Linux.
set -e

BIN_DIR="$HOME/.local/bin"
UNIT_DIR="$HOME/.config/systemd/user"
POLICY_FILE="/etc/opt/chrome/policies/managed/block-ai-model.json"

systemctl --user disable --now chrome-block-ai-model.path 2>/dev/null || true
rm -f "$UNIT_DIR/chrome-block-ai-model.path" "$UNIT_DIR/chrome-block-ai-model.service"
systemctl --user daemon-reload 2>/dev/null || true
rm -f "$BIN_DIR/chrome-block-ai-model.sh"

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"
$SUDO rm -f "$POLICY_FILE"

echo "uninstalled. Restart Chrome to re-enable the on-device model."
