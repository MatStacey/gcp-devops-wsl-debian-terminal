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
__git_sync_init_repo() {
  local repo_dir="$1" remote_url="$2"

  [ -d "$repo_dir/.git" ] && return 0

  echo "📥 Local sync directory not found or not initialized."
  mkdir -p "$repo_dir"

  if ! git clone "$remote_url" "$repo_dir" 2> /dev/null; then
    echo "⚠️ Clone failed (likely an empty remote). Initializing local repository..."
    git -C "$repo_dir" init
    git -C "$repo_dir" remote add origin "$remote_url"
  fi

  [ "$(git -C "$repo_dir" remote get-url origin 2> /dev/null)" != "$remote_url" ] &&
    git -C "$repo_dir" remote set-url origin "$remote_url" 2> /dev/null || git -C "$repo_dir" remote add origin "$remote_url"
}

#######################################
# Synchronizes the active bash config files over to the tracked git directory.
# Strips sensitive yaml keys dynamically via rsync exclusions.
# Globals:
#   HOME
# Arguments:
#   $1 - The target repository directory path.
#######################################
__git_sync_copy_files() {
  local repo_dir="$1"

  mkdir -p "$repo_dir/.bash.d"

  # Exclude root files and folders from the subfolder mirror so they do not duplicate
  rsync -a --exclude "config/config.yaml" --exclude "config/.env.cache" --exclude "README.md" --exclude ".bashrc" --exclude "install.sh" --exclude ".gitignore" --exclude ".github" --delete "$HOME/.bash.d/" "$repo_dir/.bash.d/"

  # Explicitly copy individual root files to the repository root for GitHub
  for f in README.md .bashrc install.sh .gitignore; do
    if [ -f "$HOME/.bash.d/$f" ]; then
      cp "$HOME/.bash.d/$f" "$repo_dir/$f"
    fi
  done

  # Explicitly copy root directories to the repository root
  if [ -d "$HOME/.bash.d/.github" ]; then
    cp -r "$HOME/.bash.d/.github" "$repo_dir/"
  fi

  (
    cd "$repo_dir" || exit 1
    [ ! -f ".gitignore" ] || ! grep -q ".bash.d/config/config.yaml" .gitignore 2> /dev/null && sed -i -e '$a\' .gitignore && echo ".bash.d/config/config.yaml" >> .gitignore
    git ls-files --error-unmatch .bash.d/config/config.yaml > /dev/null 2>&1 && git rm -q --cached .bash.d/config/config.yaml
    rm -f .bash.d/config/config.yaml
    git add --all
  )
}

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
__git_sync_ai_commit() {
  local repo_dir="$1"
  local provider="${DEFAULT_AI:-gemini}"

  if [ "$provider" = "gemini" ]; then
    [[ -z "${GEMINI_API_KEY:-}" || "$GEMINI_API_KEY" = "YOUR_GEMINI_API_KEY" ]] && {
      echo "ℹ️ AI commit skipped: GEMINI_API_KEY is not set." >&2
      return 1
    }
  elif [ "$provider" = "claude" ]; then
    [[ -z "${CLAUDE_API_KEY:-}" || "$CLAUDE_API_KEY" = "YOUR_CLAUDE_API_KEY" ]] && {
      echo "ℹ️ AI commit skipped: CLAUDE_API_KEY is not set." >&2
      return 1
    }
  fi

  local bytes_limit="${AI_MAX_DIFF_BYTES:-4000}"
  local diff_content
  diff_content=$(git -C "$repo_dir" diff --staged | head -c "$bytes_limit")

  [ -z "$diff_content" ] && return 0

  echo "🤖 Analyzing changes to generate systematic feature commits using $provider..." >&2

  local ai_prompt="Analyze this git diff and group the changes into logical features/tasks. Return ONLY a valid JSON array of objects representing separate commits. Each object must have a 'files' array (exact file paths from the diff) and a 'message' string (conventional commit format, < 60 chars).\n\nExample Output:\n[\n  { \"files\": [\"path/to/file1\"], \"message\": \"feat: added new module\" }\n]\n\nGit Diff:\n\n$diff_content"

  local response=""
  if [ "$provider" = "gemini" ]; then
    response=$(__ai_query_gemini "$ai_prompt" "" "" "" "")
  elif [ "$provider" = "claude" ]; then
    response=$(__ai_query_claude "$ai_prompt" "" "" "")
  elif [ "$provider" = "local" ]; then
    response=$(__ai_query_local "$ai_prompt" "" "" "")
  else
    echo "🚨 Error: Invalid provider '$provider'." >&2
    return 1
  fi

  # Extract JSON Array, handling schema wrapping, escaped string lists, and raw formats robustly
  local generated_json
  generated_json=$(echo "$response" | python3 -c '
import sys, json, re, ast

text = sys.stdin.read().strip()

def try_parse(val):
    if isinstance(val, list):
        return val
    if isinstance(val, str):
        val_clean = val.strip()
        try:
            res = json.loads(val_clean)
            if isinstance(res, list): return res
        except:
            pass
        try:
            res = ast.literal_eval(val_clean)
            if isinstance(res, list): return res
        except:
            pass
    return None

try:
    data = json.loads(text)
    if isinstance(data, dict):
        # Check message field
        if "message" in data:
            parsed = try_parse(data["message"])
            if parsed is not None:
                print(json.dumps(parsed))
                sys.exit(0)
        # Check code field if message was null/text
        if "code" in data:
            parsed = try_parse(data["code"])
            if parsed is not None:
                print(json.dumps(parsed))
                sys.exit(0)
    elif isinstance(data, list):
        print(json.dumps(data))
        sys.exit(0)
except:
    pass

# Fallback: Regex search for any bracketed list structure in the text
match = re.search(r"(\[.*?\])", text, re.DOTALL)
if match:
    try:
        res = json.loads(match.group(1))
        if isinstance(res, list):
            print(json.dumps(res))
            sys.exit(0)
    except:
        pass
    try:
        res = ast.literal_eval(match.group(1))
        if isinstance(res, list):
            print(json.dumps(res))
            sys.exit(0)
    except:
        pass

print("[]")
' 2> /dev/null)

  if [ -n "$generated_json" ] && echo "$generated_json" | jq -e . > /dev/null 2>&1; then
    # Reset the staging area so we can stage groups individually
    git -C "$repo_dir" reset HEAD > /dev/null 2>&1

    echo "$generated_json" | jq -c '.[]' | while read -r commit_obj; do
      local msg
      msg=$(echo "$commit_obj" | jq -r '.message')
      local files_staged=0

      while read -r file_path; do
        if [ -e "$repo_dir/$file_path" ] || git -C "$repo_dir" ls-files --error-unmatch "$file_path" > /dev/null 2>&1; then
          git -C "$repo_dir" add "$file_path"
          files_staged=1
        fi
      done < <(echo "$commit_obj" | jq -r '.files[]')

      if [ "$files_staged" -eq 1 ]; then
        echo "💡 Committing: $msg"
        git -C "$repo_dir" commit -m "$msg" > /dev/null
      fi
    done
    return 0
  else
    echo "⚠️ Gemini API Debug Response or Invalid JSON: $response" >&2
    return 1
  fi
}

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
mt-push-update() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }

  if command -v google-fmt > /dev/null 2>&1; then
    echo "🧹 Running Google Style code formatting before profile sync..."
    google-fmt
  fi

  local repo_dir="$SYNC_REPO_DIR"
  local remote_url="${SYNC_REPO_URL:-}"

  if [[ -z "$remote_url" || "$remote_url" == "YOUR_SYNC_REPO_URL" || "$remote_url" == "null" ]]; then
    echo -e "\n\033[1;33m⚠️  Profile Sync Not Configured\033[0m"
    echo -e "The \033[1mpush-profile-update\033[0m feature automatically versions and pushes your terminal configuration to a remote Git repository."
    echo "If you downloaded this profile as a standalone ZIP and do not wish to sync it, you can safely ignore this command."
    echo -e "\nTo enable syncing, link an empty remote Git repository by running:"
    echo -e "  \033[1;36madd-sync-url \"git@github.com:username/my-terminal-repo.git\"\033[0m\n"
    return 1
  fi

  echo "🔄 Syncing bash configuration to $repo_dir..."

  __git_sync_init_repo "$repo_dir" "$remote_url"
  __git_sync_copy_files "$repo_dir"

  (
    cd "$repo_dir" || exit 1
    git diff --staged --quiet && {
      echo "✅ Configurations are already up to date. No changes to commit."
      return 0
    }

    local user_msg="${1:-}"

    if [ -z "$user_msg" ]; then
      __git_sync_ai_commit "$repo_dir"

      git add --all
      if ! git diff --staged --quiet; then
        echo "💡 Committing: chore: sync miscellaneous updates"
        git commit -m "chore: sync miscellaneous updates" > /dev/null
      fi
    else
      echo "📦 Committing all as a single batch..."
      git commit -m "$user_msg" > /dev/null
    fi

    if git push origin HEAD; then
      echo "🚀 Successfully pushed updates to remote."
      read -p "🌐 Open repository in browser? [Y/n] " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        git-web
      fi
    else
      echo "🚨 Error: Failed to push updates to remote." >&2
      return 1
    fi
  )
}

