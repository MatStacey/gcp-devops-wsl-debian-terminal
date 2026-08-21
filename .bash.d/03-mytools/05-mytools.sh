# shellcheck shell=bash
# ------------------------------------------
# MyTools Documentation & Runner
# ------------------------------------------
# ~/.bash.d/03-mytools/05-mytools.sh

#######################################
# System: Get latest modification timestamp across all shell scripts
# Arguments:
#   $1 - Base directory path (.bash.d)
# Outputs:
#   Prints highest epoch timestamp to STDOUT
#######################################
__bashd_latest_mod() {
  local bashd_dir="$1"
  if [ "$OS_FAMILY" = "macos" ]; then
    find "$bashd_dir" -type f -name "*.sh" -exec stat -f '%m' {} \; 2> /dev/null | sort -n | tail -1
  else
    find "$bashd_dir" -type f -name "*.sh" -printf '%T@\n' 2> /dev/null | sort -n | tail -1
  fi
}

#######################################
# System: Rebuild mytools TSV index and formatted cache
#######################################
__rebuild_mytools_cache() {
  local bashd_dir="$HOME/.bash.d"
  mkdir -p "$bashd_dir/data/cache" 2> /dev/null
  local cache_file="$bashd_dir/data/cache/.mt_cache"
  local tsv_index="$bashd_dir/data/cache/.mt_data.tsv"
  local time_file="${cache_file}.time"

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

#######################################
# MyTools: Primary runner and documentation index
#######################################
mytools() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }

  local bashd_dir="$HOME/.bash.d"
  local cache_file="$bashd_dir/data/cache/.mt_cache"
  local time_file="${cache_file}.time"
  local latest_mod
  latest_mod=$(__bashd_latest_mod "$bashd_dir")

  if [ ! -f "$cache_file" ] || [ ! -f "$time_file" ] || [ "$(command cat "$time_file" 2> /dev/null)" != "$latest_mod" ]; then
    __rebuild_mytools_cache
  fi
  cat "$cache_file"
}

#######################################
# MyTools: List all available command categories
#######################################
mt-cats() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  echo -e "\n${CB_BLUE}▶ AVAILABLE CATEGORIES${C_RESET}"
  cut -f2 "$HOME/.bash.d/data/cache/.mt_data.tsv" 2> /dev/null | sort -u | while read -r cat; do
    [ -n "$cat" ] && echo -e "  ${CB_YELLOW}[${cat}]${C_RESET}"
  done
  echo ""
}

#######################################
# MyTools: List all tools within a specific category
# Arguments:
#   $1 - Category name
#######################################
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
  awk -F'\t' -v target="$target_cat" 'tolower($2) == target { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv"
  echo ""
}

#######################################
# MyTools: List all documented shell functions
#######################################
mt-funcs() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  echo -e "\n${CB_BLUE}▶ FUNCTIONS${C_RESET}\n"
  awk -F'\t' '$1 == "func" { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m (\033[1;33m%s\033[0m) \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $2, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv"
  echo ""
}

#######################################
# MyTools: List all documented shell aliases
#######################################
mt-aliases() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  echo -e "\n${CB_BLUE}▶ ALIASES${C_RESET}\n"
  awk -F'\t' '$1 == "alias" { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m (\033[1;33m%s\033[0m) \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $2, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv"
  echo ""
}

#######################################
# MyTools: Interactive fuzzy-finder to select and execute a command
#######################################
mt-run() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  local selected
  selected=$(awk -F'\t' '{ printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv" | fzf --ansi --prompt="Run Tool > " --header="COMMAND                  │ CATEGORY             │ DESCRIPTION")
  if [ -n "$selected" ]; then
    local cmd_name
    cmd_name=$(echo "$selected" | awk '{print $1}')
    echo -e "${CB_GREEN}🚀 Executing:${C_RESET} ${cmd_name}"
    eval "$cmd_name"
  fi
}

