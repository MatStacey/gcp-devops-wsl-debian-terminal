# ------------------------------------------
# System Update Check
# ------------------------------------------
# ~/.bash.d/02-update-check.sh

__check_updates() {
  # Exit immediately if not in an interactive shell
  if [[ $- != *i* ]]; then return; fi

  local pending_file="$HOME/.bash.d/.update_pending"
  local cache_file="$HOME/.bash.d/.update_check_cache"
  local current_time
  current_time=$(date +%s)

  # If a background check found updates, display the notification message
  if [ -f "$pending_file" ]; then
    local updates_count
    updates_count=$(cat "$pending_file")
    echo -e "\n\e[33m📦 $updates_count system package(s) can be upgraded. Run \e[1msys-install\e[0m\e[33m to install them.\e[0m"
    return
  fi

  # Time calculation using TTL from config (default 12 hours = 43200 seconds)
  local last_check=0
  if [ -f "$cache_file" ]; then
    last_check=$(cat "$cache_file")
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
        echo "$(date +%s)" > "$cache_file"
      fi
    ) &
    disown
  fi
}

__check_updates
