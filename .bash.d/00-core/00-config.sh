# ------------------------------------------
# Configuration Management
# ------------------------------------------
# ~/.bash.d/00-core/00-config.sh

CONFIG_FILE="$HOME/.bash.d/config/config.yaml"
CONFIG_MANAGER="$HOME/.bash.d/lib/config_manager.py"
ENV_CACHE="$HOME/.bash.d/config/.env.cache"
YAML_TEMPLATE="$HOME/.bash.d/lib/templates/config.yaml.tpl"

if [ ! -s "$CONFIG_FILE" ]; then
  mkdir -p "$(dirname "$CONFIG_FILE")"
  [ -f "$YAML_TEMPLATE" ] && cp "$YAML_TEMPLATE" "$CONFIG_FILE" || touch "$CONFIG_FILE"
fi
chmod 600 "$CONFIG_FILE" 2> /dev/null

__reload_config_if_modified() {
  if [ -f "$CONFIG_MANAGER" ]; then
    if [ ! -f "$ENV_CACHE" ] || [ "$CONFIG_FILE" -nt "$ENV_CACHE" ]; then
      local old_theme="$BASH_THEME"
      python3 "$CONFIG_MANAGER" load-env > "$ENV_CACHE"
      chmod 600 "$ENV_CACHE" 2> /dev/null
      source "$ENV_CACHE"

      if [ "$old_theme" != "$BASH_THEME" ]; then
        source "$HOME/.bash.d/00-core/01-colors.sh"
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
if [ -f "$HOME/.bash.d/00-core/01-colors.sh" ]; then
  source "$HOME/.bash.d/00-core/01-colors.sh"
fi

if [[ -z "$GEMINI_API_KEY" || "$GEMINI_API_KEY" == "YOUR_GEMINI_API_KEY" || "$GEMINI_API_KEY" == "null" ]]; then
  unset GEMINI_API_KEY
  echo -e "${C_YELLOW}No Gemini API Key provided in config.yaml. Add one via:\n    ${C_RESET}add-gemini-key \"your-api-key\"\e[0m"
fi

if [[ -z "$CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "YOUR_CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "null" ]]; then
  unset CLAUDE_API_KEY
  echo -e "${C_YELLOW}No Claude API Key provided in config.yaml. Add one via:\n    ${C_RESET}add-claude-key \"your-api-key\"\e[0m"
fi
#######################################
# Prints the current Gemini API model version and extended reasoning mode toggle.
# Globals:
#   GEMINI_VERSION
#   GEMINI_EXTENDED
# Outputs:
#   Writes the configuration status to STDOUT.
#######################################
get-gemini-status() { # => Config: Print the active Gemini version and extended mode status
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

add-gemini-key() { # => Config: Add Gemini API key to config.yaml [Usage: add-gemini-key ["key"]]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local key="$1"
  # Passing the key as an argument lands it in shell history. Prefer the
  # hidden prompt; the positional form still works for scripting.
  if [ -z "$key" ]; then
    read -rsp "Enter Gemini API Key (input hidden): " key
    echo
  fi
  if [ -z "$key" ]; then
    echo "Usage: add-gemini-key [<key>]"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "ai.gemini" "api_key" "$key"
  export GEMINI_API_KEY="$key"
  echo "✅ Gemini API Key added to $CONFIG_FILE."
}

set-gemini-version() { # => Config: Set Gemini model version [Usage: set-gemini-version "gemini-1.5-pro"]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$1" ]; then
    echo "Usage: set-gemini-version <version>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "ai.gemini" "version" "$1"
  export GEMINI_VERSION="$1"
  echo "✅ Gemini version set to $1."
}

toggle-gemini-extended() { # => Config: Toggle Gemini extended mode true/false
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local new_val="true"
  [ "$GEMINI_EXTENDED" = "true" ] && new_val="false"
  python3 "$CONFIG_MANAGER" update "ai.gemini" "extended" "$new_val"
  export GEMINI_EXTENDED="$new_val"
  echo "✅ Gemini extended mode set to $new_val."
}

add-claude-key() { # => Config: Add Claude API key to config.yaml [Usage: add-claude-key ["key"]]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local key="$1"
  # Passing the key as an argument lands it in shell history. Prefer the
  # hidden prompt; the positional form still works for scripting.
  if [ -z "$key" ]; then
    read -rsp "Enter Claude API Key (input hidden): " key
    echo
  fi
  if [ -z "$key" ]; then
    echo "Usage: add-claude-key [<key>]"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "ai.claude" "api_key" "$key"
  export CLAUDE_API_KEY="$key"
  echo "✅ Claude API Key added to $CONFIG_FILE."
}

set-claude-version() { # => Config: Set Claude model version [Usage: set-claude-version "claude-3-7-sonnet-latest"]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$1" ]; then
    echo "Usage: set-claude-version <version>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "ai.claude" "version" "$1"
  export CLAUDE_VERSION="$1"
  echo "✅ Claude version set to $1."
}

add-sync-url() { # => Config: Add remote repository URL for bash sync [Usage: add-sync-url "url"]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$1" ]; then
    echo "Usage: add-sync-url <url>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "git" "sync_repo_url" "$1"
  export SYNC_REPO_URL="$1"
  echo "✅ Sync URL added to $CONFIG_FILE."
}

set-default-ide() { # => Config: Set default IDE [Usage: set-default-ide "vscode|intellij"]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [[ "$1" != "vscode" && "$1" != "intellij" ]]; then
    echo "Usage: set-default-ide <vscode|intellij>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "system" "default_ide" "$1"
  export DEFAULT_IDE="$1"
  echo "✅ Default IDE set to $1."
}

set-default-ai() { # => Config: Set default AI model [Usage: set-default-ai "gemini|claude"]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [[ "$1" != "gemini" && "$1" != "claude" ]]; then
    echo "Usage: set-default-ai <gemini|claude>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "ai" "default_provider" "$1"
  export DEFAULT_AI="$1"
  echo "✅ Default AI set to $1."
}

toggle-ai() { # => Config: Toggle global AI prompt and integration true/false
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

open-bashd-config() { # => Config: Open bash.d directory and config.yaml in IDE [Usage: open-bashd-config [-ide vscode|intellij]]
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

set-theme() { # => Config: Set terminal color theme [Usage: set-theme "theme_name"]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local theme="${1:-default}"

  [ ! -f "$THEMES_DIR/$theme.sh" ] && {
    echo "🚨 Invalid theme. Ensure $theme.sh exists in $THEMES_DIR"
    return 1
  }

  python3 "$CONFIG_MANAGER" update "system" "theme" "$theme"
  export BASH_THEME="$theme"
  source "$HOME/.bash.d/00-core/01-colors.sh"
  echo -e "${CB_GREEN}✅ Terminal theme set to $theme.${C_RESET}"
}

_set_theme_completions() {
  if [ -d "${THEMES_DIR}" ]; then
    local themes=$(find "${THEMES_DIR}" -name "*.sh" -exec basename {} .sh \;)
    COMPREPLY=($(compgen -W "$themes" -- "${COMP_WORDS[COMP_CWORD]}"))
  fi
}
complete -F _set_theme_completions set-theme

mt-theme() { # => Config: Interactive menu to select and apply a theme [Usage: mt-theme]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  [ ! -d "${THEMES_DIR}" ] && {
    echo "🚨 Error: THEMES_DIR not found at ${THEMES_DIR}"
    return 1
  }

  local selected_theme=$(find "${THEMES_DIR}" -maxdepth 1 -name "*.sh" -exec basename {} .sh \; | sort | fzf --prompt="🎨 Select Theme > " --height=~10 --layout=reverse --border)

  [ -n "$selected_theme" ] && set-theme "$selected_theme" || echo "Theme selection cancelled."
}

toggle-auto-cleanup() { # => Config: Toggle export file background cleanup script [Usage: toggle-auto-cleanup]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local new_val="true"
  [ "$AUTO_CLEANUP_EXPORTS" = "true" ] && new_val="false"

  python3 "$CONFIG_MANAGER" update "exports" "auto_cleanup" "$new_val"
  export AUTO_CLEANUP_EXPORTS="$new_val"
  echo "✅ Auto-cleanup set to $new_val."
}

set-auto-cleanup-days() { # => Config: Modifies the threshold in days before exports are automatically deleted [Usage: set-auto-cleanup-days 7]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  [[ ! "$1" =~ ^[0-9]+$ ]] && {
    echo "Usage: set-auto-cleanup-days <number>"
    return 1
  }

  python3 "$CONFIG_MANAGER" update "exports" "auto_cleanup_days" "$1"
  export AUTO_CLEANUP_DAYS="$1"
  echo "✅ Auto-cleanup threshold set to $1 days."
}

google-fmt() { # => Config: Format Python and Shell scripts according to Google Style Guides [Usage: google-fmt]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo "🎨 Formatting Python scripts (Google Python Style)..."
  if command -v yapf > /dev/null 2>&1; then
    yapf -r -i --style="{based_on_style: google, column_limit: 88, spaces_before_comment: 2}" .
    echo "✅ Python formatting complete."
  else
    echo "⚠️ 'yapf' not found. Run 'bootstrap' to install it."
  fi

  echo "🎨 Formatting Shell scripts (Google Shell Style Guide)..."
  if command -v shfmt > /dev/null 2>&1; then
    shfmt -i 2 -ci -sr -w .
    echo "✅ Shell script formatting complete."
  else
    echo "⚠️ 'shfmt' not found."
  fi
}
