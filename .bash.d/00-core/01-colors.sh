# ------------------------------------------
# Centralized Theme & Colors
# ------------------------------------------
# ~/.bash.d/00-core/01-colors.sh

export C_RESET=$'\e[0m'

# Source the theme file based on the configured BASH_THEME
THEME_FILE="$HOME/.bash.d/config/themes/${BASH_THEME:-default}.sh"

if [ -f "$THEME_FILE" ]; then
  source "$THEME_FILE"
else
  source "$HOME/.bash.d/config/themes/default.sh"
fi
