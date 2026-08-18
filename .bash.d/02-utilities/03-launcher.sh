# shellcheck shell=bash
# ------------------------------------------
# Path & URL Launchers (Config-Driven)
# ------------------------------------------

#######################################
# Config: Change directory to sync repository root
# Arguments:
#   cd-mt-git-local
#######################################
cd-mt-git-local() {
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
#   web-view-profile-homepage
#######################################
mt-open-homepage() {
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
    web_url="${web_url#git@}"    # Strip git@
    web_url="${web_url/:/\/}"    # Swap the domain colon to a slash
    web_url="https://${web_url}" # Prepend the protocol
  fi
  web_url="${web_url%.git}"
  web_url=$(echo "$web_url" | sed -E 's#([^:])//+#\1/#g') # Strip the trailing .git

  echo "🌐 Opening $web_url in browser..."
  __open_url "$web_url"
}

#######################################
# Config: Change directory to unified AI workspace
# Arguments:
#   cd-ai
#######################################
cd-ai-workspace() {
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
win-ai-workspace() {
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

#######################################
# Config: Open current directory in the default IDE (VSCode/IntelliJ)
# Arguments:
#   ide
#######################################
ide() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local selected_ide="${DEFAULT_IDE:-vscode}"
  echo -e "${CB_GREEN}🚀 Opening current directory in ${selected_ide}...${C_RESET}"

  if [ "$selected_ide" = "intellij" ]; then
    __launch_intellij . || echo -e "${CB_RED}⚠️ Could not launch IntelliJ. Ensure 'idea' is on PATH (JetBrains Toolbox), or install IntelliJ IDEA via Homebrew on macOS.${C_RESET}"
  else
    code .
  fi
}

#######################################
# Docker: Change to Docker directory (from config.yaml) and open in Windows Explorer
#######################################
cd-win-docker() {
  # Dynamically pull the path from config.yaml
  local docker_path
  docker_path=$(python3 -c 'import yaml, os; print(yaml.safe_load(open(os.path.expanduser("~/.bash.d/config/config.yaml"))).get("paths", {}).get("docker_root", ""))')

  # Evaluate any tildes (~) or variables in the path
  docker_path=$(eval echo "$docker_path")

  if [ -z "$docker_path" ]; then
    echo -e "${CB_RED}🚨 Error: docker_root is not defined under paths in config.yaml.${C_RESET}"
    return 1
  fi

  if [ -d "$docker_path" ]; then
    echo -e "${CB_BLUE}📂 Navigating to ${docker_path}...${C_RESET}"
    cd "$docker_path" || return 1
    win-docker
  else
    echo -e "${CB_RED}🚨 Error: Directory  does not exist on the Linux filesystem.${C_RESET}"
    return 1
  fi
}
