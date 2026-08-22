# shellcheck shell=bash
# ------------------------------------------
# General System Utilities
# ------------------------------------------
# ~/.bash.d/02-utilities/99-utils.sh

#######################################
# System: Display the top largest files in a directory
# Arguments:
#   $1 - Count (default: 10)
#   $2 - Target directory (default: .)
#######################################
mt-top-files() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local count="${1:-10}"
  local target_dir="${2:-.}"
  echo -e "${CB_BLUE}📊 Finding the top ${count} largest files in ${target_dir}...${C_RESET}"
  find "$target_dir" -type f -exec du -h {} + 2> /dev/null | sort -rh | head -n "$count"
}

#######################################
# System: Centralized logging for MyTools
# Arguments:
#   $1 - Log level (INFO, SUCCESS, WARN, ERROR)
#   $2 - Message
#######################################
mt-log() {
  local level="$1"
  local msg="$2"
  local log_dir="${LOG_DIR:-$HOME/.bash.d/data/logs}"
  local log_file="$log_dir/framework.log"

  # Console Output
  case "$level" in
    INFO) echo -e "${CB_BLUE}ℹ️ ${msg}${C_RESET}" ;;
    SUCCESS) echo -e "${CB_GREEN}✅ ${msg}${C_RESET}" ;;
    WARN) echo -e "${CB_YELLOW}⚠️ ${msg}${C_RESET}" ;;
    ERROR) echo -e "${CB_RED}🚨 ${msg}${C_RESET}" >&2 ;;
    *) echo "$msg" ;;
  esac

  # File Logging (with 1MB basic rotation)
  mkdir -p "$log_dir" 2> /dev/null
  if [ -f "$log_file" ]; then
    local size
    size=$(wc -c < "$log_file" 2> /dev/null || echo 0)
    if [ "$size" -gt 1048576 ]; then
      mv "$log_file" "${log_file}.old" 2> /dev/null
    fi
  fi

  local ts
  ts=$(date +"%Y-%m-%d %H:%M:%S")
  echo "[$ts] [$level] $msg" >> "$log_file" 2> /dev/null
}

#######################################
# AI: Retrieve prompt string from prompts.yaml
# Arguments:
#   $1 - Prompt key
#######################################
__get_prompt() {
  python3 "$HOME/.bash.d/lib/python/get_prompt.py" "$1"
}

#######################################
# System: Warn and confirm before backing up an oversized payload
# Globals (read, set by mt-backup):
#   force, threshold_mb
# Returns:
#   0 to proceed, 1 if the user declined
#######################################
__mt_backup_check_size_warning() {
  mt-log INFO "Estimating backup payload size..."
  local est_size_mb
  est_size_mb=$(find . -type d \( -name .git -o -name node_modules -o -name __pycache__ -o -name .terraform -o -name venv -o -name .venv \) -prune -o -type f -exec ls -l {} + 2> /dev/null | awk '{s+=$5} END {print int(s/1048576)}')
  [ -z "$est_size_mb" ] && est_size_mb=0

  if [ "$force" = false ] && [ "$est_size_mb" -ge "$threshold_mb" ]; then
    echo -e "${CB_YELLOW}⚠️ Warning: Estimated payload is ${est_size_mb}MB, which exceeds the ${threshold_mb}MB limit.${C_RESET}"
    read -p "🚀 Proceed with backup? [y/N] " -n 1 -r < /dev/tty
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo -e "${CB_RED}🛑 Aborted.${C_RESET}"
      return 1
    fi
  fi
}

#######################################
# System: List existing backups for the current directory's safe name
# Globals (read, set by mt-backup):
#   dest, expanded_base, safe_dir_name
#######################################
__mt_backup_list() {
  if [ ! -d "$dest" ]; then
    echo -e "${CB_YELLOW}⚠️ No backups found for '${safe_dir_name}' in ${expanded_base}.${C_RESET}"
    return 0
  fi

  echo -e "${CB_BLUE}🔍 Scanning '${dest}' for backups...${C_RESET}\n"

  local count
  count=$(find "$dest" -maxdepth 1 -type f | wc -l)

  if [ "$count" -eq 0 ]; then
    echo -e "${CB_YELLOW}⚠️ No backups found in $dest.${C_RESET}"
    return 0
  fi

  echo -e "${CB_CYAN}📦 Found $count backup(s) for '${safe_dir_name}':${C_RESET}\n"

  # ls -lth sorts by time (latest first), -h gives human-readable sizes
  command ls -lth --time-style=+"%Y-%m-%d %H:%M:%S" "$dest" | grep -v '^total' | awk -v blue="$CB_BLUE" -v cyan="$CB_CYAN" -v yellow="$CB_YELLOW" -v green="$CB_GREEN" -v rst="$C_RESET" '
    BEGIN {
      printf "%s%-55s %-25s %-15s%s\n", blue, "FILENAME", "DATE CREATED", "SIZE", rst
      printf "%s%s%s\n", blue, "-------------------------------------------------------------------------------------------------", rst
    }
    {
      size = $5
      date_created = $6 " " $7
      name = ""
      # Support filenames with spaces just in case
      for(i=8; i<=NF; i++) name = name (i==8?"":" ") $i
      printf "%s%-55s%s %s%-25s%s %s%-15s%s\n", cyan, name, rst, yellow, date_created, rst, green, size, rst
    }
  '
  echo ""
}

