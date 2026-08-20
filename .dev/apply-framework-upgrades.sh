#!/usr/bin/env bash
# Execution Context: Your sync repository directory (e.g., cd-sync)

echo "🚀 Initiating Master Framework Upgrade..."

# ==========================================
# 1. Patch AI API Key Warnings (00-config.sh)
# ==========================================
echo -e "\n[1/6] 🔄 Patching AI API key warnings..."
python3 -c '
import os, re
filepath = os.path.expanduser("~/.bash.d/00-system/00-config.sh")
with open(filepath, "r") as f: content = f.read()

gemini_new = """if [[ -z "$GEMINI_API_KEY" || "$GEMINI_API_KEY" == "YOUR_GEMINI_API_KEY" || "$GEMINI_API_KEY" == "null" ]]; then
  unset GEMINI_API_KEY
  if [[ "${DEFAULT_AI:-gemini}" == "gemini" ]]; then
    echo -e "${C_YELLOW}No Gemini API Key provided in config.yaml. Add one via:\\n    ${C_RESET}mt-add-gemini-key \\"your-api-key\\"\\e[0m"
  fi
fi"""
claude_new = """if [[ -z "$CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "YOUR_CLAUDE_API_KEY" || "$CLAUDE_API_KEY" == "null" ]]; then
  unset CLAUDE_API_KEY
  if [[ "${DEFAULT_AI:-gemini}" == "claude" ]]; then
    echo -e "${C_YELLOW}No Claude API Key provided in config.yaml. Add one via:\\n    ${C_RESET}mt-add-claude-key \\"your-api-key\\"\\e[0m"
  fi
fi"""

g_pat = re.compile(r"if \[\[ -z \"\$GEMINI_API_KEY\".*?unset GEMINI_API_KEY.*?fi", re.DOTALL)
c_pat = re.compile(r"if \[\[ -z \"\$CLAUDE_API_KEY\".*?unset CLAUDE_API_KEY.*?fi", re.DOTALL)

if g_pat.search(content): content = g_pat.sub(lambda _: gemini_new, content)
if c_pat.search(content): content = c_pat.sub(lambda _: claude_new, content)
with open(filepath, "w") as f: f.write(content)
print("  ✅ AI warnings patched.")
'

# ==========================================
# 2. Patch Git Automation & PRs (50-git.sh & 52-git-sync.sh)
# ==========================================
echo -e "\n[2/6] 🔄 Upgrading Git PR logic..."
python3 -c '
import os, re
git_filepath = os.path.expanduser("~/.bash.d/20-vcs/50-git.sh")
sync_filepath = os.path.expanduser("~/.bash.d/20-vcs/52-git-sync.sh")

try:
    with open(git_filepath, "r") as f: git_content = f.read()
    with open(sync_filepath, "r") as f: sync_content = f.read()
except FileNotFoundError:
    print("  🚨 Git files not found, skipping...")
    exit()

