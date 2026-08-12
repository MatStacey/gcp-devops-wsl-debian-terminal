# ------------------------------------------
# Configuration Management
# ------------------------------------------
# ~/.bash.d/00-core/01-config.sh

CONFIG_FILE="$HOME/.bash.d/config/config.yaml"
CONFIG_MANAGER="$HOME/.bash.d/lib/config_manager.py"
YAML_TEMPLATE="$HOME/.bash.d/lib/templates/config.yaml.tpl"

# Ensure config exists and scaffold securely from the template
if [ ! -s "$CONFIG_FILE" ]; then
	mkdir -p "$(dirname "$CONFIG_FILE")"
	if [ -f "$YAML_TEMPLATE" ]; then
		cp "$YAML_TEMPLATE" "$CONFIG_FILE"
	else
		touch "$CONFIG_FILE"
	fi
fi

# Load configuration and export environment variables via dedicated Python script
if [ -f "$CONFIG_MANAGER" ]; then
	eval "$(python3 "$CONFIG_MANAGER" load-env)"
fi

# Validate Keys
if [[ -z "$GEMINI_API_KEY" || "$GEMINI_API_KEY" == "YOUR_GEMINI_API_KEY" || "$GEMINI_API_KEY" == "null" ]]; then
	unset GEMINI_API_KEY
	echo -e "${C_YELLOW}No Gemini API Key provided in config.yaml. Add one via:\n    ${C_RESET}add-gemini-key \"your-api-key\"\e[0m"
fi

if [[ -z "$CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "YOUR_CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "null" ]]; then
	unset CLAUDE_API_KEY
	echo -e "${C_YELLOW}No Claude API Key provided in config.yaml. Add one via:\n    ${C_RESET}add-claude-key \"your-api-key\"\e[0m"
fi

add-gemini-key() { # => Config: Add Gemini API key to config.yaml [Usage: add-gemini-key "key"]
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
	if [ -z "$1" ]; then echo "Usage: add-gemini-key <key>"; return 1; fi
	python3 "$CONFIG_MANAGER" update "gemini" "api_key" "$1"
	export GEMINI_API_KEY="$1"
	echo "✅ Gemini API Key added to $CONFIG_FILE."
}

set-gemini-version() { # => Config: Set Gemini model version [Usage: set-gemini-version "gemini-1.5-pro"]
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
	if [ -z "$1" ]; then echo "Usage: set-gemini-version <version>"; return 1; fi
	python3 "$CONFIG_MANAGER" update "gemini" "version" "$1"
	export GEMINI_VERSION="$1"
	echo "✅ Gemini version set to $1."
}

toggle-gemini-extended() { # => Config: Toggle Gemini extended mode true/false
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
	local new_val="true"
	if [ "$GEMINI_EXTENDED" = "true" ]; then new_val="false"; fi
	python3 "$CONFIG_MANAGER" update "gemini" "extended" "$new_val"
	export GEMINI_EXTENDED="$new_val"
	echo "✅ Gemini extended mode set to $new_val."
}

add-claude-key() { # => Config: Add Claude API key to config.yaml [Usage: add-claude-key "key"]
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
	if [ -z "$1" ]; then echo "Usage: add-claude-key <key>"; return 1; fi
	python3 "$CONFIG_MANAGER" update "claude" "api_key" "$1"
	export CLAUDE_API_KEY="$1"
	echo "✅ Claude API Key added to $CONFIG_FILE."
}

set-claude-version() { # => Config: Set Claude model version [Usage: set-claude-version "claude-3-7-sonnet-latest"]
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
	if [ -z "$1" ]; then echo "Usage: set-claude-version <version>"; return 1; fi
	python3 "$CONFIG_MANAGER" update "claude" "version" "$1"
	export CLAUDE_VERSION="$1"
	echo "✅ Claude version set to $1."
}

add-sync-url() { # => Config: Add remote repository URL for bash sync [Usage: add-sync-url "url"]
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
	if [ -z "$1" ]; then echo "Usage: add-sync-url <url>"; return 1; fi
	python3 "$CONFIG_MANAGER" update "git" "sync_repo_url" "$1"
	export SYNC_REPO_URL="$1"
	echo "✅ Sync URL added to $CONFIG_FILE."
}