#######################################
# System: Create the backup archive (zip/rar/tar) and report the result
# Globals (read, set by mt-backup):
#   dest, safe_dir_name, format
#######################################
__mt_backup_create() {
  mkdir -p "$dest"

  # Format timestamps: [YYYY-MM-DD]_[HH-MM-SS]
  local date_part
  date_part=$(date +"%Y-%m-%d")
  local time_part
  time_part=$(date +"%H-%M-%S")

  local ext="$format"
  case "$format" in
    tz | tar.xz | txz) ext="tar.xz" ;;
    gzip | tar.gz | tgz) ext="tar.gz" ;;
    rar) ext="rar" ;;
    zip | *)
      ext="zip"
      format="zip"
      ;;
  esac

  local backup_file="${dest}/[${date_part}]_[${time_part}]_${safe_dir_name}_backup.${ext}"
  mt-log INFO "Backing up ${PWD} to ${backup_file}..."

  local success=0
  if [ "$format" = "zip" ]; then
    zip -q -r "$backup_file" . -x "*.git/*" -x "*node_modules/*" -x "*__pycache__/*" -x "*.terraform/*" -x "*venv/*" -x "*.venv/*"
    success=$?
  elif [ "$format" = "rar" ]; then
    if command -v rar > /dev/null 2>&1; then
      rar a -q -r -x"*\.git\*" -x"*node_modules\*" -x"*__pycache__\*" -x"*\.terraform\*" -x"*venv\*" -x"*\.venv\*" "$backup_file" .
      success=$?
    else
      echo -e "${CB_RED}🚨 Error: 'rar' is not installed. Please install it or use zip/gzip.${C_RESET}"
      return 1
    fi
  else
    local tar_flag="z"
    [ "$ext" = "tar.xz" ] && tar_flag="J"
    tar -c${tar_flag}f "$backup_file" --exclude=".git" --exclude="node_modules" --exclude="__pycache__" --exclude=".terraform" --exclude="venv" --exclude=".venv" .
    success=$?
  fi

  if [ $success -eq 0 ]; then
    local file_size
    file_size=$(du -h "$backup_file" | cut -f1)
    mt-log SUCCESS "Backup complete: ${backup_file} (${file_size})"

    # Construct correct clickable link for terminal (OSC 8) with clean WSL-to-Windows URI formatting
    local file_url="$dest"
    if [ "$OS_FAMILY" = "wsl" ] && command -v wslpath > /dev/null 2>&1; then
      local distro="${WSL_DISTRO_NAME:-Debian}"
      file_url="file://wsl.localhost/${distro}${dest}"
    else
      file_url="file://$dest"
    fi

    echo -e " 📂 Folder: \033]8;;${file_url}\033\\${dest}\033]8;;\033\\"
  else
    mt-log ERROR "Backup failed."
  fi
}

#######################################
# System: Create an archive backup of the current directory
# Usage: mt-backup [-f|--force] [-l|--list] [-o|--output format] [-d|--dir path]
# Options:
#   -l, --list     List existing backups for the current directory
#   -f, --force    Skip the size limit warning check
#   -o, --output   Archive format: zip (default), rar, tz, gzip
#   -d, --dir      Override the base destination directory
# Globals:
#   BACKUP_DIR
#######################################
mt-backup() {
  local force=false
  local list_mode=false
  local format="zip"

  local base_dest="${BACKUP_DIR:-/tmp/backups}"

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -l | --list) list_mode=true ;;
      -f | --force) force=true ;;
      -o | --output)
        format="${2,,}"
        shift
        ;;
      -d | --dir)
        base_dest="$2"
        shift
        ;;
      -h | --help)
        mt-help "${FUNCNAME[0]}"
        return 0
        ;;
      -*)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
      *) base_dest="$1" ;;
    esac
    shift
  done

  local threshold_mb="${BACKUP_WARNING_MB:-500}"

  if ! [[ "$threshold_mb" =~ ^[0-9]+$ ]]; then
    echo -e "${CB_RED}🚨 Error: 'backup_warning_mb' in config.yaml is invalid ('$threshold_mb'). It must be a whole number.${C_RESET}"
    return 1
  fi

  if [ "$list_mode" = false ]; then
    __mt_backup_check_size_warning || return 1
  fi

  # Sanitize target directory name (strip dots, special chars)
  local raw_dir_name
  raw_dir_name=$(basename "$(realpath "$PWD")")
  local safe_dir_name
  safe_dir_name=$(echo "$raw_dir_name" | tr -d '.' | sed 's/[^a-zA-Z0-9]/_/g')

  # Resolve base destination, expanding ~ if present
  local expanded_base="${base_dest/#\~/$HOME}"
  local dest="${expanded_base}/${safe_dir_name}"

  if [ "$list_mode" = true ]; then
    __mt_backup_list
    return 0
  fi

  __mt_backup_create
}

#######################################
# System: Audit VCS root for unorganized files and directories
#######################################
mt-vcs-audit() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local vcs_dir="${VCS_ROOT:-$HOME/vcs}"
  echo -e "${CB_BLUE}🔍 Auditing ${vcs_dir} for unorganized items...${C_RESET}\n"

  if command -v eza > /dev/null 2>&1; then
    # Print a tree up to 3 levels deep, ignoring our organized folders
    eza -la --tree --level=3 --group-directories-first -I "external|personal|work|workspaces|misc|.git" "$vcs_dir"
  else
    # Fallback to standard ls if eza is unavailable
    # shellcheck disable=SC2010
    ls -la "$vcs_dir" | grep -vE "(external|personal|work|workspaces|misc)"
  fi
}