new_git_functions = r"""#######################################
# Git: Delete dead or stale branches that have been merged into the default branch
#######################################
git-clean-merged() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
  local default_branch=$(git remote show origin 2> /dev/null | awk '"'"'/HEAD branch/ {print $NF}'"'"')
  default_branch="${default_branch:-main}"
  echo -e "${CB_BLUE}🧹 Fetching latest remote state and pruning tracking branches...${C_RESET}"
  git fetch origin --prune
  echo -e "${CB_BLUE}🔄 Switching to ${default_branch} and pulling latest...${C_RESET}"
  git checkout "$default_branch" && git pull origin "$default_branch"
  echo -e "\n${CB_YELLOW}🔍 Scanning for fully merged local branches...${C_RESET}"
  local merged_branches=$(git branch --merged | grep -v "\*" | grep -v -E "^[[:space:]]*${default_branch}$" | tr -d '"'"' '"'"' || true)
  if [ -z "$merged_branches" ]; then echo -e "${CB_GREEN}✅ Workspace is clean.${C_RESET}"
  else echo "$merged_branches" | xargs -n 1 git branch -d; echo -e "${CB_GREEN}✅ Local branch cleanup complete.${C_RESET}"; fi
  echo -e "\n${CB_YELLOW}🔍 Scanning for fully merged remote branches...${C_RESET}"
  local remote_merged=$(git branch -r --merged origin/"$default_branch" | grep -v "\*" | grep -v HEAD | grep -v -E "origin/${default_branch}$" | sed '"'"'s/origin\///'"'"' | tr -d '"'"' '"'"' || true)
  if [ -z "$remote_merged" ]; then echo -e "${CB_GREEN}✅ No merged remote branches found.${C_RESET}"
  else
    for r_branch in $remote_merged; do
      read -r -p "Delete remote branch '"'"'origin/$r_branch'"'"'? [y/N] " -n 1
      echo; if [[ $REPLY =~ ^[Yy]$ ]]; then git push origin --delete "$r_branch"; fi
    done; echo -e "${CB_GREEN}✅ Remote cleanup complete.${C_RESET}"
  fi
}
alias git-clean-local='"'"'git-clean-merged'"'"'

#######################################
# Git: Push branch and create a Pull Request
#######################################
git-raise-pr() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
  local target_branch="" pr_title="" pr_body=""
  local OPTIND opt; while getopts "b:t:m:" opt; do case ${opt} in b) target_branch="$OPTARG" ;; t) pr_title="$OPTARG" ;; m) pr_body="$OPTARG" ;; esac; done
  shift $((OPTIND - 1))
  local default_branch=$(git remote show origin 2> /dev/null | awk '"'"'/HEAD branch/ {print $NF}'"'"'); default_branch="${default_branch:-main}"; target_branch="${target_branch:-$default_branch}"
  local current_branch=$(git branch --show-current)
  if [ -z "$current_branch" ]; then echo -e "${CB_RED}🚨 Error: Not on any branch.${C_RESET}"; return 1; fi
  if [ "$current_branch" = "$target_branch" ]; then echo -e "${CB_RED}🚨 Error: On target branch.${C_RESET}"; return 1; fi
  echo -e "${CB_BLUE}🔄 Fetching...${C_RESET}"; git fetch origin "$target_branch" > /dev/null 2>&1
  if ! git merge "origin/$target_branch" --no-edit > /dev/null 2>&1; then echo -e "${CB_RED}💥 Merge conflict! Aborting to preserve code.${C_RESET}"; git merge --abort > /dev/null 2>&1; return 1; fi
  local is_github=false; local origin_url=$(git config --get remote.origin.url); [[ "$origin_url" == *"github.com"* ]] && is_github=true
  local pr_state="NONE"; if [ "$is_github" = true ] && command -v gh >/dev/null 2>&1; then pr_state=$(gh pr view "$current_branch" --json state -q .state 2>/dev/null || echo "NONE"); fi
  if [ "$pr_state" = "OPEN" ]; then echo -e "${CB_GREEN}✅ PR exists.${C_RESET}"; git push origin "$current_branch"; return 0
  elif [[ "$pr_state" == "MERGED" || "$pr_state" == "CLOSED" ]]; then
    read -r -p "⚠️ Branch has a $pr_state PR. Delete and checkout new? [Y/n] " -n 1; echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
       read -r -p "Enter new branch name: " new_branch; [ -z "$new_branch" ] && return 1
       git checkout "$target_branch" && git branch -D "$current_branch" && git checkout -b "$new_branch"; current_branch="$new_branch"
    else return 1; fi
  fi
  git push -u origin "$current_branch"
  if [ "$is_github" = true ] && command -v gh >/dev/null 2>&1; then
     if [ -n "$pr_title" ]; then gh pr create --base "$target_branch" --title "$pr_title" --body "$pr_body"
     else gh pr create --base "$target_branch" --fill; fi
     read -r -p "🌐 View PR? [Y/n] " -n 1; echo
     if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then __open_url $(gh pr view --json url -q .url); fi
  else
     local web_url="$origin_url"; web_url="${web_url#git@}"; web_url="${web_url/:/\/}"; web_url="https://${web_url%.git}"
     if [[ "$web_url" == *"bitbucket.org"* ]]; then web_url="${web_url}/pull-requests/new?source=${current_branch}&dest=${target_branch}"
     elif [[ "$web_url" == *"gitlab.com"* ]]; then web_url="${web_url}/-/merge_requests/new?merge_request[source_branch]=${current_branch}&merge_request[target_branch]=${target_branch}"
     elif [[ "$web_url" == *"github.com"* ]]; then web_url="${web_url}/compare/${target_branch}...${current_branch}?expand=1"; fi
     __open_url "$web_url"
  fi
}"""

clean_pat = re.compile(r"#######################################\n# Git: Safely delete all local branches.*?\ngit-clean-local\(\) \{.*?\n\}", re.DOTALL)
if clean_pat.search(git_content):
    git_content = clean_pat.sub(lambda _: new_git_functions, git_content)
    with open(git_filepath, "w") as f: f.write(git_content)
    print("  ✅ 50-git.sh patched (Git PR & Clean rules).")

