# shellcheck shell=bash
# ------------------------------------------
# System Update Check
# ------------------------------------------
# ~/.bash.d/00-system/02-update-check.sh

#######################################
# System: Check asynchronously for pending system package updates
#######################################
__check_updates() {
  if [[ $- != *i* ]]; then return; fi

  local pending_file="$HOME/.bash.d/data/cache/.update_pending"
  local cache_file="$HOME/.bash.d/data/cache/.update_check_cache"
  local current_time
  current_time=$(date +%s)
  mkdir -p "$HOME/.bash.d/data/cache" 2> /dev/null

  if [ -f "$pending_file" ]; then
    local updates_count
    updates_count=$(command cat "$pending_file")
    echo -e "\n${C_YELLOW}📦 $updates_count system package(s) can be upgraded. Run ${C_BOLD}sys-install${C_RESET}${C_YELLOW} to install them.${C_RESET}"
    return
  fi

  local last_check=0
  if [ -f "$cache_file" ]; then
    last_check=$(command cat "$cache_file")
  fi

  local ttl="${UPDATE_CHECK_TTL_SEC:-43200}"

  if ((current_time - last_check >= ttl)); then
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
# System: Asynchronously check for profile updates from remote Git repository
#######################################
__check_profile_updates() {
  if [[ $- != *i* ]]; then return; fi

  local pending_file="$HOME/.bash.d/data/cache/.profile_update_pending"
  local cache_file="$HOME/.bash.d/data/cache/.profile_update_cache"
  local current_time
  current_time=$(date +%s)
  mkdir -p "$HOME/.bash.d/data/cache" 2> /dev/null

  if [ -f "$pending_file" ]; then
    local new_version
    new_version=$(command cat "$pending_file")
    local current_version="Local"
    local repo_dir="${DOTFILES_DIR:-$SYNC_REPO_DIR}"
    if [ -f "$HOME/.bash.d/data/.current_version" ]; then
      current_version=$(command cat "$HOME/.bash.d/data/.current_version")
    elif [ -n "$repo_dir" ] && [ -d "$repo_dir/.git" ] && command -v git > /dev/null 2>&1; then
      current_version=$(git -C "$repo_dir" describe --tags --abbrev=0 2> /dev/null || echo "Local")
    fi

    echo -e "\n${C_YELLOW}🚀 Terminal profile update available! (${C_BOLD}${current_version}${C_UNBOLD} -> ${C_BOLD}${new_version}${C_UNBOLD})${C_RESET}"
    echo -e "${C_YELLOW}   Run ${C_BOLD}mt-get-update${C_UNBOLD} to apply the latest changes.${C_RESET}\n"
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
      local repo_dir="${DOTFILES_DIR:-$SYNC_REPO_DIR}"
      if [ -f "$HOME/.bash.d/data/.current_version" ]; then
        current_version=$(command cat "$HOME/.bash.d/data/.current_version")
      elif [ -n "$repo_dir" ] && [ -d "$repo_dir/.git" ] && command -v git > /dev/null 2>&1; then
        current_version=$(git -C "$repo_dir" describe --tags --abbrev=0 2> /dev/null || echo "")
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
