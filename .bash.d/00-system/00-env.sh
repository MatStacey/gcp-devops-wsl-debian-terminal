# shellcheck shell=bash
# ~/.bash.d/00-system/00-env.sh

# Only prepend ANT_ROOT if it's actually set — an empty/unset var here
# left a leading empty entry in PATH, which bash treats as "current
# directory", i.e. `cd` into any repo with a file named `ls`/`git`/`make`
# would silently execute it.
[ -n "$ANT_ROOT" ] && export PATH="$ANT_ROOT:$PATH"
export PATH="$PATH:$HOME/.local/bin"

# NVM initialisation, lazy-loaded: sourcing nvm.sh outright costs ~70ms on
# every shell start (it defines ~50 functions), so defer that cost until
# nvm/node/npm/npx is actually invoked in this session.
export NVM_DIR="$HOME/.nvm"

if [ -s "$NVM_DIR/nvm.sh" ]; then
  __lazy_load_nvm() {
    unset -f nvm node npm npx
    # shellcheck disable=SC1091
    \. "$NVM_DIR/nvm.sh"
  }

  nvm() { __lazy_load_nvm && nvm "$@"; }
  node() { __lazy_load_nvm && node "$@"; }
  npm() { __lazy_load_nvm && npm "$@"; }
  npx() { __lazy_load_nvm && npx "$@"; }
fi

# zoxide is initialised (cached) later in 02-utilities/20-aliases.sh; no need
# to also eval its init output here.
