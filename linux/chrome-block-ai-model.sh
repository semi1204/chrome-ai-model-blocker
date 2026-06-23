#!/bin/sh
# Deletes Chrome's on-device AI model dirs if they reappear.
# Covers both google-chrome and chromium config dirs.

for base in "$HOME/.config/google-chrome" "$HOME/.config/chromium"; do
  for d in OptGuideOnDeviceModel OptGuideOnDeviceClassifierModel; do
    target="$base/$d"
    if [ -e "$target" ]; then
      rm -rf "$target"
      logger -t chrome-block-ai-model "removed $target" 2>/dev/null || true
    fi
  done
done