set-default-ide() { # => Config: Set default IDE [Usage: set-default-ide "vscode|intellij"]
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
	if [[ "$1" != "vscode" && "$1" != "intellij" ]]; then
		echo "Usage: set-default-ide <vscode|intellij>"
		return 1
	fi
	python3 "$CONFIG_MANAGER" update "system" "default_ide" "$1"
	export DEFAULT_IDE="$1"
	echo "✅ Default IDE set to $1."
}

set-default-ai() { # => Config: Set default AI model [Usage: set-default-ai "gemini|claude"]
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
	if [[ "$1" != "gemini" && "$1" != "claude" ]]; then
		echo "Usage: set-default-ai <gemini|claude>"
		return 1
	fi
	python3 "$CONFIG_MANAGER" update "system" "default_ai" "$1"
	export DEFAULT_AI="$1"
	echo "✅ Default AI set to $1."
}

open-bashd-config() { # => Config: Open bash.d directory and config.yaml in IDE [Usage: open-bashd-config [-ide vscode|intellij]]
	local selected_ide="${DEFAULT_IDE:-vscode}"
	local args=()
	
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-h|--help) mt-help "${FUNCNAME[0]}"; return 0 ;;
			-ide) selected_ide="$2"; shift 2 ;;
			*) args+=("$1"); shift ;;
		esac
	done

	local config_dir="$HOME/.bash.d"
	local config_file="$config_dir/config/config.yaml"
	local yaml_tpl="$config_dir/lib/templates/config.yaml.tpl"
	
	if [ ! -s "$config_file" ]; then
		mkdir -p "$(dirname "$config_file")"
		if [ -f "$yaml_tpl" ]; then cp "$yaml_tpl" "$config_file"; fi
	fi
	
	echo "🚀 Opening bash config in $selected_ide..."
	if [ "$selected_ide" = "intellij" ]; then
		idea "$config_dir" "$config_file" &>/dev/null || idea.exe "$config_dir" "$config_file" &>/dev/null || echo "⚠️ Could not launch IntelliJ. Ensure 'idea' or 'idea.exe' is in your PATH."
	else
		code "$config_dir" "$config_file"
	fi
}

set-theme() { # => Config: Set terminal color theme [Usage: set-theme "theme_name"]
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
	local theme="${1:-default}"
	
	if [ ! -f "$THEMES_DIR/$theme.sh" ]; then
		echo "🚨 Invalid theme. Ensure $theme.sh exists in $THEMES_DIR"
		return 1
	fi
	
	python3 "$CONFIG_MANAGER" update "system" "theme" "$theme"
	export BASH_THEME="$theme"
	source "$HOME/.bash.d/00-core/00-colors.sh"
	echo -e "${CB_GREEN}✅ Terminal theme set to $theme.${C_RESET}"
}

_set_theme_completions() {
	if [ -d "${THEMES_DIR}" ]; then
		local themes
		themes=$(find "${THEMES_DIR}" -name "*.sh" -exec basename {} .sh \;)
		COMPREPLY=($(compgen -W "$themes" -- "${COMP_WORDS[COMP_CWORD]}"))
	fi
}
complete -F _set_theme_completions set-theme

mt-theme() { # => Config: Interactive menu to select and apply a terminal theme [Usage: mt-theme]
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
	if [ ! -d "${THEMES_DIR}" ]; then
		echo "🚨 Error: THEMES_DIR not found at ${THEMES_DIR}"
		return 1
	fi
	
	local selected_theme
	selected_theme=$(find "${THEMES_DIR}" -maxdepth 1 -name "*.sh" -exec basename {} .sh \; | sort | fzf --prompt="🎨 Select Theme > " --height=~10 --layout=reverse --border)
	
	if [ -n "$selected_theme" ]; then
		set-theme "$selected_theme"
	else
		echo "Theme selection cancelled."
	fi
}

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

#######################################
# Toggles the global AI integration flag and prompt display.
# Globals:
#   CONFIG_MANAGER
#   AI_ENABLED
# Outputs:
#   Writes status messages to STDOUT.
#######################################
toggle-ai() { # => Config: Toggle global AI prompt and integration true/false
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
  local new_val="true"
  [ "${AI_ENABLED:-true}" = "true" ] && new_val="false"

  python3 "$CONFIG_MANAGER" update "system" "ai_enabled" "$new_val"
  export AI_ENABLED="$new_val"
  echo "✅ AI integration set to $new_val."
}
