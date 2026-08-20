#!/usr/bin/env bash
# Execution Context: $SYNC_REPO_DIR/.dev

GIT_FILE="$HOME/.bash.d/20-vcs/50-git.sh"
SYNC_FILE="$HOME/.bash.d/20-vcs/52-git-sync.sh"

if [ ! -f "$GIT_FILE" ] || [ ! -f "$SYNC_FILE" ]; then
  echo "🚨 Error: Could not find one or more target files."
  exit 1
fi

echo "🔄 Patching Git branch and PR logic..."

python3 -c '
import os, re

# ==========================================
# 1. Patching 50-git.sh
# ==========================================
git_filepath = os.path.expanduser("~/.bash.d/20-vcs/50-git.sh")
with open(git_filepath, "r") as f:
    git_content = f.read()

# The new git-clean-merged and git-raise-pr block
new_git_functions = r"""#######################################
# Git: Delete dead or stale branches that have been merged into the default branch
#######################################
git-clean-merged() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local default_branch
  default_branch=$(git remote show origin 2> /dev/null | awk '"'"'/HEAD branch/ {print $NF}'"'"')
  default_branch="${default_branch:-main}"

  echo -e "${CB_BLUE}🧹 Fetching latest remote state and pruning tracking branches...${C_RESET}"
  git fetch origin --prune

  echo -e "${CB_BLUE}🔄 Switching to ${default_branch} and pulling latest...${C_RESET}"
  git checkout "$default_branch"
  git pull origin "$default_branch"

  echo -e "\n${CB_YELLOW}🔍 Scanning for fully merged local branches...${C_RESET}"
  local merged_branches
  merged_branches=$(git branch --merged | grep -v "\*" | grep -v -E "^[[:space:]]*${default_branch}$" | tr -d '"'"' '"'"' || true)

  if [ -z "$merged_branches" ]; then
    echo -e "${CB_GREEN}✅ Workspace is clean. No merged local branches found.${C_RESET}"
  else
    echo "$merged_branches" | xargs -n 1 git branch -d
    echo -e "${CB_GREEN}✅ Local branch cleanup complete.${C_RESET}"
  fi

  echo -e "\n${CB_YELLOW}🔍 Scanning for fully merged remote branches...${C_RESET}"
  local remote_merged
  remote_merged=$(git branch -r --merged origin/"$default_branch" | grep -v "\*" | grep -v HEAD | grep -v -E "origin/${default_branch}$" | sed '"'"'s/origin\///'"'"' | tr -d '"'"' '"'"' || true)
  
  if [ -z "$remote_merged" ]; then
    echo -e "${CB_GREEN}✅ No merged remote branches found on origin.${C_RESET}"
  else
    for r_branch in $remote_merged; do
      read -p "Delete remote branch '"'"'origin/$r_branch'"'"'? [y/N] " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin --delete "$r_branch"
      fi
    done
    echo -e "${CB_GREEN}✅ Remote cleanup complete.${C_RESET}"
  fi
}
# Backward compatibility alias
alias git-clean-local='"'"'git-clean-merged'"'"'

#######################################
# Git: Push branch and create a Pull Request (GitHub/Bitbucket/GitLab)
# Arguments:
#   -b <branch> : Target branch to merge into (defaults to repository default branch)
#   -t <title>  : PR title (optional)
#   -m <message>: PR body/description (optional)
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
      \?) echo "Usage: git-raise-pr [-b <target_branch>] [-t <pr_title>] [-m <pr_body>]" >&2; return 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  local default_branch
  default_branch=$(git remote show origin 2> /dev/null | awk '"'"'/HEAD branch/ {print $NF}'"'"')
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
    echo -e "${CB_YELLOW}The process has been gracefully aborted to preserve your code. Please resolve the conflicts manually, commit, and run '"'"'git-raise-pr'"'"' again.${C_RESET}"
    git merge --abort > /dev/null 2>&1
    return 1
  fi
  echo -e "${CB_GREEN}✅ Branch is up to date.${C_RESET}"

  local is_github=false
  local origin_url
  origin_url=$(git config --get remote.origin.url)
  [[ "$origin_url" == *"github.com"* ]] && is_github=true

  local pr_state="NONE"
  if [ "$is_github" = true ] && command -v gh >/dev/null 2>&1; then
    pr_state=$(gh pr view "$current_branch" --json state -q .state 2>/dev/null || echo "NONE")
  fi

  if [ "$pr_state" = "OPEN" ]; then
    echo -e "${CB_GREEN}✅ An open PR already exists for this branch.${C_RESET}"
    echo -e "${CB_BLUE}🚀 Pushing latest changes to origin...${C_RESET}"
    git push origin "$current_branch"
    return 0
  elif [[ "$pr_state" == "MERGED" || "$pr_state" == "CLOSED" ]]; then
    echo -e "${CB_YELLOW}⚠️  This branch has a ${pr_state} PR (Dead Branch).${C_RESET}"
    read -p "Would you like to delete this branch locally and checkout a new one? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
       read -p "Enter new branch name: " new_branch
       if [ -z "$new_branch" ]; then
         echo -e "${CB_RED}🚨 Aborted.${C_RESET}"; return 1
       fi
       git checkout "$target_branch"
       git branch -D "$current_branch"
       git checkout -b "$new_branch"
       current_branch="$new_branch"
    else
       echo -e "${CB_RED}🚨 Aborted. Cannot raise a new PR on a branch with a closed/merged PR in GitHub without recreating it.${C_RESET}"
       return 1
    fi
  fi

  echo -e "${CB_BLUE}🚀 Pushing ${current_branch} to origin...${C_RESET}"
  git push -u origin "$current_branch"

  if [ "$is_github" = true ] && command -v gh >/dev/null 2>&1; then
     echo -e "${CB_BLUE}🛠️  Creating Pull Request via GitHub CLI...${C_RESET}"
     if [ -n "$pr_title" ]; then
        gh pr create --base "$target_branch" --title "$pr_title" --body "$pr_body"
     else
        gh pr create --base "$target_branch" --fill
     fi
     echo -e "${CB_GREEN}✅ Pull Request created successfully!${C_RESET}"
     
     read -p "🌐 View Pull Request in browser? [Y/n] " -n 1 -r
     echo
     if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        local pr_url
        pr_url=$(gh pr view --json url -q .url)
        __open_url "$pr_url"
     fi
  else
     echo -e "${CB_YELLOW}⚠️  '"'"'gh'"'"' CLI not found or using non-GitHub repository. Opening browser to create PR manually...${C_RESET}"
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
}"""

