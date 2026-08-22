# shellcheck shell=bash
# ------------------------------------------
# System & Environment Dependencies
# ------------------------------------------
# Format: "command_to_check:package_name_to_install"
#
# Note: `gh` is intentionally absent from APT_DEPENDENCIES and
# COMPLEX_DEPENDENCIES. On apt-based systems it needs GitHub's own repo/
# keyring added first, which bootstrap() already does directly at the end
# of its run -- listing it here too would just produce a failed plain
# `apt-get install gh` followed by a misleading "needs manual config"
# warning for something that gets installed correctly a few lines later
# regardless. It stays in BREW_DEPENDENCIES since Homebrew's own `gh`
# formula needs no special repo setup.

export APT_DEPENDENCIES=(
  "jq:jq"
  "fzf:fzf"
  "rg:ripgrep"
  "${BAT_BIN:-batcat}:bat"
  "rsync:rsync"
  "shfmt:shfmt"
  "file:file"
  "zoxide:zoxide"
  "pip3:python3-pip"
  "pipx:pipx"
  "python_yaml:python3-yaml"
  "zip:zip"
  "unzip:unzip"
)

export BREW_DEPENDENCIES=(
  "jq:jq"
  "fzf:fzf"
  "rg:ripgrep"
  "${BAT_BIN:-bat}:bat"
  "rsync:rsync"
  "shfmt:shfmt"
  "yq:yq"
  "eza:eza"
  "zoxide:zoxide"
  "pipx:pipx"
  "gh:gh"
  "python_yaml:pyyaml"
  "zip:zip"
  "unzip:unzip"
)

export PYTHON_DEPENDENCIES=(
  "ruff:ruff"
  "checkov:checkov"
  "yapf:yapf"
)

export COMPLEX_DEPENDENCIES=(
  "terraform:terraform"
  "gcloud:google-cloud-cli"
  "kubectl:kubectl"
  "eza:eza"
)

export EXTERNAL_DEPENDENCIES=(
  "speedtest:speedtest"
)
