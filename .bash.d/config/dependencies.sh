# shellcheck shell=bash
# ------------------------------------------
# System & Environment Dependencies
# ------------------------------------------
# Format: "command_to_check:package_name_to_install"

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
  "gh:gh"
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
  "gh:gh"
)
