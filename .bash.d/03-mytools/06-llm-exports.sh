# shellcheck shell=bash
# ------------------------------------------
# LLM Context & Export Utilities
# ------------------------------------------
# ~/.bash.d/03-mytools/06-llm-exports.sh

#######################################
# LLM: Compute the next free versioned output filename for an export
# Globals (read/write, set by mt-export):
#   dest_dir, date_prefix, safe_dir_name, zip_out
#   out_ext, v_num, base_out_name (written)
#######################################
__mt_export_calc_output_name() {
  out_ext="txt"
  [ "$zip_out" = true ] && out_ext="zip"
  v_num=1
  while [[ -f "${dest_dir}/${date_prefix}_${safe_dir_name}_${v_num}.${out_ext}" ]]; do
    ((v_num++))
  done
  base_out_name="${date_prefix}_${safe_dir_name}_${v_num}"
}

#######################################
# LLM: Resolve the active export schema and build the filtered file list
# Globals (read, set by mt-export):
#   schemas_dir, schema_query, target_dir
# Globals (written):
#   schema_file, s_name, s_inc, s_exc, all_files, file_list
#######################################
__mt_export_build_file_lists() {
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
    schema_file="$schemas_dir/default.yaml"
  fi

  if command -v yq > /dev/null 2>&1; then
    s_name=$(yq -r '.name // "Code Export"' "$schema_file")
    s_inc=$(yq -r '.include_extensions // ".*"' "$schema_file")
    s_exc=$(yq -r '.exclude_patterns // ""' "$schema_file")
  fi

  find "$target_dir" -type f 2> /dev/null | sort > "$all_files"

  grep -E -vi "(${EXPORT_BLOCKLIST})" < "$all_files" |
    grep -E -i "\.(${s_inc})$" > "$file_list"

  if [ -n "$s_exc" ] && [ "$s_exc" != "null" ] && [ "$s_exc" != '""' ]; then
    grep -E -vi "(${s_exc})" "$file_list" > "${file_list}.filtered"
    mv "${file_list}.filtered" "$file_list"
  fi
}

#######################################
# LLM: Print the export plan summary (target, size estimate, extensions)
# Globals (read, set by mt-export):
#   file_list, target_dir, dest_dir, base_out_name, schema_query, s_name, out_ext
#######################################
__mt_export_print_plan() {
  local total_files
  total_files=$(wc -l < "$file_list")
  local total_bytes=0
  if [ "$total_files" -gt 0 ]; then
    total_bytes=$(tr < "$file_list" '\n' '\0' | xargs -0 wc -c 2> /dev/null | tail -n 1 | awk '{print $1}')
  fi
  [ -z "$total_bytes" ] && total_bytes=0
  local estimated_kb=$((total_bytes / 1024))

  local ext_list
  ext_list=$(awk -F. '{if (NF>1) print $NF}' "$file_list" | sort -u | tr '\n' ', ' | sed 's/, $//')
  [ -z "$ext_list" ] && ext_list="None/Unknown"

  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e "${CB_CYAN} 📊 MT DevOps Export Plan${C_RESET}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e " ${CB_YELLOW}📁 Target Dir    :${C_RESET} $(realpath "$target_dir")"
  echo -e " ${CB_YELLOW}📤 Export Dir    :${C_RESET} $dest_dir"
  echo -e " ${CB_YELLOW}📄 Export File   :${C_RESET} ${base_out_name}.${out_ext}"
  echo -e " ${CB_YELLOW}📋 Schema Applied:${C_RESET} $schema_query ($s_name)"
  echo -e " ${CB_YELLOW}💾 Output Format :${C_RESET} ${out_ext^^}"
  echo -e " ${CB_YELLOW}📦 Est. Size     :${C_RESET} ~${estimated_kb} KB ${C_DIM}(Estimate based on file byte sum)${C_RESET}"
  echo -e " ${CB_YELLOW}📄 Total Files   :${C_RESET} $total_files"
  echo -e " ${CB_YELLOW}🗂️  Extensions   :${C_RESET} $ext_list"
  echo -e "${CB_BLUE}----------------------------------------------------------${C_RESET}"
}

#######################################
# LLM: Print the included/excluded file lists side by side
# Globals (read, set by mt-export):
#   file_list, all_files
#######################################
__mt_export_print_inclusion_diff() {
  local excluded_files="/tmp/mt_export_excluded_${RANDOM}.txt"
  grep -v -F -x -f "$file_list" "$all_files" > "$excluded_files"

  echo -e "\n${CB_RED}The following files will be EXCLUDED (-):${C_RESET}"
  while IFS= read -r f; do [ -n "$f" ] && echo -e "  ${C_RED}- $f${C_RESET}"; done < "$excluded_files"

  echo -e "\n${CB_GREEN}The following files will be INCLUDED (+):${C_RESET}"
  while IFS= read -r f; do [ -n "$f" ] && echo -e "  ${C_GREEN}+ $f${C_RESET}"; done < "$file_list"
  rm -f "$excluded_files"
}

