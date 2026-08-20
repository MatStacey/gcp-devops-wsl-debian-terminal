#!/usr/bin/env bash
# Execution Context: $SYNC_REPO_DIR/.dev

echo "🔍 Locating 'win-docker' in your framework..."

TARGET_FILE=$(grep -rlw "win-docker" "$HOME/.bash.d/" | grep '\.sh$' | head -n 1)

if [ -z "$TARGET_FILE" ]; then
  echo "🚨 Error: Could not find 'win-docker' in ~/.bash.d/"
  exit 1
fi

echo "✅ Found 'win-docker' in $(basename "$TARGET_FILE")"
echo "🔄 Injecting dynamic 'cd-win-docker' into $(basename "$TARGET_FILE")..."

python3 -c '
import sys, os

filepath = sys.argv[1]

with open(filepath, "r") as f:
    content = f.read()

if "cd-win-docker" in content:
    print("⚠️ '\''cd-win-docker'\'' already exists in this file. Please remove the old one first.")
    sys.exit(0)

new_func = r"""
#######################################
# Docker: Change to Docker directory (from config.yaml) and open in Windows Explorer
#######################################
cd-win-docker() {
  # Dynamically pull the path from config.yaml
  local docker_path
  docker_path=$(python3 -c '\''import yaml, os; print(yaml.safe_load(open(os.path.expanduser("~/.bash.d/config/config.yaml"))).get("paths", {}).get("docker_root", ""))'\'')
  
  # Evaluate any tildes (~) or variables in the path
  docker_path=$(eval echo "$docker_path")

  if [ -z "$docker_path" ]; then
    echo -e "${CB_RED}🚨 Error: 'docker_root' is not defined under 'paths' in config.yaml.${C_RESET}"
    return 1
  fi

  if [ -d "$docker_path" ]; then
    echo -e "${CB_BLUE}📂 Navigating to ${docker_path}...${C_RESET}"
    cd "$docker_path" || return 1
    win-docker
  else
    echo -e "${CB_RED}🚨 Error: Directory '${docker_path}' does not exist on the Linux filesystem.${C_RESET}"
    return 1
  fi
}
"""

with open(filepath, "a") as f:
    f.write("\n" + new_func.strip() + "\n")

print("✅ Successfully injected dynamic function!")
' "$TARGET_FILE"

if command -v mt-refresh-caches > /dev/null 2>&1; then
  echo "🧹 Refreshing MT DevOps caches..."
  mt-refresh-caches > /dev/null 2>&1
fi

echo "🚀 Done! Run 'reload' to activate."
