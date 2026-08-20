#!/usr/bin/env bash
# Execution Context: Your sync repository directory (e.g., cd-sync)

echo "🔍 Writing and executing ShellCheck fixer..."

cat << 'EOF' > .fix_sc.py
import os
import re

def patch_file(rel_path, pattern, new_content):
    fpath = os.path.expanduser(f"~/.bash.d/{rel_path}")
    if not os.path.exists(fpath):
        print(f"⚠️ Missing: {rel_path}")
        return
    with open(fpath, "r", encoding="utf-8") as f:
        c = f.read()
    c_new = re.sub(pattern, lambda _: new_content, c, flags=re.DOTALL)
    with open(fpath, "w", encoding="utf-8") as f:
        f.write(c_new)
    print(f"✅ Patched: {rel_path}")

# ==========================================
# 1. Fix 00-config.sh (Broken Quotes & Syntax)
# ==========================================
gemini_new = r"""if [[ -z "$GEMINI_API_KEY" || "$GEMINI_API_KEY" == "YOUR_GEMINI_API_KEY" || "$GEMINI_API_KEY" == "null" ]]; then
  unset GEMINI_API_KEY
  if [[ "${DEFAULT_AI:-gemini}" == "gemini" ]]; then
    echo -e "${C_YELLOW}No Gemini API Key provided in config.yaml. Add one via:${C_RESET}"
    echo -e "    ${C_RESET}mt-add-gemini-key \"your-api-key\"\\e[0m"
  fi
fi"""

claude_new = r"""if [[ -z "$CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "YOUR_CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "null" ]]; then
  unset CLAUDE_API_KEY
  if [[ "${DEFAULT_AI:-gemini}" == "claude" ]]; then
    echo -e "${C_YELLOW}No Claude API Key provided in config.yaml. Add one via:${C_RESET}"
    echo -e "    ${C_RESET}mt-add-claude-key \"your-api-key\"\\e[0m"
  fi
fi"""

patch_file("00-system/00-config.sh", r"if \[\[ -z [^$]*\$GEMINI_API_KEY[\s\S]*?fi\n\s*fi", gemini_new)
patch_file("00-system/00-config.sh", r"if \[\[ -z [^$]*\$CLAUDE_API_KEY[\s\S]*?fi\n\s*fi", claude_new)

