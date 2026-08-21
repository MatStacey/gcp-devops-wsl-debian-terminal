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
  case "$level" in
    INFO) echo -e "${CB_BLUE}ℹ️ ${msg}${C_RESET}" ;;
    SUCCESS) echo -e "${CB_GREEN}✅ ${msg}${C_RESET}" ;;
    WARN) echo -e "${CB_YELLOW}⚠️ ${msg}${C_RESET}" ;;
    ERROR) echo -e "${CB_RED}🚨 ${msg}${C_RESET}" >&2 ;;
    *) echo "$msg" ;;
  esac
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

  # Explicitly query config.yaml first to ensure we get the latest value even if env cache lags
  local cfg_backup_dir
  cfg_backup_dir=$(python3 -c 'import yaml, os; print(yaml.safe_load(open(os.path.expanduser("~/.bash.d/config/config.yaml"))).get("paths", {}).get("backup_dir", ""))' 2> /dev/null)

  local base_dest="${BACKUP_DIR:-${cfg_backup_dir:-/tmp/backups}}"

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

  # Dynamically load the warning threshold from config.yaml (default 500MB)
  local threshold_mb
  threshold_mb=$(python3 -c 'import yaml, os; print(yaml.safe_load(open(os.path.expanduser("~/.bash.d/config/config.yaml"))).get("system", yaml.safe_load(open(os.path.expanduser("~/.bash.d/config/config.yaml"))).get("core", {})).get("backup_warning_mb", 500))' 2> /dev/null)

  if ! [[ "$threshold_mb" =~ ^[0-9]+$ ]]; then
    echo -e "${CB_RED}🚨 Error: 'backup_warning_mb' in config.yaml is invalid ('$threshold_mb'). It must be a whole number.${C_RESET}"
    return 1
  fi

  if [ "$list_mode" = false ]; then
    echo -e "${CB_BLUE}🔍 Estimating backup payload size...${C_RESET}"
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
    command ls -lth --time-style=+"%Y-%m-%d %H:%M:%S" "$dest" | grep -v '^total' | awk '
      BEGIN {
        printf "\033[01;34m%-55s %-25s %-15s\033[0m\n", "FILENAME", "DATE CREATED", "SIZE"
        printf "\033[01;34m-------------------------------------------------------------------------------------------------\033[0m\n"
      }
      {
        size = $5
        date_created = $6 " " $7
        name = ""
        # Support filenames with spaces just in case
        for(i=8; i<=NF; i++) name = name (i==8?"":" ") $i
        printf "\033[01;36m%-55s\033[0m \033[01;33m%-25s\033[0m \033[01;32m%-15s\033[0m\n", name, date_created, size
      }
    '
    echo ""
    return 0
  fi

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
  echo -e "${CB_BLUE}📦 Backing up ${PWD} to ${backup_file}...${C_RESET}"

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
    echo -e "${CB_GREEN}✅ Backup complete: ${backup_file} (${file_size})${C_RESET}"

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
    echo -e "${CB_RED}🚨 Backup failed.${C_RESET}"
  fi
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
    ls -la "$vcs_dir" | grep -vE "(external|personal|work|workspaces|misc)"
  fi
}