#######################################
# LLM: Run the interactive review/adjust menu loop for mt-export
# Usage: __mt_export_interactive_menu; then check $__mt_export_aborted
# Globals (read/write, set by mt-export):
#   file_list, all_files, tmp_file, zip_out, schema_query, schemas_dir, verbose_mode
# Globals (written):
#   __mt_export_aborted -- set to "true" if the user cancelled
#######################################
__mt_export_interactive_menu() {
  __mt_export_aborted=false
  while true; do
    __mt_export_print_plan
    echo -e "\n${CB_CYAN}Interactive Menu:${C_RESET}"
    echo "  1) Review & Remove Files (fzf multi-select)"
    echo "  2) Change Output Format (Toggle TXT/ZIP)"
    echo "  3) Change Schema"
    echo "  4) View Detailed Exclusions/Inclusions (-v)"
    echo "  5) Proceed with Export"
    echo "  6) Cancel"
    read -p "Select an option [1-6] > " -r < /dev/tty

    case "$REPLY" in
      1)
        local to_remove
        to_remove=$(fzf < "$file_list" -m --prompt="Select files to EXCLUDE (Tab to multi-select) > ")
        if [ -n "$to_remove" ]; then
          grep -v -F -x "$to_remove" "$file_list" > "${file_list}.tmp"
          mv "${file_list}.tmp" "$file_list"
          echo -e "${CB_GREEN}✅ Updated file list.${C_RESET}"
        fi
        ;;
      2)
        if [ "$zip_out" = true ]; then zip_out=false; else zip_out=true; fi
        __mt_export_calc_output_name
        echo -e "${CB_GREEN}✅ Format toggled.${C_RESET}"
        ;;
      3)
        local new_schema
        new_schema=$(find "$schemas_dir" -name "*.yaml" -exec basename {} .yaml \; | fzf --prompt="Select Schema > ")
        if [ -n "$new_schema" ]; then
          schema_query="$new_schema"
          __mt_export_build_file_lists
          echo -e "${CB_GREEN}✅ Schema updated to $schema_query.${C_RESET}"
        fi
        ;;
      4)
        verbose_mode=true
        __mt_export_print_plan
        __mt_export_print_inclusion_diff
        read -p "Press Enter to return to menu..." -r < /dev/tty
        verbose_mode=false
        ;;
      5) break ;;
      6 | *)
        echo -e "${CB_RED}🛑 Aborted.${C_RESET}"
        rm -f "$file_list" "$all_files" "$tmp_file"
        __mt_export_aborted=true
        return 0
        ;;
    esac
  done
}

#######################################
# LLM: Show the dry-run plan and prompt to proceed
# Usage: __mt_export_plan_mode; then check $__mt_export_aborted
# Globals (read, set by mt-export):
#   file_list, all_files, tmp_file, verbose_mode
# Globals (written):
#   __mt_export_aborted -- set to "true" if the user declined to proceed
#######################################
__mt_export_plan_mode() {
  __mt_export_aborted=false
  __mt_export_print_plan
  if [ "$verbose_mode" = true ]; then
    __mt_export_print_inclusion_diff
  else
    echo -e "\n${CB_CYAN}Included Directory Tree:${C_RESET}"
    awk -F'/' '{for(i=1;i<NF;i++){printf "  |   "} print "  |-- "$NF}' "$file_list" | head -n 50
    local total_files
    total_files=$(wc -l < "$file_list")
    if [ "$total_files" -gt 50 ]; then
      echo -e "${C_DIM}  ...and $((total_files - 50)) more files. Run with -v for full lists.${C_RESET}"
    fi
    echo -e "\n${C_DIM}Run with --plan --verbose to see exact file inclusion/exclusion lists.${C_RESET}"
  fi

  echo ""
  read -p "🚀 Proceed with export? [Y/n] " -n 1 -r < /dev/tty
  echo
  if [[ ! $REPLY =~ ^[Yy]$ && -n $REPLY ]]; then
    echo -e "${CB_RED}🛑 Aborted.${C_RESET}"
    rm -f "$file_list" "$all_files" "$tmp_file"
    __mt_export_aborted=true
  fi
}

