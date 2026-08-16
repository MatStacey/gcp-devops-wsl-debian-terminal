# shellcheck shell=bash
# ------------------------------------------
# MyTools Documentation & Runner
# ------------------------------------------

#######################################
# Prints the most recent mtime across all .bash.d/*.sh files, used to
# invalidate the mytools cache. GNU find's `-printf` isn't available on
# macOS/BSD find, so fall back to `stat -f %m` there.
#######################################
__bashd_latest_mod() {
  local bashd_dir="$1"
  if [ "$OS_FAMILY" = "macos" ]; then
    find "$bashd_dir" -type f -name "*.sh" -exec stat -f '%m' {} \; 2> /dev/null | sort -n | tail -1
  else
    find "$bashd_dir" -type f -name "*.sh" -printf '%T@\n' 2> /dev/null | sort -n | tail -1
  fi
}

__rebuild_mytools_cache() {
  local bashd_dir="$HOME/.bash.d"
  local cache_file="$bashd_dir/.mt_cache"
  local tsv_index="$bashd_dir/.mt_data.tsv"
  local time_file="${cache_file}.time"

  # Natively parse all sh files with AWK to handle multi-line blocks
  local raw_tsv
  raw_tsv=$(find "$bashd_dir" -type f -name "*.sh" -exec awk -f "$bashd_dir/lib/awk/mytools.awk" {} +)

  echo "$raw_tsv" | sort -t$'\t' -k1,1r -k2,2f -k3,3f > "$tsv_index"

  {
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    echo -e "${CB_BLUE}                   MY CUSTOM BASH TOOLS                   ${C_RESET}"
    echo -e "${CB_BLUE}==========================================================${C_RESET}\n"

    local current_cat="" current_type=""

    while IFS=$'\t' read -r type cat name desc; do
      [ -z "$name" ] && continue

      if [ "$type" != "$current_type" ]; then
        current_type="$type"
        current_cat=""
        [ "$type" = "func" ] && echo -e "${CB_BLUE}▶ FUNCTIONS${C_RESET}" || echo -e "\n${CB_BLUE}▶ ALIASES${C_RESET}"
      fi

      if [ "$cat" != "$current_cat" ]; then
        current_cat="$cat"
        echo -e "\n  ${CB_YELLOW}[${cat}]${C_RESET}"
      fi

      printf "    ${C_DIM}•${C_RESET} ${CB_CYAN}%-24s${C_RESET} ${C_DIM}→${C_RESET} ${C_WHITE}%s${C_RESET}\n" "$name" "$desc"
    done < "$tsv_index"
    echo ""
  } > "$cache_file"

  local latest_mod
  latest_mod=$(__bashd_latest_mod "$bashd_dir")
  echo "$latest_mod" > "$time_file"
}

mytools() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }

  local bashd_dir="$HOME/.bash.d"
  local cache_file="$bashd_dir/.mt_cache"
  local time_file="${cache_file}.time"
  local latest_mod
  latest_mod=$(__bashd_latest_mod "$bashd_dir")

  if [ ! -f "$cache_file" ] || [ ! -f "$time_file" ] || [ "$(command cat "$time_file" 2> /dev/null)" != "$latest_mod" ]; then
    __rebuild_mytools_cache
  fi
  cat "$cache_file"
}

mt-cats() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  echo -e "\n${CB_BLUE}▶ AVAILABLE CATEGORIES${C_RESET}"
  cut -f2 "$HOME/.bash.d/.mt_data.tsv" 2> /dev/null | sort -u | while read -r cat; do
    [ -n "$cat" ] && echo -e "  ${CB_YELLOW}[${cat}]${C_RESET}"
  done
  echo ""
}

mt-cat() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  [ -z "$1" ] && {
    echo "Usage: mt-cat <category>"
    mt-cats
    return 1
  }

  mytools > /dev/null
  local target_cat="${1,,}"

  echo -e "\n${CB_BLUE}▶ CATEGORY: ${1}${C_RESET}\n"
  awk -F'\t' -v target="$target_cat" 'tolower($2) == target { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $4 }' "$HOME/.bash.d/.mt_data.tsv"
  echo ""
}

mt-funcs() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  echo -e "\n${CB_BLUE}▶ FUNCTIONS${C_RESET}\n"
  awk -F'\t' '$1 == "func" { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m (\033[1;33m%s\033[0m) \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $2, $4 }' "$HOME/.bash.d/.mt_data.tsv"
  echo ""
}

mt-aliases() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  echo -e "\n${CB_BLUE}▶ ALIASES${C_RESET}\n"
  awk -F'\t' '$1 == "alias" { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m (\033[1;33m%s\033[0m) \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $2, $4 }' "$HOME/.bash.d/.mt_data.tsv"
  echo ""
}

mt-run() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  local selected
  selected=$(awk -F'\t' '{ printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$HOME/.bash.d/.mt_data.tsv" | fzf --ansi --prompt="Run Tool > " --header="COMMAND                  │ CATEGORY             │ DESCRIPTION")
  if [ -n "$selected" ]; then
    local cmd_name
    cmd_name=$(echo "$selected" | awk '{print $1}')
    echo -e "${CB_GREEN}🚀 Executing:${C_RESET} ${cmd_name}"
    eval "$cmd_name"
  fi
}

mt-search() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  [ -z "$1" ] && {
    echo "Usage: mt-search <keyword>"
    return 1
  }
  mytools > /dev/null
  awk -F'\t' -v q="${1,,}" 'tolower($0) ~ q { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m (\033[1;33m%s\033[0m) \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $2, $4 }' "$HOME/.bash.d/.mt_data.tsv"
}

