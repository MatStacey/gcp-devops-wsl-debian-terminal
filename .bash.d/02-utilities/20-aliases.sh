# shellcheck shell=bash
# ------------------------------------------
# System & Navigation Aliases
# ------------------------------------------
# ~/.bash.d/02-utilities/20-aliases.sh

#######################################
# System: Change directory to ~/.bash.d
#######################################
alias cd-bashd='cd ~/.bash.d'

#######################################
# System: Change directory to ~/.bash.d
#######################################
alias mt-home='cd-bashd'

#######################################
# System: Change directory to ~/vcs
#######################################
alias cd-git-home='cd "$VCS_ROOT"'

#######################################
# System: Change directory to ~/vcs/personal
#######################################
alias cd-git-personal='cd "$VCS_PERSONAL"'

#######################################
# System: Pipe output to the system clipboard (e.g. cat file | clip)
#######################################
clip() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __clip_copy
}

#######################################
# System: Print all aliases and functions (MyTools Engine)
#######################################
alias mt='mytools'

#######################################
# System: Reload Bash profile and caches
#######################################
alias reload='mt-refresh-caches'

#######################################
# System: Reload Bash profile and caches
#######################################
alias refresh='mt-refresh-caches'

#######################################
# System: Update, Upgrade, Boostrap, and Reload
#######################################
alias sys-update-install='sys-update;bootstrap;reload'

#######################################
# System: Open ~/vcs/personal/exports in the platform's native file manager
#######################################
win-export() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "$VCS_EXPORTS"
}

#######################################
# System: Open ~/vcs in the platform's native file manager
#######################################
win-vcs() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "$VCS_ROOT"
}

#######################################
# System: Open current directory in the platform's native file manager
#######################################
win() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "$PWD"
}

# ------------------------------------------
# Development & Build Tools
# ------------------------------------------

#######################################
# Dev: Spring Boot - Run application
#######################################
alias boot-run='./mvnw spring-boot:run'

#######################################
# Dev: Maven - Clean and Install
#######################################
alias mci='./mvnw clean install'

#######################################
# Dev: Python - Install pip requirements
#######################################
alias pip-load='pip install -r requirements.txt'

#######################################
# Dev: Python - Save pip requirements
#######################################
alias pip-save='pip freeze > requirements.txt'

#######################################
# Dev: Python - Format Python files and imports using Ruff (recursive)
#######################################
alias ruff-fmt='ruff check --select I --fix . && ruff format .'

#######################################
# Dev: Shell - Format all shell scripts in current directory (recursive)
#######################################
alias shfmtlw='shfmt -l -w .'

#######################################
# Dev: Python - Create & active Python venv
#######################################
alias venv-make='python3 -m venv venv && source venv/bin/activate'

#######################################
# Dev: Python - Activate existing Python venv
#######################################
alias venv-up='source venv/bin/activate'

# ------------------------------------------
# Modern CLI Replacements
# ------------------------------------------

#######################################
# CLI: bat - Print file contents with syntax highlighting
#######################################
# shellcheck disable=SC2139
alias cat="$BAT_BIN --style=plain"

#######################################
# CLI: bat - Print file contents with line numbers & Git gutters
#######################################
# shellcheck disable=SC2139
alias ccat="$BAT_BIN"

#######################################
# CLI: jq - Pretty-print JSON stream
#######################################
alias json-fmt='jq .'

#######################################
# CLI: eza - Detailed list with Git status
#######################################
alias ll='eza -la --color=auto --group-directories-first --git'

#######################################
# CLI: eza - List files with directories first
#######################################
alias ls='eza --color=auto --group-directories-first'

#######################################
# CLI: rg - Search with smart case, include hidden, ignore .git
#######################################
alias rg='rg --smart-case --hidden --glob "!.git/*"'

#######################################
# CLI: eza - Display directory structure as a tree
#######################################
alias tree='eza --tree'

#######################################
# CLI: yq - Pretty-print YAML stream
#######################################
alias yaml-fmt='yq -P'

# ------------------------------------------
# Zoxide (Smart cd replacement)
# ------------------------------------------
if command -v zoxide > /dev/null 2>&1; then
  mkdir -p "$HOME/.bash.d/data/cache" 2> /dev/null
  ZOXIDE_CACHE="$HOME/.bash.d/data/cache/.zoxide_cache.sh"
  if [ ! -f "$ZOXIDE_CACHE" ]; then
    zoxide init bash > "$ZOXIDE_CACHE"
  fi
  source "$ZOXIDE_CACHE"

  #######################################
  # CLI: zoxide - Smart directory navigation
  #######################################
  alias cd='z'
fi

#######################################
# System: Forcefully clear and rebuild all background caches and reload profile
#######################################
alias mt-hard-reload='mt-load-config && mt-refresh-caches'
