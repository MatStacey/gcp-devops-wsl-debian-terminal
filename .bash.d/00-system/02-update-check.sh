# shellcheck shell=bash
# ------------------------------------------
# System Update Check
# ------------------------------------------
# ~/.bash.d/02-update-check.sh

__check_updates() {
  # Exit immediately if not in an interactive shell
  if [[ $- != *i* ]]; then return; fi

  local pending_file="$HOME/.bash.d/data/cache/.update_pending"
  local cache_file="$HOME/.bash.d/data/cache/.update_check_cache"
  local current_time
  current_time=$(date +%s)
  mkdir -p \"$HOME/.bash.d/data/cache\" 2> /dev/null

  # If a background check found updates, display the notification message
  if [ -f "$pending_file" ]; then
    local updates_count
    updates_count=$(command cat "$pending_file")
    echo -e "\n\e[33m📦 $updates_count system package(s) can be upgraded. Run \e[1msys-install\e[0m\e[33m to install them.\e[0m"
    return
  fi

  # Time calculation using TTL from config (default 12 hours = 43200 seconds)
  local last_check=0
  if [ -f "$cache_file" ]; then
    last_check=$(command cat "$cache_file")
  fi

  local ttl="${UPDATE_CHECK_TTL_SEC:-43200}"

  if ((current_time - last_check >= ttl)); then
    # Fire the package update check asynchronously in a background subshell
    # (Zero startup lag). APT on Debian/WSL, Homebrew on macOS.
    (
      local count
      if [ "$OS_FAMILY" = "macos" ]; then
        if command -v brew > /dev/null 2>&1; then
          count=$(brew outdated 2> /dev/null | grep -c .)
        else
          count=0
        fi
      else
        count=$(apt list --upgradable 2> /dev/null | grep -c -v 'Listing...')
      fi

      if [ "$count" -gt 0 ]; then
        echo "$count" > "$pending_file"
      else
        date +%s > "$cache_file"
      fi
    ) &
    disown
  fi
}

__check_updates

#######################################
# System: Asynchronously check for profile updates from the remote repository
#######################################
__check_profile_updates() {
  if [[ $- != *i* ]]; then return; fi

  local pending_file="$HOME/.bash.d/data/cache/.profile_update_pending"
  local cache_file="$HOME/.bash.d/data/cache/.profile_update_cache"
  local current_time
  current_time=$(date +%s)
  mkdir -p \"$HOME/.bash.d/data/cache\" 2> /dev/null

  if [ -f "$pending_file" ]; then
    local new_version
    new_version=$(command cat "$pending_file")
    local current_version="Local"
    if [ -f "$HOME/.bash.d/config/.current_version" ]; then
      current_version=$(command cat "$HOME/.bash.d/config/.current_version")
    elif [ -n "$SYNC_REPO_DIR" ] && [ -d "$SYNC_REPO_DIR/.git" ] && command -v git > /dev/null 2>&1; then
      current_version=$(git -C "$SYNC_REPO_DIR" describe --tags --abbrev=0 2> /dev/null || echo "Local")
    fi

    echo -e "\n\e[33m🚀 Terminal profile update available! (\e[1m${current_version}\e[22m -> \e[1m${new_version}\e[22m)\e[0m"
    echo -e "\e[33m   Run \e[1mmt-get-update\e[22m to apply the latest changes.\e[0m\n"
    return
  fi

  local last_check=0
  if [ -f "$cache_file" ]; then
    last_check=$(command cat "$cache_file")
  fi

  local ttl="${UPDATE_CHECK_TTL_SEC:-43200}"

  if ((current_time - last_check >= ttl)); then
    (
      local repo_path="MatStacey/mt-devops-framework"
      if [[ "${SYNC_REPO_URL:-}" =~ github\.com[:/]([^/]+/[^/.]+)(\.git)? ]]; then
        repo_path="${BASH_REMATCH[1]}"
      fi

      local remote_version
      remote_version=$(curl -s "https://api.github.com/repos/${repo_path}/releases/latest" | jq -r ".tag_name // empty")

      local current_version=""
      if [ -f "$HOME/.bash.d/config/.current_version" ]; then
        current_version=$(command cat "$HOME/.bash.d/config/.current_version")
      elif [ -n "$SYNC_REPO_DIR" ] && [ -d "$SYNC_REPO_DIR/.git" ] && command -v git > /dev/null 2>&1; then
        current_version=$(git -C "$SYNC_REPO_DIR" describe --tags --abbrev=0 2> /dev/null || echo "")
      fi

      if [ -n "$remote_version" ] && [ "$current_version" != "$remote_version" ]; then
        echo "$remote_version" > "$pending_file"
      else
        date +%s > "$cache_file"
      fi
    ) &
    disown
  fi
}

__check_profile_updates