#######################################
# LLM: Enforce file-count safety limits before running a full export
# Usage: __mt_export_check_file_count_guards; then check $? (1 = abort)
# Globals (read, set by mt-export):
#   file_list, all_files, target_dir, schema_query, plan_mode, interactive_mode
# Returns:
#   0 to proceed, 1 if the export should be aborted
#######################################
__mt_export_check_file_count_guards() {
  local total_files
  total_files=$(wc -l < "$file_list")
  if [ "$total_files" -eq 0 ]; then
    echo -e "${CB_YELLOW}⚠️ No files matched the schema '${schema_query}' in ${target_dir}.${C_RESET}"
    rm -f "$file_list" "$all_files"
    return 1
  fi

  if [ "$total_files" -gt 2000 ]; then
    echo -e "${CB_RED}🚨 KILLSWITCH: $total_files files detected. Export aborted to prevent system lockup and LLM overload.${C_RESET}"
    rm -f "$file_list" "$all_files"
    return 1
  elif [ "$total_files" -gt 500 ] && [ "$plan_mode" = false ] && [ "$interactive_mode" = false ]; then
    echo -e "${CB_YELLOW}⚠️ Warning: $total_files files detected. This may exceed AI context limits.${C_RESET}"
    read -r -p "Proceed anyway? [y/N] " -n 1 < /dev/tty
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo -e "${CB_RED}🛑 Aborted.${C_RESET}"
      rm -f "$file_list" "$all_files"
      return 1
    fi
  fi
  return 0
}

#######################################
# LLM: Write the header, directory tree, and file contents into the export
# Globals (read, set by mt-export):
#   tmp_file, s_name, target_dir, schema_query, file_list
#######################################
__mt_export_write_context_file() {
  {
    echo "=== MT DevOps Export: $s_name ==="
    echo "Generated: $(date)"
    echo "Directory: $(realpath "$target_dir")"
    echo "Schema: $schema_query"
    echo "-----------------------------------"
    echo "Directory Tree:"
  } > "$tmp_file"

  if command -v tree > /dev/null 2>&1; then
    tree -a -I '.git|.dev|.vscode|.idea|node_modules|__pycache__|.terraform|venv|.venv|.mt_cache*' "$target_dir" >> "$tmp_file" 2> /dev/null
  else
    find "$target_dir" -print | grep -E -v '/(\.git|\.dev|\.vscode|\.idea|node_modules|__pycache__|\.terraform|venv|\.venv)/' | sed -e 's;[^/]*/;|____;g;s;____|; |;g' >> "$tmp_file" 2> /dev/null
  fi
  echo "-----------------------------------" >> "$tmp_file"

  while IFS= read -r file; do
    [ -z "$file" ] && continue
    echo -e "\n==> $file <==" >> "$tmp_file"
    cat "$file" >> "$tmp_file" 2> /dev/null || echo "[Unreadable File]" >> "$tmp_file"
  done < "$file_list"
}

#######################################
# LLM: Write the final export artifact (zip or plain copy) and open its folder
# Globals (read, set by mt-export):
#   zip_out, dest_dir, base_out_name, out_ext, tmp_file, file_list, all_files, quiet_mode, target_dir
#######################################
__mt_export_finalize() {
  local final_out="${dest_dir}/${base_out_name}.${out_ext}"
  if [ "$zip_out" = true ]; then
    zip -qj "$final_out" "$tmp_file" > /dev/null 2>&1
  else
    cp "$tmp_file" "$final_out"
  fi
  echo -e "${CB_GREEN}✅ Export saved to $final_out${C_RESET}"
  echo -e "${CB_YELLOW}📂 Target Dir    :${C_RESET} $(realpath "$target_dir")"

  rm -f "$tmp_file" "$file_list" "$all_files"

  if [ "$quiet_mode" = false ] && type __open_path_gui > /dev/null 2>&1; then
    __open_path_gui "$dest_dir" 2> /dev/null || true
  fi
}

