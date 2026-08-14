# shellcheck shell=bash
# ------------------------------------------
# Path & URL Launchers (Config-Driven)
# ------------------------------------------

#######################################
# Config: Change directory to sync repository root
# Arguments:
#   cd-sync
#######################################
cd-sync() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  cd "$SYNC_REPO_DIR" || echo "🚨 Error: SYNC_REPO_DIR not set."
}

#######################################
# Config: Open sync repository in the platform's native file manager
# Arguments:
#   win-sync
#######################################
win-sync() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "$SYNC_REPO_DIR"
}

#######################################
# Config: Open sync repository remote URL in default web browser
# Arguments:
#   sync-web
#######################################
sync-web() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$SYNC_REPO_URL" ] || [ "$SYNC_REPO_URL" = "YOUR_SYNC_REPO_URL" ]; then
    echo "🚨 Error: No sync repository URL configured."
    return 1
  fi
  local web_url="$SYNC_REPO_URL"
  if [[ "$web_url" == git@* ]]; then
    web_url="https://${web_url#git@}"
    web_url="${web_url/:/\/}"
  fi
  web_url="${web_url%.git}"
  echo "🌐 Opening $web_url in browser..."
  __open_url "$web_url"
}

#######################################
# Config: Change directory to unified AI workspace
# Arguments:
#   cd-ai
#######################################
cd-ai() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  cd "$AI_WORKSPACE_DIR" || echo "🚨 Error: AI_WORKSPACE_DIR not set."
}

#######################################
# Config: Open unified AI workspace in the platform's native file manager
# Arguments:
#   win-ai
#######################################
win-ai() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "$AI_WORKSPACE_DIR"
}

#######################################
# Config: Open Docker root directory in the platform's native file manager
# Arguments:
#   win-docker
#######################################
win-docker() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "$DOCKER_ROOT_DIR"
}