mt-fzf() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  local selected
  selected=$(awk -F'\t' '{ printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$HOME/.bash.d/.mt_data.tsv" | fzf --ansi --prompt="Search MyTools > " --header="COMMAND                  │ CATEGORY             │ DESCRIPTION")
  [ -n "$selected" ] && echo "$selected" | awk '{print $1}'
}

mt-config() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e "${CB_BLUE}                ACTIVE CONFIGURATION                      ${C_RESET}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e " ${CB_CYAN}DEFAULT_AI        ${C_RESET}: ${DEFAULT_AI:-gemini}"
  echo -e " ${CB_CYAN}GEMINI_VERSION    ${C_RESET}: ${GEMINI_VERSION:-gemini-1.5-pro}"
  echo -e " ${CB_CYAN}CLAUDE_VERSION    ${C_RESET}: ${CLAUDE_VERSION:-claude-3-7-sonnet-latest}"
  echo -e " ${CB_CYAN}VCS_ROOT          ${C_RESET}: ${VCS_ROOT}"
  echo -e " ${CB_CYAN}VCS_PERSONAL      ${C_RESET}: ${VCS_PERSONAL}"
  echo -e " ${CB_CYAN}SYNC_REPO_DIR     ${C_RESET}: ${SYNC_REPO_DIR}"
  echo -e " ${CB_CYAN}AI_WORKSPACE      ${C_RESET}: ${AI_WORKSPACE_DIR}"
  echo -e " ${CB_CYAN}AUTO_CLEANUP      ${C_RESET}: ${AUTO_CLEANUP_EXPORTS:-false} (${AUTO_CLEANUP_DAYS:-7} days)"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
}

mt-help() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    echo "Usage: mt-help <command>"
    return 0
  }
  local target="$1"
  [ -z "$target" ] && {
    echo "Usage: mt-help <command>"
    return 1
  }

  local file_path
  file_path=$(grep -rlE "^(alias ${target}=|${target}\(\)[ \t]*\{)" "$HOME/.bash.d/" 2> /dev/null | head -n 1)

  if [ -z "$file_path" ]; then
    if ! type -t "$target" > /dev/null 2>&1; then
      echo "🚨 Error: '\''$target'\'' is not a recognized command, alias, or function."
      return 1
    fi
    echo "⚠️  '$target' is not a custom MyTools command. Falling back to native help..."
    "$target" --help 2> /dev/null || man "$target" || "$target" -h
    return $?
  fi

  echo -e "\033[1;34m==========================================================\033[0m"
  echo -e "\033[1;36m 🛠️  ${target}\033[0m"
  echo -e "\033[1;34m==========================================================\033[0m"
  echo -e "\033[1;33m 📄 File: \033[0m $(wslpath -m "$file_path" 2> /dev/null || echo "$file_path")"
  echo -e "\033[1;34m----------------------------------------------------------\033[0m"
  awk -v target="$target" -f "$HOME/.bash.d/lib/awk/mt_help.awk" "$file_path" | "$BAT_BIN" --language=bash --style=plain 2> /dev/null ||
    awk -v target="$target" -f "$HOME/.bash.d/lib/awk/mt_help.awk" "$file_path"

  echo -e "\033[1;34m==========================================================\033[0m"
}

_mt_cat_completions() {
  local IFS=$'\n'
  local cats
  cats=$(cut -f2 "$HOME/.bash.d/.mt_data.tsv" 2> /dev/null | sort -u)
  COMPREPLY=($(compgen -W "$cats" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _mt_cat_completions mt-cat

_mt_help_completions() {
  local tools
  tools=$(cut -f3 "$HOME/.bash.d/.mt_data.tsv" 2> /dev/null)
  COMPREPLY=($(compgen -W "$tools" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _mt_help_completions mt-help

#######################################
# System: Print the current local version of the terminal profile
#######################################
mt-get-version() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  if [ -f "$HOME/.bash.d/.current_version" ]; then
    local current_version
    current_version=$(command cat "$HOME/.bash.d/.current_version")
    echo -e "${CB_CYAN}Profile Version:${C_RESET} ${current_version}"
  elif [ -n "$SYNC_REPO_DIR" ] && [ -d "$SYNC_REPO_DIR/.git" ] && command -v git > /dev/null 2>&1; then
    local current_version
    current_version=$(git -C "$SYNC_REPO_DIR" describe --tags --abbrev=0 2> /dev/null || echo "Local")
    echo -e "${CB_CYAN}Profile Version:${C_RESET} ${current_version}"
  else
    echo -e "${CB_CYAN}Profile Version:${C_RESET} Local (Unversioned/Standalone)"
  fi
}

#######################################
# System: Forcefully clear and rebuild all background caches (.env, mytools, updates)
#######################################
mt-refresh-caches() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_YELLOW}🧹 Clearing background caches...${C_RESET}"
  rm -f "$HOME/.bash.d/config/.env.cache"
  rm -f "$HOME/.bash.d/.mt_cache" "$HOME/.bash.d/.mt_cache.time" "$HOME/.bash.d/.mt_data.tsv"
  rm -f "$HOME/.bash.d/.update_check_cache" "$HOME/.bash.d/.update_pending"
  rm -f "$HOME/.bash.d/.profile_update_cache" "$HOME/.bash.d/.profile_update_pending"

  echo -e "${CB_BLUE}🔄 Rebuilding configurations and tool indexes...${C_RESET}"
  if [ -f "$HOME/.bash.d/lib/python/config_manager.py" ]; then
    python3 "$HOME/.bash.d/lib/python/config_manager.py" load-env > "$HOME/.bash.d/config/.env.cache"
    chmod 600 "$HOME/.bash.d/config/.env.cache" 2> /dev/null
  fi

  __rebuild_mytools_cache

  source "$HOME/.bashrc"
  echo -e "${CB_GREEN}✅ All system caches refreshed successfully.${C_RESET}"
}
