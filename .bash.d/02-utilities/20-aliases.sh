# shellcheck shell=bash
# ------------------------------------------
# System & Navigation
# ------------------------------------------
#######################################
# Change directory to ~/.bash.d
#######################################
alias cd-bashd='cd ~/.bash.d'
#######################################
# Change directory to ~/vcs
#######################################
alias cd-git-home='cd "$VCS_ROOT"'
#######################################
# Change directory to ~/vcs/personal
#######################################
alias cd-git-personal='cd "$VCS_PERSONAL"'
#######################################
# Pipe output to the system clipboard (e.g. cat file | clip)
# Uses clip.exe on WSL, pbcopy on macOS, xclip/xsel on plain Linux.
#######################################
clip() {
  __clip_copy
}
#######################################
# Print all aliases and functions
#######################################
alias mt='mytools'
#######################################
# Reload Bash profile
#######################################
alias reload='mt-refresh-caches'
#######################################
# Reload Bash profile
#######################################
alias refresh='mt-refresh-caches'
#######################################
# Update, Upgrade, Boostrap, Reload
#######################################
alias sys-update-install='sys-update;bootstrap;reload'
#######################################
# Open ~/vcs/personal/exports in the platform's native file manager
#######################################
win-export() {
  __open_path_gui "$VCS_EXPORTS"
}
#######################################
# Open ~/vcs in the platform's native file manager
#######################################
win-vcs() {
  __open_path_gui "$VCS_ROOT"
}
#######################################
# Open current directory in the platform's native file manager
#######################################
win() {
  __open_path_gui "$PWD"
}

# ------------------------------------------
# Development & Build Tools
# ------------------------------------------
#######################################
# Spring Boot: Run application
#######################################
alias boot-run='./mvnw spring-boot:run'
#######################################
# Maven: Clean and Install
#######################################
alias mci='./mvnw clean install'
#######################################
# Install pip requirements
#######################################
alias pip-load='pip install -r requirements.txt'
#######################################
# Save pip requirements
#######################################
alias pip-save='pip freeze > requirements.txt'
#######################################
# Ruff: Format Python files and imports in current directory (recursive)
#######################################
alias ruff-fmt='ruff check --select I --fix . && ruff format .'
#######################################
# shfmt: Format all shell scripts in current directory (recursive)
#######################################
alias shfmtlw='shfmt -l -w .'
#######################################
# Create & active Python venv
#######################################
alias venv-make='python3 -m venv venv && source venv/bin/activate'
#######################################
# Activate existing Python venv
#######################################
alias venv-up='source venv/bin/activate'

# ------------------------------------------
# Modern CLI Replacements
# ------------------------------------------
#######################################
# bat: Print file contents with syntax highlighting
# Resolves to 'batcat' on Debian/WSL, 'bat' on macOS/Homebrew (see BAT_BIN).
#######################################
# shellcheck disable=SC2139
alias cat="$BAT_BIN --style=plain"
#######################################
# bat: Print file contents with line numbers & Git gutters
#######################################
# shellcheck disable=SC2139
alias ccat="$BAT_BIN"
#######################################
# Pretty-print JSON stream
#######################################
alias json-fmt='jq .'
#######################################
# eza: Detailed list with Git status
#######################################
alias ll='eza -la --color=auto --group-directories-first --git'
#######################################
# eza: List files with directories first
#######################################
alias ls='eza --color=auto --group-directories-first'
#######################################
# rg: Search with smart case, include hidden, ignore .git
#######################################
alias rg='rg --smart-case --hidden --glob "!.git/*"'
#######################################
# eza: Display directory structure as a tree
#######################################
alias tree='eza --tree'
#######################################
# Pretty-print YAML stream (requires yq)
#######################################
alias yaml-fmt='yq -P'

# ------------------------------------------
# Zoxide (Smart cd replacement)
# ------------------------------------------
if command -v zoxide > /dev/null 2>&1; then
  mkdir -p \"$HOME/.bash.d/data/cache\" 2> /dev/null
  ZOXIDE_CACHE=\"$HOME/.bash.d/data/cache/.zoxide_cache.sh\"
  if [ ! -f "$ZOXIDE_CACHE" ]; then
    zoxide init bash > "$ZOXIDE_CACHE"
  fi
  source "$ZOXIDE_CACHE"
  alias cd='z'
fi