#######################################
# MyTools: Search through available mytools commands with tab-completion
# Usage: mt-lookup [-i|--interactive] [-v|--verbose] [keyword]
# Arguments:
#   -i, --interactive  Open an fzf menu to select a tool
#   -v, --verbose      Open interactive menu and print the full code using mt-help -v
#   $1                 Search term or command name
#######################################
mt-lookup() {
  local interactive=false
  local verbose=false
  local query=""

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -i | --interactive) interactive=true ;;
      -v | --verbose) verbose=true ;;
      -h | --help)
        mt-help "${FUNCNAME[0]}"
        return 0
        ;;
      -*)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        echo "Usage: mt-lookup [-i|--interactive] [-v|--verbose] [keyword]"
        return 1
        ;;
      *) query="$1" ;;
    esac
    shift
  done

  mytools > /dev/null
  local tsv_file="$HOME/.bash.d/data/cache/.mt_data.tsv"

  # Trigger the menu if -i or -v is passed
  if [ "$interactive" = true ] || [ "$verbose" = true ]; then
    local selected
    if [ -n "$query" ]; then
      selected=$(awk -F'\t' -v q="${query,,}" 'tolower($0) ~ q { printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$tsv_file" | fzf --ansi --prompt="Select Tool > " --header="COMMAND                  │ CATEGORY             │ DESCRIPTION")
    else
      selected=$(awk -F'\t' '{ printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$tsv_file" | fzf --ansi --prompt="Select Tool > " --header="COMMAND                  │ CATEGORY             │ DESCRIPTION")
    fi

    if [ -n "$selected" ]; then
      local cmd_name
      cmd_name=$(echo "$selected" | awk '{print $1}')
      if [ "$verbose" = true ]; then
        mt-help -v "$cmd_name"
      else
        mt-help "$cmd_name"
      fi
    fi
  else
    if [ -z "$query" ]; then
      echo "Usage: mt-lookup [-i|--interactive] [-v|--verbose] <keyword|command>"
      return 1
    fi
    # Standard non-interactive output
    awk -F'\t' -v q="${query,,}" 'tolower($0) ~ q { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m (\033[1;33m%s\033[0m) \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $2, $4 }' "$tsv_file"
  fi
}

#######################################
# MyTools: Search through available mytools commands (Alias)
#######################################
alias mt-search='mt-lookup'

_mt_lookup_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local tsv="$HOME/.bash.d/data/cache/.mt_data.tsv"
  if [ -f "$tsv" ]; then
    local candidates
    candidates=$(awk -F'\t' '{print $3 "\n" $2}' "$tsv" | sort -u)
    COMPREPLY=($(compgen -W "$candidates" -- "$cur"))
  fi
}
complete -F _mt_lookup_completions mt-lookup mt-search

#######################################
# MyTools: Interactive fuzzy-finder to search for a command
#######################################
mt-fzf() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  local selected
  selected=$(awk -F'\t' '{ printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv" | fzf --ansi --prompt="Search MyTools > " --header="COMMAND                  │ CATEGORY             │ DESCRIPTION")
  [ -n "$selected" ] && echo "$selected" | awk '{print $1}'
}

#######################################
# MyTools: Display active framework configuration variables
#######################################
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
  echo -e " ${CB_CYAN}DOTFILES_DIR      ${C_RESET}: ${DOTFILES_DIR:-$SYNC_REPO_DIR}"
  echo -e " ${CB_CYAN}AI_WORKSPACE      ${C_RESET}: ${AI_WORKSPACE_DIR}"
  echo -e " ${CB_CYAN}EXPORT_DIR        ${C_RESET}: ${EXPORT_DIR:-/tmp/exports}"
  echo -e " ${CB_CYAN}BACKUP_DIR        ${C_RESET}: ${BACKUP_DIR:-~/backups}"
  echo -e " ${CB_CYAN}AUTO_CLEANUP      ${C_RESET}: ${AUTO_CLEANUP_EXPORTS:-false} (${AUTO_CLEANUP_DAYS:-7} days)"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
}