# Find the old git-clean-local block and replace it
clean_local_pattern = re.compile(r"#######################################\n# Git: Safely delete all local branches that have been merged into the default branch\n#######################################\ngit-clean-local\(\) \{.*?\n\}", re.DOTALL)

if clean_local_pattern.search(git_content):
    git_content = clean_local_pattern.sub(lambda _: new_git_functions, git_content)
    with open(git_filepath, "w") as f:
        f.write(git_content)
    print("✅ Successfully patched 50-git.sh")
else:
    print("⚠️  Warning: Could not find git-clean-local block in 50-git.sh. It may already be patched.")


# ==========================================
# 2. Patching 52-git-sync.sh
# ==========================================
sync_filepath = os.path.expanduser("~/.bash.d/20-vcs/52-git-sync.sh")
with open(sync_filepath, "r") as f:
    sync_content = f.read()

# The new mt-push-update block
new_sync_function = r"""#######################################
# Git: Sync local bash configs to terminal repo and create a Pull Request
# Globals:
#   SYNC_REPO_DIR
#   SYNC_REPO_URL
# Arguments:
#   -i <issue> - Optional issue number to link to the Pull Request.
#   $@ - Optional string message. If empty, triggers AI systematic feature grouping.
# Outputs:
#   Writes sync, diff, and execution state to STDOUT.
# Returns:
#   0 on success, 1 on misconfigured URL path.
#######################################
mt-push-update() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local issue_num=""
  local OPTIND opt
  while getopts "i:" opt; do
    case ${opt} in
      i) issue_num="$OPTARG" ;;
      \?) echo "Usage: mt-push-update [-i <issue_number>] [optional message]" >&2; return 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  local user_msg="$*"
  local repo_dir="$SYNC_REPO_DIR"
  local remote_url="${SYNC_REPO_URL:-}"

  if [[ -z "$remote_url" || "$remote_url" == "YOUR_SYNC_REPO_URL" || "$remote_url" == "null" ]]; then
    echo -e "\033[1;33m⚠️  Profile Sync Not Configured\033[0m"
    echo -e "The \033[1mpush-profile-update\033[0m feature automatically versions and pushes your terminal configuration to a remote Git repository."
    echo "If you downloaded this profile as a standalone ZIP and do not wish to sync it, you can safely ignore this command."
    echo -e "\nTo enable syncing, link an empty remote Git repository by running:"
    echo -e "   \033[1;36mmt-add-sync-url \"git@github.com:username/my-terminal-repo.git\"\033[0m\n"
    return 1
  fi

  echo "🔄 Syncing bash configuration to $repo_dir..."
  __git_sync_init_repo "$repo_dir" "$remote_url"

  (
    cd "$repo_dir" || exit 1

    local default_branch
    default_branch=$(git remote show origin 2> /dev/null | awk '"'"'/HEAD branch/ {print $NF}'"'"')
    default_branch="${default_branch:-main}"

    local current_branch
    current_branch=$(git branch --show-current)

    # 1. Pre-flight check: If on a feature branch, is it a dead branch? (Do this BEFORE copying files over)
    if [ "$current_branch" != "$default_branch" ] && command -v gh >/dev/null 2>&1; then
       local pr_state
       pr_state=$(gh pr view "$current_branch" --json state -q .state 2>/dev/null || echo "NONE")
       if [[ "$pr_state" == "MERGED" || "$pr_state" == "CLOSED" ]]; then
         echo -e "${CB_YELLOW}⚠️  Current branch '"'"'$current_branch'"'"' has a $pr_state PR and is considered dead.${C_RESET}"
         read -p "Delete '"'"'$current_branch'"'"' locally and checkout a new branch from $default_branch? [Y/n] " -n 1 -r
         echo
         if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
           git checkout "$default_branch"
           git pull origin "$default_branch"
           git branch -D "$current_branch"
           current_branch="$default_branch"
         else
           echo -e "${CB_RED}🚨 Aborted profile sync.${C_RESET}"
           exit 1
         fi
       fi
    fi

    # 2. Check out main, OR ensure current feature branch is safely merged and up to date
    if [ "$current_branch" = "$default_branch" ]; then
       git checkout "$default_branch" > /dev/null 2>&1 || git checkout -b "$default_branch" > /dev/null 2>&1
       git pull origin "$default_branch" > /dev/null 2>&1 || true
    else
       echo -e "${CB_BLUE}🔄 Ensuring ${current_branch} is up to date with origin/${default_branch}...${C_RESET}"
       git fetch origin "$default_branch" > /dev/null 2>&1
       if ! git merge "origin/$default_branch" --no-edit > /dev/null 2>&1; then
         echo -e "${CB_RED}💥 Merge conflict detected with origin/${default_branch}!${C_RESET}"
         echo -e "${CB_YELLOW}The sync automation has paused to protect your code. Please resolve conflicts manually in $repo_dir, commit, and run mt-push-update again.${C_RESET}"
         git merge --abort > /dev/null 2>&1
         exit 1
       fi
    fi
  )

  # 3. Synchronize modified files over to the repo
  __git_sync_copy_files "$repo_dir"

  (
    cd "$repo_dir" || exit 1

    if command -v shfmt > /dev/null 2>&1; then
      echo "🧹 Running Google Style code formatting before profile sync..."
      shfmt -i 2 -ci -sr -w . > /dev/null 2>&1 || true
    fi

    git add --all

    if git diff --staged --quiet; then
      echo "✅ Configurations are already up to date. No changes to commit."
      return 0
    fi

    local current_branch
    current_branch=$(git branch --show-current)
    
    local default_branch
    default_branch=$(git remote show origin 2> /dev/null | awk '"'"'/HEAD branch/ {print $NF}'"'"')
    default_branch="${default_branch:-main}"

    local branch_name="$current_branch"
    local pr_title="$user_msg"

    # 4. If we are still on main, we need to generate a new branch for the PR
    if [ "$current_branch" = "$default_branch" ]; then
        if [ -n "$user_msg" ]; then
          local type
          type=$(echo "$user_msg" | grep -oE '"'"'^[a-zA-Z]+'"'"' || echo "chore")

          local slug
          slug=$(echo "$user_msg" | sed -E '"'"'s/^[a-zA-Z]+(\([^)]+\))?:[[:space:]]*//'"'"' | tr '"'"'[:upper:]'"'"' '"'"'[:lower:]'"'"' | sed -E '"'"'s/[^a-z0-9]+/-/g'"'"' | sed -E '"'"'s/^-|-$//g'"'"' | cut -c1-40)
          [ -z "$slug" ] && slug="update-$(date +%s)"

          branch_name="${type}/${slug}"
        else
          branch_name="chore/automated-sync-$(date +%Y%m%d-%H%M%S)"
          pr_title="chore: automated profile synchronization"
        fi

        echo "🌿 Creating and checking out branch: $branch_name"
        git checkout -b "$branch_name" > /dev/null 2>&1
    else
        if [ -z "$pr_title" ]; then
            pr_title="chore: automated profile synchronization"
        fi
    fi

    # 5. Build PR body content
    local pr_body="Automated sync of terminal profile configurations."
    if [ -n "$issue_num" ]; then
      issue_num="${issue_num#\#}"
      pr_body="${pr_body}\n\nResolves #${issue_num}"
    fi

    # 6. Commit the changes
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

    # 7. Delegate all push/PR logic to the new robust function!
    git-raise-pr -b "$default_branch" -t "$pr_title" -m "$(echo -e "$pr_body")"
  )
}"""