#######################################
# System: View, filter, and manage framework logs
# Usage: mt-logs [-n lines] [-l level] [-s keyword] [-o] [-f] [-c]
# Options:
#   -n, --lines <num>     Number of lines to display (default: 50)
#   -l, --level <level>   Filter by severity (INFO, SUCCESS, WARN, ERROR)
#   -s, --search <term>   Search for a specific keyword
#   -o, --open            Open the log file in your default IDE
#   -f, --follow          Tail the logs live
#   -c, --clear           Clear the log file
#######################################
mt-logs() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local log_file="${LOG_DIR:-$HOME/.bash.d/data/logs}/framework.log"
  local lines=50
  local level_filter=""
  local search_term=""
  local do_open=false
  local do_follow=false
  local do_clear=false

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -n | --lines)
        lines="$2"
        shift
        ;;
      -l | --level)
        level_filter="${2^^}"
        shift
        ;;
      -s | --search)
        search_term="$2"
        shift
        ;;
      -o | --open) do_open=true ;;
      -f | --follow) do_follow=true ;;
      -c | --clear) do_clear=true ;;
      -*)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
    esac
    shift
  done

  if [ ! -f "$log_file" ]; then
    echo -e "${CB_YELLOW}⚠️ No log file found at $log_file${C_RESET}"
    return 0
  fi

  if [ "$do_clear" = true ]; then
    true > "$log_file"
    echo -e "${CB_GREEN}✅ Log file cleared.${C_RESET}"
    return 0
  fi

  if [ "$do_open" = true ]; then
    echo -e "${CB_BLUE}📂 Opening $log_file in ${DEFAULT_IDE:-vscode}...${C_RESET}"
    if [ "${DEFAULT_IDE:-vscode}" = "intellij" ]; then
      idea "$log_file" 2> /dev/null || cat "$log_file"
    else
      code "$log_file" 2> /dev/null || cat "$log_file"
    fi
    return 0
  fi

  if [ "$do_follow" = true ]; then
    tail -f "$log_file"
    return 0
  fi

  local cmd="cat \"$log_file\""
  [ -n "$level_filter" ] && cmd="$cmd | grep \"\[$level_filter\]\""
  [ -n "$search_term" ] && cmd="$cmd | grep -i \"$search_term\""
  cmd="$cmd | tail -n $lines"

  echo -e "${CB_CYAN}📜 Showing last $lines lines of framework logs...${C_RESET}"
  [ -n "$level_filter" ] && echo -e "${C_DIM}   Level: $level_filter${C_RESET}"
  [ -n "$search_term" ] && echo -e "${C_DIM}   Search: $search_term${C_RESET}"
  echo -e "${CB_BLUE}----------------------------------------------------------${C_RESET}"

  eval "$cmd"
}

#######################################
# System: Interactively create or update an alias
# Usage: mt-alias [-u alias_name] [-i]
# Options:
#   -u, --update <name>   Update a specific existing alias
#   -i, --interactive     Select an existing alias to update via fzf
#######################################
mt-alias() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local update_name="" interactive=false
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -u | --update)
        update_name="$2"
        shift 2
        ;;
      -i | --interactive)
        interactive=true
        shift
        ;;
      *)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
    esac
  done
  if [ "$interactive" = true ]; then
    update_name=$(awk -F'\t' '$1 == "alias" { printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv" | fzf --ansi --prompt="Select Alias to Update > " | awk '{print $1}')
    [ -z "$update_name" ] && return 0
  fi
  local alias_name="$update_name" default_cmd="" default_cat="User Custom" default_desc="" aliases_file="$HOME/.bash.d/02-utilities/20-aliases.sh"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  if [ -n "$alias_name" ]; then
    if ! grep -qE "^[ \t]*alias ${alias_name}=" "$aliases_file"; then
      echo -e "${CB_RED}🚨 Error: Alias '${alias_name}' not found.${C_RESET}"
      return 1
    fi
    echo -e "${CB_CYAN} 🛠️  Update Existing Alias: ${alias_name}${C_RESET}"
    default_cmd=$(grep -E "^[ \t]*alias ${alias_name}=" "$aliases_file" | sed -E "s/^[ \t]*alias ${alias_name}=['\"]?//;s/['\"]?$//")
    local tsv_line
    tsv_line=$(awk -F'\t' -v n="$alias_name" '$1=="alias" && $3==n {print $2 "|" $4}' "$HOME/.bash.d/data/cache/.mt_data.tsv" | head -n 1)
    if [ -n "$tsv_line" ]; then
      default_cat=$(echo "$tsv_line" | cut -d'|' -f1)
      default_desc=$(echo "$tsv_line" | cut -d'|' -f2)
    fi
  else
    echo -e "${CB_CYAN} 🛠️  Create New Alias${C_RESET}"
    read -r -p "1️⃣  Alias Name (e.g., kgpo)     : " alias_name
    [ -z "$alias_name" ] && return 1
    if grep -qE "^[ \t]*alias ${alias_name}=" "$aliases_file"; then
      echo -e "${CB_RED}🚨 Alias already exists. Use -u to update.${C_RESET}"
      return 1
    fi
  fi
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  local alias_cmd="" alias_cat="" alias_desc=""
  read -r -e -i "$default_cmd" -p "2️⃣  Target Command             : " alias_cmd
  [ -z "$alias_cmd" ] && return 1
  read -r -e -i "$default_cat" -p "3️⃣  Category (e.g., Docker)    : " alias_cat
  [ -z "$alias_cat" ] && alias_cat="User Custom"
  read -r -e -i "$default_desc" -p "4️⃣  Description                : " alias_desc
  [ -z "$alias_desc" ] && alias_desc="Custom shortcut for ${alias_cmd}"
  if [ -n "$update_name" ]; then
    python3 -c "import sys; p, n = sys.argv[1], sys.argv[2]
with open(p, 'r') as f: l = f.read().split('\n')
o, i = [], 0
while i < len(l):
    if l[i].startswith('#######################################'):
        if any(x.startswith(f'alias {n}=') for x in l[i+1:i+10]):
            while not l[i].startswith(f'alias {n}='): i += 1
            i += 1
            continue
    if l[i].startswith(f'alias {n}='): i += 1; continue
    o.append(l[i]); i += 1
while o and o[-1].strip() == '': o.pop()
with open(p, 'w') as f: f.write('\n'.join(o) + '\n')" "$aliases_file" "$alias_name"
  fi
  cat << ALIASEOF >> "$aliases_file"

#######################################
# ${alias_cat}: ${alias_desc}
#######################################
alias ${alias_name}='${alias_cmd}'
ALIASEOF
  # shellcheck disable=SC1090
  source "$aliases_file"
  mt-refresh-caches > /dev/null 2>&1
  echo -e "${CB_GREEN}🎉 Success! You can now use '${alias_name}'.${C_RESET}"
}

