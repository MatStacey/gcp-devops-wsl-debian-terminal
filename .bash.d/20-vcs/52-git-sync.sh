# shellcheck shell=bash
# ------------------------------------------
# Version Control (Git) - Profile Synchronization
# ------------------------------------------
# ~/.bash.d/20-vcs/52-git-sync.sh

#######################################
# Git: Clone and initialize repository in sync directory
# Arguments:
#   $1 - Target repository directory path
#   $2 - Remote origin URL
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
# Git: Synchronize active bash configuration files into dotfiles repository
# Arguments:
#   $1 - Target repository directory path
#######################################
__git_sync_copy_files() {
  local repo_dir="$1"

  mkdir -p "$repo_dir/.bash.d"

  local syncignore="$HOME/.bash.d/config/.syncignore"
  local syncignore_tpl="$HOME/.bash.d/lib/templates/syncignore.tpl"

  if [ ! -f "$syncignore" ]; then
    if [ -f "$syncignore_tpl" ]; then
      cp "$syncignore_tpl" "$syncignore"
    else
      touch "$syncignore"
    fi
  fi

  # SECURITY FIX: One-way sync ONLY. Local Home is the source of truth during a push.
  rsync -a -u --delete --delete-excluded --exclude-from="$syncignore" "$HOME/.bash.d/" "$repo_dir/.bash.d/"

  if [ -f "$HOME/.bashrc" ]; then
    cp -f "$HOME/.bashrc" "$repo_dir/.bashrc"
  fi

  for f in install.sh README.md .gitignore .dockerignore Dockerfile .gitleaks.toml; do
    if [ -f "$HOME/.bash.d/$f" ]; then
      cp -f "$HOME/.bash.d/$f" "$repo_dir/$f"
    elif [ -f "$HOME/$f" ]; then
      cp -f "$HOME/$f" "$repo_dir/$f"
    fi
  done

  for d in .github .devcontainer; do
    if [ -d "$HOME/.bash.d/$d" ]; then
      cp -r -f "$HOME/.bash.d/$d" "$repo_dir/"
    elif [ -d "$HOME/$d" ]; then
      cp -r -f "$HOME/$d" "$repo_dir/"
    fi
  done

  (
    cd "$repo_dir" || exit 1

    touch .gitignore
    local template_file="$HOME/.bash.d/lib/templates/gitignore.tpl"
    if [ -f "$template_file" ]; then
      while IFS= read -r pattern || [ -n "$pattern" ]; do
        [[ -z "$pattern" || "$pattern" == \#* ]] && continue
        grep -qxF "$pattern" .gitignore || echo "$pattern" >> .gitignore
      done < "$template_file"
    fi

    git rm -r -q --cached . > /dev/null 2>&1
    git add --all
  )
}

#######################################
# System: Sync local bash configs to terminal dotfiles repo and create a Pull Request
# Usage: mt-push-update [-i|--issue issue_num] [-s|--shellcheck] [-b|--backup] [optional_message]
# Options:
#   -i, --issue <num>  Optional issue number to link to the Pull Request
#   -s, --shellcheck   Run ShellCheck locally before pushing to catch errors early
#   -b, --backup       Create a zip backup of .bash.d and .bashrc before syncing
#   -m, --no-ai        Skip AI commit message generation and commit in a single batch
#   -d, --delete-merged Delete local branches that have been merged into main/master
#   $@                 Optional commit message string
#######################################
mt-push-update() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local issue_num=""
  local run_shellcheck=false
  local backup_before_sync=false
  local delete_merged=false
  local skip_ai=false
  local user_msg=""

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -i | --issue)
        issue_num="$2"
        shift 2
        ;;
      -s | --shellcheck)
        run_shellcheck=true
        shift
        ;;
      -b | --backup)
        backup_before_sync=true
        shift
        ;;
      -m | --no-ai)
        skip_ai=true
        export SKIP_AI=true
        shift
        ;;
      -d | --delete-merged)
        delete_merged=true
        shift
        ;;
      -*)
        echo "Usage: mt-push-update [-i|--issue <num>] [-s|--shellcheck] [-b|--backup] [-m|--no-ai] [-d|--delete-merged] [message]" >&2
        return 1
        ;;
      *)
        user_msg="${user_msg} $1"
        shift
        ;;
    esac
  done

  user_msg=$(echo "$user_msg" | xargs)

  if [ "$run_shellcheck" = true ]; then
    echo -e "${CB_BLUE}🔍 Running local ShellCheck...${C_RESET}"
    if command -v shellcheck > /dev/null 2>&1; then
      if ! find "$HOME/.bash.d" -type f -name "*.sh" -print0 | xargs -0 shellcheck -e SC1090,SC1091,SC2119,SC2120,SC2207,SC2015,SC2317,SC2016,SC2129,SC2028,SC1003; then
        echo -e "${CB_RED}🚨 ShellCheck failed! Please fix the errors above before syncing.${C_RESET}"
        return 1
      fi
      echo -e "${CB_GREEN}✅ ShellCheck passed!${C_RESET}"
    else
      echo -e "${CB_YELLOW}⚠️ ShellCheck is not installed locally. Skipping...${C_RESET}"
    fi
  fi

  local repo_dir="${DOTFILES_DIR:-$SYNC_REPO_DIR}"
  local remote_url="${SYNC_REPO_URL:-}"

  if [[ -z "$remote_url" || "$remote_url" == "YOUR_SYNC_REPO_URL" || "$remote_url" == "null" ]]; then
    echo -e "\033[1;33m⚠️  Profile Sync Not Configured\033[0m"
    echo -e "The \033[1mpush-profile-update\033[0m feature automatically versions and pushes your terminal configuration to a remote Git repository."
    echo "If you downloaded this profile as a standalone ZIP and do not wish to sync it, you can safely ignore this command."
    echo -e "\nTo enable syncing, link an empty remote Git repository by running:"
    echo -e "   \033[1;36mmt-add-sync-url \"git@github.com:username/my-terminal-repo.git\"\033[0m\n"
    return 1
  fi

  # ==========================================
  # SAFEGUARD: PRE-SYNC BACKUP
  # ==========================================
  if [ "$backup_before_sync" = true ]; then
    echo -e "${CB_BLUE}📦 Creating pre-sync backup of framework...${C_RESET}"
    local dest="${BACKUP_DIR:-~/backups}/framework-pre-sync"
    mkdir -p "$dest"
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_file="${dest}/mt_framework_backup_${timestamp}.zip"

    (
      cd "$HOME" || exit 1
      zip -q -r "$backup_file" .bash.d .bashrc -x ".bash.d/.git/*" -x ".bash.d/data/cache/*" -x ".bash.d/node_modules/*" -x ".bash.d/**/__pycache__/*" -x ".bash.d/.terraform/*" -x ".bash.d/venv/*" -x ".bash.d/.venv/*"
    )

    if [ -f "$backup_file" ]; then
      local file_size
      file_size=$(du -h "$backup_file" | cut -f1)
      echo -e "${CB_GREEN}✅ Pre-sync backup saved to ${backup_file} (${file_size})${C_RESET}"
    else
      echo -e "${CB_RED}🚨 Pre-sync backup failed. Aborting sync to prevent data loss.${C_RESET}"
      return 1
    fi
  fi

  echo "🔄 Syncing bash configuration to $repo_dir..."
  __git_sync_init_repo "$repo_dir" "$remote_url"

  (
    cd "$repo_dir" || exit 1

    local default_branch
    default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print $NF}')
    default_branch="${default_branch:-main}"

    local current_branch
    current_branch=$(git branch --show-current)

    if [ "$current_branch" != "$default_branch" ] && command -v gh > /dev/null 2>&1; then
      local pr_state
      pr_state=$(gh pr view "$current_branch" --json state -q .state 2> /dev/null || echo "NONE")
      if [ "$pr_state" = "MERGED" ] || [ "$pr_state" = "CLOSED" ]; then
        echo -e "${CB_YELLOW}⚠️  Current branch '$current_branch' has a $pr_state PR and is considered dead.${C_RESET}"
        read -r -p "Delete '$current_branch' locally and checkout a new branch from $default_branch? [Y/n] " -n 1
        echo
        if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ] || [ -z "$REPLY" ]; then
          read -r -p "Delete the remote branch 'origin/$current_branch' as well? [Y/n] " -n 1
          echo
          if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ] || [ -z "$REPLY" ]; then
            echo -e "${CB_BLUE}🗑️  Deleting remote branch...${C_RESET}"
            git push origin --delete "$current_branch" 2> /dev/null || echo -e "${CB_YELLOW}⚠️  Remote branch already deleted or unreachable.${C_RESET}"
          fi
          local stashed=false
          if ! git diff --quiet || ! git diff --staged --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
            git stash push --include-untracked -m "mt-push auto stash" > /dev/null 2>&1
            stashed=true
          fi
          if git checkout "$default_branch" > /dev/null 2>&1; then
            git pull origin "$default_branch" > /dev/null 2>&1
            git branch -D "$current_branch" > /dev/null 2>&1
            current_branch="$default_branch"
          else
            echo -e "${CB_RED}🚨 Failed to checkout $default_branch. Please commit or stash changes manually.${C_RESET}"
            [ "$stashed" = true ] && git stash pop > /dev/null 2>&1
            exit 1
          fi
          [ "$stashed" = true ] && git stash pop > /dev/null 2>&1
        else
          echo -e "${CB_RED}🚨 Aborted profile sync.${C_RESET}"
          exit 1
        fi
      fi
    fi

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
  ) || return 1

  __git_sync_copy_files "$repo_dir"

  (
    cd "$repo_dir" || exit 1

    if command -v shfmt > /dev/null 2>&1; then
      echo "🧹 Running Google Style code formatting before profile sync..."
      shfmt -i 2 -ci -sr -w . > /dev/null 2>&1 || true
    fi

    if [ "$skip_ai" = true ]; then
      echo -e "${C_DIM}⏩ Skipping AI README summarization (-m active)...${C_RESET}"
    else
      __git_sync_ai_docs "$repo_dir"
    fi
    if [ $? -eq 100 ]; then
      echo -e "${CB_RED}🚨 Aborting profile sync.${C_RESET}"
      exit 1
    fi

    git add --all

    if git diff --staged --quiet; then
      echo "✅ Configurations are already up to date. No changes to commit."
      return 0
    fi

    local current_branch
    current_branch=$(git branch --show-current)

    local default_branch
    default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print $NF}')
    default_branch="${default_branch:-main}"

    local branch_name="$current_branch"
    local pr_title="$user_msg"

    if [ "$current_branch" = "$default_branch" ]; then
      if [ -n "$user_msg" ]; then
        local type
        type=$(echo "$user_msg" | grep -oE '^[a-zA-Z]+' || echo "chore")

        local slug
        slug=$(echo "$user_msg" | sed -E 's/^[a-zA-Z]+(\([^)]+\))?:[[:space:]]*//' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-|-$//g' | cut -c1-40)
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

    local pr_body="Automated sync of terminal profile configurations."
    if [ -n "$issue_num" ]; then
      issue_num="${issue_num#\#}"
      pr_body="${pr_body}\n\nResolves #${issue_num}"
    fi

    if [ "$skip_ai" = true ]; then
      local commit_msg="${user_msg:-chore: automated profile synchronization}"
      echo "📦 Skipping AI commit generation. Batch committing with: \"$commit_msg\"..."
      git commit -m "$commit_msg" > /dev/null
    elif [ -z "$user_msg" ]; then
      __git_sync_ai_commit "$repo_dir"
      if [ $? -eq 100 ]; then
        echo -e "${CB_RED}🚨 Aborting profile sync.${C_RESET}"
        exit 1
      fi

      git add --all
      if ! git diff --staged --quiet; then
        echo "💡 Committing: chore: sync miscellaneous updates"
        git commit -m "chore: sync miscellaneous updates" > /dev/null
      fi
    else
      echo "📦 Committing all as a single batch..."
      git commit -m "$user_msg" > /dev/null
    fi

    if [ "$delete_merged" = true ]; then
      echo -e "${CB_BLUE}🧹 Pruning remote tracking references and deleting merged local branches...${C_RESET}"
      git fetch --prune > /dev/null 2>&1
      local main_b="main"
      git show-ref --verify --quiet refs/heads/master && main_b="master"

      local merged_b
      merged_b=$(git branch --merged "$main_b" | grep -v -E "^[*+]|\\b(main|master|dev|developer)\\b")

      if [ -n "$merged_b" ]; then
        echo "$merged_b" | xargs -r git branch -d
        echo -e "${CB_GREEN}✅ Merged local branches cleaned up successfully!${C_RESET}"
      else
        echo -e "${C_DIM}No stale merged branches found to delete.${C_RESET}"
      fi
    fi

    git-raise-pr -b "$default_branch" -t "$pr_title" -m "$(echo -e "$pr_body")"
  ) || return 1
}

