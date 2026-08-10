# ~/.bash.d/00-env.sh
export PATH="$ANT_ROOT:$PATH"
export PATH="$PATH:/home/mst/.local/bin"

# NVM initialisation
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

eval "$(zoxide init bash)"
