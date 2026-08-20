# shellcheck shell=bash
#######################################
# Docker: Restart all currently running Docker containers
# Globals:
#   DOCKER_BLOCKLIST
# Arguments:
#   -x <container_name,container_name>  Comma-separated list of containers to exclude
#######################################
docker-reboot-all() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local manual_excludes=""

  local OPTIND opt
  while getopts "x:" opt; do
    case ${opt} in
      x) manual_excludes="$OPTARG" ;;
      \?)
        echo "Usage: docker-reboot-all [-x container1,container2]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  # Combine permanent config blocklist with manual exclusions
  local full_excludes="${DOCKER_BLOCKLIST}"
  if [ -n "$manual_excludes" ]; then
    if [ -n "$full_excludes" ]; then
      full_excludes="${full_excludes},${manual_excludes}"
    else
      full_excludes="${manual_excludes}"
    fi
  fi

  # Build the filter string for docker ps
  local filter_args=""
  if [ -n "$full_excludes" ]; then
    # Convert comma-separated string to array, safely handling spaces
    IFS=',' read -ra exclude_arr <<< "$full_excludes"
    for item in "${exclude_arr[@]}"; do
      # Trim leading/trailing whitespace
      local trimmed_item
      trimmed_item=$(echo "$item" | xargs)
      if [ -n "$trimmed_item" ]; then
        filter_args+=" --filter name=^/(?!${trimmed_item}$).*$"
      fi
    done
  fi

  local running_containers
  if [ -n "$filter_args" ]; then
    # Note: Docker's native negative filtering is tricky.
    # It's safer to grab all running, then use grep to exclude.
    running_containers=$(docker ps --format "{{.Names}}" | grep -Ev "^($(echo "$full_excludes" | sed 's/,/|/g' | sed 's/ //g'))$")
  else
    running_containers=$(docker ps --format "{{.Names}}")
  fi

  if [ -z "$running_containers" ]; then
    echo "⚠️ No running Docker containers found matching the criteria."
    return 0
  fi

  echo "🔄 Restarting containers..."
  for container in $running_containers; do
    echo "   Stopping -> Starting: $container"
    docker restart "$container" > /dev/null
  done
  echo "✅ Restart complete."
}

#######################################
# Docker: List all running containers in a clean table format
#######################################
docker-ls() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
}

#######################################
# Docker: Interactive fuzzy-finder to exec into a running container
#######################################
docker-shell() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local target
  target=$(docker ps --format "{{.Names}}" | fzf --prompt="🐳 Select Container > " --height=~10 --layout=reverse --border)

  if [ -n "$target" ]; then
    echo -e "${CB_GREEN}🚀 Entering sandbox for: ${target}...${C_RESET}"
    # Try bash first, fallback to standard sh if bash isn't installed in the container
    docker exec -it "$target" /bin/bash || docker exec -it "$target" /bin/sh
  else
    echo "⚠️ Selection cancelled."
  fi
}

#######################################
# Docker: Aggressive cleanup of all unused containers, images, and volumes
#######################################
docker-nuke() {
  if [[ "$1" == "--dry-run" ]]; then
    echo "🔍 Simulating destruction of unused Docker resources..."
    docker system prune -a --volumes
    return 0
  elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_RED}⚠️  WARNING: This will destroy all stopped containers, unused networks, dangling images, and unused volumes.${C_RESET}"
  read -p "Are you sure you want to proceed? [y/N] " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "💥 Nuking unused Docker resources..."
    docker system prune -a --volumes -f
    echo -e "${CB_GREEN}✅ Docker environment sanitized.${C_RESET}"
  else
    echo "🛑 Aborted."
  fi
}

#######################################
# Docker: Spin up a temporary, throwaway container sandbox
# Arguments:
#   $1 - Target image (default: debian)
#######################################
docker-sandbox() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local image="${1:-debian}"
  echo -e "${CB_BLUE}🚀 Launching temporary ${image} sandbox...${C_RESET}"

  docker run --rm -it "$image" /bin/bash || docker run --rm -it "$image" /bin/sh
}

#######################################
# Docker: Concurrently tail logs from multiple selected containers
#######################################
docker-tail() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  # 1. Select containers using fzf multi-select (Tab to select multiple)
  local selected
  selected=$(docker ps --format "{{.Names}}" | fzf --multi --prompt="🐳 Select Containers (TAB to multi-select) > " --height=~15 --layout=reverse --border)

  if [ -z "$selected" ]; then
    echo "⚠️ No containers selected."
    return 0
  fi

  # Replace newlines with spaces for the printout
  local flat_selected
  flat_selected=$(echo "$selected" | tr '\n' ' ')

  echo -e "${CB_GREEN}🚀 Tailing logs for: ${flat_selected}${C_RESET}"
  echo -e "${C_DIM}(Press Ctrl+C to stop)${C_RESET}\n"

  # Array of distinct ANSI colors for the prefixes
  local colors=("\e[36m" "\e[32m" "\e[33m" "\e[34m" "\e[35m" "\e[31m")
  local color_reset="\e[0m"

  # Keep track of background PIDs so we can cleanly kill them later
  local pids=()

  # Cleanup trap to kill all background streams when Ctrl+C is pressed
  cleanup() {
    echo -e "\n${CB_YELLOW}🛑 Stopping all log streams...${C_RESET}"
    kill "${pids[@]}" 2> /dev/null || true
  }
  trap cleanup SIGINT

  # Loop through selected containers, attach a color, and tail in the background
  local i=0
  for container in $selected; do
    local color="${colors[$((i % ${#colors[@]}))]}"

    # 2>&1 redirects stderr to stdout (catching error logs).
    # Apply OS-specific unbuffered flags to sed
    local sed_buf="-u"
    [ "$OS_FAMILY" = "macos" ] && sed_buf="-l"
    docker logs -f --tail 50 "$container" 2>&1 | sed "$sed_buf" "s/^/${color}[$container]${color_reset} /" &
    pids+=($!)

    ((i++))
  done

  # Wait for all background processes to finish (or until trap is triggered)
  wait "${pids[@]}" 2> /dev/null || true

  # Remove the trap once finished
  trap - SIGINT
}

