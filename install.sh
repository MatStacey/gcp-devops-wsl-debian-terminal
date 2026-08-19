#!/usr/bin/env bash
set -e

HOME_DIR="$HOME"
TARGET_BASHD="$HOME_DIR/.bash.d"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Starting installation of MT DevOps Framework..."

# 1. Backup existing .bashrc if it exists and isn't a symlink/our file
if [ -f "$HOME_DIR/.bashrc" ] && [ ! -L "$HOME_DIR/.bashrc" ]; then
  echo "📦 Backing up existing .bashrc to ~/.bashrc.bak..."
  cp "$HOME_DIR/.bashrc" "$HOME_DIR/.bashrc.bak"
fi

# 2. Sync core bashrc and modular directory
echo "📂 Copying .bashrc and .bash.d/ structure..."
rsync -a "$REPO_DIR/.bashrc" "$HOME_DIR/"
mkdir -p "$TARGET_BASHD"
# --delete would otherwise wipe local-only files (*private*.sh, *.local.sh)
# that the repo's own .gitignore tells users to keep secrets in, plus the
# generated env cache — exclude all of them alongside config.yaml.
rsync -a --delete \
  --exclude 'config/config.yaml' \
  --exclude 'config/.env.cache' \
  --exclude '*private*.sh' \
  --exclude '*.local.sh' \
  --exclude '*.local' \
  "$REPO_DIR/.bash.d/" "$TARGET_BASHD/"

# 3. Scaffold config.yaml from template if missing
CONFIG_FILE="$TARGET_BASHD/config/config.yaml"
TEMPLATE_FILE="$TARGET_BASHD/lib/templates/config.yaml.tpl"
if [ ! -s "$CONFIG_FILE" ] && [ -f "$TEMPLATE_FILE" ]; then
  echo "⚙️ Scaffolding initial config.yaml from template..."
  mkdir -p "$(dirname "$CONFIG_FILE")"
  cp "$TEMPLATE_FILE" "$CONFIG_FILE"

  # Automatically bind the SYNC_REPO to the directory where install.sh was executed
  echo "🔗 Binding sync repository path to extraction directory..."
  sed -i "s|sync_repo: ~/vcs/personal/mt-devops-framework|sync_repo: $REPO_DIR|g" "$CONFIG_FILE"
fi

echo "✅ Files successfully synced to home directory."

# 4. Check dependencies and conditionally prompt for bootstrap
echo "🔍 Checking for missing system dependencies..."
source "$TARGET_BASHD/00-system/00-os.sh"
source "$TARGET_BASHD/00-system/04-bootstrap.sh"

MISSING_DEPS_CHECK=()
if [ "$OS_FAMILY" = "macos" ]; then
  MISSING_DEPS_CHECK=("${BREW_DEPENDENCIES[@]}")
else
  MISSING_DEPS_CHECK=("${APT_DEPENDENCIES[@]}")
  MISSING_DEPS_CHECK+=("yq:yq") # Linux manually checks yq since it bypasses APT
fi
MISSING_DEPS_CHECK+=("${PYTHON_DEPENDENCIES[@]}" "${COMPLEX_DEPENDENCIES[@]}")

# Utilize the framework's native checker
MISSING_LIST=($(__get_missing_deps "${MISSING_DEPS_CHECK[@]}"))

if [ ${#MISSING_LIST[@]} -gt 0 ]; then
  echo -e "\n\033[1;33m⚠️ Missing required dependencies detected: ${MISSING_LIST[*]}\033[0m"
  read -p "🔍 Would you like to run 'bootstrap' to install them now? [Y/n] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    bootstrap
  else
    echo "💡 You can run 'bootstrap' anytime later from your terminal."
  fi
else
  echo "✅ All system dependencies are already satisfied."
fi

echo -e "\n🎉 Installation complete! Run 'source ~/.bashrc' or open a new terminal session to activate your environment."
