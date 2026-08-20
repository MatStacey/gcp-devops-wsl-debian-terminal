#!/usr/bin/env bash
# Execution Context: $SYNC_REPO_DIR/.dev

GIT_FILE="$HOME/.bash.d/20-vcs/50-git.sh"

if [ ! -f "$GIT_FILE" ]; then
  echo "🚨 Error: Could not find $GIT_FILE"
  exit 1
fi

echo "🔄 Fixing ShellCheck SC2162 in $GIT_FILE..."

python3 -c '
import os

filepath = os.path.expanduser("~/.bash.d/20-vcs/50-git.sh")
with open(filepath, "r") as f:
    content = f.read()

old_line = "read -p \"Enter new branch name: \" new_branch"
new_line = "read -r -p \"Enter new branch name: \" new_branch"

if old_line in content:
    content = content.replace(old_line, new_line)
    with open(filepath, "w") as f:
        f.write(content)
    print("✅ Successfully added -r flag to read statement!")
else:
    print("⚠️  Warning: Could not find the target line. It may already be patched or formatted differently.")
'
