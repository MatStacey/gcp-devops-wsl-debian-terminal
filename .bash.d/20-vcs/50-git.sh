# shellcheck shell=bash
# ------------------------------------------
# Version Control (Git) - Core Helpers
# ------------------------------------------
# ~/.bash.d/20-vcs/50-git.sh

#######################################
# Git: Create and checkout a new feature branch
# Globals:
#   GIT_FEATURE_PREFIX
# Arguments:
#   $1 - Jira ticket ID or branch descriptor suffix
# Usage: git-new-feature <CCON-123|suffix>
#######################################
git-new-feature() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  [ -z "$1" ] && {
    echo -e "🚨 Error: Jira ID / branch suffix cannot be empty.\nUsage: git-new-feature CCON-123"
    return 1
  }

  git checkout -b "${GIT_FEATURE_PREFIX:-feature/}$1"
}

#######################################
# Git: Intercept 'clone' to automatically route repositories into ~/vcs/
# Globals:
#   VCS_ROOT
# Arguments:
#   $@ - Standard git clone options and URL
#######################################
git() {
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
# Git: Open current repository remote URL in default web browser
#######################################
git-view-remote() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
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
# Git: Clone repository into ~/vcs/, navigate into it, and open in default IDE
# Usage: git-clone-ide [-ide vscode|intellij] <repo-url>
# Arguments:
#   -ide <name>  Override default IDE (vscode or intelliJ)
#   <url>        Target repository URL
#######################################
git-clone-ide() {
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
    echo -e "🚨 Error: Repository URL cannot be empty.\nUsage: git-clone-ide [-ide vscode|intellij] <repo-url>"
    return 1
  }

  mkdir -p "$VCS_ROOT"
  local repo_name
  repo_name=$(basename "$repo_url" .git)

  echo "📥 Cloning $repo_name to$VCS_ROOT/..."

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
# Git: Print a clean, color-coded, single-line log graph
#######################################
git-pretty-log() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all
}

#######################################
# Git: Delete local and remote branches merged into the default branch
#######################################
git-clean-merged() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local default_branch
  default_branch=$(git remote show origin 2> /dev/null \vert{} awk '/HEAD branch/ {print$NF}')
  default_branch="${default_branch:-main}"

  echo -e "${CB_BLUE}🧹 Fetching latest remote state and pruning tracking branches...${C_RESET}"
  git fetch origin --prune

  echo -e "${CB_BLUE}🔄 Switching to ${default_branch} and pulling latest...${C_RESET}"
  git checkout "$default_branch" && git pull origin "$default_branch"

  echo -e "\n${CB_YELLOW}🔍 Scanning for fully merged local branches...${C_RESET}"
  local merged_branches
  merged_branches=$(git branch --merged | grep -v "\*" | grep -v -E "^[[:space:]]*${default_branch}$" | tr -d ' ' || true)

  if [ -z "$merged_branches" ]; then
    echo -e "${CB_GREEN}✅ Workspace is clean. No merged local branches found.${C_RESET}"
  else
    echo "$merged_branches" | xargs -n 1 git branch -d
    echo -e "${CB_GREEN}✅ Local branch cleanup complete.${C_RESET}"
  fi

  echo -e "\n${CB_YELLOW}🔍 Scanning for fully merged remote branches...${C_RESET}"
  local remote_merged
  remote_merged=$(git branch -r --merged "origin/$default_branch" | grep -v "\*" | grep -v HEAD | grep -v -E "origin/${default_branch}$" | sed 's/origin\///' | tr -d ' ' || true)

  if [ -z "$remote_merged" ]; then
    echo -e "${CB_GREEN}✅ No merged remote branches found on origin.${C_RESET}"
  else
    for r_branch in $remote_merged; do
      read -r -p "Delete remote branch 'origin/$r_branch'? [y/N] " -n 1
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin --delete "$r_branch"
      fi
    done
    echo -e "${CB_GREEN}✅ Remote cleanup complete.${C_RESET}"
  fi
}

#######################################
# Git: Delete local and remote branches merged into default branch
#######################################
alias git-clean-local='git-clean-merged'

