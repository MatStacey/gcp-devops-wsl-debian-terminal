# shellcheck shell=bash
# ------------------------------------------
# OS Detection & Cross-Platform Helpers
# ------------------------------------------
# ~/.bash.d/00-system/00-os.sh

#######################################
# System: Detect operating system family (wsl, macos, or linux)
# Outputs:
#   Prints 'wsl', 'macos', or 'linux' to STDOUT
#######################################
__detect_os_family() {
  local kernel
  kernel="$(uname -s 2> /dev/null)"

  case "$kernel" in
    Darwin)
      echo "macos"
      ;;
    Linux)
      if [ -n "${WSL_DISTRO_NAME:-}" ] ||
        [ -e /proc/sys/fs/binfmt_misc/WSLInterop ] ||
        grep -qi microsoft /proc/version 2> /dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    *)
      echo "linux"
      ;;
  esac
}

export OS_FAMILY
OS_FAMILY="$(__detect_os_family)"

# bat vs batcat binary resolution
export BAT_BIN
if command -v batcat > /dev/null 2>&1; then
  BAT_BIN="batcat"
elif command -v bat > /dev/null 2>&1; then
  BAT_BIN="bat"
elif [ "$OS_FAMILY" = "macos" ]; then
  BAT_BIN="bat"
else
  BAT_BIN="batcat"
fi

#######################################
# System: Open a local path in the native file manager
# Arguments:
#   $1 - Path to directory or file
#######################################
__open_path_gui() {
  local target="$1"
  case "$OS_FAMILY" in
    macos)
      open "$target" 2> /dev/null
      ;;
    wsl)
      local ps_script="$HOME/.bash.d/lib/windows/win_explorer_focus.ps1"
      if [ -f "$ps_script" ] && command -v powershell.exe > /dev/null 2>&1; then
        powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "$(wslpath -w "$ps_script")" "$(wslpath -w "$target")" > /dev/null 2>&1
      else
        explorer.exe "$(wslpath -w "$target")" 2> /dev/null
      fi
      ;;
    *)
      if command -v xdg-open > /dev/null 2>&1; then
        xdg-open "$target" > /dev/null 2>&1
      else
        echo "⚠️ No GUI file manager launcher available on this OS."
      fi
      ;;
  esac
}

#######################################
# System: Open a URL in default web browser
# Arguments:
#   $1 - Target URL string
#######################################
__open_url() {
  local url="$1"
  case "$OS_FAMILY" in
    macos)
      open "$url" > /dev/null 2>&1
      ;;
    wsl)
      explorer.exe "$url" > /dev/null 2>&1
      ;;
    *)
      if command -v xdg-open > /dev/null 2>&1; then
        xdg-open "$url" > /dev/null 2>&1
      else
        echo "⚠️ No browser launcher available. Open manually: $url"
      fi
      ;;
  esac
}

#######################################
# System: Launch IntelliJ IDEA against given path(s)
# Arguments:
#   $@ - Path(s) to open in IntelliJ
# Returns:
#   0 on success, 1 on failure
#######################################
__launch_intellij() {
  if command -v idea > /dev/null 2>&1; then
    idea "$@" &> /dev/null && return 0
  fi

  case "$OS_FAMILY" in
    macos)
      open -a "IntelliJ IDEA" "$@" &> /dev/null && return 0
      ;;
    *)
      if command -v idea.exe > /dev/null 2>&1; then
        idea.exe "$@" &> /dev/null && return 0
      fi
      ;;
  esac

  return 1
}

#######################################
# System: Copy STDIN stream to system clipboard
#######################################
__clip_copy() {
  case "$OS_FAMILY" in
    macos)
      pbcopy
      ;;
    wsl)
      clip.exe
      ;;
    *)
      if command -v xclip > /dev/null 2>&1; then
        xclip -selection clipboard
      elif command -v xsel > /dev/null 2>&1; then
        xsel --clipboard --input
      else
        echo "⚠️ No clipboard utility found on this OS." >&2
        cat > /dev/null
      fi
      ;;
  esac
}
