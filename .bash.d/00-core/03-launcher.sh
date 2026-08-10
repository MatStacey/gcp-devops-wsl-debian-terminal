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
# Config: Open sync repository in Windows File Explorer
# Arguments:
#   win-sync
#######################################
win-sync() {
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		mt-help "${FUNCNAME[0]}"
		return 0
	fi
	explorer.exe "$(wslpath -w "$SYNC_REPO_DIR")" 2>/dev/null
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
	explorer.exe "$web_url" >/dev/null 2>&1
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
# Config: Open unified AI workspace in Windows File Explorer
# Arguments:
#   win-ai
#######################################
win-ai() {
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		mt-help "${FUNCNAME[0]}"
		return 0
	fi
	explorer.exe "$(wslpath -w "$AI_WORKSPACE_DIR")" 2>/dev/null
}
