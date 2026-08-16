# shellcheck shell=bash
# ------------------------------------------
# Version Control (Git) - Profile Synchronization
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

  # 1. Sync the core directory, aggressively dropping caches at the rsync level
  rsync -a --delete --delete-excluded \
    --exclude "config/config.yaml" \
    --exclude "config/.env.cache" \
    --exclude ".mt_cache*" \
    --exclude ".update_check_cache" \
    --exclude ".profile_update_cache" \
    --exclude ".current_version" \
    --exclude ".*_pending" \
    --exclude ".mt_data.tsv" \
    --exclude "__pycache__" \
    --exclude ".ruff_cache" \
    --exclude ".vscode" \
    --exclude ".vsclog" \
    --exclude ".github" \
    --exclude ".devcontainer" \
    "$HOME/.bash.d/" "$repo_dir/.bash.d/"

  # 2. Explicitly sync the root ~/.bashrc file from the home directory
  if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$repo_dir/.bashrc"
  fi

  # 3. Move standard root-level configuration files to the repo root
  for f in install.sh README.md .gitignore .dockerignore Dockerfile .gitleaks.toml; do
    if [ -f "$HOME/.bash.d/$f" ]; then
      cp "$HOME/.bash.d/$f" "$repo_dir/$f"
    elif [ -f "$HOME/$f" ]; then
      cp "$HOME/$f" "$repo_dir/$f"
    fi
  done

  # 4. Explicitly copy required root directories
  for d in .github .devcontainer; do
    if [ -d "$HOME/.bash.d/$d" ]; then
      cp -r "$HOME/.bash.d/$d" "$repo_dir/"
    elif [ -d "$HOME/$d" ]; then
      cp -r "$HOME/$d" "$repo_dir/"
    fi
  done

  (
    cd "$repo_dir" || exit 1

    # 5. Enforce mandatory .gitignore rules safely
    touch .gitignore
    local template_file="$HOME/.bash.d/lib/templates/gitignore.tpl"
    if [ -f "$template_file" ]; then
      while IFS= read -r pattern || [ -n "$pattern" ]; do
        [[ -z "$pattern" || "$pattern" == \#* ]] && continue
        grep -qxF "$pattern" .gitignore || echo "$pattern" >> .gitignore
      done < "$template_file"
    fi

    # 6. Purge index and restage to respect new ignore rules
    git rm -r -q --cached . > /dev/null 2>&1
    git add --all
  )
}

#######################################
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
      \?)
        echo "Usage: mt-push-update [-i <issue_number>] [optional message]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  local user_msg="$*"
  local repo_dir="$SYNC_REPO_DIR"
  local remote_url="${SYNC_REPO_URL:-}"

  if [[ -z "$remote_url" || "$remote_url" == "YOUR_SYNC_REPO_URL" || "$remote_url" == "null" ]]; then
    echo -e "