# ==========================================
# 2. Fix 52-git-sync.sh (Local assignments & getopts)
# ==========================================
mt_push_update_new = r"""#######################################
# Git: Sync local bash configs to terminal repo and create a Pull Request
#######################################
mt-push-update() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
  local issue_num=""
  local OPTIND opt
  while getopts "i:" opt; do
    case ${opt} in
      i) issue_num="$OPTARG" ;;
      *) ;;
    esac
  done
  shift $((OPTIND - 1))
  
  local user_msg="$*"
  local repo_dir="$SYNC_REPO_DIR"
  local remote_url="${SYNC_REPO_URL:-}"
  if [[ -z "$remote_url" || "$remote_url" == "YOUR_SYNC_REPO_URL" || "$remote_url" == "null" ]]; then echo "⚠️ Sync Not Configured"; return 1; fi
  
  echo "🔄 Syncing bash configuration to $repo_dir..."
  __git_sync_init_repo "$repo_dir" "$remote_url"
  (
    cd "$repo_dir" || exit 1
    local default_branch
    default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print $NF}')
    default_branch="${default_branch:-main}"
    
    local current_branch
    current_branch=$(git branch --show-current)
    
    if [ "$current_branch" != "$default_branch" ] && command -v gh >/dev/null 2>&1; then
       local pr_state
       pr_state=$(gh pr view "$current_branch" --json state -q .state 2>/dev/null || echo "NONE")
       if [[ "$pr_state" == "MERGED" || "$pr_state" == "CLOSED" ]]; then
         read -r -p "⚠️ Branch dead. Checkout $default_branch? [Y/n] " -n 1
         echo
         if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
           git checkout "$default_branch" && git pull origin "$default_branch" && git branch -D "$current_branch"
           current_branch="$default_branch"
         else exit 1; fi
       fi
    fi
    
    if [ "$current_branch" = "$default_branch" ]; then
       git checkout "$default_branch" >/dev/null 2>&1 || git checkout -b "$default_branch" >/dev/null 2>&1
       git pull origin "$default_branch" >/dev/null 2>&1 || true
    else
       git fetch origin "$default_branch" >/dev/null 2>&1
       if ! git merge "origin/$default_branch" --no-edit >/dev/null 2>&1; then
         echo -e "${CB_RED}💥 Merge conflict! Aborting sync.${C_RESET}"
         git merge --abort >/dev/null 2>&1
         exit 1
       fi
    fi
  )
  __git_sync_copy_files "$repo_dir"
  (
    cd "$repo_dir" || exit 1
    if command -v shfmt > /dev/null 2>&1; then shfmt -i 2 -ci -sr -w . > /dev/null 2>&1 || true; fi
    git add --all
    if git diff --staged --quiet; then echo "✅ Configurations already up to date."; return 0; fi
    
    local current_branch
    current_branch=$(git branch --show-current)
    local default_branch
    default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print $NF}')
    default_branch="${default_branch:-main}"
    
    local branch_name="$current_branch"
    local pr_title="$user_msg"
    if [ "$current_branch" = "$default_branch" ]; then
        if [ -n "$user_msg" ]; then
            local slug
            slug=$(echo "$user_msg" | sed -E 's/^[a-zA-Z]+(\([^)]+\))?:[[:space:]]*//' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-|-$//g' | cut -c1-40)
            branch_name="chore/${slug:-update-$(date +%s)}"
        else
            branch_name="chore/automated-sync-$(date +%Y%m%d-%H%M%S)"
            pr_title="chore: automated profile synchronization"
        fi
        git checkout -b "$branch_name" > /dev/null 2>&1
    else
        [ -z "$pr_title" ] && pr_title="chore: automated profile synchronization"
    fi
    
    local pr_body="Automated sync of terminal profile configurations."
    [ -n "$issue_num" ] && pr_body="${pr_body}\n\nResolves #${issue_num#\#}"
    
    if [ -n "$user_msg" ]; then
        git commit -m "$user_msg" > /dev/null
    else
        __git_sync_ai_commit "$repo_dir"
        git add --all
        git diff --staged --quiet || git commit -m "chore: sync miscellaneous updates" > /dev/null
    fi
    git-raise-pr -b "$default_branch" -t "$pr_title" -m "$(echo -e "$pr_body")"
  )
}"""
patch_file("20-vcs/52-git-sync.sh", r"#######################################\n# Git: Sync local bash configs to terminal repo and create a Pull Request.*?\n\}(?=\n|$)", mt_push_update_new)

