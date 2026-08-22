# shellcheck shell=bash disable=SC2119,SC2120
# ------------------------------------------
# System & Environment Bootstrap
# ------------------------------------------
# ~/.bash.d/00-system/04-bootstrap.sh

if [ -f "$HOME/.bash.d/config/dependencies.sh" ]; then
  source "$HOME/.bash.d/config/dependencies.sh"
fi

#######################################
# System: Filter list of dependencies to return missing packages
# Arguments:
#   $@ - Dependency definitions (command:package)
# Outputs:
#   Prints one missing package name per line to STDOUT (nothing if none are
#   missing -- callers read this via `mapfile -t`, which requires
#   one-per-line output; a space-joined single line, or printf with no
#   arguments, both leave a phantom empty element in the resulting array)
#######################################
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
  [ ${#missing[@]} -gt 0 ] && printf '%s\n' "${missing[@]}"
  return 0
}

#######################################
# System: Bootstrap APT dependencies on Debian/WSL
#######################################
__bootstrap_apt() {
  local apt_deps
  mapfile -t apt_deps < <(__get_missing_deps "${APT_DEPENDENCIES[@]}")

  if [ ${#apt_deps[@]} -gt 0 ]; then
    echo -e "\n📦 Installing standard APT dependencies: ${apt_deps[*]}..."
    sudo apt-get update && sudo apt-get install -y "${apt_deps[@]}"
  else
    echo "✅ All standard APT dependencies are satisfied."
  fi
}

#######################################
# System: Bootstrap Homebrew dependencies on macOS
#######################################
__bootstrap_brew() {
  if ! command -v brew > /dev/null 2>&1; then
    echo -e "\n🍺 Homebrew not found. Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

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

  local brew_deps
  mapfile -t brew_deps < <(__get_missing_deps "${BREW_DEPENDENCIES[@]}")

  if [ ${#brew_deps[@]} -gt 0 ]; then
    echo -e "\n📦 Installing standard Homebrew dependencies: ${brew_deps[*]}..."
    brew install "${brew_deps[@]}"
  else
    echo "✅ All standard Homebrew dependencies are satisfied."
  fi

  command -v bat > /dev/null 2>&1 && export BAT_BIN="bat"
}

#######################################
# System: Bootstrap Python tooling dependencies via pipx/pip3
#######################################
__bootstrap_python() {
  local pip_deps
  mapfile -t pip_deps < <(__get_missing_deps "${PYTHON_DEPENDENCIES[@]}")

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

#######################################
# System: Download and install yq binary on Linux
#######################################
__bootstrap_yq() {
  [ "$OS_FAMILY" = "macos" ] && return 0

  if ! command -v yq > /dev/null 2>&1; then
    echo -e "\n⚙️ Installing 'yq'..."
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod a+x /usr/local/bin/yq
    echo "✅ yq installed."
  fi
}

#######################################
# System: Install Ookla Speedtest CLI
#######################################
__install_speedtest() {
  echo -e "\n📦 Installing Ookla Speedtest CLI..."

  if [ "$OS_FAMILY" = "macos" ]; then
    if command -v brew > /dev/null 2>&1; then
      brew install speedtest
    else
      echo "🚨 Homebrew is required to install Speedtest on macOS."
      return 1
    fi

  elif command -v apt-get > /dev/null 2>&1; then
    local arch
    arch="$(dpkg --print-architecture)"

    if [ "$arch" != "amd64" ]; then
      echo "🚨 Unsupported architecture for Ookla Speedtest: $arch"
      return 1
    fi

    # We hard coded version to 1.2.0.84-1.ea6b6773cf because the Ookla packagecloud.io repository was returning 404s for Ubuntu Noble/Jammy, so we switched to downloading a known-good .deb directly.
    local version="1.2.0.84-1.ea6b6773cf"
    local url="https://packagecloud.io/ookla/speedtest-cli/packages/ubuntu/jammy/speedtest_${version}_amd64.deb/download.deb"
    local tmpdir
    tmpdir="$(mktemp -d)"

    echo "📥 Downloading Ookla Speedtest CLI..."

    if ! curl -fsSL -o "$tmpdir/speedtest.deb" "$url"; then
      echo "🚨 Failed to download Ookla Speedtest CLI."
      rm -rf "$tmpdir"
      return 1
    fi

    echo "📦 Installing Ookla Speedtest CLI..."

    if sudo apt-get install -y "$tmpdir/speedtest.deb"; then
      rm -rf "$tmpdir"
      echo "✅ Ookla Speedtest CLI installed successfully."
    else
      echo "🚨 Speedtest installation failed."
      rm -rf "$tmpdir"
      return 1
    fi

  else
    echo "🚨 Unsupported platform for Ookla Speedtest CLI."
    return 1
  fi

  if command -v speedtest > /dev/null 2>&1; then
    echo "✅ Speedtest is available at: $(command -v speedtest)"
  else
    echo "🚨 Speedtest installation failed."
    return 1
  fi
}

#######################################
# System: Check and report missing external dependencies
#######################################
__bootstrap_external() {
  local missing_external
  mapfile -t missing_external < <(__get_missing_deps "${EXTERNAL_DEPENDENCIES[@]}")

  for dep in "${missing_external[@]}"; do
    case "$dep" in
      speedtest)
        __install_speedtest
        ;;
      *)
        echo "⚠️ No installer defined for external dependency: $dep"
        ;;
    esac
  done
}

#######################################
# System: Check and report missing complex dependencies
#######################################
__bootstrap_check_complex() {
  local missing_complex
  mapfile -t missing_complex < <(__get_missing_deps "${COMPLEX_DEPENDENCIES[@]}")

  if [ ${#missing_complex[@]} -gt 0 ]; then
    echo -e "\n⚠️  The following tools are missing and require manual repo config:"
    for dep in "${missing_complex[@]}"; do echo "  - $dep"; done
  fi
}

#######################################
# System: Bootstrap missing dependencies (Debian/WSL via APT, macOS via Homebrew)
# Usage: bootstrap [OPTIONS]
# Options:
#   -h, --help    Show this help menu
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
  __bootstrap_external
  __bootstrap_check_complex

  echo -e "\n🎉 Environment bootstrap complete!"

  if ! command -v gh > /dev/null 2>&1; then
    echo -e "${CB_BLUE}📦 Installing GitHub CLI...${C_RESET}"
    if command -v apt-get > /dev/null 2>&1; then
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null 2>&1
      sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt-get update > /dev/null 2>&1
      sudo apt-get install -y gh > /dev/null 2>&1
    else
      echo -e "${CB_YELLOW}⚠️ apt-get not found. Please install GitHub CLI manually.${C_RESET}"
    fi
  fi

  if ! command -v claude > /dev/null 2>&1; then
    if command -v npm > /dev/null 2>&1; then
      echo -e "${CB_BLUE}📦 Installing Claude Code...${C_RESET}"
      sudo npm install -g @anthropic-ai/claude-code > /dev/null 2>&1
    else
      echo -e "${CB_YELLOW}⚠️ npm not found. Skipping Claude Code install. (Please install Node.js first)${C_RESET}"
    fi
  fi
}

#######################################
# System: Notify if missing dependencies are detected
# Notes:
#   The actual scan (in particular its `python3 -c "import yaml"` check) costs
#   ~20ms, so it's run in the background at most once per
#   UPDATE_CHECK_TTL_SEC and its result cached, the same pattern used by
#   __check_updates/__check_profile_updates in 02-update-check.sh.
#######################################
__check_missing_deps() {
  if [[ $- != *i* ]]; then return; fi

  local pending_file="$HOME/.bash.d/data/cache/.deps_pending"
  local cache_file="$HOME/.bash.d/data/cache/.deps_check_cache"
  local current_time
  current_time=$(date +%s)
  mkdir -p "$HOME/.bash.d/data/cache" 2> /dev/null

  if [ -f "$pending_file" ]; then
    echo -e "\n${C_YELLOW}⚠️  Missing required dependencies detected in your environment:${C_RESET}"
    while IFS= read -r dep; do
      [ -n "$dep" ] && echo "  - $dep"
    done < "$pending_file"
    echo -e "${C_YELLOW}   Run ${C_BOLD}bootstrap${C_UNBOLD} to install them.${C_RESET}"
    return
  fi

  local last_check=0
  if [ -f "$cache_file" ]; then
    last_check=$(command cat "$cache_file")
  fi

  local ttl="${UPDATE_CHECK_TTL_SEC:-43200}"

  if ((current_time - last_check >= ttl)); then
    (
      local to_check=()
      if [ "$OS_FAMILY" = "macos" ]; then
        to_check=("${BREW_DEPENDENCIES[@]}")
      else
        to_check=("${APT_DEPENDENCIES[@]}")
        to_check+=("yq:yq")
      fi
      to_check+=(
        "${PYTHON_DEPENDENCIES[@]}"
        "${COMPLEX_DEPENDENCIES[@]}"
        "${EXTERNAL_DEPENDENCIES[@]}"
      )
      local missing_list
      mapfile -t missing_list < <(__get_missing_deps "${to_check[@]}")

      if [ ${#missing_list[@]} -gt 0 ]; then
        printf '%s\n' "${missing_list[@]}" > "$pending_file"
      else
        date +%s > "$cache_file"
      fi
    ) &
    disown
  fi
}

#######################################
# System: Updates system packages (APT on Debian/WSL, Homebrew on macOS)
# Usage: sys-update [OPTIONS]
# Options:
#   -h, --help    Show this help menu
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
# System: Updates system packages and clears pending-update marker
# Usage: sys-install [OPTIONS]
# Options:
#   -h, --help    Show this help menu
#######################################
sys-install() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  sys-update
  rm -f "$HOME/.bash.d/data/cache/.update_pending"
}

__check_missing_deps
