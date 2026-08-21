# shellcheck shell=bash
# ------------------------------------------
# Version Control (Git) - AI Workflows
# ------------------------------------------
# ~/.bash.d/20-vcs/51-git-ai.sh

#######################################
# Git: Analyze git diff and generate feature-grouped AI commits
# Globals:
#   GEMINI_API_KEY, CLAUDE_API_KEY, DEFAULT_AI, AI_MAX_DIFF_BYTES
# Arguments:
#   $1 - Target repository directory
# Returns:
#   0 on success, 1 on failure/missing keys, 99/100 on bypass/rate limit
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

  local base_prompt
  base_prompt=$(__get_prompt "git_commit")
  local ai_prompt="${base_prompt}\n\n${diff_content}"

  local response=""
  local query_status=0
  if [ "$provider" = "gemini" ]; then
    response=$(__ai_query_gemini "$ai_prompt" "" "" "" "")
    query_status=$?
  elif [ "$provider" = "claude" ]; then
    response=$(__ai_query_claude "$ai_prompt" "" "" "")
    query_status=$?
  elif [ "$provider" = "local" ]; then
    response=$(__ai_query_local "$ai_prompt" "" "" "")
    query_status=$?
  else
    echo "🚨 Error: Invalid provider '$provider'." >&2
    return 1
  fi

  if [ $query_status -eq 99 ]; then return 0; fi
  if [ $query_status -eq 100 ]; then return 100; fi

  local generated_json
  generated_json=$(__ai_extract_json_array "$response")

  if [ -n "$generated_json" ] && echo "$generated_json" | jq -e . > /dev/null 2>&1; then
    git -C "$repo_dir" reset HEAD > /dev/null 2>&1

    echo "$generated_json" | jq -c '.[]' | while read -r commit_obj; do
      local msg
      msg=$(echo "$commit_obj" | jq -r '.message')
      local files_staged=0

      while read -r file_path; do
        if [ -e "$repo_dir/$file_path" ] || git -C "$repo_dir" ls-files --error-unmatch "$file_path" > /dev/null 2>&1; then
          if ! git -C "$repo_dir" check-ignore -q "$file_path"; then
            git -C "$repo_dir" add "$file_path" > /dev/null 2>&1
            files_staged=1
          fi
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
# Git: Auto-format, stage, generate AI commits, and push all changes
# Usage: git-ai-push-all [optional_commit_message]
# Arguments:
#   $1 - Optional user commit message (bypasses AI)
#######################################
git-ai-push-all() {
  __git_auto_format "."
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

    local loop_count=0
    local max_loops=10

    while ! git diff --staged --quiet; do
      ((loop_count++))

      if [ "$loop_count" -gt "$max_loops" ]; then
        echo "⚠️ AI loop limit reached. Batch committing remaining files..."
        git commit -m "chore: automated changes (batch remainder)"
        break
      fi

      local prev_staged
      prev_staged=$(git diff --staged --name-only | wc -l)

      __git_sync_ai_commit "."
      local commit_status=$?
      if [ $commit_status -eq 100 ]; then
        echo -e "${CB_RED}🚨 Aborting push.${C_RESET}"
        return 1
      elif [ $commit_status -ne 0 ]; then
        echo "⚠️ AI commit generation skipped or failed. Falling back to default batch commit..."
        git add .
        git commit -m "chore: automated changes"
        break
      fi

      git add .

      local next_staged
      next_staged=$(git diff --staged --name-only | wc -l)
      if [ "$prev_staged" -eq "$next_staged" ]; then
        echo "⚠️ AI failed to process the remaining diff chunks. Batch committing..."
        git commit -m "chore: automated changes (batch remainder)"
        break
      fi
    done
  fi

  echo "🚀 Pushing changes to remote..."
  git push
}

#######################################
# Git: Preflight safety checks for AI file generation (.gitignore, README)
# Arguments:
#   $1 - Target filename (e.g., .gitignore, README.md)
#######################################
__git_ai_preflight_check() {
  local target_file="$1"

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${CB_RED}🚨 Error: Not inside a Git repository.${C_RESET}" >&2
    return 1
  fi

  if [[ "$PWD" == "$HOME" || "$PWD" == "/" || "$PWD" == "$VCS_ROOT" ]]; then
    echo -e "${CB_RED}🚨 Error: Refusing to generate $target_file in a root/home directory.${C_RESET}" >&2
    return 1
  fi

  local file_count
  file_count=$(find . -type f -not -path "*/\.git/*" -not -path "*/node_modules/*" -not -path "*/venv/*" -not -path "*/\.terraform/*" 2> /dev/null | head -n 1000 | wc -l)
  if [ "$file_count" -ge 1000 ]; then
    echo -e "${CB_YELLOW}⚠️  Warning: This directory contains 1000+ files. AI context may exceed limits.${C_RESET}" >&2
    read -p "Proceed anyway? [y/N] " -n 1 -r < /dev/tty
    echo > /dev/tty
    [[ ! $REPLY =~ ^[Yy]$ ]] && {
      echo "🛑 Aborted." >&2
      return 1
    }
  fi

  if [ -f "$target_file" ]; then
    echo -e "${CB_YELLOW}⚠️  A $target_file file already exists.${C_RESET}" >&2
    read -p "Do you want to overwrite it? [y/N] " -n 1 -r < /dev/tty
    echo > /dev/tty
    [[ ! $REPLY =~ ^[Yy]$ ]] && {
      echo "🛑 Aborted." >&2
      return 1
    }
  fi

  return 0
}