# ==========================================
# 3. Fix 06-llm-exports.sh (Local assignments & array expansion)
# ==========================================
mt_copy_new = r"""#######################################
# LLM: Copy a file or directory tree to clipboard with headers and extension filters
#######################################
mt-copy() {
  local ext_list="" target=""
  local OPTIND opt
  while getopts "e:h" opt; do
    case ${opt} in
      e) ext_list="$OPTARG" ;;
      h) echo -e "${CB_BLUE}Usage:${C_RESET} mt-copy [-e <ext1,ext2>] <file-or-directory>"; return 0 ;;
      *) echo "Usage: mt-copy [-e <extensions>] <file-or-directory>" >&2; return 1 ;;
    esac
  done
  shift $((OPTIND - 1))
  
  target="${1:-.}"
  if [ ! -e "$target" ]; then echo -e "${CB_RED}🚨 Error: '$target' missing.${C_RESET}"; return 1; fi
  
  local clip_cmd=""
  if command -v clip.exe >/dev/null 2>&1; then clip_cmd="clip.exe"
  elif command -v pbcopy >/dev/null 2>&1; then clip_cmd="pbcopy"
  elif command -v xclip >/dev/null 2>&1; then clip_cmd="xclip -selection clipboard"
  else echo "🚨 No clipboard utility."; return 1; fi
  
  echo -e "${CB_BLUE}🔍 Scanning '$target'...${C_RESET}"
  
  local temp_file
  temp_file=$(mktemp)
  
  local blocklist_regex
  blocklist_regex=$(python3 -c "import yaml, os; print(yaml.safe_load(open(os.path.expanduser('~/.bash.d/config/config.yaml'))).get('exports', {}).get('blocklist', ''))" 2>/dev/null)
  [ -z "$blocklist_regex" ] && blocklist_regex="(secret|token|credential|pass|key|rsa|env|lock\.hcl|__pycache__)"
  
  local filter_ext=".*"
  if [ -n "$ext_list" ]; then
    local ext_fmt
    ext_fmt=$(echo "$ext_list" | sed 's/,/|/g; s/ //g')
    filter_ext="\.(${ext_fmt})$"
    echo -e "${C_GRAY}   (Filtering for: $ext_list)${C_RESET}"
  fi
  
  local prune_dirs=(-name .git -o -name node_modules -o -name .terraform -o -name __pycache__ -o -name .venv)
  
  if [ -d "$target" ]; then
    find "$target" -type d \( "${prune_dirs[@]}" \) -prune -o -type f -print | grep -E -v "$blocklist_regex" | grep -Ei "$filter_ext" | while IFS= read -r file; do
      if file -b --mime-encoding "$file" | grep -qv "binary"; then
        echo -e "\n==> $file <==" >> "$temp_file"
        cat "$file" >> "$temp_file"
      fi
    done
  elif [ -f "$target" ]; then
    echo -e "==> $target <==" >> "$temp_file"
    cat "$target" >> "$temp_file"
  fi
  
  local bytes
  bytes=$(wc -c < "$temp_file")
  if [ "$bytes" -eq 0 ]; then
    echo -e "${CB_YELLOW}⚠️ Nothing copied.${C_RESET}"
  else
    eval "$clip_cmd" < "$temp_file"
    local lines
    lines=$(wc -l < "$temp_file")
    echo -e "${CB_GREEN}✅ Copied $lines lines to clipboard!${C_RESET}"
  fi
  rm -f "$temp_file"
}"""
patch_file("03-mytools/06-llm-exports.sh", r"#######################################\n# LLM: Copy a file or directory tree to clipboard.*?\n\}(?=\n|$)", mt_copy_new)

# ==========================================
# 4. Fix 50-git.sh (Local assignments & getopts)
# ==========================================
git_clean_merged_new = r"""#######################################
# Git: Delete dead or stale branches that have been merged into the default branch
#######################################
git-clean-merged() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
  local default_branch
  default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print $NF}')
  default_branch="${default_branch:-main}"
  
  echo -e "${CB_BLUE}🧹 Fetching latest remote state and pruning tracking branches...${C_RESET}"
  git fetch origin --prune
  
  echo -e "${CB_BLUE}🔄 Switching to ${default_branch} and pulling latest...${C_RESET}"
  git checkout "$default_branch" && git pull origin "$default_branch"
  
  echo -e "\n${CB_YELLOW}🔍 Scanning for fully merged local branches...${C_RESET}"
  local merged_branches
  merged_branches=$(git branch --merged | grep -v "\*" | grep -v -E "^[[:space:]]*${default_branch}$" | tr -d '"' | tr -d '\'' || true)
  
  if [ -z "$merged_branches" ]; then
    echo -e "${CB_GREEN}✅ Workspace is clean.${C_RESET}"
  else
    echo "$merged_branches" | xargs -n 1 git branch -d
    echo -e "${CB_GREEN}✅ Local branch cleanup complete.${C_RESET}"
  fi
  
  echo -e "\n${CB_YELLOW}🔍 Scanning for fully merged remote branches...${C_RESET}"
  local remote_merged
  remote_merged=$(git branch -r --merged origin/"$default_branch" | grep -v "\*" | grep -v HEAD | grep -v -E "origin/${default_branch}$" | sed 's/origin\///' | tr -d '"' | tr -d '\'' || true)
  
  if [ -z "$remote_merged" ]; then
    echo -e "${CB_GREEN}✅ No merged remote branches found.${C_RESET}"
  else
    for r_branch in $remote_merged; do
      read -r -p "Delete remote branch 'origin/$r_branch'? [y/N] " -n 1
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then git push origin --delete "$r_branch"; fi
    done
    echo -e "${CB_GREEN}✅ Remote cleanup complete.${C_RESET}"
  fi
}
alias git-clean-local='git-clean-merged'"""
patch_file("20-vcs/50-git.sh", r"#######################################\n# Git: Delete dead or stale branches.*?\nalias git-clean-local.*?\n", git_clean_merged_new + "\n\n")

