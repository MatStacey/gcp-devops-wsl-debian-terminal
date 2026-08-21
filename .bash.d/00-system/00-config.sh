# shellcheck shell=bash
# ------------------------------------------
# Configuration Management
# ------------------------------------------
# ~/.bash.d/00-system/00-config.sh

CONFIG_FILE="$HOME/.bash.d/config/config.yaml"
CONFIG_MANAGER="$HOME/.bash.d/lib/python/config_manager.py"
ENV_CACHE="$HOME/.bash.d/data/cache/.env.cache"
YAML_TEMPLATE="$HOME/.bash.d/lib/templates/config.yaml.tpl"

if [ ! -s "$CONFIG_FILE" ]; then
  mkdir -p "$(dirname "$CONFIG_FILE")"
  [ -f "$YAML_TEMPLATE" ] && cp "$YAML_TEMPLATE" "$CONFIG_FILE" || touch "$CONFIG_FILE"
fi
chmod 600 "$CONFIG_FILE" 2> /dev/null

#######################################
# System: Intercept shell prompt to intelligently reload config.yaml if modified
#######################################
__reload_config_if_modified() {
  if [ -f "$CONFIG_MANAGER" ]; then
    if [ ! -f "$ENV_CACHE" ] || [ "$CONFIG_FILE" -nt "$ENV_CACHE" ]; then
      local old_theme="$BASH_THEME"
      python3 "$CONFIG_MANAGER" load-env > "$ENV_CACHE"
      chmod 600 "$ENV_CACHE" 2> /dev/null
      source "$ENV_CACHE"

      if [ "$old_theme" != "$BASH_THEME" ]; then
        source "$HOME/.bash.d/01-ui/01-colors.sh"
      fi
    fi
  fi
}

[[ "$PROMPT_COMMAND" != *"__reload_config_if_modified"* ]] && PROMPT_COMMAND="__reload_config_if_modified; ${PROMPT_COMMAND:-}"
__reload_config_if_modified

# Force load the cache for fresh terminal sessions
if [ -f "$ENV_CACHE" ]; then
  source "$ENV_CACHE"
fi

# Ensure color definitions are loaded before running startup checks
if [ -f "$HOME/.bash.d/01-ui/01-colors.sh" ]; then
  source "$HOME/.bash.d/01-ui/01-colors.sh"
fi

if [[ -z "$GEMINI_API_KEY" || "$GEMINI_API_KEY" == "YOUR_GEMINI_API_KEY" || "$GEMINI_API_KEY" == "null" ]]; then
  unset GEMINI_API_KEY
  if [[ "${DEFAULT_AI:-gemini}" == "gemini" ]]; then
    echo -e "${C_YELLOW}No Gemini API Key provided in config.yaml. Add one via:${C_RESET}"
    echo -e "    ${C_RESET}mt-add-gemini-key 'your-api-key'\033[0m"
  fi
fi

if [[ -z "$CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "YOUR_CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "null" ]]; then
  unset CLAUDE_API_KEY
  if [[ "${DEFAULT_AI:-gemini}" == "claude" ]]; then
    echo -e "${C_YELLOW}No Claude API Key provided in config.yaml. Add one via:${C_RESET}"
    echo -e "    ${C_RESET}mt-add-claude-key 'your-api-key'\033[0m"
  fi
fi

#######################################
# AI: Print current Gemini API model version and extended reasoning mode toggle
#######################################
mt-get-gemini-status() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e "${CB_BLUE}                 GEMINI CONFIGURATION                     ${C_RESET}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e " ${CB_CYAN}GEMINI_VERSION    ${C_RESET}: ${GEMINI_VERSION:-Not Set}"
  echo -e " ${CB_CYAN}GEMINI_EXTENDED   ${C_RESET}: ${GEMINI_EXTENDED:-false}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
}

#######################################
# Config: Toggle global format-on-push behavior (true/false)
#######################################
mt-toggle-format-on-push() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local current="${GIT_FORMAT_ON_PUSH:-true}"
  local next="true"
  [ "$current" = "true" ] && next="false"

  python3 "$CONFIG_MANAGER" update "git" "format_on_push" "$next"
  export GIT_FORMAT_ON_PUSH="$next"
  echo "✅ Format-on-push set to $next."
}

