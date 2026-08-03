# ------------------------------------------
# Windows
# ------------------------------------------
alias win='explorer.exe .'                         # => Open current WSL dir in Windows Explorer
alias clip='clip.exe'                              # => Pipe output to Windows clipboard (e.g. cat file | clip)

# ------------------------------------------
# Python
# ------------------------------------------
alias venv-make='python3 -m venv venv && source venv/bin/activate' # => Create & active Python venv
alias venv-up='source venv/bin/activate'           # => Activate existing Python venv
alias pip-save='pip freeze > requirements.txt'     # => Save pip requirements
alias pip-load='pip install -r requirements.txt'   # => Install pip requirements

# ------------------------------------------
# Data Serializaton 
# ------------------------------------------
alias json-format='jq .'                           # => Pretty-print JSON stream
alias yaml-format='yq -P'                          # => Pretty-print YAML stream (requires yq)

# ------------------------------------------
# Java
# ------------------------------------------
alias mci='./mvnw clean install'                   # => Maven: Clean and Install
alias boot-run='./mvnw spring-boot:run'            # => Spring Boot: Run application                              # => MyTools: List Aliases and Functions available in Terminal

# ------------------------------------------
# Update & Upgrade
# ------------------------------------------
alias sys-update='sudo apt update && sudo apt upgrade' # => Updates Debian/Ubuntu packages

# ------------------------------------------
# Modern CLI Replacements
# ------------------------------------------
# eza: Modern ls replacement
alias ls='eza --color=auto --group-directories-first' # => eza: List files with directories first
alias ll='eza -la --color=auto --group-directories-first --git' # => eza: Detailed list with Git status
alias tree='eza --tree'                            # => eza: Display directory structure as a tree

# bat: Modern cat replacement
# (Debian maps 'bat' to 'batcat' to avoid package conflicts)
alias cat='batcat --style=plain'                   # => bat: Print file contents with syntax highlighting
alias ccat='batcat'                                # => bat: Print file contents with line numbers & Git gutters

# ripgrep: Modern grep replacement
# The binary is already 'rg', but we add smart defaults
alias rg='rg --smart-case --hidden --glob "!.git/*"' # => rg: Search with smart case, include hidden, ignore .git

# ------------------------------------------
# Custom Tools
# ------------------------------------------
alias mt='mytools'   