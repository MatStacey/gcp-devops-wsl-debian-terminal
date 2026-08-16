# shellcheck shell=bash
# ------------------------------------------
# System & Environment Bootstrap
# ------------------------------------------

# Source dependencies config safely
if [ -f "$HOME/.bash.d/config/dependencies.sh" ]; then
  source "$HOME/.bash.d/config/dependencies.sh"
fi

__get_missing_deps() {
  local missing=()
  for dep in "$@"; do
    local cmd="${dep%%:*}"
    local pkg="${dep##*:}"

    if [ "$cmd" = "python_yaml" ]; then
      python3 -c "import yaml" > /dev/null 2>&1 || missing+=("$pkg")
    else
      command -v "$cmd" > /dev/null 2>&1 || missing+=("$pkg")
    fi
  done
  echo "${missing[@]}"
}

__bootstrap_apt() {
  local apt_deps=($(__get_missing_deps "${APT_DEPENDENCIES[@]}"))

  if [ ${#apt_deps[@]} -gt 0 ]; then
    echo -e "\n📦 Installing standard APT dependencies: ${apt_deps[*]}..."
    sudo apt-get update && sudo apt-get install -y "${apt_deps[@]}"
  else
    echo "✅ All standard APT dependencies are satisfied."
  fi
}

__bootstrap_brew() {
  if ! command -v brew > /dev/null 2>&1; then
    echo -e "\n🍺 Homebrew not found. Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Homebrew isn't on PATH yet in this shell after a fresh install.
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  if ! command -v brew > /dev/null 2>&1; then
    echo "🚨 Homebrew installation failed or 'brew' is still not on PATH. Skipping Homebrew bootstrap."
    return 1
  fi

  local brew_deps=($(__get_missing_deps "${BREW_DEPENDENCIES[@]}"))

  if [ ${#brew_deps[@]} -gt 0 ]; then
    echo -e "\n📦 Installing standard Homebrew dependencies: ${brew_deps[*]}..."
    brew install "${brew_deps[@]}"
  else
    echo "✅ All standard Homebrew dependencies are satisfied."
  fi

  # bat installed fresh via Homebrew resolves as 'bat', not 'batcat'.
  command -v bat > /dev/null 2>&1 && export BAT_BIN="bat"
}

__bootstrap_python() {
  local pip_deps=($(__get_missing_deps "${PYTHON_DEPENDENCIES[@]}"))

  if [ ${#pip_deps[@]} -gt 0 ]; then
    echo -e "\n🐍 Installing Python tooling (${pip_deps[*]})..."
    if command -v pipx > /dev/null 2>&1; then
      for pkg in "${pip_deps[@]}"; do pipx install "$pkg" 2> /dev/null || pip3 install --user "$pkg"; done
    else
      pip3 install --user "${pip_deps[@]}"
    fi
  else
    echo "✅ All Python CLI dependencies are satisfied."
  fi
}

__bootstrap_yq() {
  # macOS installs yq via Homebrew; this binary download is Linux-specific
  [ "$OS_FAMILY" = "macos" ] && return 0

  if ! command -v yq > /dev/null 2>&1; then
    echo -e "\n⚙️ Installing 'yq'..."
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod a+x /usr/local/bin/yq
    echo "✅ yq installed."
  fi
}

__bootstrap_check_complex() {
  local missing_complex=($(__get_missing_deps "${COMPLEX_DEPENDENCIES[@]}"))

  if [ ${#missing_complex[@]} -gt 0 ]; then
    echo -e "\n⚠️  The following tools are missing and require manual repo config:"
    for dep in "${missing_complex[@]}"; do echo "  - $dep"; done
  fi
}

#######################################
# System: Bootstrap missing dependencies for bash aliases (Debian/WSL via APT, macOS via Homebrew)
#######################################
bootstrap() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo "🔍 Scanning system for missing dependencies..."

  if [ "$OS_FAMILY" = "macos" ]; then
    __bootstrap_brew
  else
    __bootstrap_apt
  fi
  __bootstrap_python
  __bootstrap_yq
  __bootstrap_check_complex

  echo -e "\n🎉 Environment bootstrap complete!"
}

__check_missing_deps() {
  if [[ $- != *i* ]]; then return; fi

  local to_check=()
  if [ "$OS_FAMILY" = "macos" ]; then
    to_check=("${BREW_DEPENDENCIES[@]}")
  else
    to_check=("${APT_DEPENDENCIES[@]}")
    to_check+=("yq:yq") # Linux manually checks yq since it bypasses APT
  fi
  to_check+=("${PYTHON_DEPENDENCIES[@]}" "${COMPLEX_DEPENDENCIES[@]}")

  local missing_list=($(__get_missing_deps "${to_check[@]}"))

  if [ ${#missing_list[@]} -gt 0 ]; then
    echo -e "\n\e[33m⚠️  Missing required dependencies detected in your environment.\e[0m"
    read -p "Would you like to run 'bootstrap' to install them now? [Y/n] " -n 1 -r choice
    echo

    if [[ $choice =~ ^[Yy]$ ]] || [[ -z $choice ]]; then
      bootstrap
    fi
  fi
}

#######################################
# System: Updates system packages (APT on Debian/WSL, Homebrew on macOS)
#######################################
sys-update() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ "$OS_FAMILY" = "macos" ]; then
    if ! command -v brew > /dev/null 2>&1; then
      echo "🚨 Homebrew not found. Run 'bootstrap' first."
      return 1
    fi
    brew update && brew upgrade
  else
    sudo apt update && sudo apt upgrade
  fi
}

#######################################
# System: Updates system packages and clears the pending-update marker
#######################################
sys-install() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  sys-update
  rm -f "$HOME/.bash.d/.update_pending"
}

__check_missing_deps