#######################################
# Config: Set the upstream repository path for framework updates
# Arguments:
#   $1 - The repository path (e.g., "MatStacey/mt-devops-framework")
#######################################
mt-set-upstream-path() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$1" ]; then
    echo "Usage: mt-set-upstream-path <MatStacey/mt-devops-framework>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "git" "upstream_repo_path" "$1"
  export UPSTREAM_REPO_PATH="$1"
  echo "✅ Upstream repository path set to $1."
}

#######################################
# Config: Set default terminal IDE launcher
# Usage: mt-set-default-ide "vscode|intellij"
# Arguments:
#   $1 - IDE identifier (vscode or intellij)
#######################################
mt-set-default-ide() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [[ "$1" != "vscode" && "$1" != "intellij" ]]; then
    echo "Usage: mt-set-default-ide <vscode|intellij>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "system" "default_ide" "$1"
  export DEFAULT_IDE="$1"
  echo "✅ Default IDE set to $1."
}

#######################################
# Config: Set default AI model provider
# Usage: mt-set-default-ai "gemini|claude|local"
# Arguments:
#   $1 - AI provider identifier
#######################################
mt-set-default-ai() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [[ "$1" != "gemini" && "$1" != "claude" && "$1" != "local" ]]; then
    echo "Usage: mt-set-default-ai <gemini|claude|local>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "ai" "default_provider" "$1"
  export DEFAULT_AI="$1"
  echo "✅ Default AI set to $1."
}

#######################################
# Config: Toggle global AI prompt and workflow integration (true/false)
#######################################
mt-toggle-ai() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local new_val="true"
  [ "${AI_ENABLED:-true}" = "true" ] && new_val="false"
  python3 "$CONFIG_MANAGER" update "ai" "enabled" "$new_val"
  export AI_ENABLED="$new_val"
  echo "✅ AI integration set to $new_val."
}

#######################################
# Config: Open bash.d directory and config.yaml in IDE
# Usage: mt-open-config [-ide vscode|intellij]
# Options:
#   -ide <name>   Override default IDE launcher
#######################################
mt-open-config() {
  local selected_ide="${DEFAULT_IDE:-vscode}"
  local args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h | --help)
        mt-help "${FUNCNAME[0]}"
        return 0
        ;;
      -ide)
        selected_ide="$2"
        shift 2
        ;;
      *)
        args+=("$1")
        shift
        ;;
    esac
  done

  local config_dir="$HOME/.bash.d"
  local config_file="$config_dir/config/config.yaml"
  local yaml_tpl="$config_dir/lib/templates/config.yaml.tpl"

  if [ ! -s "$config_file" ]; then
    mkdir -p "$(dirname "$config_file")"
    [ -f "$yaml_tpl" ] && cp "$yaml_tpl" "$config_file"
  fi

  echo "🚀 Opening bash config in $selected_ide..."
  [ "$selected_ide" = "intellij" ] &&
    { __launch_intellij "$config_dir" "$config_file" || echo "⚠️ Could not launch IntelliJ. Ensure 'idea' is on PATH (JetBrains Toolbox), or install IntelliJ IDEA via Homebrew on macOS."; } ||
    code "$config_dir" "$config_file"
}

#######################################
# Config: Set terminal color theme
# Usage: mt-set-theme "theme_name"
# Arguments:
#   $1 - Valid theme name (e.g. default, dracula, monokai)
#######################################
mt-set-theme() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local theme="${1:-default}"

  if [ ! -f "$HOME/.bash.d/config/themes/$theme.sh" ]; then
    echo "🚨 Invalid theme. Ensure $theme.sh exists in $HOME/.bash.d/config/themes/"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "system" "theme" "$theme"
  export BASH_THEME="$theme"
  echo "✅ Terminal theme set to $theme."
}

