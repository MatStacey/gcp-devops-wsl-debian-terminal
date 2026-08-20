# shellcheck shell=bash

__mt_do_export() {
  local title="$1"
  local default_ext="$2"
  shift 2

  local target_dir="."
  local recursive=true
  local inc_exts=""
  local exc_exts=""
  local zip_out=false
  local quiet_mode=false

  # Parse Arguments
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -d | --dir)
        target_dir="$2"
        shift
        ;;
      -R | --no-recursive) recursive=false ;;
      -i | --include)
        inc_exts="$2"
        shift
        ;;
      -x | --exclude)
        exc_exts="$2"
        shift
        ;;
      -z | --zip) zip_out=true ;;
      -q | --quiet) quiet_mode=true ;;
      -h | --help)
        mt-help "${FUNCNAME[1]}"
        return 0
        ;;
      *) target_dir="$1" ;; # Handle positional fallback
    esac
    shift
  done

  if [ ! -d "$target_dir" ]; then
    echo -e "${CB_RED}🚨 Error: Directory '$target_dir' not found.${C_RESET}"
    return 1
  fi

  # Resolve centralized exports directory
  local dest_dir="${AI_WORKSPACE_DIR:-$HOME/vcs/ai-workspace}/exports"
  mkdir -p "$dest_dir"

  # Build the dynamic filename
  local safe_dir_name
  safe_dir_name=$(basename "$(realpath "$target_dir")")
  local timestamp
  timestamp=$(date +"%Y%m%d_%H%M%S")
  local base_out_name="${timestamp}_${safe_dir_name}_export"

  # Build recursion arg
  local maxdepth=""
  [ "$recursive" = false ] && maxdepth="-maxdepth 1"

  # Convert comma separated strings to regex (e.g. py,sh -> py|sh)
  local ext_pattern="$default_ext"
  [ -n "$inc_exts" ] && ext_pattern="${inc_exts//,/|}"
  local exc_pattern=""
  [ -n "$exc_exts" ] && exc_pattern="${exc_exts//,/|}"

  local tmp_file="/tmp/mt_export_${RANDOM}.txt"
  local file_list="/tmp/mt_export_files_${RANDOM}.txt"

  # Find files, exclude global blocklist, include specified extensions
  eval "find \"$target_dir\" $maxdepth -type f" 2> /dev/null |
    grep -E -vi "(${EXPORT_BLOCKLIST})" |
    grep -E -i "\.(${ext_pattern})$" > "$file_list"

  # Optionally filter out excluded extensions
  if [ -n "$exc_pattern" ]; then
    grep -E -vi "\.(${exc_pattern})$" "$file_list" > "${file_list}.filtered"
    mv "${file_list}.filtered" "$file_list"
  fi

  echo "=== MT DevOps Export: $title ===" > "$tmp_file"
  echo "Generated: $(date)" >> "$tmp_file"
  echo "Directory: $(realpath "$target_dir")" >> "$tmp_file"
  echo "-----------------------------------" >> "$tmp_file"

  # Inject the directory tree overview
  echo "Directory Tree:" >> "$tmp_file"
  if command -v tree > /dev/null 2>&1; then
    tree -a -I '.git|.dev|.vscode|.idea|node_modules|__pycache__|.terraform|venv|.venv|.mt_cache*' "$target_dir" >> "$tmp_file" 2> /dev/null
  else
    # Fallback to sed-formatted find if tree is missing
    # shellcheck disable=SC2086
    find "$target_dir" $maxdepth -print | grep -E -v '/(\.git|\.dev|\.vscode|\.idea|node_modules|__pycache__|\.terraform|venv|\.venv)/' | sed -e 's;[^/]*/;|____;g;s;____|; |;g' >> "$tmp_file" 2> /dev/null
  fi
  echo "-----------------------------------" >> "$tmp_file"

  # Append actual file contents
  while IFS= read -r file; do
    echo -e "
==> $file <==" >> "$tmp_file"
    cat "$file" >> "$tmp_file" 2> /dev/null || echo "[Unreadable File]" >> "$tmp_file"
  done < "$file_list"

  local final_out=""
  if [ "$zip_out" = true ]; then
    final_out="${dest_dir}/${base_out_name}.zip"
    zip -qj "$final_out" "$tmp_file" > /dev/null 2>&1
    echo "✅ Export saved to $final_out"
  else
    final_out="${dest_dir}/${base_out_name}.txt"
    cp "$tmp_file" "$final_out"
    echo "✅ Export saved to $final_out"
  fi

  rm -f "$tmp_file" "$file_list"

  # Open GUI Explorer unless quiet mode is on
  if [ "$quiet_mode" = false ]; then
    if type __open_path_gui > /dev/null 2>&1; then
      __open_path_gui "$dest_dir" 2> /dev/null || true
    fi
  fi
}

mt-export() { __mt_do_export "Generic Code Export" ".*" "$@"; }
mt-export-shell() { __mt_do_export "Shell Scripts Export" "sh|bash|zsh" "$@"; }
mt-export-terraform() { __mt_do_export "Terraform Code Export" "tf|tfvars|yaml|yml" "$@"; }
mt-export-cloudrun() { __mt_do_export "Cloud Run Python Export" "py|txt|yaml|yml|Dockerfile|sh" "$@"; }
