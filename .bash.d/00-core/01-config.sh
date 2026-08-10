# ------------------------------------------
# Configuration Management
# ------------------------------------------
# ~/.bash.d/00-core/01-config.sh

CONFIG_FILE="$HOME/.bash.d/config/config.yaml"
CONFIG_MANAGER="$HOME/.bash.d/lib/config_manager.py"
ENV_CACHE="$HOME/.bash.d/config/.env.cache"
YAML_TEMPLATE="$HOME/.bash.d/lib/templates/config.yaml.tpl"

if [ ! -s "$CONFIG_FILE" ]; then
	mkdir -p "$(dirname "$CONFIG_FILE")"
	[ -f "$YAML_TEMPLATE" ] && cp "$YAML_TEMPLATE" "$CONFIG_FILE" || touch "$CONFIG_FILE"
fi

if [ -f "$CONFIG_MANAGER" ]; then
	if [ ! -f "$ENV_CACHE" ] || [ "$CONFIG_FILE" -nt "$ENV_CACHE" ]; then
		python3 "$CONFIG_MANAGER" load-env >"$ENV_CACHE"
	fi
	source "$ENV_CACHE"
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
# Adds a Gemini API key to the local YAML configuration.
# Globals:
#   CONFIG_MANAGER
#   CONFIG_FILE
# Arguments:
#   $1 - The raw API key string.
# Outputs:
#   Writes status messages to STDOUT.
# Returns:
#   0 on success, 1 if no key is provided.
#######################################
add-gemini-key() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	[ -z "$1" ] && { echo "Usage: add-gemini-key <key>"; return 1; }

	python3 "$CONFIG_MANAGER" update "gemini" "api_key" "$1"
	export GEMINI_API_KEY="$1"
	echo "✅ Gemini API Key added to $CONFIG_FILE."
}

#######################################
# Sets the default Gemini model version in configuration.
# Globals:
#   CONFIG_MANAGER
# Arguments:
#   $1 - The target model version (e.g., gemini-1.5-pro).
# Outputs:
#   Writes status messages to STDOUT.
# Returns:
#   0 on success, 1 if no version is provided.
#######################################
set-gemini-version() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	[ -z "$1" ] && { echo "Usage: set-gemini-version <version>"; return 1; }

	python3 "$CONFIG_MANAGER" update "gemini" "version" "$1"
	export GEMINI_VERSION="$1"
	echo "✅ Gemini version set to $1."
}

#######################################
# Toggles the Gemini extended reasoning mode flag.
# Globals:
#   CONFIG_MANAGER
#   GEMINI_EXTENDED
# Outputs:
#   Writes status messages to STDOUT.
#######################################
toggle-gemini-extended() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	local new_val="true"
	[ "$GEMINI_EXTENDED" = "true" ] && new_val="false"

	python3 "$CONFIG_MANAGER" update "gemini" "extended" "$new_val"
	export GEMINI_EXTENDED="$new_val"
	echo "✅ Gemini extended mode set to $new_val."
}

#######################################
# Adds a Claude API key to the local YAML configuration.
# Globals:
#   CONFIG_MANAGER
#   CONFIG_FILE
# Arguments:
#   $1 - The raw API key string.
# Outputs:
#   Writes status messages to STDOUT.
# Returns:
#   0 on success, 1 if no key is provided.
#######################################
add-claude-key() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	[ -z "$1" ] && { echo "Usage: add-claude-key <key>"; return 1; }

	python3 "$CONFIG_MANAGER" update "claude" "api_key" "$1"
	export CLAUDE_API_KEY="$1"
	echo "✅ Claude API Key added to $CONFIG_FILE."
}

#######################################
# Sets the default Claude model version in configuration.
# Globals:
#   CONFIG_MANAGER
# Arguments:
#   $1 - The target model version.
# Outputs:
#   Writes status messages to STDOUT.
# Returns:
#   0 on success, 1 if no version is provided.
#######################################
set-claude-version() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	[ -z "$1" ] && { echo "Usage: set-claude-version <version>"; return 1; }

	python3 "$CONFIG_MANAGER" update "claude" "version" "$1"
	export CLAUDE_VERSION="$1"
	echo "✅ Claude version set to $1."
}

#######################################
# Configures the remote git URL for the bash profile synchronization tool.
# Globals:
#   CONFIG_MANAGER
#   CONFIG_FILE
# Arguments:
#   $1 - The remote repository URL.
# Outputs:
#   Writes status messages to STDOUT.
# Returns:
#   0 on success, 1 if no URL is provided.
#######################################
add-sync-url() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	[ -z "$1" ] && { echo "Usage: add-sync-url <url>"; return 1; }

	python3 "$CONFIG_MANAGER" update "git" "sync_repo_url" "$1"
	export SYNC_REPO_URL="$1"
	echo "✅ Sync URL added to $CONFIG_FILE."
}

#######################################
# Sets the default local IDE for launch commands.
# Globals:
#   CONFIG_MANAGER
# Arguments:
#   $1 - "vscode" or "intellij".
# Outputs:
#   Writes status messages to STDOUT.
# Returns:
#   0 on success, 1 if an invalid IDE string is provided.
#######################################
set-default-ide() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	[[ "$1" != "vscode" && "$1" != "intellij" ]] && { echo "Usage: set-default-ide <vscode|intellij>"; return 1; }

	python3 "$CONFIG_MANAGER" update "system" "default_ide" "$1"
	export DEFAULT_IDE="$1"
	echo "✅ Default IDE set to $1."
}