#######################################
# Git: Push current branch and raise a Pull Request (GitHub/GitLab/Bitbucket)
# Usage: git-raise-pr [-b target_branch] [-t pr_title] [-m pr_body]
# Options:
#   -b <branch>   Target branch to merge into (defaults to default branch)
#   -t <title>    Pull Request title
#   -m <message>  Pull Request body or description
#######################################
git-raise-pr() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local target_branch="" pr_title="" pr_body=""

  local OPTIND opt
  while getopts "b:t:m:" opt; do
    case ${opt} in
      b) target_branch="$OPTARG" ;;
      t) pr_title="$OPTARG" ;;
      m) pr_body="$OPTARG" ;;
      \?)
        echo "Usage: git-raise-pr [-b <target_branch>] [-t <pr_title>] [-m <pr_body>]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  local default_branch
  default_branch=$(git remote show origin 2> /dev/null \vert{} awk '/HEAD branch/ {print$NF}')
  default_branch="${default_branch:-main}"
  target_branch="${target_branch:-$default_branch}"

  local current_branch
  current_branch=$(git branch --show-current)

  if [ -z "$current_branch" ]; then
    echo -e "${CB_RED}🚨 Error: Not currently on any branch.${C_RESET}"
    return 1
  fi

  if [ "$current_branch" = "$target_branch" ]; then
    echo -e "${CB_RED}🚨 Error: You are currently on the target branch ($target_branch). Please checkout a new feature branch first.${C_RESET}"
    return 1
  fi

  echo -e "${CB_BLUE}🔄 Fetching latest from origin...${C_RESET}"
  git fetch origin "$target_branch" > /dev/null 2>&1

  echo -e "${CB_BLUE}🔄 Ensuring ${current_branch} is up to date with origin/${target_branch}...${C_RESET}"
  if ! git merge "origin/$target_branch" --no-edit > /dev/null 2>&1; then
    echo -e "${CB_RED}💥 Merge conflict detected with origin/${target_branch}!${C_RESET}"
    echo -e "${CB_YELLOW}The process has been gracefully aborted to preserve your code. Please resolve the conflicts manually, commit, and run 'git-raise-pr' again.${C_RESET}"
    git merge --abort > /dev/null 2>&1
    return 1
  fi
  echo -e "${CB_GREEN}✅ Branch is up to date.${C_RESET}"

  local is_github=false
  local origin_url
  origin_url=$(git config --get remote.origin.url)
  [[ "$origin_url" == *"github.com"* ]] && is_github=true

  local pr_state="NONE"
  if [ "$is_github" = true ] && command -v gh > /dev/null 2>&1; then
    pr_state=$(gh pr view "$current_branch" --json state -q .state 2> /dev/null || echo "NONE")
  fi

  if [ "$pr_state" = "OPEN" ]; then
    echo -e "${CB_GREEN}✅ An open PR already exists for this branch.${C_RESET}"
    echo -e "${CB_BLUE}🚀 Pushing latest changes to origin...${C_RESET}"
    git push origin "$current_branch"
    return 0
  elif [[ "$pr_state" == "MERGED" \vert{}\vert{} "$pr_state" == "CLOSED" ]]; then
    echo -e "${CB_YELLOW}⚠️  This branch has a ${pr_state} PR (Dead Branch).${C_RESET}"
    read -r -p "Would you like to delete this branch locally and checkout a new one? [Y/n] " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$]] \vert{}\vert{} [[ -z$REPLY ]]; then
      read -r -p "Delete the remote branch 'origin/$current_branch' as well? [Y/n] " -n 1
      echo
      if [[ $REPLY =~ ^[Yy]$]] \vert{}\vert{} [[ -z$REPLY ]]; then
        echo -e "${CB_BLUE}🗑️  Deleting remote branch...${C_RESET}"
        git push origin --delete "$current_branch" 2> /dev/null \vert{}\vert{} echo -e "${CB_YELLOW}⚠️  Remote branch already deleted or unreachable.${C_RESET}"
      fi

      read -r -p "Enter new branch name: " new_branch
      if [ -z "$new_branch" ]; then
        echo -e "${CB_RED}🚨 Aborted.${C_RESET}"
        return 1
      fi
      git checkout -b "$new_branch"
      git branch -D "$current_branch"
      current_branch="$new_branch"
    else
      echo -e "${CB_RED}🚨 Aborted. Cannot raise a new PR on a branch with a closed/merged PR in GitHub without recreating it.${C_RESET}"
      return 1
    fi
  fi

  echo -e "${CB_BLUE}🚀 Pushing ${current_branch} to origin...${C_RESET}"
  git push -u origin "$current_branch"

  if [ "$is_github" = true ] && command -v gh > /dev/null 2>&1; then
    echo -e "${CB_BLUE}🛠️  Creating Pull Request via GitHub CLI...${C_RESET}"
    if [ -n "$pr_title" ]; then
      gh pr create --base "$target_branch" --title "$pr_title" --body "$pr_body"
    else
      gh pr create --base "$target_branch" --fill
    fi
    echo -e "${CB_GREEN}✅ Pull Request created successfully!${C_RESET}"

    read -r -p "🌐 View Pull Request in browser? [Y/n] " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$]] \vert{}\vert{} [[ -z$REPLY ]]; then
      local pr_url
      pr_url=$(gh pr view --json url -q .url)
      __open_url "$pr_url"
    fi
  else
    echo -e "${CB_YELLOW}⚠️  'gh' CLI not found or using non-GitHub repository. Opening browser to create PR manually...${C_RESET}"
    local web_url="$origin_url"
    if [[ "$web_url" == git@* ]]; then
      web_url="${web_url#git@}"
      web_url="${web_url/:/\/}"
      web_url="https://${web_url}"
    fi
    web_url="${web_url%.git}"

    if [[ "$web_url" == *"bitbucket.org"* ]]; then
      web_url="${web_url}/pull-requests/new?source=${current_branch}&dest=${target_branch}"
    elif [[ "$web_url" == *"gitlab.com"* ]]; then
      web_url="${web_url}/-/merge_requests/new?merge_request[source_branch]=${current_branch}&merge_request[target_branch]=${target_branch}"
    elif [[ "$web_url" == *"github.com"* ]]; then
      web_url="${web_url}/compare/${target_branch}...${current_branch}?expand=1"
    fi

    __open_url "$web_url"
  fi
}