new_sync = r"""#######################################
# Git: Sync local bash configs to terminal repo and create a Pull Request
#######################################
mt-push-update() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then mt-help "${FUNCNAME[0]}"; return 0; fi
  local issue_num=""; local OPTIND opt; while getopts "i:" opt; do case ${opt} in i) issue_num="$OPTARG" ;; esac; done; shift $((OPTIND - 1))
  local user_msg="$*"; local repo_dir="$SYNC_REPO_DIR"; local remote_url="${SYNC_REPO_URL:-}"
  if [[ -z "$remote_url" || "$remote_url" == "YOUR_SYNC_REPO_URL" || "$remote_url" == "null" ]]; then echo "⚠️ Sync Not Configured"; return 1; fi
  echo "🔄 Syncing bash configuration to $repo_dir..."; __git_sync_init_repo "$repo_dir" "$remote_url"
  (
    cd "$repo_dir" || exit 1
    local default_branch=$(git remote show origin 2> /dev/null | awk '"'"'/HEAD branch/ {print $NF}'"'"'); default_branch="${default_branch:-main}"
    local current_branch=$(git branch --show-current)
    if [ "$current_branch" != "$default_branch" ] && command -v gh >/dev/null 2>&1; then
       local pr_state=$(gh pr view "$current_branch" --json state -q .state 2>/dev/null || echo "NONE")
       if [[ "$pr_state" == "MERGED" || "$pr_state" == "CLOSED" ]]; then
         read -r -p "⚠️ Branch dead. Checkout $default_branch? [Y/n] " -n 1; echo
         if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then git checkout "$default_branch" && git pull origin "$default_branch" && git branch -D "$current_branch"; current_branch="$default_branch"
         else exit 1; fi
       fi
    fi
    if [ "$current_branch" = "$default_branch" ]; then git checkout "$default_branch" >/dev/null 2>&1 || git checkout -b "$default_branch" >/dev/null 2>&1; git pull origin "$default_branch" >/dev/null 2>&1 || true
    else
       git fetch origin "$default_branch" >/dev/null 2>&1; if ! git merge "origin/$default_branch" --no-edit >/dev/null 2>&1; then echo -e "${CB_RED}💥 Merge conflict! Aborting sync.${C_RESET}"; git merge --abort >/dev/null 2>&1; exit 1; fi
    fi
  )
  __git_sync_copy_files "$repo_dir"
  (
    cd "$repo_dir" || exit 1
    if command -v shfmt > /dev/null 2>&1; then shfmt -i 2 -ci -sr -w . > /dev/null 2>&1 || true; fi
    git add --all; if git diff --staged --quiet; then echo "✅ Configurations already up to date."; return 0; fi
    local current_branch=$(git branch --show-current); local default_branch=$(git remote show origin 2> /dev/null | awk '"'"'/HEAD branch/ {print $NF}'"'"'); default_branch="${default_branch:-main}"
    local branch_name="$current_branch"; local pr_title="$user_msg"
    if [ "$current_branch" = "$default_branch" ]; then
        if [ -n "$user_msg" ]; then local slug=$(echo "$user_msg" | sed -E '"'"'s/^[a-zA-Z]+(\([^)]+\))?:[[:space:]]*//'"'"' | tr '"'"'[:upper:]'"'"' '"'"'[:lower:]'"'"' | sed -E '"'"'s/[^a-z0-9]+/-/g'"'"' | sed -E '"'"'s/^-|-$//g'"'"' | cut -c1-40); branch_name="chore/${slug:-update-$(date +%s)}"
        else branch_name="chore/automated-sync-$(date +%Y%m%d-%H%M%S)"; pr_title="chore: automated profile synchronization"; fi
        git checkout -b "$branch_name" > /dev/null 2>&1
    else [ -z "$pr_title" ] && pr_title="chore: automated profile synchronization"; fi
    local pr_body="Automated sync of terminal profile configurations."; [ -n "$issue_num" ] && pr_body="${pr_body}\n\nResolves #${issue_num#\#}"
    if [ -z "$user_msg" ]; then __git_sync_ai_commit "$repo_dir"; git add --all; git diff --staged --quiet || git commit -m "chore: sync miscellaneous updates" > /dev/null
    else git commit -m "$user_msg" > /dev/null; fi
    git-raise-pr -b "$default_branch" -t "$pr_title" -m "$(echo -e "$pr_body")"
  )
}"""

sync_pat = re.compile(r"#######################################\n# Git: Sync local bash configs to terminal repo and create a Pull Request.*?\n\}\n", re.DOTALL)
if sync_pat.search(sync_content):
    sync_content = sync_pat.sub(lambda _: new_sync + "\n", sync_content)
    with open(sync_filepath, "w") as f: f.write(sync_content)
    print("  ✅ 52-git-sync.sh patched (mt-push-update).")