#######################################
# System: Download and install profile updates from GitHub releases
# Usage: mt-get-update [-v version]
# Options:
#   -v <version>  Specify a target release version (e.g., v1.1.0)
#######################################
mt-get-update() {
  local target_version=""
  local OPTIND opt
  while getopts "v:h" opt; do
    case ${opt} in
      v) target_version="$OPTARG" ;;
      h)
        mt-help "${FUNCNAME[0]}"
        return 0
        ;;
      ?)
        echo "Usage: mt-get-update [-v <version>]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  echo -e "${CB_BLUE}⬇️ Fetching release information...${C_RESET}"

  local repo_path="${UPSTREAM_REPO_PATH:-MatStacey/mt-devops-framework}"

  local api_url="https://api.github.com/repos/${repo_path}/releases/latest"
  if [ -n "$target_version" ]; then
    api_url="https://api.github.com/repos/${repo_path}/releases/tags/${target_version}"
  fi

  local release_data
  release_data=$(curl -s "$api_url")

  local download_url
  download_url=$(echo "$release_data" | jq -r ".assets[0].browser_download_url // empty")
  local tag_name
  tag_name=$(echo "$release_data" | jq -r ".tag_name // empty")

  local current_version="Local"
  local repo_dir="${DOTFILES_DIR:-$SYNC_REPO_DIR}"
  if [ -f "$HOME/.bash.d/data/.current_version" ]; then
    current_version=$(command cat "$HOME/.bash.d/data/.current_version" | tr -d '\r\n ')
  elif [ -n "$repo_dir" ] && [ -d "$repo_dir/.git" ] && command -v git > /dev/null 2>&1; then
    current_version=$(git -C "$repo_dir" describe --tags --abbrev=0 2> /dev/null || echo "Local")
    current_version=$(echo "$current_version" | tr -d '\r\n ')
  fi

  local clean_tag
  clean_tag=$(echo "$tag_name" | tr -d '\r\n ')

  if [ "$clean_tag" = "$current_version" ] && [ -z "$target_version" ]; then
    echo -e "${CB_GREEN}✅ You are already running the latest version (${current_version}).${C_RESET}"
    return 0
  fi

  if [ -z "$download_url" ] || [ "$download_url" = "null" ]; then
    if [ -n "$target_version" ]; then
      echo -e "${CB_RED}🚨 Error: Could not find release assets for version ${target_version} in ${repo_path}.${C_RESET}"
    else
      echo -e "${CB_RED}🚨 Error: Could not find latest release assets for ${repo_path}.${C_RESET}"
    fi
    return 1
  fi

  echo -e "${CB_GREEN}📦 Found release ${tag_name}. Downloading...${C_RESET}"

  local tmp_dir
  tmp_dir=$(mktemp -d)
  local zip_path="${tmp_dir}/update.zip"

  if ! curl -L -s --fail "$download_url" -o "$zip_path"; then
    echo -e "${CB_RED}🚨 Error: Failed to download release asset from ${download_url}.${C_RESET}"
    rm -rf "$tmp_dir"
    return 1
  fi

  echo -e "${CB_YELLOW}🔄 Extracting and applying updates...${C_RESET}"
  unzip -q "$zip_path" -d "${tmp_dir}/extracted" > /dev/null 2>&1

  local ext_root="${tmp_dir}/extracted"
  if [ ! -f "$ext_root/install.sh" ]; then
    local nested
    nested=$(find "$ext_root" -name "install.sh" -exec dirname {} \; | head -n 1)
    if [ -n "$nested" ]; then
      ext_root="$nested"
    fi
  fi

  if [ -f "$ext_root/install.sh" ]; then
    (
      cd "$ext_root" || exit 1
      bash ./install.sh
    )
    mkdir -p "$HOME/.bash.d/data/cache" "$HOME/.bash.d/data/logs"
    echo "$tag_name" > "$HOME/.bash.d/data/.current_version"
    mt-refresh-caches > /dev/null 2>&1
  else
    echo -e "${CB_RED}🚨 Error: install.sh missing from downloaded release.${C_RESET}"
  fi

  rm -rf "$tmp_dir"
}

