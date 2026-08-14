# shellcheck shell=bash
# ------------------------------------------
# LLM Code Export Utilities
# ------------------------------------------

__win_explorer_focus() {
  case "$OS_FAMILY" in
    macos)
      # `open` already reveals/refocuses an existing Finder window for the
      # path, so there's no COM-style refocus trick needed here.
      open "$1" 2> /dev/null
      ;;
    wsl)
      local target_path
      target_path=$(wslpath -m "$1")

      powershell.exe -ExecutionPolicy Bypass -NoProfile -File "$(wslpath -w "$HOME/.bash.d/lib/win_explorer_focus.ps1")" -TargetPath "$target_path" > /dev/null 2>&1
      ;;
    *)
      # No native window-focus mechanism on plain Linux; best effort only.
      command -v xdg-open > /dev/null 2>&1 && xdg-open "$1" > /dev/null 2>&1
      ;;
  esac
}

__vcs_core_export() {
  local export_prefix="$1"
  local allow_regex="$2"
  local block_regex="$3"
  local search_dir="${4:-.}"

  local root_dir
  root_dir=$(basename "$PWD")
  if [ "$search_dir" != "." ]; then
    # Sanitize the sub-directory path to safely append it to the filename
    local safe_sub
    safe_sub=$(echo "$search_dir" | sed -e 's/^\.\///' -e 's/[^a-zA-Z0-9]/-/g' -e 's/--*/-/g' -e 's/^-//' -e 's/-$//')
    [ -n "$safe_sub" ] && root_dir="${root_dir}-${safe_sub}"
  fi

  local datetime_str
  datetime_str=$(date +"%Y-%m-%d_%H-%M-%S")
  local target_dir="${AI_WORKSPACE_DIR}/context-exports/${root_dir}-exports"
  mkdir -p "$target_dir"

  local patch=0
  while [[ -f "${target_dir}/${datetime_str}-${root_dir}-${export_prefix}-v1.0.${patch}.txt" ]]; do
    patch=$((patch + 1))
  done

  local export_file="${target_dir}/${datetime_str}-${root_dir}-${export_prefix}-v1.0.${patch}.txt"
  echo "Compiling codebase into ${export_file}..."
  : > "$export_file"

  find "$search_dir" -type f -not -path "*/\.git/*" -not -path "*/node_modules/*" -not -path "*/venv/*" -not -path "*/\.terraform/*" -print0 | while IFS= read -r -d '' file; do
    local clean_file="${file#./}"
    local lower_file="${clean_file,,}"

    if [[ "$lower_file" =~ \.(png|jpe?g|gif|ico|pdf|zip|tar|gz|mp4|mp3|wav|exe|dll|so|class|jar|bin|o|pyc|tfstate)$ ]]; then continue; fi
    if [ -n "$allow_regex" ] && ! [[ "$lower_file" =~ $allow_regex ]]; then continue; fi
    if [ -n "$block_regex" ] && [[ "$lower_file" =~ $block_regex ]]; then continue; fi

    echo "==> ./$clean_file <==" >> "$export_file"
    command cat "$file" >> "$export_file"
    echo -e "\n" >> "$export_file"
  done

  local file_size
  file_size=$(du -h "$export_file" | cut -f1)
  echo "✅ Export saved to $export_file ($file_size)"
  __win_explorer_focus "$target_dir"
}

#######################################
# LLM: Exports all text/code files [Usage: mt-export [-d subdir]]
#######################################
mt-export() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local search_dir="."
  local OPTIND opt
  while getopts "d:" opt; do
    case ${opt} in
      d) search_dir="$OPTARG" ;;
      \?)
        echo "Usage: mt-export [-d subdirectory]" >&2
        return 1
        ;;
    esac
  done

  if [ "$search_dir" != "." ] && [ ! -d "$search_dir" ]; then
    echo "🚨 Error: Subdirectory '$search_dir' not found." >&2
    return 1
  fi

  __vcs_core_export "export" "" "${EXPORT_BLOCKLIST}" "$search_dir"
}