#######################################
# AI: Generate a comprehensive .gitignore for the active repository
#######################################
mt-ai-gitignore() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  __git_ai_preflight_check ".gitignore" || return 0

  local prompt
  prompt=$(__get_prompt "git_gitignore")

  echo -e "${CB_BLUE}🤖 Analyzing project structure to generate .gitignore...${C_RESET}"
  ai -e -o ".gitignore" -t "project-gitignore" "$prompt"
}

#######################################
# AI: Generate a comprehensive README.md for the active repository
#######################################
mt-ai-readme() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  __git_ai_preflight_check "README.md" || return 0

  local prompt
  prompt=$(__get_prompt "git_readme")

  echo -e "${CB_BLUE}🤖 Analyzing codebase to generate README.md...${C_RESET}"
  ai -e -o "README.md" -t "project-readme" "$prompt"
}

#######################################
# Git: Generate COMMANDS.md reference and ask AI to update README.md summary
# Arguments:
#   $1 - Target repository directory path
#######################################
__git_sync_ai_docs() {
  local repo_dir="$1"
  echo "📚 Generating COMMANDS.md reference..."
  cat << 'MARKDOWN_EOF' > "$repo_dir/COMMANDS.md"
# MT DevOps Framework - Command Reference

This document is automatically generated on every sync and lists all available framework functions and aliases.

---

## 🔗 Aliases
Shortcuts for common commands and CLI replacements.
MARKDOWN_EOF

  if [ -f "$HOME/.bash.d/data/cache/.mt_data.tsv" ]; then
    local awk_script="$HOME/.bash.d/lib/awk/commands_md.awk"
    local tsv_data="$HOME/.bash.d/data/cache/.mt_data.tsv"

    awk -v target_type="alias" -f "$awk_script" <(sort -t$'	' -k2,2 -k3,3 "$tsv_data") >> "$repo_dir/COMMANDS.md"

    echo -e "
---

## 🛠️ Functions
Complex bash functions, framework utilities, and automated workflows." >> "$repo_dir/COMMANDS.md"

    awk -v target_type="func" -f "$awk_script" <(sort -t$'	' -k2,2 -k3,3 "$tsv_data") >> "$repo_dir/COMMANDS.md"
  fi

  local provider="${DEFAULT_AI:-gemini}"
  if [ "$provider" = "gemini" ] && [[ -z "${GEMINI_API_KEY:-}" || "$GEMINI_API_KEY" == "YOUR_GEMINI_API_KEY" ]]; then return 0; fi
  if [ "$provider" = "claude" ] && [[ -z "${CLAUDE_API_KEY:-}" || "$CLAUDE_API_KEY" == "YOUR_CLAUDE_API_KEY" ]]; then return 0; fi

  git -C "$repo_dir" add --all
  local diff_content
  diff_content=$(git -C "$repo_dir" diff --staged -- ':!COMMANDS.md' ':!README.md' | head -c 8000)

  if [ -z "$diff_content" ]; then return 0; fi

  echo "🤖 Asking $provider to summarize changes for README.md..."
  local base_prompt
  base_prompt=$(__get_prompt "git_readme_summary")
  base_prompt="${base_prompt}\n\n${diff_content}"

  local response=""
  local query_status=0
  if [ "$provider" = "gemini" ]; then
    response=$(__ai_query_gemini "$base_prompt" "" "" "" "")
    query_status=$?
  elif [ "$provider" = "claude" ]; then
    response=$(__ai_query_claude "$base_prompt" "" "" "")
    query_status=$?
  elif [ "$provider" = "local" ]; then
    response=$(__ai_query_local "$base_prompt" "" "" "")
    query_status=$?
  fi

  if [ $query_status -eq 99 ]; then return 0; fi
  if [ $query_status -eq 100 ]; then return 100; fi

  local clean_updates
  if echo "$response" | jq -e . > /dev/null 2>&1; then
    clean_updates=$(echo "$response" | jq -r '.message // .code // .')
  else
    clean_updates=$(echo "$response" | sed 's/```json//gi; s/```markdown//gi; s/```//g')
  fi

  if [ -n "$clean_updates" ] && [ -f "$repo_dir/README.md" ]; then
    python3 "$HOME/.bash.d/lib/python/update_readme_summary.py" "$repo_dir/README.md" "$clean_updates"
  fi
}
