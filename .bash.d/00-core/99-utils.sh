docker-reboot-all() { # => Docker: Restart all currently running Docker containers [Usage: docker-reboot-all]
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local running_containers
  running_containers=$(docker ps -q)

  if [ -z "$running_containers" ]; then
    echo "⚠️ No running Docker containers found."
    return 0
  fi

  echo "🔄 Restarting all running Docker containers..."
  docker restart $running_containers
  echo "✅ All running containers have been restarted."
}
