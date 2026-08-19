# shellcheck shell=bash
# ~/.bash.d/00-system/00-env.sh

# Only prepend ANT_ROOT if it's actually set — an empty/unset var here
# left a leading empty entry in PATH, which bash treats as "current
# directory", i.e. `cd` into any repo with a file named `ls`/`git`/`make`
# would silently execute it.
[ -n "$ANT_ROOT" ] && export PATH="$ANT_ROOT:$PATH"
export PATH="$PATH:$HOME/.local/bin"

# NVM initialisation
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

command -v zoxide > /dev/null 2>&1 && eval "$(zoxide init bash)"