#######################################
# Config: Launch the interactive Master Setup Wizard Menu
#######################################
mt-setup() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e "${CB_BLUE}        MT DEVOPS FRAMEWORK - MASTER SETUP WIZARD         ${C_RESET}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}\n"

  local options=(
    "1. Quick Setup (First-Time Defaults)"
    "2. System Configuration"
    "3. AI Provider Configuration"
    "4. Exports & Cleanup Configuration"
    "5. Workspace & Directory Paths"
    "6. Git & Version Control"
    "7. CI/CD Default Provider"
    "8. Docker Preferences"
    "9. Exit"
  )

  local choice
  choice=$(printf '%s\n' "${options[@]}" | fzf --prompt="⚙️ Select a category to configure > " --height=~15 --layout=reverse --border)

  case "$choice" in
    1*) __mt_setup_quick ;;
    2*) mt-setup-system ;;
    3*) mt-setup-ai ;;
    4*) mt-setup-exports ;;
    5*) mt-setup-paths ;;
    6*) mt-setup-git ;;
    7*) mt-setup-cicd ;;
    8*) mt-setup-docker ;;
    *)
      echo "⚠️ Setup cancelled."
      return 0
      ;;
  esac

  mt-refresh-caches > /dev/null 2>&1
  echo -e "${CB_GREEN}✅ Configuration saved! Run 'reload' to apply changes fully.${C_RESET}"
}

#######################################
# Config: Internal Quick First-Time Setup workflow
#######################################
__mt_setup_quick() {
  echo -e "${CB_BLUE}--- Quick Setup ---${C_RESET}"
  read -r -p "1️⃣ Default IDE (vscode/intellij) [${DEFAULT_IDE:-vscode}]: " ide
  [ -n "$ide" ] && mt-set-default-ide "$ide"

  read -r -p "2️⃣ Default AI Provider (gemini/claude/local) [${DEFAULT_AI:-gemini}]: " provider
  [ -n "$provider" ] && mt-set-default-ai "$provider"

  local active_provider="${provider:-${DEFAULT_AI:-gemini}}"
  if [ "$active_provider" = "gemini" ]; then
    read -r -s -p "🔑 Enter Gemini API Key (Enter to skip): " key
    echo
    [ -n "$key" ] && mt-add-gemini-key "$key"
  elif [ "$active_provider" = "claude" ]; then
    read -r -s -p "🔑 Enter Claude API Key (Enter to skip): " key
    echo
    [ -n "$key" ] && mt-add-claude-key "$key"
  fi

  read -r -p "3️⃣ CI/CD Provider (github/bitbucket/gitlab/azure/jenkins) [${CICD_PROVIDER:-github}]: " cicd
  [ -n "$cicd" ] && mt-set-cicd "$cicd"

  local default_sync="${UPSTREAM_REPO_PATH:-MatStacey/mt-devops-framework}"
  read -r -p "4️⃣ Git Sync Repo URL [${SYNC_REPO_URL:-$default_sync}]: " sync_url
  [ -n "$sync_url" ] && mt-add-sync-url "$sync_url" || { [ -z "$SYNC_REPO_URL" ] && mt-add-sync-url "$default_sync"; }
}

#######################################
# Config: Interactive System Setup Menu
#######################################
mt-setup-system() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- System Configuration ---${C_RESET}"
  read -r -p "Default IDE (vscode/intellij) [${DEFAULT_IDE:-vscode}]: " ide
  [ -n "$ide" ] && python3 "$CONFIG_MANAGER" update "system" "default_ide" "$ide"
  read -r -p "Max Parallel Threads [${MAX_PARALLEL_THREADS:-8}]: " threads
  [ -n "$threads" ] && python3 "$CONFIG_MANAGER" update "system" "max_parallel_threads" "$threads"
  read -r -p "Update Check TTL (seconds) [${UPDATE_CHECK_TTL_SEC:-43200}]: " ttl
  [ -n "$ttl" ] && python3 "$CONFIG_MANAGER" update "system" "update_check_ttl_sec" "$ttl"
  echo -e "${CB_GREEN}✅ System config updated.${C_RESET}"
}

