#!/usr/bin/env bash
# Execution Context: $SYNC_REPO_DIR/.dev

echo "🔍 Locating 'win-docker' in your framework..."

# Search for the file containing win-docker
TARGET_FILE=$(grep -rlw "win-docker" "$HOME/.bash.d/" | grep '\.sh$' | head -n 1)

if [ -z "$TARGET_FILE" ]; then
  echo "🚨 Error: Could not find 'win-docker' in ~/.bash.d/"
  exit 1
fi

echo "✅ Found 'win-docker' in $(basename "$TARGET_FILE")"
echo ""
echo "What is the internal Linux path to your Docker directory? (e.g., /var/lib/docker or ~/.docker)"
read -e -r -p "👉 Path: " DOCKER_PATH

if [ -z "$DOCKER_PATH" ]; then
  echo "🚨 Aborted. A path is required."
  exit 1
fi

echo "🔄 Injecting 'cd-win-docker' into $(basename "$TARGET_FILE")..."

python3 -c '
import sys, os

filepath = sys.argv[1]
docker_path = sys.argv[2]

with open(filepath, "r") as f:
    content = f.read()

if "cd-win-docker" in content:
    print("⚠️ '\''cd-win-docker'\'' already exists in this file.")
    sys.exit(0)

new_func = f"""
#######################################
# Docker: Change to Docker directory and open in Windows Explorer
#######################################
cd-win-docker() {{
  if [ -d "{docker_path}" ]; then
    echo -e "${{CB_BLUE}}📂 Navigating to {docker_path}...${{C_RESET}}"
    cd "{docker_path}" || return 1
    win-docker
  else
    echo -e "${{CB_RED}}🚨 Error: Directory '{docker_path}' does not exist on the Linux filesystem.${{C_RESET}}"
    return 1
  fi
}}
"""

# Append the new function to the bottom of the target file
with open(filepath, "a") as f:
    f.write("\n" + new_func.strip() + "\n")

print("✅ Successfully injected function!")
' "$TARGET_FILE" "$DOCKER_PATH"

if type mt-refresh-caches > /dev/null 2>&1; then
  echo "🧹 Refreshing MT DevOps caches..."
  mt-refresh-caches > /dev/null 2>&1
fi

echo "🚀 Done! Run 'reload' to start using cd-win-docker."
