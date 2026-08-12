# ------------------------------------------
# System & Environment Bootstrap
# ------------------------------------------

__bootstrap_apt() {
  local apt_deps=()
  command -v jq > /dev/null 2>&1 || apt_deps+=("jq")
  command -v fzf > /dev/null 2>&1 || apt_deps+=("fzf")
  command -v rg > /dev/null 2>&1 || apt_deps+=("ripgrep")
  command -v "$BAT_BIN" > /dev/null 2>&1 || apt_deps+=("bat")
  command -v rsync > /dev/null 2>&1 || apt_deps+=("rsync")
  command -v shfmt > /dev/null 2>&1 || apt_deps+=("shfmt")
  command -v file > /dev/null 2>&1 || apt_deps+=("file")
  command -v zoxide > /dev/null 2>&1 || apt_deps+=("zoxide")
  python3 -c "import yaml" 2> /dev/null || apt_deps+=("python3-yaml")

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

  local brew_deps=()
  command -v jq > /dev/null 2>&1 || brew_deps+=("jq")
  command -v fzf > /dev/null 2>&1 || brew_deps+=("fzf")
  command -v rg > /dev/null 2>&1 || brew_deps+=("ripgrep")
  command -v "$BAT_BIN" > /dev/null 2>&1 || brew_deps+=("bat")
  command -v rsync > /dev/null 2>&1 || brew_deps+=("rsync")
  command -v shfmt > /dev/null 2>&1 || brew_deps+=("shfmt")
  command -v yq > /dev/null 2>&1 || brew_deps+=("yq")
  command -v eza > /dev/null 2>&1 || brew_deps+=("eza")
  command -v zoxide > /dev/null 2>&1 || brew_deps+=("zoxide")
  python3 -c "import yaml" 2> /dev/null || brew_deps+=("pyyaml")

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
  local pip_deps=("ruff" "checkov" "yapf")
  local missing_pip=()

  for pkg in "${pip_deps[@]}"; do
    command -v "$pkg" > /dev/null 2>&1 || missing_pip+=("$pkg")
  done

  if [ ${#missing_pip[@]} -gt 0 ]; then
    echo -e "\n🐍 Installing Python tooling (${missing_pip[*]})..."
    if command -v pipx > /dev/null 2>&1; then
      for pkg in "${missing_pip[@]}"; do pipx install "$pkg" 2> /dev/null || pip3 install --user "$pkg"; done
    else
      pip3 install --user "${pip_deps[@]}"
    fi
  else
    echo "✅ All Python CLI dependencies are satisfied."
  fi
}

__bootstrap_yq() {
  # macOS installs yq via Homebrew as part of __bootstrap_brew; this binary
  # download is Linux-specific (and the artifact name is Linux-only).
  [ "$OS_FAMILY" = "macos" ] && return 0

  if ! command -v yq > /dev/null 2>&1; then
    echo -e "\n⚙️ Installing 'yq'..."
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod a+x /usr/local/bin/yq
    echo "✅ yq installed."
  fi
}

__bootstrap_check_complex() {
  local missing_complex_deps=()
  command -v terraform > /dev/null 2>&1 || missing_complex_deps+=("terraform")
  command -v gcloud > /dev/null 2>&1 || missing_complex_deps+=("google-cloud-cli")
  command -v kubectl > /dev/null 2>&1 || missing_complex_deps+=("kubectl")
  command -v eza > /dev/null 2>&1 || missing_complex_deps+=("eza")

  if [ ${#missing_complex_deps[@]} -gt 0 ]; then
    echo -e "\n⚠️  The following tools are missing and require manual repo config:"
    for dep in "${missing_complex_deps[@]}"; do echo "  - $dep"; done
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

  local missing=0
  local deps=(jq fzf rg "$BAT_BIN" rsync shfmt file ruff checkov terraform gcloud kubectl eza yq)

  for dep in "${deps[@]}"; do
    if ! command -v "$dep" > /dev/null 2>&1; then
      missing=1
      break
    fi
  done

  if [ "$missing" -eq 0 ] && ! python3 -c "import yaml" > /dev/null 2>&1; then
    missing=1
  fi

  if [ "$missing" -eq 1 ]; then
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
sys-update() { # => System: Updates system packages (APT/Homebrew)
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
sys-install() { # => System: Updates system packages (APT/Homebrew) and clears pending marker
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  sys-update
  rm -f "$HOME/.bash.d/.update_pending"
}

__check_missing_deps
