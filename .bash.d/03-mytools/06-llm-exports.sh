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

  while IFS= read -r file; do
    echo -e "\n==> $file <==" >> "$tmp_file"
    cat "$file" >> "$tmp_file" 2> /dev/null || echo "[Unreadable File]" >> "$tmp_file"
  done < "$file_list"

  if [ "$zip_out" = true ]; then
    local zip_name
    zip_name="export_$(date +%s).zip"
    zip -qj "$zip_name" "$tmp_file"
    echo "✅ Export saved to $zip_name"
  else
    clip < "$tmp_file"
    echo "✅ Export copied to clipboard!"
  fi

  rm -f "$tmp_file" "$file_list"
}

mt-export() { __mt_do_export "Generic Code Export" ".*" "$@"; }
mt-export-shell() { __mt_do_export "Shell Scripts Export" "sh|bash|zsh" "$@"; }
mt-export-terraform() { __mt_do_export "Terraform Code Export" "tf|tfvars|yaml|yml" "$@"; }
mt-export-cloudrun() { __mt_do_export "Cloud Run Python Export" "py|txt|yaml|yml|Dockerfile|sh" "$@"; }
