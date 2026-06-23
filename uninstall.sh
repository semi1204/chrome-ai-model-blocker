#!/bin/sh
# One-line bootstrap uninstaller for macOS / Linux.
#   curl -fsSL https://raw.githubusercontent.com/semi1204/chrome-ai-model-blocker/master/uninstall.sh | sh
set -e

REPO="semi1204/chrome-ai-model-blocker"
REF="${REF:-master}"
TARBALL="https://codeload.github.com/$REPO/tar.gz/refs/heads/$REF"

case "$(uname -s)" in
    Darwin) OS=macos ;;
    Linux)  OS=linux ;;
    *) echo "Unsupported OS: $(uname -s). Use windows/uninstall.ps1 on Windows." >&2; exit 1 ;;
esac

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

curl -fsSL "$TARBALL" | tar -xz -C "$TMP"
SRC="$TMP/$(ls "$TMP")"
sh "$SRC/$OS/uninstall.sh"