#######################################
# LLM: Exports local TF codebase [Usage: mt-export-terraform [-d subdir]]
#######################################
mt-export-terraform() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local search_dir="."
  local OPTIND opt
  while getopts "d:" opt; do
    case ${opt} in
      d) search_dir="$OPTARG" ;;
      \?)
        echo "Usage: mt-export-terraform [-d subdirectory]" >&2
        return 1
        ;;
    esac
  done

  if [ "$search_dir" != "." ] && [ ! -d "$search_dir" ]; then
    echo "🚨 Error: Subdirectory '$search_dir' not found." >&2
    return 1
  fi

  __vcs_core_export "tf-export" "\.(tf|sh|ya?ml|json|md)$" "${EXPORT_BLOCKLIST}" "$search_dir"
}

#######################################
# LLM: Exports local .sh files [Usage: mt-export-shell [-d subdir]]
#######################################
mt-export-shell() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local search_dir="."
  local OPTIND opt
  while getopts "d:" opt; do
    case ${opt} in
      d) search_dir="$OPTARG" ;;
      \?)
        echo "Usage: mt-export-shell [-d subdirectory]" >&2
        return 1
        ;;
    esac
  done

  if [ "$search_dir" != "." ] && [ ! -d "$search_dir" ]; then
    echo "🚨 Error: Subdirectory '$search_dir' not found." >&2
    return 1
  fi

  __vcs_core_export "sh-export" "\.sh$" "${EXPORT_BLOCKLIST}" "$search_dir"
}

#######################################
# LLM: Exports Python GCF codebase [Usage: mt-export-cloudrun [-d subdir]]
#######################################
mt-export-cloudrun() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local search_dir="."
  local OPTIND opt
  while getopts "d:" opt; do
    case ${opt} in
      d) search_dir="$OPTARG" ;;
      \?)
        echo "Usage: mt-export-cloudrun [-d subdirectory]" >&2
        return 1
        ;;
    esac
  done

  if [ "$search_dir" != "." ] && [ ! -d "$search_dir" ]; then
    echo "🚨 Error: Subdirectory '$search_dir' not found." >&2
    return 1
  fi

  __vcs_core_export "py-export" "\.(py|tf|sh|ya?ml|json|toml|md|properties|txt)$" "${EXPORT_BLOCKLIST}|(\.egg-info|test-reports|\.pyc$)" "$search_dir"
}

#######################################
# LLM: Clean up export files
# Arguments:
#   cleanup-exports [-d <repo>
#######################################
mt-export-cleanup() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local target_repo=""
  local days=""
  local base_dir="${AI_WORKSPACE_DIR}/context-exports"

  local OPTIND opt
  while getopts "d:o:" opt; do
    case ${opt} in
      d) target_repo="$OPTARG" ;;
      o) days="$OPTARG" ;;
      \?)
        echo "Usage: cleanup-exports [-d <repo-name>] [-o <days>]" >&2
        return 1
        ;;
    esac
  done

  if [ ! -d "$base_dir" ]; then
    echo "⚠️ Exports directory not found at $base_dir."
    return 0
  fi

  local target_dir="$base_dir"
  if [ -n "$target_repo" ]; then
    target_dir="${base_dir}/${target_repo}-exports"
    if [ ! -d "$target_dir" ]; then
      echo "⚠️ No exports found for repository '$target_repo'."
      return 0
    fi
  fi

  if [ -n "$days" ]; then
    if ! [[ "$days" =~ ^[0-9]+$ ]]; then
      echo "🚨 Error: The '-o' flag requires a numeric value (days)."
      return 1
    fi
    echo "🧹 Pruning files older than $days days in ${target_dir}..."
    find "$target_dir" -type f -mtime +"$days" -delete
    find "$base_dir" -type d -empty -delete 2> /dev/null || true
    echo "✅ Old exports pruned."
  else
    echo "🧹 Deleting all exports in ${target_dir}..."
    rm -rf "${target_dir:?}"
    [ -z "$target_repo" ] && mkdir -p "$base_dir"
    echo "✅ Export cleanup complete."
  fi
}

__async_auto_cleanup() {
  if [[ $- != *i* ]]; then return; fi

  if [ "$AUTO_CLEANUP_EXPORTS" = "true" ]; then
    local days="${AUTO_CLEANUP_DAYS:-7}"
    local base_dir="${AI_WORKSPACE_DIR}/context-exports"

    if [ -d "$base_dir" ] && [[ "$days" =~ ^[0-9]+$ ]]; then
      (
        find "$base_dir" -type f -mtime +"$days" -delete 2> /dev/null
        find "$base_dir" -type d -empty -delete 2> /dev/null
      ) &
      disown
    fi
  fi
}

__async_auto_cleanup
