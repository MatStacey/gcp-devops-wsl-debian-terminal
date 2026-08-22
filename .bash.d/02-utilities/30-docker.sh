# shellcheck shell=bash
# ------------------------------------------
# Docker: Container Management Utilities
# ------------------------------------------
# ~/.bash.d/02-utilities/30-docker.sh

#######################################
# Docker: Restart all currently running Docker containers
# Usage: docker-reboot-all [-x container1,container2]
# Options:
#   -x <names>  Comma-separated list of container names to exclude, in
#               addition to the permanent DOCKER_BLOCKLIST
# Globals:
#   DOCKER_BLOCKLIST
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

  local full_excludes="${DOCKER_BLOCKLIST}"
  [ -n "$manual_excludes" ] && full_excludes="${full_excludes:+${full_excludes},}${manual_excludes}"

  local running_containers
  if [ -n "$full_excludes" ]; then
    # Docker's own negative-filter syntax is unreliable across versions;
    # grab everything running and exclude via grep instead.
    local exclude_pattern
    exclude_pattern=$(echo "$full_excludes" | sed 's/,/|/g; s/ //g')
    running_containers=$(docker ps --format "{{.Names}}" | grep -Ev "^(${exclude_pattern})$")
  else
    running_containers=$(docker ps --format "{{.Names}}")
  fi

  if [ -z "$running_containers" ]; then
    mt-log WARN "No running Docker containers found matching the criteria."
    return 0
  fi

  echo "🔄 Restarting containers..."
  local container
  for container in $running_containers; do
    echo "   Stopping -> Starting: $container"
    docker restart "$container" > /dev/null
  done
  echo -e "${CB_GREEN}✅ Restart complete.${C_RESET}"
}

#######################################
# Docker: List all running containers in a clean table format
# Usage: docker-ls
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
# Usage: docker-shell
#######################################
docker-shell() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local target
  target=$(docker ps --format "{{.Names}}" | fzf --prompt="🐳 Select Container > " --height=~10 --layout=reverse --border)

  if [ -z "$target" ]; then
    echo -e "${CB_YELLOW}⚠️  Selection cancelled.${C_RESET}"
    return 0
  fi

  echo -e "${CB_GREEN}🚀 Entering sandbox for: ${target}...${C_RESET}"
  # Try bash first, fallback to standard sh if bash isn't installed in the container
  docker exec -it "$target" /bin/bash || docker exec -it "$target" /bin/sh
}

#######################################
# Docker: Aggressive cleanup of all unused containers, images, and volumes
# Usage: docker-nuke [--dry-run]
# Options:
#   --dry-run  Show what would be removed without actually deleting anything
#######################################
docker-nuke() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  if [[ "$1" == "--dry-run" ]]; then
    echo "🔍 Simulating destruction of unused Docker resources..."
    docker system prune -a --volumes
    return 0
  fi

  echo -e "${CB_RED}⚠️  WARNING: This will destroy all stopped containers, unused networks, dangling images, and unused volumes.${C_RESET}"
  read -r -p "Are you sure you want to proceed? [y/N] " -n 1 < /dev/tty || REPLY="n"
  echo

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${CB_YELLOW}🛑 Aborted.${C_RESET}"
    return 0
  fi

  echo "💥 Nuking unused Docker resources..."
  docker system prune -a --volumes -f
  mt-log SUCCESS "Docker environment sanitized."
}

#######################################
# Docker: Spin up a temporary, throwaway container sandbox
# Usage: docker-sandbox [image]
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
# Docker: Kill every backgrounded 'docker logs' stream started by
# docker-tail and clear its interrupt trap
# Globals (read):
#   pids
#######################################
__docker_tail_cleanup() {
  echo -e "\n${CB_YELLOW}🛑 Stopping all log streams...${C_RESET}"
  kill "${pids[@]}" 2> /dev/null || true
}

#######################################
# Docker: Concurrently tail logs from multiple selected containers, each
# prefixed with a distinct color
# Usage: docker-tail
# Globals:
#   OS_FAMILY
#######################################
docker-tail() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local selected
  selected=$(docker ps --format "{{.Names}}" | fzf --multi --prompt="🐳 Select Containers (TAB to multi-select) > " --height=~15 --layout=reverse --border)

  if [ -z "$selected" ]; then
    echo -e "${CB_YELLOW}⚠️  No containers selected.${C_RESET}"
    return 0
  fi

  local flat_selected
  flat_selected=$(echo "$selected" | tr '\n' ' ')
  echo -e "${CB_GREEN}🚀 Tailing logs for: ${flat_selected}${C_RESET}"
  echo -e "${C_DIM}(Press Ctrl+C to stop)${C_RESET}\n"

  local colors=("$CB_CYAN" "$CB_GREEN" "$CB_YELLOW" "$CB_BLUE" "$CB_MAGENTA" "$CB_RED")
  local pids=()
  trap __docker_tail_cleanup SIGINT

  local sed_buf="-u"
  [ "$OS_FAMILY" = "macos" ] && sed_buf="-l"

  local i=0 container
  for container in $selected; do
    local color="${colors[$((i % ${#colors[@]}))]}"
    docker logs -f --tail 50 "$container" 2>&1 | sed "$sed_buf" "s/^/${color}[$container]${C_RESET} /" &
    pids+=($!)
    ((i++))
  done

  wait "${pids[@]}" 2> /dev/null || true
  trap - SIGINT
}