#######################################
# Config: Interactive AI Setup Menu
#######################################
mt-setup-ai() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- AI Configuration ---${C_RESET}"
  read -r -p "Enable AI Features? (true/false) [${AI_ENABLED:-true}]: " enabled
  [ -n "$enabled" ] && python3 "$CONFIG_MANAGER" update "ai" "enabled" "$enabled"
  read -r -p "Default Provider (gemini/claude/local) [${DEFAULT_AI:-gemini}]: " prov
  [ -n "$prov" ] && python3 "$CONFIG_MANAGER" update "ai" "default_provider" "$prov"

  echo -e "\n${CB_CYAN}Gemini Settings:${C_RESET}"
  read -r -p "Gemini Model Version [${GEMINI_VERSION:-gemini-3.6-flash}]: " g_ver
  [ -n "$g_ver" ] && python3 "$CONFIG_MANAGER" update "ai.gemini" "version" "$g_ver"
  read -r -s -p "Update Gemini API Key (Leave blank to keep current): " g_key
  echo
  [ -n "$g_key" ] && python3 "$CONFIG_MANAGER" update "ai.gemini" "api_key" "$g_key"

  echo -e "\n${CB_CYAN}Claude Settings:${C_RESET}"
  read -r -p "Claude Model Version [${CLAUDE_VERSION:-claude-3-7-sonnet-latest}]: " c_ver
  [ -n "$c_ver" ] && python3 "$CONFIG_MANAGER" update "ai.claude" "version" "$c_ver"
  read -r -s -p "Update Claude API Key (Leave blank to keep current): " c_key
  echo
  [ -n "$c_key" ] && python3 "$CONFIG_MANAGER" update "ai.claude" "api_key" "$c_key"

  echo -e "\n${CB_CYAN}Local AI Settings:${C_RESET}"
  read -r -p "Local AI Base URL [${LOCAL_AI_BASE_URL:-http://localhost:11434/v1}]: " l_url
  [ -n "$l_url" ] && python3 "$CONFIG_MANAGER" update "ai.local" "base_url" "$l_url"
  read -r -p "Local AI Model [${LOCAL_AI_MODEL:-llama3.2}]: " l_mod
  [ -n "$l_mod" ] && python3 "$CONFIG_MANAGER" update "ai.local" "model" "$l_mod"

  echo -e "${CB_GREEN}✅ AI config updated.${C_RESET}"
}

#######################################
# Config: Interactive Exports Setup Menu
#######################################
mt-setup-exports() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- Exports Configuration ---${C_RESET}"
  read -r -p "Auto Cleanup Exports? (true/false) [${AUTO_CLEANUP_EXPORTS:-true}]: " cln
  [ -n "$cln" ] && python3 "$CONFIG_MANAGER" update "exports" "auto_cleanup" "$cln"
  read -r -p "Auto Cleanup Threshold (days) [${AUTO_CLEANUP_DAYS:-7}]: " days
  [ -n "$days" ] && python3 "$CONFIG_MANAGER" update "exports" "auto_cleanup_days" "$days"
  read -r -p "Regex Blocklist [${EXPORT_BLOCKLIST}]: " blk
  [ -n "$blk" ] && python3 "$CONFIG_MANAGER" update "exports" "blocklist" "$blk"
  echo -e "${CB_GREEN}✅ Exports config updated.${C_RESET}"
}

#######################################
# Config: Interactive Paths Setup Menu
#######################################
mt-setup-paths() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- Paths Configuration ---${C_RESET}"
  read -r -p "VCS Root [${VCS_ROOT:-~/vcs}]: " p1
  [ -n "$p1" ] && python3 "$CONFIG_MANAGER" update "paths" "vcs_root" "$p1"
  read -r -p "VCS Personal [${VCS_PERSONAL:-~/vcs/personal}]: " p2
  [ -n "$p2" ] && python3 "$CONFIG_MANAGER" update "paths" "vcs_personal" "$p2"
  read -r -p "VCS Exports [${VCS_EXPORTS:-~/vcs/personal/exports}]: " p3
  [ -n "$p3" ] && python3 "$CONFIG_MANAGER" update "paths" "vcs_exports" "$p3"
  read -r -p "Dotfiles Repo [${DOTFILES_DIR:-~/vcs/personal/mt-devops-framework}]: " p4
  [ -n "$p4" ] && python3 "$CONFIG_MANAGER" update "paths" "dotfiles_dir" "$p4"
  read -r -p "AI Workspace [${AI_WORKSPACE_DIR:-~/vcs/ai-workspace}]: " p5
  [ -n "$p5" ] && python3 "$CONFIG_MANAGER" update "paths" "ai_workspace" "$p5"
  read -r -p "IAM Scripts [${SCRIPTS_IAM_DIR:-~/vcs/scripts/iam}]: " p6
  [ -n "$p6" ] && python3 "$CONFIG_MANAGER" update "paths" "scripts_iam" "$p6"
  read -r -p "Docker Root [${DOCKER_ROOT_DIR:-~/.docker}]: " p7
  [ -n "$p7" ] && python3 "$CONFIG_MANAGER" update "paths" "docker_root" "$p7"
  read -r -p "Backup Dir [${BACKUP_DIR:-~/backups}]: " p8
  [ -n "$p8" ] && python3 "$CONFIG_MANAGER" update "paths" "backup_dir" "$p8"
  echo -e "${CB_GREEN}✅ Paths config updated.${C_RESET}"
}

