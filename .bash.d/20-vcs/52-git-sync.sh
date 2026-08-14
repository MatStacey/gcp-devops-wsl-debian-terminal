# shellcheck shell=bash
# ------------------------------------------
# Version Control (Git) - Profile Synchronization
# ------------------------------------------

#######################################
# Clones and initializes a repository into the sync directory.
# Arguments:
#   $1 - The target repository directory path.
#   $2 - The remote origin URL to bind to.
# Outputs:
#   Writes clone or init status to STDOUT.
# Returns:
#   0 on success.
#######################################
__git_sync_init_repo() {
  local repo_dir="$1" remote_url="$2"

  [ -d "$repo_dir/.git" ] && return 0

  echo "📥 Local sync directory not found or not initialized."
  mkdir -p "$repo_dir"

  if ! git clone "$remote_url" "$repo_dir" 2> /dev/null; then
    echo "⚠️ Clone failed (likely an empty remote). Initializing local repository..."
    git -C "$repo_dir" init
    git -C "$repo_dir" remote add origin "$remote_url"
  fi

  [ "$(git -C "$repo_dir" remote get-url origin 2> /dev/null)" != "$remote_url" ] &&
    git -C "$repo_dir" remote set-url origin "$remote_url" 2> /dev/null || git -C "$repo_dir" remote add origin "$remote_url"
}

#######################################
# Synchronizes the active bash config files over to the tracked git directory.
# Strips sensitive yaml keys dynamically via rsync exclusions.
# Globals:
#   HOME
# Arguments:
#   $1 - The target repository directory path.
#######################################
__git_sync_copy_files() {
  local repo_dir="$1"

  mkdir -p "$repo_dir/.bash.d"

  # Exclude root files and folders from the subfolder mirror so they do not duplicate
  rsync -a --exclude "config/config.yaml" --exclude "config/.env.cache" --exclude "README.md" --exclude ".bashrc" --exclude "install.sh" --exclude ".gitignore" --exclude ".github" --delete "$HOME/.bash.d/" "$repo_dir/.bash.d/"

  # Explicitly sync the root .bashrc file
  if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$repo_dir/.bashrc"
  fi

  (
    cd "$repo_dir" || exit 1
    [ ! -f ".gitignore" ] || ! grep -q ".bash.d/config/config.yaml" .gitignore 2> /dev/null && sed -i -e '$a\' .gitignore && echo ".bash.d/config/config.yaml" >> .gitignore
    git ls-files --error-unmatch .bash.d/config/config.yaml > /dev/null 2>&1 && git rm -q --cached .bash.d/config/config.yaml
    rm -f .bash.d/config/config.yaml
    git add --all
  )
}

#######################################
# Git: Sync local bash configs to terminal repo and push (AI-powered systematic commits)
# Globals:
#   SYNC_REPO_DIR
#   SYNC_REPO_URL
# Arguments:
#   $1 - Optional string message. If empty, triggers AI systematic feature grouping.
# Outputs:
#   Writes sync, diff, and execution state to STDOUT.
# Returns:
#   0 on success, 1 on misconfigured URL path.
#######################################
mt-push-update() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }

  if command -v google-fmt > /dev/null 2>&1; then
    echo "🧹 Running Google Style code formatting before profile sync..."
    google-fmt
  fi

  local repo_dir="$SYNC_REPO_DIR"
  local remote_url="${SYNC_REPO_URL:-}"

  if [[ -z "$remote_url" || "$remote_url" == "YOUR_SYNC_REPO_URL" || "$remote_url" == "null" ]]; then
    echo -e "\n\033[1;33m⚠️  Profile Sync Not Configured\033[0m"
    echo -e "The \033[1mpush-profile-update\033[0m feature automatically versions and pushes your terminal configuration to a remote Git repository."
    echo "If you downloaded this profile as a standalone ZIP and do not wish to sync it, you can safely ignore this command."
    echo -e "\nTo enable syncing, link an empty remote Git repository by running:"
    echo -e "  \033[1;36mmt-add-sync-url \"git@github.com:username/my-terminal-repo.git\"\033[0m\n"
    return 1
  fi

  echo "🔄 Syncing bash configuration to $repo_dir..."

  __git_sync_init_repo "$repo_dir" "$remote_url"
  __git_sync_copy_files "$repo_dir"

  (
    cd "$repo_dir" || exit 1
    git diff --staged --quiet && {
      echo "✅ Configurations are already up to date. No changes to commit."
      return 0
    }

    local user_msg="${1:-}"

    if [ -z "$user_msg" ]; then
      __git_sync_ai_commit "$repo_dir"

      git add --all
      if ! git diff --staged --quiet; then
        echo "💡 Committing: chore: sync miscellaneous updates"
        git commit -m "chore: sync miscellaneous updates" > /dev/null
      fi
    else
      echo "📦 Committing all as a single batch..."
      git commit -m "$user_msg" > /dev/null
    fi

    if git push origin HEAD; then
      echo "🚀 Successfully pushed updates to remote."
      read -p "🌐 Open repository in browser? [Y/n] " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        git-web
      fi
    else
      echo "🚨 Error: Failed to push updates to remote." >&2
      return 1
    fi
  )
}

#######################################
# Git: Pull latest profile changes from remote and sync to local workspace
#######################################
mt-get-update() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local repo_dir="$SYNC_REPO_DIR"

  if [ -z "$repo_dir" ] || [ ! -d "$repo_dir/.git" ]; then
    echo -e "\n\033[1;33m⚠️  Profile Sync Not Configured\033[0m"
    echo "Your environment is currently running as a standalone local installation."
    echo -e "To pull updates from a remote repository, you must first configure a sync URL using \033[1mmt-add-sync-url\033[0m and push your initial commit.\n"
    return 1
  fi

  echo -e "${CB_BLUE}⬇️ Pulling latest changes from remote repository...${C_RESET}"
  (
    cd "$repo_dir" || exit 1
    git fetch --tags origin
    git pull origin "$(git rev-parse --abbrev-ref HEAD)"
  )

  echo -e "\n${CB_YELLOW}🔄 Applying updates to local ~/.bash.d workspace...${C_RESET}"
  if [ -f "$repo_dir/install.sh" ]; then
    bash "$repo_dir/install.sh"

    # Clear the update marker so the prompt goes away
    rm -f "$HOME/.bash.d/.profile_update_pending"

    # Note: install.sh advises the user to run 'reload'.
    # We will automatically trigger it here for a seamless experience.
    source "$HOME/.bashrc"
  else
    echo -e "${CB_RED}🚨 Error: install.sh missing from repository root.${C_RESET}"
    return 1
  fi
}