#######################################
# System: Submit a task to the background job registry
#######################################
#######################################
# System: Submit a task to the background job registry
#######################################
__mt_bg_run() {
  local job_name="$1" log_file="$2" cmd_string="$3"
  local job_id
  job_id="job_$(date +%s)_${RANDOM}"
  local jobs_file="$HOME/.bash.d/data/cache/.mt_jobs.tsv"

  # Ensure log directory and job tracking directories exist BEFORE subshell redirects
  mkdir -p "$(dirname "$log_file")" "$(dirname "$jobs_file")"
  touch "$jobs_file"

  (
    local start_time
    start_time=$(date +%s)
    echo "${job_id}|${BASHPID}|${job_name}|${start_time}||RUNNING|${log_file}|${cmd_string}" >> "$jobs_file"
    eval "$cmd_string" > "$log_file" 2>&1
    local exit_code=$?
    local end_time
    end_time=$(date +%s)
    local status="SUCCESS"
    [ $exit_code -ne 0 ] && status="FAILED"
    local tmp
    tmp=$(mktemp)
    awk -F'|' -v id="$job_id" -v e="$end_time" -v s="$status" 'BEGIN{OFS="|"} $1==id { $5=e; $6=s } {print $0}' "$jobs_file" > "$tmp" && mv "$tmp" "$jobs_file"
  ) &
  disown
  echo -e "${CB_GREEN}🚀 Background job started: ${job_name}${C_RESET}"
  echo -e "${C_DIM}Monitor logs: tail -f $log_file${C_RESET}"
  echo -e "${C_DIM}Manage jobs : mt-jobs -i${C_RESET}"
}

#######################################
# System: List and manage MT background jobs
# Usage: mt-jobs [-i|--interactive] [-p|--purge] [-c|--clean]
#######################################
#######################################
# System: Kill every RUNNING job and mark it CANCELLED in the jobs file
# Globals (read, set by mt-jobs):
#   jobs_file, current_time
#######################################
__mt_jobs_purge() {
  echo -e "${CB_RED}🛑 Purging all running background jobs...${C_RESET}"
  local tmp_m
  tmp_m=$(mktemp)
  local count=0
  local j_id j_pid j_name j_start j_end j_status j_log j_cmd
  while IFS='|' read -r j_id j_pid j_name j_start j_end j_status j_log j_cmd; do
    [ -z "$j_id" ] && continue
    if [ "$j_status" = "RUNNING" ]; then
      kill -9 "$j_pid" 2> /dev/null
      j_status="CANCELLED"
      j_end=$current_time
      ((count++))
    fi
    echo "${j_id}|${j_pid}|${j_name}|${j_start}|${j_end}|${j_status}|${j_log}|${j_cmd}" >> "$tmp_m"
  done < "$jobs_file"
  mv "$tmp_m" "$jobs_file"
  echo -e "${CB_GREEN}✅ Purged ${count} running job(s).${C_RESET}"
}