#######################################
# Config: Interactive Git Setup Menu
#######################################
mt-setup-git() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- Git Configuration ---${C_RESET}"
  local default_sync="${UPSTREAM_REPO_PATH:-MatStacey/mt-devops-framework}"
  read -r -p "Sync Repo URL [${SYNC_REPO_URL:-$default_sync}]: " sync_url
  [ -n "$sync_url" ] && python3 "$CONFIG_MANAGER" update "git" "sync_repo_url" "$sync_url"

  read -r -p "Upstream Framework Path [${UPSTREAM_REPO_PATH:-MatStacey/mt-devops-framework}]: " upstream
  [ -n "$upstream" ] && python3 "$CONFIG_MANAGER" update "git" "upstream_repo_path" "$upstream"

  read -r -p "Format on Push? (true/false) [${GIT_FORMAT_ON_PUSH:-true}]: " fmt
  [ -n "$fmt" ] && python3 "$CONFIG_MANAGER" update "git" "format_on_push" "$fmt"

  read -r -p "Feature Branch Prefix [${GIT_FEATURE_PREFIX:-feature/}]: " prefix
  [ -n "$prefix" ] && python3 "$CONFIG_MANAGER" update "git" "feature_prefix" "$prefix"

  read -r -p "AI Max Diff Bytes [${AI_MAX_DIFF_BYTES:-4000}]: " bytes
  [ -n "$bytes" ] && python3 "$CONFIG_MANAGER" update "git" "ai_max_diff_bytes" "$bytes"
  echo -e "${CB_GREEN}✅ Git config updated.${C_RESET}"
}

#######################################
# Config: Interactive CI/CD Setup Menu
#######################################
mt-setup-cicd() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- CI/CD Configuration ---${C_RESET}"
  read -r -p "Default Provider (github/bitbucket/gitlab/azure/jenkins) [${CICD_PROVIDER:-github}]: " prov
  [ -n "$prov" ] && python3 "$CONFIG_MANAGER" update "cicd" "provider" "$prov"
  echo -e "${CB_GREEN}✅ CI/CD config updated.${C_RESET}"
}

#######################################
# Config: Interactive Docker Setup Menu
#######################################
mt-setup-docker() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- Docker Configuration ---${C_RESET}"
  read -r -p "Restart Blocklist (comma-separated) [${DOCKER_BLOCKLIST:-redis,postgres,local-db}]: " blk
  [ -n "$blk" ] && python3 "$CONFIG_MANAGER" update "docker" "restart_blocklist" "$blk"
  echo -e "${CB_GREEN}✅ Docker config updated.${C_RESET}"
}

#######################################
# Config: Forcefully re-parse config.yaml and reload environment variables
#######################################
mt-load-config() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_BLUE}🔄 Forcefully re-parsing config.yaml...${C_RESET}"

  local env_cache="$HOME/.bash.d/data/cache/.env.cache"
  rm -f "$env_cache" "$HOME/.bash.d/config/.env.cache" 2> /dev/null

  if [ -f "$CONFIG_MANAGER" ]; then
    python3 "$CONFIG_MANAGER" load-env > "$env_cache"
    chmod 600 "$env_cache" 2> /dev/null
    source "$env_cache"
    echo -e "${CB_GREEN}✅ Config reloaded! Active variables updated.${C_RESET}"
  else
    echo -e "${CB_RED}🚨 Error: config_manager.py not found.${C_RESET}"
    return 1
  fi
}

#######################################
# Config: Forcefully re-parse config.yaml and reload environment variables
#######################################
alias mt-reload-config='mt-load-config'