#######################################
# System: Download a release zip from the remote repository
# Usage: mt-download-release [-v version] [-d directory]
# Options:
#   -v <version>    Specify target release version (defaults to latest)
#   -d <directory>  Specify destination directory (defaults to current directory)
#######################################
mt-download-release() {
  local target_version=""
  local dest_dir="$PWD"
  local OPTIND opt

  while getopts "v:d:h" opt; do
    case ${opt} in
      v) target_version="$OPTARG" ;;
      d) dest_dir="$OPTARG" ;;
      h)
        mt-help "${FUNCNAME[0]}"
        return 0
        ;;
      \?)
        echo "Usage: mt-download-release [-v <version>] [-d <directory>]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  if [ ! -d "$dest_dir" ]; then
    echo -e "${CB_YELLOW}⚠️ Directory '${dest_dir}' does not exist. Creating it...${C_RESET}"
    mkdir -p "$dest_dir" || {
      echo -e "${CB_RED}🚨 Error: Failed to create directory '${dest_dir}'.${C_RESET}"
      return 1
    }
  fi

  echo -e "${CB_BLUE}⬇️ Fetching release information...${C_RESET}"

  local repo_path="${UPSTREAM_REPO_PATH:-MatStacey/mt-devops-framework}"

  local api_url="https://api.github.com/repos/${repo_path}/releases/latest"
  if [ -n "$target_version" ]; then
    api_url="https://api.github.com/repos/${repo_path}/releases/tags/${target_version}"
  fi

  local release_data
  release_data=$(curl -s "$api_url")

  local download_url
  download_url=$(echo "$release_data" | jq -r ".assets[0].browser_download_url // empty")
  local asset_name
  asset_name=$(echo "$release_data" | jq -r ".assets[0].name // empty")
  local tag_name
  tag_name=$(echo "$release_data" | jq -r ".tag_name // empty")

  if [ -z "$download_url" ] || [ "$download_url" = "null" ]; then
    if [ -n "$target_version" ]; then
      echo -e "${CB_RED}🚨 Error: Could not find release assets for version ${target_version} in ${repo_path}.${C_RESET}"
    else
      echo -e "${CB_RED}🚨 Error: Could not find latest release assets for ${repo_path}.${C_RESET}"
    fi
    return 1
  fi

  [ -z "$asset_name" ] || [ "$asset_name" = "null" ] && asset_name="mt-devops-framework-${tag_name}.zip"

  local dest_file="${dest_dir}/${asset_name}"

  echo -e "${CB_GREEN}📦 Found release ${tag_name}. Downloading to ${dest_file}...${C_RESET}"

  if curl -L -# --fail "$download_url" -o "$dest_file"; then
    echo -e "${CB_GREEN}✅ Successfully downloaded release ${tag_name} to ${dest_file}${C_RESET}"
    if type __win_explorer_focus > /dev/null 2>&1; then
      __win_explorer_focus "$dest_dir" 2> /dev/null || true
    fi
  else
    echo -e "${CB_RED}🚨 Error: Failed to download release asset from ${download_url}.${C_RESET}"
    return 1
  fi
}