#######################################
# System: Drop every finished (non-RUNNING) job and its log from history
# Globals (read, set by mt-jobs):
#   jobs_file
#######################################
__mt_jobs_clean() {
  echo -e "${CB_YELLOW}🧹 Cleaning completed job history...${C_RESET}"
  local tmp_c
  tmp_c=$(mktemp)
  local count=0
  local j_id j_pid j_name j_start j_end j_status j_log j_cmd
  while IFS='|' read -r j_id j_pid j_name j_start j_end j_status j_log j_cmd; do
    [ -z "$j_id" ] && continue
    if [ "$j_status" != "RUNNING" ]; then
      [ -f "$j_log" ] && rm -f "$j_log"
      ((count++))
    else
      echo "${j_id}|${j_pid}|${j_name}|${j_start}|${j_end}|${j_status}|${j_log}|${j_cmd}" >> "$tmp_c"
    fi
  done < "$jobs_file"
  mv "$tmp_c" "$jobs_file"
  echo -e "${CB_GREEN}✅ Removed ${count} finished job(s) from history.${C_RESET}"
}

#######################################
# System: Mark RUNNING jobs whose PID no longer exists as ORPHANED
# Globals (read, set by mt-jobs):
#   jobs_file, current_time
#######################################
__mt_jobs_reap_orphans() {
  local tmp_jobs
  tmp_jobs=$(mktemp)
  local j_id j_pid j_name j_start j_end j_status j_log j_cmd
  while IFS='|' read -r j_id j_pid j_name j_start j_end j_status j_log j_cmd; do
    [ -z "$j_id" ] && continue
    if [ "$j_status" = "RUNNING" ]; then
      if ! kill -0 "$j_pid" 2> /dev/null; then
        j_status="ORPHANED"
        j_end=$current_time
      fi
    fi
    echo "${j_id}|${j_pid}|${j_name}|${j_start}|${j_end}|${j_status}|${j_log}|${j_cmd}" >> "$tmp_jobs"
  done < "$jobs_file"
  mv "$tmp_jobs" "$jobs_file"
}

#######################################
# System: Render the jobs table into a tab-delimited temp file for display/fzf
# Globals (read, set by mt-jobs):
#   jobs_file, current_time
# Globals (written):
#   tmp_out -- path to the rendered table
#######################################
__mt_jobs_render_table() {
  tmp_out=$(mktemp)

  local j_id j_pid j_name j_start j_end j_status j_log j_cmd
  while IFS='|' read -r j_id j_pid j_name j_start j_end j_status j_log j_cmd; do
    [ -z "$j_id" ] && continue

    local t_start="-"
    [ -n "$j_start" ] && t_start=$(date -d "@$j_start" +"%H:%M:%S" 2> /dev/null || date -r "$j_start" +"%H:%M:%S" 2> /dev/null)
    local t_end="-"
    [ -n "$j_end" ] && t_end=$(date -d "@$j_end" +"%H:%M:%S" 2> /dev/null || date -r "$j_end" +"%H:%M:%S" 2> /dev/null)

    local end_calc="${j_end:-$current_time}"
    local diff=$((end_calc - j_start))
    local dur
    dur=$(printf "%02dm %02ds" $((diff / 60)) $((diff % 60)))

    local color="${CB_CYAN}"
    [ "$j_status" = "SUCCESS" ] && color="${CB_GREEN}"
    [ "$j_status" = "FAILED" ] || [ "$j_status" = "ORPHANED" ] && color="${CB_RED}"
    [ "$j_status" = "CANCELLED" ] && color="${CB_YELLOW}"

    local p_name
    p_name=$(printf "%-22s" "${j_name:0:22}")
    local p_start
    p_start=$(printf "%-10s" "$t_start")
    local p_end
    p_end=$(printf "%-10s" "$t_end")
    local p_dur
    p_dur=$(printf "%-10s" "$dur")

    # Store RAW j_id first separated by tabs so fzf can extract it perfectly
    echo -e "${j_id}	${p_name} ${C_DIM}${p_start}${C_RESET} ${C_DIM}${p_end}${C_RESET} ${C_DIM}${p_dur}${C_RESET} ${color}${j_status}${C_RESET}" >> "$tmp_out"
  done < "$jobs_file"
}

#######################################
# System: Print the rendered jobs table (non-interactive mode) and clean up
# Globals (read, set by mt-jobs):
#   tmp_out
#######################################
__mt_jobs_print_table() {
  printf "
${CB_BLUE}%-22s %-10s %-10s %-10s %-12s${C_RESET}
" "NAME" "START" "END" "DURATION" "STATUS"
  echo -e "${CB_BLUE}-------------------------------------------------------------------${C_RESET}"
  cut -f2- "$tmp_out"
  echo -e "
${C_DIM}Run 'mt-jobs -i' to interact, 'mt-jobs -c' to clean history.${C_RESET}"
  rm -f "$tmp_out"
}