[1;33m⚠️  Profile Sync Not Configured[0m"
    echo -e "The [1mpush-profile-update[0m feature automatically versions and pushes your terminal configuration to a remote Git repository."
    echo "If you downloaded this profile as a standalone ZIP and do not wish to sync it, you can safely ignore this command."
    echo -e "
To enable syncing, link an empty remote Git repository by running:"
    echo -e "  [1;36mmt-add-sync-url \"git@github.com:username/my-terminal-repo.git\"[0m
"
    return 1
  fi

  echo "🔄 Syncing bash configuration to $repo_dir..."

  __git_sync_init_repo "$repo_dir" "$remote_url"

  (
    cd "$repo_dir" || exit 1

    # Securely checkout default branch and pull latest before branching
    local default_branch
    default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print $NF}')
    default_branch="${default_branch:-main}"

    git checkout "$default_branch" > /dev/null 2>&1 || git checkout -b "$default_branch" > /dev/null 2>&1
    git pull origin "$default_branch" > /dev/null 2>&1 || true
  )

  __git_sync_copy_files "$repo_dir"

  (
    cd "$repo_dir" || exit 1

    if command -v shfmt > /dev/null 2>&1; then
      echo "🧹 Running Google Style code formatting before profile sync..."
      shfmt -i 2 -ci -sr -w . > /dev/null 2>&1 || true
    fi

    git add --all

    git diff --staged --quiet && {
      echo "✅ Configurations are already up to date. No changes to commit."
      return 0
    }

    # Generate branching and PR variables
    local branch_name=""
    local pr_title=""
    local pr_body="Automated sync of terminal profile configurations."

    if [ -n "$issue_num" ]; then
      issue_num="${issue_num#\#}"
      pr_body="${pr_body}

Resolves #${issue_num}"
    fi

    if [ -n "$user_msg" ]; then
      local type
      type=$(echo "$user_msg" | grep -oE '^[a-zA-Z]+' || echo "chore")

      local slug
      slug=$(echo "$user_msg" | sed -E 's/^[a-zA-Z]+(\([^)]+\))?:[[:space:]]*//' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-|-$//g' | cut -c1-40)
      [ -z "$slug" ] && slug="update-$(date +%s)"

      branch_name="${type}/${slug}"
      pr_title="$user_msg"
    else
      branch_name="chore/automated-sync-$(date +%Y%m%d-%H%M%S)"
      pr_title="chore: automated profile synchronization"
    fi

    echo "🌿 Creating and checking out branch: $branch_name"
    git checkout -b "$branch_name" > /dev/null 2>&1

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

    echo "🚀 Pushing branch to remote..."
    if git push -u origin "$branch_name"; then
      if command -v gh > /dev/null 2>&1; then
        echo "🛠️  Creating Pull Request via GitHub CLI..."
        gh pr create --title "$pr_title" --body "$(echo -e "$pr_body")"
        echo "✅ Pull Request created successfully!"
        read -p "🌐 View Pull Request in browser? [Y/n] " -n 1 -r < /dev/tty
        echo > /dev/tty
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
          local pr_url
          pr_url=$(gh pr view --json url -q .url)
          __open_url "$pr_url"
        fi
      else
        echo "✅ Successfully pushed branch to remote."
        echo "⚠️ 'gh' CLI is not installed. Skipping automatic PR creation."
        read -p "🌐 Open repository in browser to create PR manually? [Y/n] " -n 1 -r < /dev/tty
        echo > /dev/tty
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
          git-view-remote
        fi
      fi
    else
      echo "🚨 Error: Failed to push branch to remote." >&2
      return 1
    fi
  )
}

#######################################
# System: Download and install profile updates from GitHub releases [Usage: mt-get-update [-v version]]
# Arguments:
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
      \?)
        echo "Usage: mt-get-update [-v <version>]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  echo -e "${CB_BLUE}⬇️ Fetching release information...${C_RESET}"

  # Fallback to official repo if SYNC_REPO_URL isn't set or parsed
  local repo_path="MatStacey/mt-devops-framework"
  if [[ "${SYNC_REPO_URL:-}" =~ github\.com[:/]([^/]+/[^/.]+)(\.git)? ]]; then
    repo_path="${BASH_REMATCH[1]}"
  fi

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
  unzip -q "$zip_path" -d "$tmp_dir/extracted" > /dev/null 2>&1

  # Locate the root of the extracted zip containing install.sh
  local ext_root="$tmp_dir/extracted"
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

    # Clear update markers to reset the terminal prompts
    rm -f "$HOME/.bash.d/.profile_update_pending" "$HOME/.bash.d/.profile_update_cache"
    echo "$tag_name" > "$HOME/.bash.d/.current_version"

    source "$HOME/.bashrc"
    echo -e "${CB_GREEN}✅ Update to ${tag_name} completed successfully.${C_RESET}"
  else
    echo -e "${CB_RED}🚨 Error: install.sh missing from downloaded release.${C_RESET}"
  fi

  rm -rf "$tmp_dir"
}

#######################################
# System: Download a release zip from the remote repository [Usage: mt-download-release [-v version] [-d directory]]
# Arguments:
#   -v <version>    Specify a target release version (e.g., v1.1.0). Defaults to latest.
#   -d <directory>  Specify a destination directory. Defaults to current directory.
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

  # Fallback to official repo if SYNC_REPO_URL isn't set or parsed
  local repo_path="MatStacey/mt-devops-framework"
  if [[ "${SYNC_REPO_URL:-}" =~ github\.com[:/]([^/]+/[^/.]+)(\.git)? ]]; then
    repo_path="${BASH_REMATCH[1]}"
  fi

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

  # Fallback if asset name wasn't parsed correctly
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
