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
      local trimmed_item=$(echo "$item" | xargs)
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
