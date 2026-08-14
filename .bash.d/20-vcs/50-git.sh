# shellcheck shell=bash
# ------------------------------------------
# Version Control (Git)
# ------------------------------------------

#######################################
# Clones and initializes a repository into the sync directory.
# Arguments:
#   $1 - The target repository directory path.
#   $2 - The remote origin URL to bind to.
# Outputs:
#   Writes clone or init status to STDOUT.
# Returns:
#   0 on success.
#######################################
# Synchronizes the active bash config files over to the tracked git directory.
# Strips sensitive yaml keys dynamically via rsync exclusions.
# Globals:
#   HOME
# Arguments:
#   $1 - The target repository directory path.
#######################################
# Analyzes git diffs and calls the Gemini API to systematically generate
# separate commits for each logical feature/change.
# Globals:
#   GEMINI_API_KEY, AI_MAX_DIFF_BYTES, GEMINI_VERSION
# Arguments:
#   $1 - The target repository directory path.
# Outputs:
#   Executes git add and git commit commands sequentially.
# Returns:
#   0 on success or graceful fallback bypass.
#######################################
# Git: Sync local bash configs to terminal repo and push (AI-powered systematic commits)
# Globals:
#   SYNC_REPO_DIR
#   SYNC_REPO_URL
# Arguments:
#   $1 - Optional string message. If empty, triggers AI systematic feature grouping.
# Outputs:
#   Writes sync, diff, and execution state to STDOUT.
# Returns:
#   0 on success, 1 on misconfigured URL path.
#######################################
# Git: Add all files, intelligently group via AI, and push [Usage: git-ai-pc [optional message]]
#######################################
# Git: Create and checkout a new feature branch
# Globals:
#   GIT_FEATURE_PREFIX
# Arguments:
#   $1 - Jira ticket ID or branch descriptor suffix.
# Returns:
#   0 on success, 1 on empty argument input.
#######################################
git-feature() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  [ -z "$1" ] && {
    echo -e "🚨 Error: Jira ID / branch suffix cannot be empty.\nUsage: git-chk-feat CCON-123"
    return 1
  }

  git checkout -b "${GIT_FEATURE_PREFIX:-feature/}$1"
}

#######################################
# Git: Wrapper to force 'clone' into ~/vcs/ from anywhere
# Globals:
#   VCS_ROOT
# Outputs:
#   Writes execution path modification data to STDOUT.
# Returns:
#   Passes through standard git return codes.
#######################################
git() {
  # Deliberately does NOT intercept -h/--help here (unlike other mytools
  # wrappers) — this wraps a real command with its own --help, and
  # shadowing it broke `git --help`/`git <subcommand> --help` entirely.
  # Use `mt-help git` for the custom doc block instead.
  if [ "$1" != "clone" ]; then
    command git "$@"
    return $?
  fi

  shift
  mkdir -p "$VCS_ROOT"
  echo "📥 Intercepting 'git clone': Redirecting to $VCS_ROOT/..."
  if (cd "$VCS_ROOT" && command git clone "$@"); then
    local repo_name
    repo_name=$(basename "${@: -1}" .git)
    echo -e "\n✅ Repository cloned successfully.\n💡 To navigate to it, run: cd $VCS_ROOT/$repo_name"
  fi
}

#######################################
# Git: Open the current repository in the default web browser
# Outputs:
#   Opens the remote URL via the platform's default browser launcher.
# Returns:
#   0 on success, 1 if no upstream origin is found.
#######################################
git-web() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  local origin_url
  origin_url=$(git config --get remote.origin.url 2> /dev/null)

  [ -z "$origin_url" ] && {
    echo "🚨 Error: No remote 'origin' found for the current repository."
    return 1
  }

  local web_url="$origin_url"
  if [[ "$web_url" == git@* ]]; then
    web_url="${web_url#git@}"
    web_url="${web_url/:/\//}"
    web_url="https://${web_url}"
  fi

  web_url="${web_url%.git}"
  web_url=$(echo "$web_url" | sed -E 's#([^:])//+#\1/#g')
  echo "🌐 Opening $web_url in browser..."
  __open_url "$web_url"
}