#######################################
# MyTools: Display detailed help and source code for a command
# Usage: mt-help [-v|--verbose] <command>
# Arguments:
#   $1 - Command name or keyword
#######################################
mt-help() {
  local show_code=false
  local target=""

  # Parse Arguments
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -v | --verbose) show_code=true ;;
      -h | --help)
        echo -e "${CB_BLUE}Usage:${C_RESET} mt-help [-v|--verbose] <command>"
        return 0
        ;;
      -*)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        echo "Usage: mt-help [-v|--verbose] <command>"
        return 1
        ;;
      *) target="$1" ;;
    esac
    shift
  done

  [ -z "$target" ] && {
    echo "Usage: mt-help [-v|--verbose] <command>"
    return 1
  }

  __render_help() {
    local cmd="$1"
    local fpath="$2"
    local show_code="$3"

    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    echo -e "${CB_CYAN} 🛠️  ${cmd}${C_RESET}"
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    echo -e "${CB_YELLOW} 📄 File: ${C_RESET} $(wslpath -m "$fpath" 2> /dev/null || echo "$fpath")"
    echo -e "${CB_BLUE}----------------------------------------------------------${C_RESET}"

    # Use AWK to cleanly separate the docstring from the codeblock
    local raw_data
    raw_data=$(awk -v target="$cmd" '
      BEGIN { flag=0; doc=""; code="" }
      /^#######################################/ { next }
      /^#/ {
          line = substr($0, 2)
          sub(/^[ \t]/, "", line)
          doc = doc line "\n"
          next
      }
      $0 ~ "^alias " target "=" { code = $0 "\n"; exit }
      $0 ~ "^" target "\(\\)[ \t]*\{" { code = $0 "\n"; flag=1; next }
      flag { code = code $0 "\n"; if ($0 ~ /^}$/) exit }
      { if (!flag) { doc=""; code="" } }
      END { print doc; print "---MT_CODE_DELIMITER---"; print code }
    ' "$fpath")

    local docstring="${raw_data%%---MT_CODE_DELIMITER---*}"
    local codeblock="${raw_data#*---MT_CODE_DELIMITER---}"

    # Parse and colorize the documentation string
    local section="desc"
    while IFS= read -r line; do
      [ -z "$line" ] && continue

      # Catch Headers (Usage:, Options:, Arguments:, etc.)
      if [[ "$line" =~ ^(Usage|Options|Arguments|Returns|Outputs|Globals): ]]; then
        echo -e "\n${CB_CYAN}▶ ${line}${C_RESET}"
        section="details"
      elif [ "$section" = "desc" ]; then
        # Main description text is standard white
        echo -e "${C_WHITE}${line}${C_RESET}"
      else
        # In details sections, look for flags starting with a dash
        if [[ "$line" =~ ^[[:space:]]*- ]]; then
          # Color the flag yellow, and the description dim text
          echo -e "  ${CB_YELLOW}${line%%  *}${C_RESET}  ${C_DIM}${line#*  }${C_RESET}"
        else
          echo -e "  ${C_DIM}${line}${C_RESET}"
        fi
      fi
    done <<< "$docstring"

    # Only show source code if the flag was provided
    if [ "$show_code" = true ] && [ -n "$codeblock" ]; then
      echo -e "\n${CB_BLUE}▶ SOURCE CODE${C_RESET}"
      echo -e "${CB_BLUE}----------------------------------------------------------${C_RESET}"
      if command -v "$BAT_BIN" > /dev/null 2>&1; then
        echo "$codeblock" | "$BAT_BIN" --language=bash --style=plain --paging=never 2> /dev/null
      else
        echo -e "${C_DIM}${codeblock}${C_RESET}"
      fi
    fi
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
  }

  local file_path
  file_path=$(grep -rlE "^(alias ${target}=|${target}\(\)[ \t]*\{)" "$HOME/.bash.d/" 2> /dev/null | head -n 1)
  if [ -n "$file_path" ]; then
    __render_help "$target" "$file_path" "$show_code"
    return 0
  fi

  mytools > /dev/null
  local tsv_file="$HOME/.bash.d/data/cache/.mt_data.tsv"
  local candidates=()

  if [ -f "$tsv_file" ]; then
    while read -r match; do
      [ -n "$match" ] && candidates+=("$match")
    done < <(awk -F'\t' -v q="${target,,}" 'tolower($3) ~ q { print $3 }' "$tsv_file" | sort -u)
  fi

  local count="${#candidates[@]}"

  if [ "$count" -eq 1 ]; then
    local single_target="${candidates[0]}"
    file_path=$(grep -rlE "^(alias ${single_target}=|${single_target}\(\)[ \t]*\{)" "$HOME/.bash.d/" 2> /dev/null | head -n 1)
    if [ -n "$file_path" ]; then
      __render_help "$single_target" "$file_path" "$show_code"
      return 0
    fi
  elif [ "$count" -gt 1 ]; then
    echo -e "${CB_YELLOW}⚠️  No exact match found for '${target}'. Did you mean one of these?${C_RESET}\n"
    for cand in "${candidates[@]}"; do
      echo -e "  ${C_DIM}•${C_RESET} ${CB_CYAN}${cand}${C_RESET}"
    done
    echo ""
    return 0
  fi

  echo -e "${CB_RED}🚨 Error: '${target}' is not a recognized custom MyTools command.${C_RESET}"
  return 1
}