git_raise_pr_new = r"""#######################################
# Git: Push branch and create a Pull Request
#######################################
git-raise-pr() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
  local target_branch="" pr_title="" pr_body=""
  local OPTIND opt
  while getopts "b:t:m:" opt; do
    case ${opt} in
      b) target_branch="$OPTARG" ;;
      t) pr_title="$OPTARG" ;;
      m) pr_body="$OPTARG" ;;
      *) ;;
    esac
  done
  shift $((OPTIND - 1))
  
  local default_branch
  default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print $NF}')
  default_branch="${default_branch:-main}"
  target_branch="${target_branch:-$default_branch}"
  
  local current_branch
  current_branch=$(git branch --show-current)
  if [ -z "$current_branch" ]; then echo -e "${CB_RED}🚨 Error: Not on any branch.${C_RESET}"; return 1; fi
  if [ "$current_branch" = "$target_branch" ]; then echo -e "${CB_RED}🚨 Error: On target branch.${C_RESET}"; return 1; fi
  
  echo -e "${CB_BLUE}🔄 Fetching...${C_RESET}"
  git fetch origin "$target_branch" > /dev/null 2>&1
  if ! git merge "origin/$target_branch" --no-edit > /dev/null 2>&1; then
    echo -e "${CB_RED}💥 Merge conflict! Aborting to preserve code.${C_RESET}"
    git merge --abort > /dev/null 2>&1
    return 1
  fi
  
  local is_github=false
  local origin_url
  origin_url=$(git config --get remote.origin.url)
  [[ "$origin_url" == *"github.com"* ]] && is_github=true
  
  local pr_state="NONE"
  if [ "$is_github" = true ] && command -v gh >/dev/null 2>&1; then
     pr_state=$(gh pr view "$current_branch" --json state -q .state 2>/dev/null || echo "NONE")
  fi
  
  if [ "$pr_state" = "OPEN" ]; then
    echo -e "${CB_GREEN}✅ PR exists.${C_RESET}"
    git push origin "$current_branch"
    return 0
  elif [[ "$pr_state" == "MERGED" || "$pr_state" == "CLOSED" ]]; then
    read -r -p "⚠️ Branch has a $pr_state PR. Delete and checkout new? [Y/n] " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
       read -r -p "Enter new branch name: " new_break_name
       [ -z "$new_break_name" ] && return 1
       git checkout "$target_branch" && git branch -D "$current_branch" && git checkout -b "$new_break_name"
       current_branch="$new_break_name"
    else return 1; fi
  fi
  
  git push -u origin "$current_branch"
  
  if [ "$is_github" = true ] && command -v gh >/dev/null 2>&1; then
     if [ -n "$pr_title" ]; then gh pr create --base "$target_branch" --title "$pr_title" --body "$pr_body"
     else gh pr create --base "$target_branch" --fill; fi
     read -r -p "🌐 View PR? [Y/n] " -n 1
     echo
     if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
       local pr_url
       pr_url=$(gh pr view --json url -q .url)
       __open_url "$pr_url"
     fi
  else
     local web_url="$origin_url"
     web_url="${web_url#git@}"
     web_url="${web_url/:/\/}"
     web_url="https://${web_url%.git}"
     
     if [[ "$web_url" == *"bitbucket.org"* ]]; then web_url="${web_url}/pull-requests/new?source=${current_branch}&dest=${target_branch}"
     elif [[ "$web_url" == *"gitlab.com"* ]]; then web_url="${web_url}/-/merge_requests/new?merge_request[source_branch]=${current_branch}&merge_request[target_branch]=${target_branch}"
     elif [[ "$web_url" == *"github.com"* ]]; then web_url="${web_url}/compare/${target_branch}...${current_branch}?expand=1"; fi
     __open_url "$web_url"
  fi
}"""
patch_file("20-vcs/50-git.sh", r"#######################################\n# Git: Push branch and create a Pull Request.*?\n\}(?=\n|$)", git_raise_pr_new)
EOF

python3 .fix_sc.py
rm -f .fix_sc.py

if command -v mt-refresh-caches > /dev/null 2>&1; then
  echo "🧹 Refreshing MT DevOps caches..."
  mt-refresh-caches > /dev/null 2>&1
fi

echo "🚀 Check complete! Run 'reload' to activate."
