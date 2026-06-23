#!/bin/sh
# One-line bootstrap installer for macOS / Linux.
#   curl -fsSL https://raw.githubusercontent.com/semi1204/chrome-ai-model-blocker/master/install.sh | sh
#
# Downloads the repo and runs the installer for the detected OS.
set -e

REPO="semi1204/chrome-ai-model-blocker"
REF="${REF:-master}"
TARBALL="https://codeload.github.com/$REPO/tar.gz/refs/heads/$REF"

case "$(uname -s)" in
    Darwin) OS=macos ;;
    Linux)  OS=linux ;;
    *) echo "Unsupported OS: $(uname -s). Use windows/install.ps1 on Windows." >&2; exit 1 ;;
esac

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Downloading $REPO ($REF)..."
curl -fsSL "$TARBALL" | tar -xz -C "$TMP"

SRC="$TMP/$(ls "$TMP")"
sh "$SRC/$OS/install.sh"
