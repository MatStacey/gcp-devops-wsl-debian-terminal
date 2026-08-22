# shellcheck shell=bash
# ------------------------------------------
# Centralized Theme & Colors
# ------------------------------------------
# ~/.bash.d/01-ui/01-colors.sh

export C_RESET=$'\e[0m'
export C_BOLD=$'\e[1m'
export C_UNBOLD=$'\e[22m'

# Source the theme file based on the configured BASH_THEME
THEME_FILE="$HOME/.bash.d/config/themes/${BASH_THEME:-default}.sh"

if [ -f "$THEME_FILE" ]; then
  # shellcheck disable=SC1090
  source "$THEME_FILE"
else
  source "$HOME/.bash.d/config/themes/default.sh"
fi