#######################################
# AI: Retrieves a prompt string from the centralized prompts.yaml
# Arguments:
#   $1 - The key of the prompt to retrieve
#######################################
__get_prompt() {
  python3 "$HOME/.bash.d/lib/python/get_prompt.py" "$1"
}

#######################################
# System: Centralized logging with colored output
#######################################
mt-log() {
  local level="$1"
  shift
  local msg="$*"
  local log_file="$HOME/.bash.d/.mt_log"
  local timestamp
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")

  echo "[$timestamp] [$level] $msg" >> "$log_file"

  case "$level" in
    INFO) echo -e "${CB_BLUE}ℹ️  ${msg}${C_RESET}" ;;
    WARN) echo -e "${CB_YELLOW}⚠️  ${msg}${C_RESET}" ;;
    ERROR) echo -e "${CB_RED}🚨 ${msg}${C_RESET}" ;;
    SUCCESS) echo -e "${CB_GREEN}✅ ${msg}${C_RESET}" ;;
    *) echo -e "$msg" ;;
  esac
}

#######################################
# Framework: Scaffold a new repository using standardized DevOps blueprints
# Arguments:
#   -t <blueprint> (Optional) Name of the blueprint to use
#######################################
mt-blueprint() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local blueprints_dir="$HOME/.bash.d/lib/blueprints"
  if [ ! -d "$blueprints_dir" ]; then
    echo -e "${CB_RED}🚨 Error: Blueprints directory not found at $blueprints_dir${C_RESET}"
    return 1
  fi

  local target=""
  local OPTIND opt
  while getopts "t:" opt; do
    case ${opt} in
      t) target="$OPTARG" ;;
      \?)
        echo "Usage: mt-blueprint [-t <blueprint_name>]" >&2
        return 1
        ;;
    esac
  done

  if [ -z "$target" ]; then
    target=$(find "$blueprints_dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | fzf --prompt="🏗️  Select Blueprint > " --height=~10 --layout=reverse --border)
  fi

  if [ -z "$target" ]; then
    echo "⚠️  Blueprint selection cancelled."
    return 0
  fi

  # Safeguard: Check if the directory is not empty
  if [ "$(ls -A 2> /dev/null)" ]; then
    echo -e "\n${CB_YELLOW}⚠️  WARNING: The current directory is not empty.${C_RESET}"
    echo -e "${CB_YELLOW}Applying this blueprint may overwrite existing files like README.md or .gitignore.${C_RESET}"
    read -r -p "Are you sure you want to proceed? [y/N] " -n 1
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "🛑 Aborted."
      return 0
    fi
  fi

  local source_dir="${blueprints_dir}/${target}"
  if [ ! -d "$source_dir" ]; then
    echo -e "${CB_RED}🚨 Error: Blueprint '$target' does not exist.${C_RESET}"
    return 1
  fi

  local project_name
  project_name=$(basename "$PWD")
  echo -e "${CB_BLUE}🏗️  Scaffolding '$target' into $PWD...${C_RESET}"

  # Copy blueprint files into the current directory
  cp -R "$source_dir/"* . 2> /dev/null || true
  cp -R "$source_dir/".[!.]* . 2> /dev/null || true

  # Replace placeholders dynamically
  if [ "$(uname)" = "Darwin" ]; then
    find . -type f -not -path "*/\.git/*" -print0 | xargs -0 -I {} sed -i '' "s/{{PROJECT_NAME}}/$project_name/g" {} 2> /dev/null
  else
    find . -type f -not -path "*/\.git/*" -print0 | xargs -0 -I {} sed -i "s/{{PROJECT_NAME}}/$project_name/g" {} 2> /dev/null
  fi

  # Initialize Git if not already tracked
  if [ ! -d ".git" ]; then
    echo "📦 Initializing Git repository..."
    git init -q
  fi

  # Route CI/CD pipelines
  if [ -d ".cicd_templates" ]; then
    local provider="${CICD_PROVIDER:-github}"
    if [ -d ".cicd_templates/$provider" ]; then
      echo -e "${CB_BLUE}⚙️  Injecting $provider pipeline configuration...${C_RESET}"
      cp -a ".cicd_templates/$provider/." .
    else
      echo -e "${CB_YELLOW}⚠️  No $provider pipeline template available for this blueprint. Skipping CI/CD generation.${C_RESET}"
    fi
    rm -rf ".cicd_templates"
  fi

  if type mt-log > /dev/null 2>&1; then
    mt-log SUCCESS "Blueprint '$target' applied successfully!"
  else
    echo -e "${CB_GREEN}✅ Blueprint '$target' applied successfully!${C_RESET}"
  fi
}
