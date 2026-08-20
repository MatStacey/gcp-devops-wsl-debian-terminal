#!/usr/bin/env bash

CONFIG_FILE="$HOME/.bash.d/00-system/00-config.sh"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "🚨 Error: Could not find $CONFIG_FILE"
  exit 1
fi

echo "🔄 Patching AI API key warnings in $CONFIG_FILE..."

# Use a Python string replacement to safely overwrite the exact multi-line block
python3 -c '
import os
import sys

filepath = os.path.expanduser("~/.bash.d/00-system/00-config.sh")
try:
    with open(filepath, "r") as f:
        content = f.read()
except FileNotFoundError:
    print("🚨 Target file not found.")
    sys.exit(1)

old_block = r"""if [[ -z "$GEMINI_API_KEY" || "$GEMINI_API_KEY" == "YOUR_GEMINI_API_KEY" || "$GEMINI_API_KEY" == "null" ]];
then
  unset GEMINI_API_KEY
  echo -e "${C_YELLOW}No Gemini API Key provided in config.yaml. Add one via:\n    ${C_RESET}mt-add-gemini-key \"your-api-key\"\e[0m"
fi

if [[ -z "$CLAUDE_API_KEY" ||
"$CLAUDE_API_KEY" == "YOUR_CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "null" ]]; then
  unset CLAUDE_API_KEY
  echo -e "${C_YELLOW}No Claude API Key provided in config.yaml. Add one via:\n    ${C_RESET}mt-add-claude-key \"your-api-key\"\e[0m"
fi"""

new_block = r"""if [[ -z "$GEMINI_API_KEY" || "$GEMINI_API_KEY" == "YOUR_GEMINI_API_KEY" || "$GEMINI_API_KEY" == "null" ]]; then
  unset GEMINI_API_KEY
  # Only warn if Gemini is the active provider
  if [[ "${DEFAULT_AI:-gemini}" == "gemini" ]]; then
    echo -e "${C_YELLOW}No Gemini API Key provided in config.yaml. Add one via:\n    ${C_RESET}mt-add-gemini-key \"your-api-key\"\e[0m"
  fi
fi

if [[ -z "$CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "YOUR_CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "null" ]]; then
  unset CLAUDE_API_KEY
  # Only warn if Claude is the active provider
  if [[ "${DEFAULT_AI:-gemini}" == "claude" ]]; then
    echo -e "${C_YELLOW}No Claude API Key provided in config.yaml. Add one via:\n    ${C_RESET}mt-add-claude-key \"your-api-key\"\e[0m"
  fi
fi"""

if old_block in content:
    content = content.replace(old_block, new_block)
    with open(filepath, "w") as f:
        f.write(content)
    print("✅ Successfully patched the API key warnings!")
else:
    print("⚠️  Target block not found. The file may have already been patched.")
'

# Trigger a cache refresh if the framework is currently loaded
if command -v mt-refresh-caches > /dev/null 2>&1; then
  echo "🧹 Refreshing MT DevOps caches..."
  mt-refresh-caches > /dev/null 2>&1
  echo "🚀 Done! Warnings will now respect your DEFAULT_AI setting."
else
  echo "🚀 Done! Run 'mt-refresh-caches' or 'reload' for changes to take effect."
fi