'

# ==========================================
# 3. Patch Bootstrap (04-bootstrap.sh)
# ==========================================
echo -e "\n[3/6] 🔄 Injecting tools into bootstrap..."
python3 -c '
import os, re
filepath = os.path.expanduser("~/.bash.d/00-system/04-bootstrap.sh")
with open(filepath, "r") as f: content = f.read()

tool_injection = r"""
  # Install GitHub CLI (gh)
  if ! command -v gh >/dev/null 2>&1; then
    echo -e "${CB_BLUE}📦 Installing GitHub CLI...${C_RESET}"
    if command -v apt-get >/dev/null 2>&1; then
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null 2>&1
      sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt-get update >/dev/null 2>&1 && sudo apt-get install -y gh >/dev/null 2>&1
    else echo -e "${CB_YELLOW}⚠️ apt-get not found. Install gh manually.${C_RESET}"; fi
  fi
  # Install Claude Code (claude)
  if ! command -v claude >/dev/null 2>&1; then
    if command -v npm >/dev/null 2>&1; then echo -e "${CB_BLUE}📦 Installing Claude Code...${C_RESET}"; sudo npm install -g @anthropic-ai/claude-code >/dev/null 2>&1
    else echo -e "${CB_YELLOW}⚠️ npm not found. Skipping Claude Code.${C_RESET}"; fi
  fi
"""
if "githubcli-archive-keyring" not in content:
    pat = re.compile(r"(bootstrap\(\)\s*\{.*?)(^\}$)", re.DOTALL | re.MULTILINE)
    if pat.search(content):
        content = pat.sub(lambda m: m.group(1) + tool_injection + m.group(2), content)
        with open(filepath, "w") as f: f.write(content)
        print("  ✅ Tools injected into 04-bootstrap.sh")
'

# ==========================================
# 4. Patch cd-win-docker
# ==========================================
echo -e "\n[4/6] 🔄 Injecting dynamic cd-win-docker..."
TARGET_DOCKER_FILE=$(grep -rlw "win-docker" "$HOME/.bash.d/" | grep '\.sh$' | head -n 1)
if [ -n "$TARGET_DOCKER_FILE" ]; then
  python3 -c '
import sys, os
filepath = sys.argv[1]
with open(filepath, "r") as f: content = f.read()
if "cd-win-docker" not in content:
    new_func = r"""
#######################################
# Docker: Change to Docker directory (from config.yaml) and open in Windows Explorer
#######################################
cd-win-docker() {
  local docker_path=$(python3 -c '\''import yaml, os; print(yaml.safe_load(open(os.path.expanduser("~/.bash.d/config/config.yaml"))).get("paths", {}).get("docker_root", ""))'\'' 2>/dev/null)
  docker_path=$(eval echo "$docker_path")
  if [ -z "$docker_path" ]; then echo -e "${CB_RED}🚨 Error: '\''docker_root'\'' missing in config.yaml.${C_RESET}"; return 1; fi
  if [ -d "$docker_path" ]; then
    echo -e "${CB_BLUE}📂 Navigating to ${docker_path}...${C_RESET}"
    cd "$docker_path" || return 1; win-docker
  else echo -e "${CB_RED}🚨 Error: Directory '${docker_path}' missing.${C_RESET}"; return 1; fi
}
"""
    with open(filepath, "a") as f: f.write("\n" + new_func.strip() + "\n")
    print("  ✅ cd-win-docker added.")
' "$TARGET_DOCKER_FILE"
fi