_mt_cat_completions() {
  local IFS=$'\n'
  local cats
  cats=$(cut -f2 "$HOME/.bash.d/data/cache/.mt_data.tsv" 2> /dev/null | sort -u)
  COMPREPLY=($(compgen -W "$cats" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _mt_cat_completions mt-cat

_mt_help_completions() {
  local tools
  tools=$(cut -f3 "$HOME/.bash.d/data/cache/.mt_data.tsv" 2> /dev/null)
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

  if [ -f "$HOME/.bash.d/data/.current_version" ]; then
    local current_version
    current_version=$(command cat "$HOME/.bash.d/data/.current_version")
    echo -e "${CB_CYAN}Profile Version:${C_RESET} ${current_version}"
  elif [ -n "$DOTFILES_DIR" ] && [ -d "$DOTFILES_DIR/.git" ] && command -v git > /dev/null 2>&1; then
    local current_version
    current_version=$(git -C "$DOTFILES_DIR" describe --tags --abbrev=0 2> /dev/null || echo "Local")
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
  # Self-heal missing cache directories (e.g., after clean git clone or update)
  mkdir -p "$HOME/.bash.d/data/cache" "$HOME/.bash.d/data/logs" "$HOME/.bash.d/config"

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_YELLOW}🧹 Clearing background caches...${C_RESET}"
  rm -f "$HOME/.bash.d/config/.env.cache"
  rm -f "$HOME/.bash.d/data/cache/.mt_cache" "$HOME/.bash.d/data/cache/.mt_cache.time" "$HOME/.bash.d/data/cache/.mt_data.tsv"
  rm -f "$HOME/.bash.d/data/cache/.update_check_cache" "$HOME/.bash.d/data/cache/.update_pending"
  rm -f "$HOME/.bash.d/data/cache/.zoxide_cache.sh"
  rm -f "$HOME/.bash.d/data/cache/.profile_update_cache" "$HOME/.bash.d/data/cache/.profile_update_pending"

  echo -e "${CB_BLUE}🔄 Rebuilding configurations and tool indexes...${C_RESET}"
  if [ -f "$HOME/.bash.d/lib/python/config_manager.py" ]; then
    python3 "$HOME/.bash.d/lib/python/config_manager.py" load-env > "$HOME/.bash.d/config/.env.cache"
    chmod 600 "$HOME/.bash.d/config/.env.cache" 2> /dev/null
  fi

  __rebuild_mytools_cache

  source "$HOME/.bashrc"
  echo -e "${CB_GREEN}✅ All system caches refreshed successfully.${C_RESET}"
}

#######################################
# System: Display a unified health check and status dashboard
#######################################
mt-status() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e "${CB_BLUE}                 MT DEVOPS DASHBOARD                      ${C_RESET}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"

  local current_version="Local"
  [ -f "$HOME/.bash.d/data/.current_version" ] && current_version=$(tr -d '[:space:]' < "$HOME/.bash.d/data/.current_version")
  echo -e "${CB_YELLOW}▶ FRAMEWORK${C_RESET}"
  echo -e "  ${CB_CYAN}Version       ${C_RESET}: ${current_version}"
  echo -e "  ${CB_CYAN}Theme         ${C_RESET}: ${BASH_THEME:-default}"
  echo -e "  ${CB_CYAN}AI Enabled    ${C_RESET}: ${AI_ENABLED:-true} (${DEFAULT_AI:-gemini})"

  echo -e "\n${CB_YELLOW}▶ PROFILE SYNC REPO${C_RESET}"
  local repo_dir="${DOTFILES_DIR:-$SYNC_REPO_DIR}"
  if [ -n "$repo_dir" ] && [ -d "$repo_dir/.git" ]; then
    local branch
    branch=$(git -C "$repo_dir" branch --show-current 2> /dev/null)
    local changes
    changes=$(git -C "$repo_dir" status --porcelain 2> /dev/null | wc -l)
    echo -e "  ${CB_CYAN}Path          ${C_RESET}: ${repo_dir}"
    echo -e "  ${CB_CYAN}Branch        ${C_RESET}: ${branch}"
    if [ "$changes" -gt 0 ]; then
      echo -e "  ${CB_CYAN}Uncommitted   ${C_RESET}: ${CB_RED}${changes} file(s) (Run mt-push-update)${C_RESET}"
    else
      echo -e "  ${CB_CYAN}Uncommitted   ${C_RESET}: ${CB_GREEN}Clean${C_RESET}"
    fi
  else
    echo -e "  ${CB_RED}Not initialized or not a Git repository. Run mt-setup to configure.${C_RESET}"
  fi

  echo -e "\n${CB_YELLOW}▶ DOCKER ENVIRONMENT${C_RESET}"
  if command -v docker > /dev/null 2>&1 && docker info > /dev/null 2>&1; then
    local running
    running=$(docker ps -q 2> /dev/null | wc -l)
    local total
    total=$(docker ps -aq 2> /dev/null | wc -l)
    echo -e "  ${CB_CYAN}Daemon        ${C_RESET}: ${CB_GREEN}Running${C_RESET}"
    echo -e "  ${CB_CYAN}Containers    ${C_RESET}: ${running} running / ${total} total"
  else
    echo -e "  ${CB_CYAN}Daemon        ${C_RESET}: ${CB_RED}Stopped or Not Installed${C_RESET}"
  fi

  echo -e "\n${CB_YELLOW}▶ SYSTEM UPDATES${C_RESET}"
  if [ -f "$HOME/.bash.d/data/cache/.update_pending" ]; then
    local sys_updates
    sys_updates=$(tr -d '[:space:]' < "$HOME/.bash.d/data/cache/.update_pending")
    echo -e "  ${CB_CYAN}OS Packages   ${C_RESET}: ${CB_RED}${sys_updates} available (Run sys-install)${C_RESET}"
  else
    echo -e "  ${CB_CYAN}OS Packages   ${C_RESET}: ${CB_GREEN}Up to date${C_RESET}"
  fi

  if [ -f "$HOME/.bash.d/data/cache/.profile_update_pending" ]; then
    local prof_update
    prof_update=$(tr -d '[:space:]' < "$HOME/.bash.d/data/cache/.profile_update_pending")
    echo -e "  ${CB_CYAN}Framework     ${C_RESET}: ${CB_RED}${prof_update} available (Run mt-get-update)${C_RESET}"
  else
    echo -e "  ${CB_CYAN}Framework     ${C_RESET}: ${CB_GREEN}Up to date${C_RESET}"
  fi

  echo -e "${CB_BLUE}==========================================================${C_RESET}"
}

#######################################
# MyTools: Generate a detailed technical Markdown dump of all functions and aliases
# Usage: mt-dump [OPTIONS]
# Options:
#   -d, --dir <path>       Specify export directory (default: ~/.bash.d/docs)
#   --private              Include private/internal framework functions (starting with _ or __)
#   -h, --help             Show this help menu
#######################################
mt-dump() {
  local export_dir="$HOME/.bash.d/docs"
  local include_private=false

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -d | --dir)
        export_dir="$2"
        shift
        ;;
      --private)
        include_private=true
        ;;
      -h | --help)
        mt-help "${FUNCNAME[0]}"
        return 0
        ;;
      *)
        echo "Usage: mt-dump [-d <export_dir>] [--private]"
        return 1
        ;;
    esac
    shift
  done

  mkdir -p "$export_dir"
  local out_file="${export_dir}/TECHNICAL_REFERENCE.md"

  echo -e "${CB_BLUE}📝 Generating technical reference manual...${C_RESET}"

  cat << 'HDR' > "$out_file"
