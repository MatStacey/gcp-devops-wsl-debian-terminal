# shellcheck shell=bash
# ------------------------------------------
# LLM Context & Export Utilities
# ------------------------------------------
# ~/.bash.d/03-mytools/06-llm-exports.sh

#######################################
# LLM: Export codebase to text/zip for LLM context window using dynamic schemas
# Usage: mt-export [-d dir] [-s schema] [-z] [-q]
# Options:
#   -d, --dir <path>     Target directory to export (default: current directory)
#   -s, --schema <name>  Export schema to apply (default, terraform, shell, python, springboot)
#   -z, --zip            Compress output into a .zip file
#   -q, --quiet          Do not automatically open the output directory
#######################################
mt-export() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local target_dir="."
  local schema_query="default"
  local zip_out=false
  local quiet_mode=false

  # Parse Arguments
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -d | --dir)
        target_dir="$2"
        shift
        ;;
      -s | --schema)
        schema_query="$2"
        shift
        ;;
      -z | --zip) zip_out=true ;;
      -q | --quiet) quiet_mode=true ;;
      *) target_dir="$1" ;; # Handle positional fallback
    esac
    shift
  done

  if [ ! -d "$target_dir" ]; then
    echo -e "${CB_RED}🚨 Error: Directory '$target_dir' not found.${C_RESET}"
    return 1
  fi

  local schemas_dir="$HOME/.bash.d/config/export/schemas"
  local schema_file=""

  # Resolve the correct schema using Python
  local py_script="
import os, yaml, sys
schemas_dir = sys.argv[1]
query = sys.argv[2].lower()
for f in os.listdir(schemas_dir):
    if not f.endswith('.yaml'): continue
    path = os.path.join(schemas_dir, f)
    try:
        with open(path, 'r') as yf:
            data = yaml.safe_load(yf)
            aliases = data.get('aliases', [])
            if query in aliases or query == data.get('name', '').lower() or query == f.split('.')[0]:
                print(path)
                sys.exit(0)
    except: pass
print('')
"
  if command -v python3 > /dev/null 2>&1; then
    schema_file=$(python3 -c "$py_script" "$schemas_dir" "$schema_query")
  fi

  if [ -z "$schema_file" ] || [ ! -f "$schema_file" ]; then
    echo -e "${CB_YELLOW}⚠️ Schema '${schema_query}' not found. Falling back to default.${C_RESET}"
    schema_file="$schemas_dir/default.yaml"
  fi

  # Extract Schema Values using yq
  local s_name="Code Export"
  local s_inc=".*"
  local s_exc=""

  if command -v yq > /dev/null 2>&1; then
    s_name=$(yq -r '.name // "Code Export"' "$schema_file")
    s_inc=$(yq -r '.include_extensions // ".*"' "$schema_file")
    s_exc=$(yq -r '.exclude_patterns // ""' "$schema_file")
  fi

  echo -e "${CB_BLUE}📦 Running: $s_name${C_RESET}"

  # Resolve centralized exports directory
  local dest_dir="${AI_WORKSPACE_DIR:-$HOME/vcs/ai-workspace}/exports"
  mkdir -p "$dest_dir"

  # Build the dynamic filename
  local safe_dir_name
  safe_dir_name=$(basename "$(realpath "$target_dir")")
  local timestamp
  timestamp=$(date +"%Y%m%d_%H%M%S")
  local base_out_name="${timestamp}_${safe_dir_name}_${schema_query}"

  local tmp_file="/tmp/mt_export_${RANDOM}.txt"
  local file_list="/tmp/mt_export_files_${RANDOM}.txt"

  # Find files, exclude global blocklist, include specified extensions
  eval "find \"$target_dir\" -type f" 2> /dev/null |
    grep -E -vi "(${EXPORT_BLOCKLIST})" |
    grep -E -i "\.(${s_inc})$" > "$file_list"

  # Optionally filter out schema-specific excluded patterns
  if [ -n "$s_exc" ] && [ "$s_exc" != "null" ] && [ "$s_exc" != '""' ]; then
    grep -E -vi "(${s_exc})" "$file_list" > "${file_list}.filtered"
    mv "${file_list}.filtered" "$file_list"
  fi

  local total_files
  total_files=$(wc -l < "$file_list")

  if [ "$total_files" -eq 0 ]; then
    echo -e "${CB_YELLOW}⚠️ No files matched the schema '${schema_query}' in ${target_dir}.${C_RESET}"
    rm -f "$file_list"
    return 0
  fi

  # === AI Context Size Protection (Killswitch) ===
  if [ "$total_files" -gt 2000 ]; then
    echo -e "${CB_RED}🚨 KILLSWITCH: $total_files files detected. Export aborted to prevent system lockup and LLM overload.${C_RESET}"
    rm -f "$file_list"
    return 1
  elif [ "$total_files" -gt 500 ]; then
    echo -e "${CB_YELLOW}⚠️ Warning: $total_files files detected. This may exceed AI context limits.${C_RESET}"
    read -r -p "Proceed anyway? [y/N] " -n 1 < /dev/tty
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo -e "${CB_RED}🛑 Aborted.${C_RESET}"
      rm -f "$file_list"
      return 1
    fi
  fi

  echo "=== MT DevOps Export: $s_name ===" > "$tmp_file"
  echo "Generated: $(date)" >> "$tmp_file"
  echo "Directory: $(realpath "$target_dir")" >> "$tmp_file"
  echo "Schema: $schema_query" >> "$tmp_file"
  echo "-----------------------------------" >> "$tmp_file"

  # Inject the directory tree overview
  echo "Directory Tree:" >> "$tmp_file"
  if command -v tree > /dev/null 2>&1; then
    tree -a -I '.git|.dev|.vscode|.idea|node_modules|__pycache__|.terraform|venv|.venv|.mt_cache*' "$target_dir" >> "$tmp_file" 2> /dev/null
  else
    # Fallback to sed-formatted find if tree is missing
    # shellcheck disable=SC2086
    find "$target_dir" -print | grep -E -v '/(\.git|\.dev|\.vscode|\.idea|node_modules|__pycache__|\.terraform|venv|\.venv)/' | sed -e 's;[^/]*/;|____;g;s;____|; |;g' >> "$tmp_file" 2> /dev/null
  fi
  echo "-----------------------------------" >> "$tmp_file"

  # Append actual file contents
  while IFS= read -r file; do
    echo -e "\n==> $file <==" >> "$tmp_file"
    cat "$file" >> "$tmp_file" 2> /dev/null || echo "[Unreadable File]" >> "$tmp_file"
  done < "$file_list"

  local final_out=""
  if [ "$zip_out" = true ]; then
    final_out="${dest_dir}/${base_out_name}.zip"
    zip -qj "$final_out" "$tmp_file" > /dev/null 2>&1
    echo -e "${CB_GREEN}✅ Export saved to $final_out${C_RESET}"
  else
    final_out="${dest_dir}/${base_out_name}.txt"
    cp "$tmp_file" "$final_out"
    echo -e "${CB_GREEN}✅ Export saved to $final_out${C_RESET}"
  fi

  rm -f "$tmp_file" "$file_list"

  # Open GUI Explorer unless quiet mode is on
  if [ "$quiet_mode" = false ]; then
    if type __open_path_gui > /dev/null 2>&1; then
      __open_path_gui "$dest_dir" 2> /dev/null || true
    fi
  fi
}