# Find the old mt-push-update block and replace it
mt_push_pattern = re.compile(r"#######################################\n# Git: Sync local bash configs to terminal repo and create a Pull Request\n# Globals:.*?\ngit-view-remote", re.DOTALL)

# The pattern stops at `git-view-remote` (or whatever the next block is) so we need to inject it back in to avoid deleting subsequent code
replacement_with_lookahead = lambda match: new_sync_function + "\n\n" + (match.group(0).split("\n\n")[-1] if "\n\n" in match.group(0) else "")

if re.search(r"mt-push-update\(\) \{", sync_content):
    # Safe replacement by looking for the exact function signature
    function_pattern = re.compile(r"#######################################\n# Git: Sync local bash configs to terminal repo and create a Pull Request.*?\n\}\n", re.DOTALL)
    
    if function_pattern.search(sync_content):
        sync_content = function_pattern.sub(lambda _: new_sync_function + "\n", sync_content)
        with open(sync_filepath, "w") as f:
            f.write(sync_content)
        print("✅ Successfully patched 52-git-sync.sh")
    else:
        print("⚠️  Warning: Could not match exact mt-push-update block. It may be heavily modified.")
else:
    print("⚠️  Warning: Could not find mt-push-update block in 52-git-sync.sh.")

print("\n🚀 Patch complete! Run 'mt-refresh-caches' or 'reload' for changes to take effect.")
'

if command -v mt-refresh-caches > /dev/null 2>&1; then
  echo "🧹 Refreshing MT DevOps caches..."
  mt-refresh-caches > /dev/null 2>&1
fi