#######################################
# Git: Fetch upstream origin and rebase current branch onto default branch
#######################################
git-default-rebase() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local current_branch
  current_branch=$(git branch --show-current)

  local default_branch
  default_branch=$(git remote show origin 2> /dev/null \vert{} awk '/HEAD branch/ {print$NF}')
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
# Git: Hard reset local branch to upstream state and wipe untracked files
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
  read -r -p "Reset '${current_branch}' to origin/${current_branch}? [y/N] " -n 1
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "💥 Nuking local environment..."
    git fetch origin > /dev/null 2>&1
    if ! git ls-remote --exit-code --heads origin "$current_branch" > /dev/null 2>&1; then
      echo -e "\e[01;31m🚨 Error: Upstream branch 'origin/$current_branch' does not exist. Cannot safely reset.\e[0m"
      return 1
    fi
    git reset --hard "origin/$current_branch"
    git clean -fd
    echo -e "${CB_GREEN}✅ Branch reset to upstream state.${C_RESET}"
  else
    echo "🛑 Aborted."
  fi
}

#######################################
# Git: Stage all files, commit with provided message, and push
# Usage: git-push-all "commit message"
# Arguments:
#   $1 - Commit message string (Required)
#######################################
git-push-all() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local commit_msg="${1:-}"

  if [ -z "$commit_msg" ]; then
    echo -e "${CB_RED}🚨 Error: A commit message is required.${C_RESET}"
    echo -e "Usage: git-push-all \"Your commit message\""
    return 1
  fi

  git add .

  if git diff --staged --quiet; then
    echo -e "${CB_GREEN}✅ No changes staged to commit.${C_RESET}"
    return 0
  fi

  echo -e "${CB_BLUE}📦 Committing changes...${C_RESET}"
  git commit -m "$commit_msg"

  echo -e "${CB_BLUE}🚀 Pushing changes to remote...${C_RESET}"
  git push
}

#######################################
# Git: Language-aware automatic code formatter (Shell, Python, Terraform, Prettier)
# Arguments:
#   $1 - Target directory path (default: .)
#######################################
__git_auto_format() {
  local target_dir="${1:-.}"

  if [ "${GIT_FORMAT_ON_PUSH:-true}" = "false" ]; then
    return 0
  fi

  echo "🧹 Running language auto-formatters..."

  if command -v shfmt > /dev/null 2>&1; then
    if find "$target_dir" -type f \( -name "*.sh" -o -name "*.bash" \) | read -r; then
      shfmt -i 2 -ci -sr -w "$target_dir" > /dev/null 2>&1 || true
    fi
  fi

  if find "$target_dir" -type f -name "*.py" | read -r; then
    if command -v ruff > /dev/null 2>&1; then
      ruff check --select I --fix "$target_dir" > /dev/null 2>&1 || true
      ruff format "$target_dir" > /dev/null 2>&1 || true
    fi
    if command -v yapf > /dev/null 2>&1; then
      yapf -r -i --style="{based_on_style: google, column_limit: 88, spaces_before_comment: 2}" "$target_dir" > /dev/null 2>&1 || true
    fi
  fi

  if command -v terraform > /dev/null 2>&1; then
    if find "$target_dir" -type f -name "*.tf" | read -r; then
      terraform fmt -recursive "$target_dir" > /dev/null 2>&1 || true
    fi
  fi

  if command -v prettier > /dev/null 2>&1; then
    if find "$target_dir" -type f \( -name "*.yml" -o -name "*.yaml" -o -name "*.json" -o -name "*.md" \) | read -r; then
      prettier --write "$target_dir/**/*.{yml,yaml,json,md}" > /dev/null 2>&1 || true
    fi
  fi
}