#######################################
# System: fzf-select a job from the rendered table, then run the chosen action
# Globals (read, set by mt-jobs):
#   tmp_out, jobs_file, current_time
#######################################
__mt_jobs_interactive_select() {
  local selected
  selected=$(fzf < "$tmp_out" --ansi --delimiter="	" --with-nth=2 --prompt="Select Job > ")
  rm -f "$tmp_out"

  [ -z "$selected" ] && return 0

  local sel_id
  sel_id=$(echo "$selected" | cut -f1)

  local sel_data
  sel_data=$(grep "^${sel_id}|" "$jobs_file" | head -n 1)

  [ -z "$sel_data" ] && {
    echo -e "${CB_RED}🚨 Error resolving job details for ID: ${sel_id}${C_RESET}"
    return 1
  }

  local j_id j_pid j_name j_start j_end j_status j_log j_cmd
  IFS='|' read -r j_id j_pid j_name j_start j_end j_status j_log j_cmd <<< "$sel_data"

  echo -e "
${CB_BLUE}▶ Selected Job: ${j_name} (${j_id})${C_RESET}"
  local options=("1. View Logs (cat)")
  [ "$j_status" = "RUNNING" ] && options+=("2. Tail Logs (live)")
  [ "$j_status" = "RUNNING" ] && options+=("3. Cancel Job (kill)")
  options+=("4. Restart Job")
  options+=("5. Clear Selected Job History")
  options+=("6. Clear ALL Job History")

  local action
  action=$(printf '%s
' "${options[@]}" | fzf --prompt="Select Action > ")

  case "$action" in
    1*)
      if [ -f "$j_log" ]; then
        echo -e "${CB_CYAN}--- LOGS ($j_log) ---${C_RESET}"
        cat "$j_log"
        echo -e "${CB_CYAN}---------------------${C_RESET}"
      else
        echo -e "${CB_RED}🚨 Log file missing ($j_log).${C_RESET}"
      fi
      ;;
    2*)
      [ -f "$j_log" ] && tail -f "$j_log" || echo -e "${CB_RED}🚨 Log file missing ($j_log).${C_RESET}"
      ;;
    3*)
      if [ "$j_status" = "RUNNING" ]; then
        kill -9 "$j_pid" 2> /dev/null
        local tmp_m
        tmp_m=$(mktemp)
        awk -F'|' -v id="$j_id" -v e="$current_time" 'BEGIN{OFS="|"}$1==id{$5=e;$6="CANCELLED"}{print $0}' "$jobs_file" > "$tmp_m" && mv "$tmp_m" "$jobs_file"
        echo -e "${CB_GREEN}✅ Job cancelled.${C_RESET}"
      fi
      ;;
    4*)
      local new_log
      new_log="${LOG_DIR:-$HOME/.bash.d/data/logs}/indexer_$(date +%s).log"
      __mt_bg_run "${j_name}" "$new_log" "$j_cmd"
      ;;
    5*)
      local tmp_m
      tmp_m=$(mktemp)
      grep -v "^${j_id}|" "$jobs_file" > "$tmp_m" && mv "$tmp_m" "$jobs_file"
      [ -f "$j_log" ] && rm -f "$j_log"
      echo -e "${CB_GREEN}✅ Selected job history cleared.${C_RESET}"
      ;;
    6*)
      true > "$jobs_file"
      echo -e "${CB_GREEN}✅ All job history cleared.${C_RESET}"
      ;;
  esac
}

#######################################
# System: List and manage MT background jobs
# Usage: mt-jobs [-i|--interactive] [-p|--purge] [-c|--clean]
#######################################
mt-jobs() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local jobs_file="$HOME/.bash.d/data/cache/.mt_jobs.tsv"

  local interactive=false do_purge=false do_clean=false
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -i | --interactive) interactive=true ;;
      -p | --purge) do_purge=true ;;
      -c | --clean) do_clean=true ;;
      *)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
    esac
    shift
  done

  if [ ! -f "$jobs_file" ] || [ ! -s "$jobs_file" ]; then
    echo -e "${CB_YELLOW}⚠️ No background jobs found.${C_RESET}"
    return 0
  fi

  local current_time
  current_time=$(date +%s)

  if [ "$do_purge" = true ]; then
    __mt_jobs_purge
    return 0
  fi

  if [ "$do_clean" = true ]; then
    __mt_jobs_clean
    return 0
  fi

  __mt_jobs_reap_orphans

  local tmp_out
  __mt_jobs_render_table

  if [ "$interactive" = false ]; then
    __mt_jobs_print_table
    return 0
  fi

  __mt_jobs_interactive_select
}