#######################################
# Git: Add all files, intelligently group via AI, and push [Usage: git-ai-pc [optional message]]
#######################################
git-ai-pc() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }

  git add .

  if git diff --staged --quiet; then
    echo "✅ No changes staged to commit."
    return 0
  fi

  local user_msg="${1:-}"

  if [ -n "$user_msg" ]; then
    echo "📦 Committing staged changes with provided message..."
    git commit -m "$user_msg"
  else
    echo "🤖 AI enabled: Generating feature-grouped commits..."
    if ! __git_sync_ai_commit "."; then
      echo "⚠️ AI commit generation skipped or failed. Falling back to default batch commit..."
      git commit -m "chore: automated changes"
    fi
  fi

  echo "🚀 Pushing changes to remote..."
  git push
}

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
mt-get-update() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local repo_dir="$SYNC_REPO_DIR"

  if [ -z "$repo_dir" ] || [ ! -d "$repo_dir/.git" ]; then
    echo -e "\n\033[1;33m⚠️  Profile Sync Not Configured\033[0m"
    echo "Your environment is currently running as a standalone local installation."
    echo -e "To pull updates from a remote repository, you must first configure a sync URL using \033[1madd-sync-url\033[0m and push your initial commit.\n"
    return 1
  fi

  echo -e "${CB_BLUE}⬇️ Pulling latest changes from remote repository...${C_RESET}"
  (
    cd "$repo_dir" || exit 1
    git pull origin "$(git rev-parse --abbrev-ref HEAD)"
  )

  echo -e "\n${CB_YELLOW}🔄 Applying updates to local ~/.bash.d workspace...${C_RESET}"
  if [ -f "$repo_dir/install.sh" ]; then
    bash "$repo_dir/install.sh"

    # Clear the update marker so the prompt goes away
    rm -f "$HOME/.bash.d/.profile_update_pending"

    # Note: install.sh advises the user to run 'reload'.
    # We will automatically trigger it here for a seamless experience.
    source "$HOME/.bashrc"
  else
    echo -e "${CB_RED}🚨 Error: install.sh missing from repository root.${C_RESET}"
    return 1
  fi
}