#######################################
# Sets the default LLM provider for the 'ai' command suite.
# Globals:
#   CONFIG_MANAGER
# Arguments:
#   $1 - "gemini" or "claude".
# Outputs:
#   Writes status messages to STDOUT.
# Returns:
#   0 on success, 1 if an invalid AI string is provided.
#######################################
set-default-ai() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	[[ "$1" != "gemini" && "$1" != "claude" ]] && { echo "Usage: set-default-ai <gemini|claude>"; return 1; }

	python3 "$CONFIG_MANAGER" update "system" "default_ai" "$1"
	export DEFAULT_AI="$1"
	echo "✅ Default AI set to $1."
}

#######################################
# Opens the bash.d configuration directory directly in the configured IDE.
# Globals:
#   DEFAULT_IDE
# Arguments:
#   -ide <name> Override the default IDE selection.
# Outputs:
#   Launches the requested IDE application.
#######################################
open-bashd-config() {
	local selected_ide="${DEFAULT_IDE:-vscode}"
	local args=()

	while [[ $# -gt 0 ]]; do
		case "$1" in
		-h | --help) mt-help "${FUNCNAME[0]}"; return 0 ;;
		-ide) selected_ide="$2"; shift 2 ;;
		*) args+=("$1"); shift ;;
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
		{ idea "$config_dir" "$config_file" &>/dev/null || idea.exe "$config_dir" "$config_file" &>/dev/null || echo "⚠️ Could not launch IntelliJ. Ensure 'idea' or 'idea.exe' is in your PATH."; } ||
		code "$config_dir" "$config_file"
}

#######################################
# Sets the active terminal color theme and reloads the color profile.
# Globals:
#   CONFIG_MANAGER
#   THEMES_DIR
# Arguments:
#   $1 - The theme name (matches the filename in themes/).
# Outputs:
#   Writes status messages to STDOUT.
# Returns:
#   0 on success, 1 if the theme file does not exist.
#######################################
set-theme() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	local theme="${1:-default}"

	[ ! -f "$THEMES_DIR/$theme.sh" ] && { echo "🚨 Invalid theme. Ensure $theme.sh exists in $THEMES_DIR"; return 1; }

	python3 "$CONFIG_MANAGER" update "system" "theme" "$theme"
	export BASH_THEME="$theme"
	source "$HOME/.bash.d/00-core/00-colors.sh"
	echo -e "${CB_GREEN}✅ Terminal theme set to $theme.${C_RESET}"
}

_set_theme_completions() {
	if [ -d "${THEMES_DIR}" ]; then
		local themes=$(find "${THEMES_DIR}" -name "*.sh" -exec basename {} .sh \;)
		COMPREPLY=($(compgen -W "$themes" -- "${COMP_WORDS[COMP_CWORD]}"))
	fi
}
complete -F _set_theme_completions set-theme

#######################################
# Opens an interactive fuzzy-finder menu to select and apply a theme.
# Globals:
#   THEMES_DIR
# Outputs:
#   Launches the fzf menu.
# Returns:
#   0 on success, 1 if the themes directory is missing.
#######################################
mt-theme() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	[ ! -d "${THEMES_DIR}" ] && { echo "🚨 Error: THEMES_DIR not found at ${THEMES_DIR}"; return 1; }

	local selected_theme=$(find "${THEMES_DIR}" -maxdepth 1 -name "*.sh" -exec basename {} .sh \; | sort | fzf --prompt="🎨 Select Theme > " --height=~10 --layout=reverse --border)

	[ -n "$selected_theme" ] && set-theme "$selected_theme" || echo "Theme selection cancelled."
}

#######################################
# Toggles the background execution of the export cleanup script.
# Globals:
#   CONFIG_MANAGER
#   AUTO_CLEANUP_EXPORTS
# Outputs:
#   Writes status messages to STDOUT.
#######################################
toggle-auto-cleanup() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	local new_val="true"
	[ "$AUTO_CLEANUP_EXPORTS" = "true" ] && new_val="false"

	python3 "$CONFIG_MANAGER" update "system" "auto_cleanup_exports" "$new_val"
	export AUTO_CLEANUP_EXPORTS="$new_val"
	echo "✅ Auto-cleanup set to $new_val."
}

#######################################
# Modifies the threshold in days before exports are automatically deleted.
# Globals:
#   CONFIG_MANAGER
# Arguments:
#   $1 - Numeric threshold in days.
# Outputs:
#   Writes status messages to STDOUT.
# Returns:
#   0 on success, 1 if a non-numeric argument is supplied.
#######################################
set-auto-cleanup-days() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && { mt-help "${FUNCNAME[0]}"; return 0; }
	[[ ! "$1" =~ ^[0-9]+$ ]] && { echo "Usage: set-auto-cleanup-days <number>"; return 1; }

	python3 "$CONFIG_MANAGER" update "system" "auto_cleanup_days" "$1"
	export AUTO_CLEANUP_DAYS="$1"
	echo "✅ Auto-cleanup threshold set to $1 days."
}