# ==========================================
# 5. Patch mt-copy (06-llm-exports.sh)
# ==========================================
echo -e "\n[5/6] 🔄 Upgrading mt-copy..."
python3 -c '
import os, re
filepath = os.path.expanduser("~/.bash.d/03-mytools/06-llm-exports.sh")
if os.path.exists(filepath):
    with open(filepath, "r") as f: content = f.read()
    new_func = r"""#######################################
# LLM: Copy a file or directory tree to clipboard with headers and extension filters
#######################################
mt-copy() {
  local ext_list="" target=""; local OPTIND opt
  while getopts "e:h" opt; do case ${opt} in
      e) ext_list="$OPTARG" ;;
      h) echo -e "${CB_BLUE}Usage:${C_RESET} mt-copy [-e <ext1,ext2>] <file-or-directory>"; return 0 ;;
      \?) echo "Usage: mt-copy [-e <extensions>] <file-or-directory>" >&2; return 1 ;;
  esac; done; shift $((OPTIND - 1))
  target="${1:-.}"; if [ ! -e "$target" ]; then echo -e "${CB_RED}🚨 Error: '\''$target'\'' missing.${C_RESET}"; return 1; fi
  local clip_cmd=""; if command -v clip.exe >/dev/null 2>&1; then clip_cmd="clip.exe"; elif command -v pbcopy >/dev/null 2>&1; then clip_cmd="pbcopy"; elif command -v xclip >/dev/null 2>&1; then clip_cmd="xclip -selection clipboard"; else echo "🚨 No clipboard utility."; return 1; fi
  echo -e "${CB_BLUE}🔍 Scanning '\''$target'\''...${C_RESET}"; local temp_file=$(mktemp)
  local blocklist_regex=$(python3 -c '\''import yaml, os; print(yaml.safe_load(open(os.path.expanduser("~/.bash.d/config/config.yaml"))).get("exports", {}).get("blocklist", ""))'\'' 2>/dev/null)
  [ -z "$blocklist_regex" ] && blocklist_regex="(secret|token|credential|pass|key|rsa|env|lock\.hcl|__pycache__)"
  local filter_ext=".*"; if [ -n "$ext_list" ]; then local ext_fmt=$(echo "$ext_list" | sed '\''s/,/|/g; s/ //g'\''); filter_ext="\.(${ext_fmt})$"; echo -e "${C_GRAY}   (Filtering for: $ext_list)${C_RESET}"; fi
  local prune_dirs="-name .git -o -name node_modules -o -name .terraform -o -name __pycache__ -o -name .venv"
  if [ -d "$target" ]; then
    find "$target" -type d \( $prune_dirs \) -prune -o -type f -print | grep -E -v "$blocklist_regex" | grep -Ei "$filter_ext" | while IFS= read -r file; do
      if file -b --mime-encoding "$file" | grep -qv "binary"; then echo -e "\n==> $file <==" >> "$temp_file"; cat "$file" >> "$temp_file"; fi
    done
  elif [ -f "$target" ]; then echo -e "==> $target <==" >> "$temp_file"; cat "$target" >> "$temp_file"; fi
  local bytes=$(wc -c < "$temp_file")
  if [ "$bytes" -eq 0 ]; then echo -e "${CB_YELLOW}⚠️ Nothing copied.${C_RESET}"
  else cat "$temp_file" | eval "$clip_cmd"; local lines=$(wc -l < "$temp_file"); echo -e "${CB_GREEN}✅ Copied $lines lines to clipboard!${C_RESET}"; fi
  rm -f "$temp_file"
}"""
    if "mt-copy()" not in content:
        with open(filepath, "a") as f: f.write("\n" + new_func + "\n")
    else:
        pat = re.compile(r"#######################################\n# LLM: Copy a file or directory tree to clipboard.*?\n\}(?=\n|$)", re.DOTALL)
        content = pat.sub(lambda _: new_func, content)
        with open(filepath, "w") as f: f.write(content)
    print("  ✅ mt-copy upgraded.")
'

# ==========================================
# 6. Patch README.md
# ==========================================
echo -e "\n[6/6] 🔄 Updating README.md..."
README_FILE="${SYNC_REPO_DIR:-$(cd .. && pwd)}/README.md"
if [ -f "$README_FILE" ]; then
  python3 -c '
import sys, re
with open("'"$README_FILE"'", "r", encoding="utf-8") as f: content = f.read()
if "## 🚀 Recent Updates" not in content and "## 🚀 Key Features" in content:
    updates = """## 🚀 Recent Updates & Enhancements\n\n* **Intelligent Git Automation:** `git-raise-pr` and `git-clean-merged` for universal PR/branch management.\n* **Advanced AI:** Native Claude Code integration and dynamic API warnings.\n* **Seamless Dev Containers:** Automated `dotfiles` deployment.\n* **Quality of Life:** `mt-copy` for LLM context, `cd-win-docker`, and segmented `.gitignore`.\n\n---\n\n## 🚀 Key Features"""
    content = content.replace("## 🚀 Key Features", updates)
    with open("'"$README_FILE"'", "w", encoding="utf-8") as f: f.write(content)
    print("  ✅ README.md updated.")
'
fi

# ==========================================
# Finalization
# ==========================================
if command -v mt-refresh-caches > /dev/null 2>&1; then
  echo -e "\n🧹 Refreshing MT DevOps caches..."
  mt-refresh-caches > /dev/null 2>&1
fi

echo "🚀 All upgrades applied successfully! Run 'reload' to activate."