# 🛠️ MT DevOps Framework - Technical Command Reference

> **Auto-generated Reference Document**  
> Generated: $(date)  
> Environment: $(uname -s) ($(uname -m))

---

HDR

  local tsv_index="$HOME/.bash.d/data/cache/.mt_data.tsv"
  mytools > /dev/null

  if [ -f "$tsv_index" ]; then
    echo "" >> "$out_file"
    echo "## 🔗 Shell Aliases" >> "$out_file"
    echo "" >> "$out_file"
    awk -F'\t' '$1 == "alias" { printf "- **`%s`** *(%s)*: %s\n", $3, $2, $4 }' "$tsv_index" >> "$out_file"
    echo "" >> "$out_file"
    echo "---" >> "$out_file"
    echo "" >> "$out_file"
    echo "## 🛠️ Public Functions" >> "$out_file"
    echo "" >> "$out_file"

    local current_cat=""
    while IFS=$'\t' read -r type cat name desc; do
      [ "$type" != "func" ] && continue

      if [ "$cat" != "$current_cat" ]; then
        current_cat="$cat"
        echo "" >> "$out_file"
        echo "### 📂 ${current_cat}" >> "$out_file"
        echo "" >> "$out_file"
      fi

      echo "" >> "$out_file"
      echo "#### \`$name\`" >> "$out_file"
      echo "" >> "$out_file"
      echo "> $desc" >> "$out_file"
      echo "" >> "$out_file"

      local src_file
      src_file=$(grep -rlE "^${name}\(\)[ \t]*\{" "$HOME/.bash.d/" 2> /dev/null | head -n 1)
      if [ -n "$src_file" ]; then
        echo "\`\`\`bash" >> "$out_file"
        awk -v target="$name" -f "$HOME/.bash.d/lib/awk/mt_help.awk" "$src_file" >> "$out_file"
        echo "\`\`\`" >> "$out_file"
      fi
    done < <(sort -t$'\t' -k2,2 -k3,3 "$tsv_index")
  fi

  if [ "$include_private" = true ]; then
    echo "" >> "$out_file"
    echo "---" >> "$out_file"
    echo "" >> "$out_file"
    echo "## 🔒 Internal Framework Helpers (Private Functions)" >> "$out_file"
    echo "" >> "$out_file"
    echo "Private functions prefixed with \`_\` or \`__\` used internally by the framework." >> "$out_file"

    find "$HOME/.bash.d" -type f -name "*.sh" -exec grep -HnE "^_{1,2}[a-zA-Z0-9_-]+\(\)[ \t]*\{" {} + | while read -r line; do
      local fpath
      fpath=$(echo "$line" | cut -d: -f1)
      local func_name
      func_name=$(echo "$line" | grep -oE "_{1,2}[a-zA-Z0-9_-]+")

      [ -z "$func_name" ] && continue
      local rel_fpath="${fpath#"$HOME"/.bash.d/}"

      echo "" >> "$out_file"
      echo "### \`$func_name\` *(File: \`00-system/${rel_fpath}\`)*" >> "$out_file"
      echo "" >> "$out_file"
      echo "\`\`\`bash" >> "$out_file"
      awk -v target="$func_name" -f "$HOME/.bash.d/lib/awk/mt_help.awk" "$fpath" >> "$out_file"
      echo "\`\`\`" >> "$out_file"
    done
  fi

  echo -e "${CB_GREEN}✅ Technical reference generated at:${C_RESET} ${out_file}"

  if type __open_path_gui > /dev/null 2>&1; then
    __open_path_gui "$export_dir" 2> /dev/null || true
  fi
}

_mt_dump_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "-d --dir --private -h --help" -- "$cur"))
}
complete -F _mt_dump_completions mt-dump
