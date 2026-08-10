#!/usr/bin/env bash
set -e

HOME_DIR="$HOME"
TARGET_BASHD="$HOME_DIR/.bash.d"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Starting installation of GCP DevOps WSL Debian Terminal..."

# 1. Backup existing .bashrc if it exists and isn't a symlink/our file
if [ -f "$HOME_DIR/.bashrc" ] && [ ! -L "$HOME_DIR/.bashrc" ]; then
    echo "📦 Backing up existing .bashrc to ~/.bashrc.bak..."
    cp "$HOME_DIR/.bashrc" "$HOME_DIR/.bashrc.bak"
fi

# 2. Sync core bashrc and modular directory
echo "📂 Copying .bashrc and .bash.d/ structure..."
rsync -a "$REPO_DIR/.bashrc" "$HOME_DIR/"
mkdir -p "$TARGET_BASHD"
rsync -a --delete --exclude 'config/config.yaml' "$REPO_DIR/.bash.d/" "$TARGET_BASHD/"

# 3. Scaffold config.yaml from template if missing
CONFIG_FILE="$TARGET_BASHD/config/config.yaml"
TEMPLATE_FILE="$TARGET_BASHD/lib/templates/config.yaml.tpl"
if [ ! -s "$CONFIG_FILE" ] && [ -f "$TEMPLATE_FILE" ]; then
    echo "⚙️ Scaffolding initial config.yaml from template..."
    mkdir -p "$(dirname "$CONFIG_FILE")"
    cp "$TEMPLATE_FILE" "$CONFIG_FILE"
fi

echo "✅ Files successfully synced to home directory."

# 4. Prompt to run bootstrap
read -p "🔍 Would you like to run 'bootstrap' to install system dependencies (jq, fzf, PyYAML, terraform, etc.) now? [Y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    # Source temporarily to make bootstrap available in this session
    source "$HOME_DIR/.bashrc"
    bootstrap
else
    echo "💡 You can run 'bootstrap' anytime later from your terminal."
fi

echo -e "\n🎉 Installation complete! Run 'reload' or open a new terminal session to activate your environment."