#######################################
# System: Restore framework from a zip backup
# Usage: mt-restore [backup_file] [-i|--interactive]
# Options:
#   -i, --interactive  Choose a backup from an fzf menu
#######################################
mt-restore() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local selected_backup=""
  local backup_base_dir="${BACKUP_DIR:-$HOME/backups}"

  if [ -n "$1" ] && [ "$1" != "-i" ] && [ "$1" != "--interactive" ]; then
    if [ -f "$1" ]; then
      selected_backup="$1"
    elif [ -f "${backup_base_dir}/$1" ]; then
      selected_backup="${backup_base_dir}/$1"
    elif [ -f "${backup_base_dir}/bashd/$1" ]; then
      selected_backup="${backup_base_dir}/bashd/$1"
    else
      echo -e "${CB_RED}🚨 Backup file not found: $1${C_RESET}"
      return 1
    fi
  else
    echo -e "${CB_BLUE}🔍 Scanning for available backups in ${backup_base_dir}...${C_RESET}"
    local tmp_list
    tmp_list=$(mktemp)
    find "$backup_base_dir" -type f -name "*.zip" 2> /dev/null | sort -r > "$tmp_list"

    if [ ! -s "$tmp_list" ]; then
      echo -e "${CB_YELLOW}⚠️ No backup zip files found in ${backup_base_dir}.${C_RESET}"
      rm -f "$tmp_list"
      return 1
    fi

    selected_backup=$(fzf --prompt="Select Backup to Restore > " --header="Available Framework Backups" < "$tmp_list")
    rm -f "$tmp_list"

    [ -z "$selected_backup" ] && return 0
  fi

  echo -e "${CB_CYAN}📦 Selected Backup: ${selected_backup}${C_RESET}"
  read -r -p "🚀 Are you sure you want to restore this backup? [y/N] " -n 1
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${CB_RED}🛑 Restore aborted.${C_RESET}"
    return 0
  fi

  # 1. Pre-restore Safety Backup
  echo -e "${CB_BLUE}🛡️ Creating safety backup of current codebase before restoring...${C_RESET}"
  local pre_dest="${backup_base_dir}/pre-restore"
  mkdir -p "$pre_dest"
  local timestamp
  timestamp=$(date +"%Y%m%d_%H%M%S")
  local safety_file="${pre_dest}/pre_restore_safety_${timestamp}.zip"

  (
    cd "$HOME" || exit 1
    zip -q -r "$safety_file" .bash.d -x ".bash.d/.git/*" -x ".bash.d/data/cache/*" -x ".bash.d/node_modules/*" -x ".bash.d/**/__pycache__/*"
  )
  echo -e "${CB_GREEN}✅ Safety backup saved: ${safety_file}${C_RESET}"

  # 2. Extract selected backup
  echo -e "${CB_YELLOW}🔄 Restoring .bash.d directory...${C_RESET}"
  if ! unzip -q -o "$selected_backup" -d "$HOME/"; then
    echo -e "${CB_RED}🚨 Unzip failed during restore!${C_RESET}"
    return 1
  fi

  # 3. Sync to Git Workspace
  local git_repo_path="${DOTFILES_DIR:-$HOME/vcs/personal/mt-devops-framework}"
  if [ -d "$git_repo_path" ]; then
    echo -e "${CB_BLUE}🔄 Syncing restored files to Git workspace (${git_repo_path})...${C_RESET}"
    rsync -a -u --delete "$HOME/.bash.d/" "${git_repo_path}/.bash.d/"
  fi

  echo -e "${CB_GREEN}🎉 Restore complete! Rebuilding caches...${C_RESET}"
  mt-refresh-caches > /dev/null 2>&1
}

#######################################
# System: Display history of executed framework commands
# Usage: mt-cmd-history [-i|--interactive] [-n count]
# Options:
#   -i, --interactive  Select a past framework command via fzf to re-run
#   -n, --lines <num>  Number of entries to show (default: 20)
#######################################
#######################################
# System: Display history of executed framework commands
# Usage: mt-cmd-history [-i|--interactive] [-n count]
# Options:
#   -i, --interactive  Select a past framework command via fzf to re-run
#   -n, --lines <num>  Number of entries to show (default: 20)
#######################################

#######################################
# System: Display history of executed framework commands
# Usage: mt-cmd-history [-i|--interactive] [-n count]
# Options:
#   -i, --interactive  Select a past framework command via fzf to re-run
#   -n, --lines <num>  Number of entries to show (default: 20)
#######################################

#######################################
# System: Display history of executed framework commands
# Usage: mt-cmd-history [-i|--interactive] [-n count]
# Options:
#   -i, --interactive  Select a past framework command via fzf to re-run
#   -n, --lines <num>  Number of entries to show (default: 20)
#######################################

#######################################
# System: Display history of executed framework commands
# Usage: mt-cmd-history [-i|--interactive] [-n count]
# Options:
#   -i, --interactive  Select a past framework command via fzf to re-run
#   -n, --lines <num>  Number of entries to show (default: 20)
#######################################

#######################################
# System: Display history of executed framework commands
# Usage: mt-cmd-history [-i|--interactive] [-n count]
# Options:
#   -i, --interactive  Select a past framework command via fzf to re-run
#   -n, --lines <num>  Number of entries to show (default: 20)
#######################################

