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
