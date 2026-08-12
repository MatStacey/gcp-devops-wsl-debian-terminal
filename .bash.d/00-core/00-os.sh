# ------------------------------------------
# OS Detection & Cross-Platform Helpers
# ------------------------------------------
# ~/.bash.d/00-core/00-os.sh
#
# Single source of truth for platform detection. Every other module should
# branch on $OS_FAMILY rather than probing `uname`/`wslpath`/etc directly.
#
#   OS_FAMILY values:
#     wsl    - Windows Subsystem for Linux (Debian/Ubuntu userland)
#     macos  - macOS (Darwin)
#     linux  - Plain/native Linux (sane fallback, treated like WSL for apt)

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
      # Unrecognized kernel: degrade to the Linux/apt code path rather than
      # hard-failing.
      echo "linux"
      ;;
  esac
}

export OS_FAMILY
OS_FAMILY="$(__detect_os_family)"

# ------------------------------------------
# bat vs batcat
# ------------------------------------------
# Debian/Ubuntu renames the `bat` binary to `batcat` to avoid a package name
# collision. Homebrew installs it as `bat` directly. Resolve the binary name
# once here so nothing else in the config has to hardcode it.
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

# ------------------------------------------
# GUI / launcher helpers
# ------------------------------------------
# Open a local path in the platform's native file manager.
# WSL:   explorer.exe (via wslpath translation)
# macOS: open
# Linux: xdg-open (best effort)
__open_path_gui() {
  local target="$1"
  case "$OS_FAMILY" in
    macos)
      open "$target" 2> /dev/null
      ;;
    wsl)
      explorer.exe "$(wslpath -w "$target")" 2> /dev/null
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

# Open a URL in the platform's default web browser.
# WSL:   explorer.exe is used as a workaround (no native xdg-open/open)
# macOS: open just works
# Linux: xdg-open (best effort)
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

# Launch IntelliJ IDEA against the given path(s), trying the platform's
# preferred launcher first and falling back gracefully.
#   1. `idea` shim (JetBrains Toolbox on any OS, or Homebrew cask on macOS)
#   2. macOS:  `open -a "IntelliJ IDEA"`
#   3. WSL/Linux: `idea.exe` (Windows-side install accessible from WSL)
# Returns 1 if nothing worked so callers can print their own message.
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

# Copy stdin to the system clipboard.
# WSL:   clip.exe
# macOS: pbcopy
# Linux: xclip/xsel (best effort)
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