#######################################
# LLM: Export codebase to text/zip for LLM context window using dynamic schemas
# Usage: mt-export [-d dir] [-s schema] [-z] [-q] [-p] [-v] [-i]
# Options:
#   -d, --dir <path>     Target directory to export (default: current directory)
#   -s, --schema <name>  Export schema to apply (default, terraform, shell, python, springboot)
#   -z, --zip            Compress output into a .zip file
#   -q, --quiet          Do not automatically open the output directory
#   -p, --plan           Dry-run: show estimated size and included files, prompt to proceed
#   -v, --verbose        Show detailed terraform-style plan of inclusions/exclusions
#   -i, --interactive    Open an interactive menu to adjust export files, format, and schema
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
  local plan_mode=false
  local verbose_mode=false
  local interactive_mode=false

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
      -p | --plan) plan_mode=true ;;
      -v | --verbose) verbose_mode=true ;;
      -i | --interactive) interactive_mode=true ;;
      *) target_dir="$1" ;;
    esac
    shift
  done

  if [ ! -d "$target_dir" ]; then
    echo -e "${CB_RED}🚨 Error: Directory '$target_dir' not found.${C_RESET}"
    return 1
  fi

  local schemas_dir="$HOME/.bash.d/config/export/schemas"
  local schema_file=""
  local s_name="Code Export"
  local s_inc=".*"
  local s_exc=""

  local tmp_file="/tmp/mt_export_${RANDOM}.txt"
  local file_list="/tmp/mt_export_files_${RANDOM}.txt"
  local all_files="/tmp/mt_export_all_${RANDOM}.txt"

  local date_prefix
  date_prefix=$(date +"%Y%m%d")

  local safe_dir_name
  safe_dir_name=$(basename "$(realpath "$target_dir")" | tr '.' '_')

  local dest_dir="${EXPORT_DIR:-/tmp/exports}/${safe_dir_name}"
  mkdir -p "$dest_dir"
  local out_ext="txt"
  local v_num=1
  local base_out_name=""

  __mt_export_calc_output_name
  __mt_export_build_file_lists

  local __mt_export_aborted=false
  if [ "$interactive_mode" = true ]; then
    __mt_export_interactive_menu
    [ "$__mt_export_aborted" = true ] && return 0
  elif [ "$plan_mode" = true ]; then
    __mt_export_plan_mode
    [ "$__mt_export_aborted" = true ] && return 0
  fi

  __mt_export_check_file_count_guards || return 1

  if [ "$plan_mode" = false ] && [ "$interactive_mode" = false ]; then
    echo -e "${CB_BLUE}📦 Running: $s_name${C_RESET}"
  fi

  __mt_export_write_context_file
  __mt_export_finalize
}

#######################################
# LLM: Copy a file or directory tree to clipboard with headers and extension filters
# Usage: mt-copy [-e <extensions>] <file-or-directory>
#######################################
mt-copy() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local ext_list="" target=""
  local OPTIND opt
  while getopts "e:" opt; do
    case ${opt} in
      e) ext_list="$OPTARG" ;;
      *)
        echo "Usage: mt-copy [-e <extensions>] <file-or-directory>" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  target="${1:-.}"
  if [ ! -e "$target" ]; then
    echo -e "${CB_RED}🚨 Error: '$target' missing.${C_RESET}"
    return 1
  fi

  local clip_cmd=""
  if command -v clip.exe > /dev/null 2>&1; then
    clip_cmd="clip.exe"
  elif command -v pbcopy > /dev/null 2>&1; then
    clip_cmd="pbcopy"
  elif command -v xclip > /dev/null 2>&1; then
    clip_cmd="xclip -selection clipboard"
  else
    echo "🚨 No clipboard utility."
    return 1
  fi

  echo -e "${CB_BLUE}🔍 Scanning '$target'...${C_RESET}"

  local temp_file
  temp_file=$(mktemp)

  local blocklist_regex="${EXPORT_BLOCKLIST:-(secret|token|credential|pass|key|rsa|env|lock\.hcl|__pycache__)}"

  local filter_ext=".*"
  if [ -n "$ext_list" ]; then
    local ext_fmt
    ext_fmt=$(echo "$ext_list" | sed 's/,/|/g; s/ //g')
    filter_ext="\.(${ext_fmt})$"
    echo -e "${C_DIM}   (Filtering for: $ext_list)${C_RESET}"
  fi

  local prune_dirs=(-name .git -o -name node_modules -o -name .terraform -o -name __pycache__ -o -name .venv)

  if [ -d "$target" ]; then
    find "$target" -type d \( "${prune_dirs[@]}" \) -prune -o -type f -print | grep -E -v "$blocklist_regex" | grep -Ei "$filter_ext" | while IFS= read -r file; do
      if file -b --mime-encoding "$file" | grep -qv "binary"; then
        echo -e "\n==> $file <==" >> "$temp_file"
        cat "$file" >> "$temp_file"
      fi
    done
  elif [ -f "$target" ]; then
    echo -e "==> $target <==" >> "$temp_file"
    cat "$target" >> "$temp_file"
  fi

  local bytes
  bytes=$(wc -c < "$temp_file")
  if [ "$bytes" -eq 0 ]; then
    echo -e "${CB_YELLOW}⚠️ Nothing copied.${C_RESET}"
  else
    eval "$clip_cmd" < "$temp_file"
    local lines
    lines=$(wc -l < "$temp_file")
    echo -e "${CB_GREEN}✅ Copied $lines lines to clipboard!${C_RESET}"
  fi
  rm -f "$temp_file"
}