#######################################
# Git: Clone a repository into ~/vcs/, cd into it, and open in IDE
# Globals:
#   DEFAULT_IDE, VCS_ROOT
# Arguments:
#   -ide <ide_name> Override default IDE variable
#   <url> The target repository string.
# Returns:
#   0 on success, 1 on empty URL parameter or git clone failure.
#######################################
git-ide() {
  local selected_ide="${DEFAULT_IDE:-vscode}"
  local repo_url=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h | --help)
        mt-help "${FUNCNAME[0]}"
        return 0
        ;;
      -ide)
        selected_ide="$2"
        shift 2
        ;;
      *)
        repo_url="$1"
        shift
        ;;
    esac
  done

  [ -z "$repo_url" ] && {
    echo -e "🚨 Error: Repository URL cannot be empty.\nUsage: git-ide [-ide vscode|intellij] <repo-url>"
    return 1
  }

  mkdir -p "$VCS_ROOT"
  local repo_name
  repo_name=$(basename "$repo_url" .git)

  echo "📥 Cloning $repo_name to $VCS_ROOT/..."

  if ! git clone "$repo_url" "$VCS_ROOT/$repo_name"; then
    echo "🚨 Error: Clone failed."
    return 1
  fi

  cd "$VCS_ROOT/$repo_name" || return 1
  echo "✅ Moved to $(pwd)"
  echo "🚀 Opening in $selected_ide..."

  [ "$selected_ide" = "intellij" ] &&
    { __launch_intellij . || echo "⚠️ Could not launch IntelliJ. Ensure 'idea' is on PATH (JetBrains Toolbox), or install IntelliJ IDEA via Homebrew on macOS."; } ||
    code -n .
}

#######################################
# Git: Print a beautiful, color-coded, single-line graph log
#######################################
git-lg() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all
}

#######################################
# Git: Safely delete all local branches that have been merged into the default branch
#######################################
git-cleanup() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  # Auto-detect default branch (main or master)
  local default_branch
  default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print $NF}')
  default_branch="${default_branch:-main}"

  echo -e "${CB_BLUE}🧹 Switching to ${default_branch} and pulling latest...${C_RESET}"
  git checkout "$default_branch"
  git pull origin "$default_branch"

  echo -e "\n${CB_YELLOW}🔍 Scanning for merged local branches...${C_RESET}"
  local merged_branches
  merged_branches=$(git branch --merged | grep -v "\*" | grep -v -E "^[[:space:]]*${default_branch}$" || true)

  if [ -z "$merged_branches" ]; then
    echo -e "${CB_GREEN}✅ Workspace is clean. No merged branches found.${C_RESET}"
    return 0
  fi

  echo "$merged_branches" | xargs -n 1 git branch -d
  echo -e "${CB_GREEN}✅ Local branch cleanup complete.${C_RESET}"
}

#######################################
# Git: Fetch upstream and rebase the current branch onto the default branch
#######################################
git-update() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local current_branch
  current_branch=$(git branch --show-current)

  local default_branch
  default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print $NF}')
  default_branch="${default_branch:-main}"

  if [ "$current_branch" = "$default_branch" ]; then
    echo "You are already on the default branch (${default_branch}). Pulling latest..."
    git pull origin "$default_branch"
    return 0
  fi

  echo -e "${CB_BLUE}🔄 Fetching remote and rebasing ${current_branch} onto origin/${default_branch}...${C_RESET}"
  git fetch origin
  git rebase "origin/$default_branch"
}

#######################################
# Git: Hard reset and wipe all untracked files on the current branch
#######################################
git-nuke() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local current_branch
  current_branch=$(git branch --show-current)

  if [ -z "$current_branch" ]; then
    echo "🚨 Error: Not currently on any branch."
    return 1
  fi

  echo -e "${CB_RED}⚠️  WARNING: This will DESTROY all local uncommitted changes AND untracked files.${C_RESET}"
  read -p "Reset '${current_branch}' to origin/${current_branch}? [y/N] " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "💥 Nuking local environment..."
    git fetch origin
    git reset --hard "origin/$current_branch"
    git clean -fd
    echo -e "${CB_GREEN}✅ Branch reset to upstream state.${C_RESET}"
  else
    echo "🛑 Aborted."
  fi
}

#######################################
# Git: Pull latest profile changes from remote and sync to local workspace
#######################################
# Git: Preflight safety checks for AI file generation
# Arguments:
#   $1 - The target filename (e.g., .gitignore, README.md)
#######################################
# Git: Ask AI to generate a comprehensive .gitignore for the current project
#######################################
# Git: Ask AI to generate a comprehensive README.md for the current project
