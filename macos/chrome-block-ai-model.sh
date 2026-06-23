#!/bin/sh
# Deletes Chrome's on-device AI model dirs if they reappear.
# Backed by the GenAILocalFoundationalModelSettings=1 policy; this is the safety net.

CHROME_DIR="$HOME/Library/Application Support/Google/Chrome"

for d in OptGuideOnDeviceModel OptGuideOnDeviceClassifierModel; do
  target="$CHROME_DIR/$d"
  if [ -e "$target" ]; then
    rm -rf "$target"
    /usr/bin/logger -t chrome-block-ai-model "removed $target"
  fi
done