#######################################
# System: Display history of executed framework commands
# Usage: mt-cmd-history [-i|--interactive] [-n count]
# Options:
#   -i, --interactive  Select a past framework command via fzf to re-run
#   -n, --lines <num>  Number of entries to show (default: 20)
#######################################
mt-cmd-history() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local interactive=false
  local limit=20

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -i | --interactive) interactive=true ;;
      -n | --lines)
        limit="$2"
        shift
        ;;
      *)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
    esac
    shift
  done

  local tsv_file="$HOME/.bash.d/data/cache/.mt_data.tsv"
  if [ ! -f "$tsv_file" ]; then
    mt-refresh-caches > /dev/null 2>&1
  fi

  local tmp_cmds tmp_hist
  tmp_cmds=$(mktemp)
  tmp_hist=$(mktemp)

  # Extract list of framework functions and aliases into a clean file
  awk -F"\t" "{print \$3}" "$tsv_file" | sort -u | grep -v "^$" > "$tmp_cmds"

  if [ ! -s "$tmp_cmds" ]; then
    echo -e "${CB_RED}🚨 Failed to load framework command definitions.${C_RESET}"
    rm -f "$tmp_cmds" "$tmp_hist"
    return 1
  fi

  # Flush current in-memory history to disk
  history -a 2> /dev/null || true

  local hist_source="$HOME/.bash_history"

  if [ -f "$hist_source" ]; then
    # Force grep -a (text mode) and strip non-printable characters
    strings "$hist_source" 2> /dev/null | grep -a -v -E "^(#|[[:space:]]*$)" |
      sed "s/^[[:space:]]*[0-9]*[[:space:]]*//" |
      awk -v cmd_file="$tmp_cmds" '
      BEGIN {
        while ((getline line < cmd_file) > 0) {
          if (line != "") cmds[line] = 1
        }
        close(cmd_file)
      }
      {
        cmd = $1
        sub(/^.*::/, "", cmd)
        
        # Match only if the FIRST word is an exact framework tool name
        if (cmd in cmds) {
          print $0
        }
      }
    ' | awk "!seen[\$0]++" | tail -n "$limit" > "$tmp_hist"
  fi

  rm -f "$tmp_cmds"

  if [ ! -s "$tmp_hist" ]; then
    echo -e "${CB_YELLOW}⚠️ No recorded framework commands found in shell history.${C_RESET}"
    rm -f "$tmp_hist"
    return 0
  fi

  if [ "$interactive" = true ]; then
    local selected_cmd
    selected_cmd=$(fzf --prompt="Re-run Framework Command > " --header="Framework Command History" < "$tmp_hist")
    rm -f "$tmp_hist"

    if [ -n "$selected_cmd" ]; then
      echo -e "${CB_GREEN}🚀 Executing:${C_RESET} ${selected_cmd}"
      eval "$selected_cmd"
    fi
  else
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    echo -e "${CB_CYAN} 📜 Recent Framework Command History${C_RESET}"
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    awk -v yellow="$CB_YELLOW" -v white="$C_WHITE" -v rst="$C_RESET" '{printf "  %s%3d%s  %s%s%s\n", yellow, NR, rst, white, $0, rst}' "$tmp_hist"
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    echo -e "${C_DIM}Run 'mt-history -i' to select and re-run a command via fzf.${C_RESET}"
    rm -f "$tmp_hist"
  fi
}

#######################################
# System: Display history of executed framework commands (Alias)
#######################################
alias mt-history="mt-cmd-history"

#6666666666666666666666666666666666666666
# System: Safely execute or write clipboard code without terminal paste truncation
# Usage: mt-apply [optional_target_file_path]
#6666666666666666666666666666666666666666

#6666666666666666666666666666666666666666
# System: Safely execute or write clipboard code without terminal paste truncation
# Usage: mt-apply [optional_target_file_path]
#6666666666666666666666666666666666666666

#######################################
# System: Safely execute or write clipboard code without terminal paste truncation
# Usage: mt-apply [optional_target_file_path]
#######################################

#######################################
# System: Safely execute or write clipboard code without terminal paste truncation
# Usage: mt-apply [optional_target_file_path]
#######################################

#######################################
# System: Safely execute or write clipboard code without terminal paste truncation
# Usage: mt-apply [optional_target_file_path]
#######################################
#######################################
# System: Safely execute or write clipboard code without terminal paste truncation
# Usage: mt-apply [optional_target_file_path]
#######################################
mt-apply() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local tmp_raw tmp_clean
  tmp_raw=$(mktemp /tmp/mt_apply_raw_XXXXXX)
  tmp_clean=$(mktemp /tmp/mt_apply_clean_XXXXXX)
  local target_file="${1:-}"

  if command -v powershell.exe > /dev/null 2>&1; then
    powershell.exe -Command "Get-Clipboard" | tr -d "\r" > "$tmp_raw"
  elif command -v xclip > /dev/null 2>&1; then
    xclip -o -selection clipboard > "$tmp_raw"
  elif command -v pbpaste > /dev/null 2>&1; then
    pbpaste > "$tmp_raw"
  else
    echo -e "${CB_RED}🚨 No clipboard helper found.${C_RESET}"
    rm -f "$tmp_raw" "$tmp_clean"
    return 1
  fi

  if [ ! -s "$tmp_raw" ]; then
    echo -e "${CB_YELLOW}⚠️ Clipboard is empty!${C_RESET}"
    rm -f "$tmp_raw" "$tmp_clean"
    return 1
  fi

  grep -v -E "^[[:space:]]*\`\`\`" "$tmp_raw" | sed -E "s/^[[:space:]]*\$[[:space:]]*//" > "$tmp_clean"

  if [ -n "$target_file" ]; then
    mkdir -p "$(dirname "$target_file")"
    mv "$tmp_clean" "$target_file"
    rm -f "$tmp_raw"
    echo -e "${CB_GREEN}✅ Successfully written clipboard content to ${target_file}!${C_RESET}"
    return 0
  fi

  if python3 -c 'import sys; txt=open(sys.argv[1]).read(); sys.exit(0 if ("import " in txt or "shutil." in txt or "os.path" in txt) and not "python3 -c" in txt else 1)' "$tmp_clean"; then
    echo -e "${CB_BLUE}⚡ Executing native Python script from clipboard...${C_RESET}"
    python3 "$tmp_clean"
  else
    echo -e "${CB_BLUE}⚡ Executing Bash script from clipboard...${C_RESET}"
    bash "$tmp_clean"
  fi

  local exit_code=$?
  rm -f "$tmp_raw" "$tmp_clean"
  return $exit_code
}

# Load local un-versioned secrets if they exist
if [ -f "$HOME/.bash.d/config/github_token.sh" ]; then
  # shellcheck disable=SC1091
  source "$HOME/.bash.d/config/github_token.sh"
fi
