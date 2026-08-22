# shellcheck shell=bash
# ------------------------------------------
# MT Repo Hub - AI & Heuristic Metadata Dashboard
# ------------------------------------------

#######################################
# Repo Hub: Find every git repository under a search root
# Arguments:
#   $1 - Root directory to search
# Outputs:
#   Prints one repository's absolute path per line
#######################################
__mt_hub_find_repos() {
  local search_dir="$1"
  find "$search_dir" -type d -exec test -d "{}/.git" \; -prune -print
}

#######################################
# Repo Hub: Detect a repo's CI/CD provider from known config files
# Arguments:
#   $1 - Repository path
# Outputs:
#   Prints the detected provider name, or "None"
#######################################
__mt_hub_detect_cicd() {
  local repo_path="$1"
  local cicd="None"
  [ -f "$repo_path/bitbucket-pipelines.yml" ] && cicd="Bitbucket Pipelines"
  [ -d "$repo_path/.github/workflows" ] && cicd="GitHub Actions"
  [ -f "$repo_path/.gitlab-ci.yml" ] && cicd="GitLab CI"
  [ -f "$repo_path/Jenkinsfile" ] && cicd="Jenkins"
  [ -f "$repo_path/azure-pipelines.yml" ] && cicd="Azure DevOps"
  echo "$cicd"
}

#######################################
# Repo Hub: Detect a repo's build tool from known manifest files
# Arguments:
#   $1 - Repository path
# Outputs:
#   Prints the detected build tool name, or "None"
#######################################
__mt_hub_detect_build_tool() {
  local repo_path="$1"
  local build="None"
  [ -f "$repo_path/pom.xml" ] && build="Maven"
  [ -f "$repo_path/build.gradle" ] && build="Gradle"
  [ -f "$repo_path/package.json" ] && build="NPM/Yarn"
  if [ -f "$repo_path/requirements.txt" ] || [ -f "$repo_path/Pipfile" ] || [ -f "$repo_path/pyproject.toml" ]; then
    build="Pip/Poetry"
  fi
  [ -f "$repo_path/go.mod" ] && build="Go Modules"
  echo "$build"
}

#######################################
# Repo Hub: Detect a repo's test framework from known conventions
# Arguments:
#   $1 - Repository path
# Outputs:
#   Prints the detected test framework name, or "None"
#######################################
__mt_hub_detect_test_framework() {
  local repo_path="$1"
  local testing="None"
  if [ -d "$repo_path/tests" ] || [ -d "$repo_path/src/test" ]; then
    testing="Standard Dirs"
  fi
  grep -qi "pytest" "$repo_path/requirements.txt" 2> /dev/null && testing="PyTest"
  grep -qi "jest" "$repo_path/package.json" 2> /dev/null && testing="Jest"
  grep -qi "junit" "$repo_path/pom.xml" 2> /dev/null && testing="JUnit"
  echo "$testing"
}

#######################################
# Repo Hub: Detect a repo's primary language/stack by the most common file
# extension among its top-level files
# Arguments:
#   $1 - Repository path
# Outputs:
#   Prints the detected stack name, or "Unknown"
#######################################
__mt_hub_detect_stack() {
  local repo_path="$1"
  local top_ext
  top_ext=$(find "$repo_path" -maxdepth 3 -type f -not -path "*/\.git/*" -not -path "*/node_modules/*" -not -path "*/venv/*" 2> /dev/null | rev | cut -d. -f1 | rev | grep -E "^(py|java|js|ts|tf|go|sh|cpp|c|html|css)$" | sort | uniq -c | sort -rn | head -n1 | awk '{print $2}')

  local stack="Unknown"
  case "$top_ext" in
    py) stack="Python" ;;
    java) stack="Java" ;;
    tf) stack="Terraform" ;;
    js) stack="JavaScript" ;;
    ts) stack="TypeScript" ;;
    go) stack="Go" ;;
    sh) stack="Bash/Shell" ;;
    html) stack="HTML/Web" ;;
  esac
  echo "$stack"
}

#######################################
# Repo Hub: Ask the configured AI to produce a 1-sentence description and
# category for a repository, based on its README and directory tree
# Arguments:
#   $1 - Repository path
# Globals (written, expected pre-declared local by the caller):
#   ai_description, ai_category
#######################################
__mt_hub_summarize_repo() {
  local repo_path="$1"
  local ai_prompt="Analyze this repository structure and README. Return ONLY a valid JSON object matching exactly this schema: {\"description\": \"A highly concise 1-sentence description of what this project does\", \"category\": \"Application\" | \"Infrastructure\" | \"CI/CD\" | \"Tooling\" | \"Library\" | \"Dotfiles\" | \"Other\"}"

  local ctx_file
  ctx_file=$(mktemp)
  [ -f "$repo_path/README.md" ] && head -c 2000 "$repo_path/README.md" > "$ctx_file"
  echo -e "\n\nDIRECTORY TREE:\n" >> "$ctx_file"
  find "$repo_path" -maxdepth 2 -not -path "*/\.git/*" -not -path "*/node_modules/*" >> "$ctx_file"

  local ai_res
  ai_res=$(ai -f "$ctx_file" "$ai_prompt" 2> /dev/null)
  rm -f "$ctx_file"

  ai_description="No description available."
  ai_category="Unknown"
  [ -z "$ai_res" ] && return 0

  local clean_json
  # shellcheck disable=SC2016
  clean_json=$(echo "$ai_res" | sed 's/```json//gi; s/```//g')
  echo "$clean_json" | jq -e . > /dev/null 2>&1 || return 0

  ai_description=$(echo "$clean_json" | jq -r '.description // "No description available."')
  ai_category=$(echo "$clean_json" | jq -r '.category // "Unknown"')
}

#######################################
# Repo Hub: Decide whether a repo should be indexed given the active
# type/name filters and cache/force-reindex state
# Arguments:
#   $1 - Repository path
#   $2 - VCS search root (used to derive the repo's type from its
#        relative path)
#   $3 - Type filter (lowercased; empty = no filter)
#   $4 - Name filter (empty = no filter)
#   $5 - Cache file path
#   $6 - force_reindex (true/false)
# Returns:
#   0 if the repo should be indexed, 1 if it should be skipped
#######################################
__mt_hub_should_index() {
  local repo_path="$1" search_dir="$2" filter_type="$3" filter_repo="$4" cache_file="$5" force_reindex="$6"
  local repo_name
  repo_name=$(basename "$repo_path")

  local rel_path="${repo_path#"$search_dir"/}"
  local repo_type="Root"
  [[ "$rel_path" == */* ]] && repo_type="${rel_path%%/*}"

  [ -n "$filter_type" ] && [ "${repo_type,,}" != "$filter_type" ] && return 1
  [ -n "$filter_repo" ] && [ "$repo_name" != "$filter_repo" ] && return 1

  local exists="false"
  [ -f "$cache_file" ] && exists=$(jq -r "has(\"$repo_path\")" "$cache_file" 2> /dev/null || echo "false")

  if [ "$exists" = "true" ] && [ "$force_reindex" != "true" ]; then
    echo -e "${C_DIM}⏭️  Skipping $repo_name (already indexed)${C_RESET}"
    return 1
  fi
  return 0
}

#######################################
# Repo Hub: Run all heuristics and AI summarization for one repo and
# persist the result into the JSON cache
# Arguments:
#   $1 - Repository path
#   $2 - Path to the JSON cache file
#######################################
__mt_hub_index_one_repo() {
  local repo_path="$1" cache_file="$2"
  local repo_name
  repo_name=$(basename "$repo_path")

  echo -e "${CB_YELLOW}⚙️  Indexing $repo_name...${C_RESET}"

  local cicd build testing stack
  cicd=$(__mt_hub_detect_cicd "$repo_path")
  build=$(__mt_hub_detect_build_tool "$repo_path")
  testing=$(__mt_hub_detect_test_framework "$repo_path")
  stack=$(__mt_hub_detect_stack "$repo_path")

  local ai_description="" ai_category=""
  __mt_hub_summarize_repo "$repo_path"

  local tmp_cache
  tmp_cache=$(mktemp)
  jq --arg r "$repo_path" \
    --arg c "$ai_category" \
    --arg d "$ai_description" \
    --arg s "$stack" \
    --arg b "$build" \
    --arg ci "$cicd" \
    --arg t "$testing" \
    '.[$r] = {"category": $c, "description": $d, "stack": $s, "build": $b, "cicd": $ci, "testing": $t}' \
    "$cache_file" > "$tmp_cache" && mv "$tmp_cache" "$cache_file"

  echo -e "${CB_GREEN}✅ Indexed $repo_name${C_RESET}"
}

#######################################
# Repo Hub: Index every discovered repository under VCS_ROOT into the
# heuristic/AI metadata cache
# Usage: __mt_hub_index <cache_file> <filter_type> <filter_repo> <force_reindex>
# Globals:
#   VCS_ROOT
# Arguments:
#   $1 - Path to the JSON cache file
#   $2 - Type filter (empty = no filter)
#   $3 - Name filter (empty = no filter)
#   $4 - force_reindex (true/false)
#######################################
__mt_hub_index() {
  local cache_file="$1"
  local filter_type="${2,,}"
  local filter_repo="$3"
  local force_reindex="$4"
  local search_dir="${VCS_ROOT:-$HOME/vcs}"

  local msg_suffix=""
  [ -n "$filter_type" ] && msg_suffix=" of type '${filter_type}'"
  [ -n "$filter_repo" ] && msg_suffix="${msg_suffix} matching repo '${filter_repo}'"
  echo -e "${CB_BLUE}🔍 Scanning for repositories to index${msg_suffix}...${C_RESET}"

  local repos=()
  local repo_path
  while IFS= read -r repo_path; do repos+=("$repo_path"); done < <(__mt_hub_find_repos "$search_dir")

  local processed=0
  for repo_path in "${repos[@]}"; do
    __mt_hub_should_index "$repo_path" "$search_dir" "$filter_type" "$filter_repo" "$cache_file" "$force_reindex" || continue
    processed=$((processed + 1))
    __mt_hub_index_one_repo "$repo_path" "$cache_file"
  done

  if [ "$processed" -eq 0 ]; then
    mt-log WARN "No repositories matched your filter criteria."
  else
    echo -e "\n${CB_GREEN}🎉 Indexing complete! Run 'mt-hub' to view the dashboard.${C_RESET}"
  fi
}

__mt_hub_preview() {
  local repo="$1"
  local cache_file="$2"

  local repo_name
  repo_name=$(basename "$repo")
  echo -e "${CB_CYAN}============================================================${C_RESET}"
  echo -e "${CB_BLUE} 📦 ${repo_name}${C_RESET}"
  echo -e "${CB_CYAN}============================================================${C_RESET}\n"

  local meta
  meta=$(jq -r ".[ \"$repo\" ] // empty" "$cache_file" 2> /dev/null)

  if [ -z "$meta" ] || [ "$meta" == "null" ]; then
    echo -e "${CB_YELLOW}⚠️ No metadata found.${C_RESET}\n"
    echo -e "Run ${CB_GREEN}mt-hub --index${C_RESET} to generate AI insights and heuristics for this repository."
    return 0
  fi

  local cat
  cat=$(echo "$meta" | jq -r '.category')
  local desc
  desc=$(echo "$meta" | jq -r '.description')
  local stack
  stack=$(echo "$meta" | jq -r '.stack')
  local build
  build=$(echo "$meta" | jq -r '.build')
  local cicd
  cicd=$(echo "$meta" | jq -r '.cicd')
  local test_fw
  test_fw=$(echo "$meta" | jq -r '.testing')

  echo -e "${CB_MAGENTA}▶ OVERVIEW${C_RESET}"
  echo -e "${C_RESET}${desc}${C_RESET}\n"

  echo -e "${CB_MAGENTA}▶ ARCHITECTURE METADATA${C_RESET}"
  echo -e " ${CB_CYAN}Category    :${C_RESET} ${cat}"
  echo -e " ${CB_CYAN}Tech Stack  :${C_RESET} ${stack}"
  echo -e " ${CB_CYAN}Build Tools :${C_RESET} ${build}"
  echo -e " ${CB_CYAN}CI/CD       :${C_RESET} ${cicd}"
  echo -e " ${CB_CYAN}Testing     :${C_RESET} ${test_fw}"

  echo -e "\n${CB_MAGENTA}▶ RECENT COMMITS${C_RESET}"
  git -C "$repo" log -3 --format="%C(yellow)%h%Creset - %s %Cgreen(%cr)%Creset" 2> /dev/null || echo "No commits yet."
}

#######################################
# System: Interactive AI-powered Repository Dashboard
# Usage: mt-hub [--index] [-t|--type type] [-r|--repo name]
# Options:
#   --index       Scan and build the AI metadata cache
#   -t, --type    Filter indexing to a specific folder (e.g. personal, work)
#   -r, --repo    Filter indexing to a specific repository name
#######################################
mt-hub() {
  local cache_file="$HOME/.bash.d/data/cache/.vcs_hub.json"
  mkdir -p "$(dirname "$cache_file")"
  [ ! -f "$cache_file" ] && echo "{}" > "$cache_file"

  local do_index=false
  local run_bg=false
  local force_index=false
  local filter_type=""
  local filter_repo=""

  # Argument parsing
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --index) do_index=true ;;
      -b | --bg | --background) run_bg=true ;;
      -f | --force) force_index=true ;;
      -t | --type)
        filter_type="$2"
        shift
        ;;
      -r | --repo)
        filter_repo="$2"
        shift
        ;;
      --preview)
        __mt_hub_preview "$2" "$cache_file"
        return 0
        ;;
      -h | --help)
        mt-help "${FUNCNAME[0]}"
        return 0
        ;;
      *)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
    esac
    shift
  done

  if [ "$do_index" = true ]; then
    if [ "$run_bg" = true ]; then
      local log_out
      log_out="${LOG_DIR:-$HOME/.bash.d/data/logs}/indexer_$(date +%s).log"
      local cmd_str="__mt_hub_index \"$cache_file\" \"$filter_type\" \"$filter_repo\" \"$force_index\""
      __mt_bg_run "mt-hub-indexer" "$log_out" "$cmd_str"
    else
      __mt_hub_index "$cache_file" "$filter_type" "$filter_repo" "$force_index"
    fi
    return 0
  fi

  local search_dir="${VCS_ROOT:-$HOME/vcs}"
  local tmp_out
  tmp_out=$(mktemp)

  while IFS= read -r repo_path; do
    [ -z "$repo_path" ] && continue
    local repo_name
    repo_name=$(basename "$repo_path")

    local rel_path="${repo_path#"$search_dir"/}"
    local repo_type="Root"
    if [[ "$rel_path" == */* ]]; then
      repo_type="${rel_path%%/*}"
    fi
    repo_type="$(tr '[:lower:]' '[:upper:]' <<< "${repo_type:0:1}")${repo_type:1}"

    local branch
    branch=$(git -C "$repo_path" branch --show-current 2> /dev/null || echo "HEAD detached")
    [ -z "$branch" ] && branch="No commits"

    echo "${repo_type}|${repo_name}|${branch}|${repo_path}" >> "$tmp_out"
  done < <(find "$search_dir" -type d -exec test -d "{}/.git" \; -prune -print)

  sort -t'|' -k1,1 -k2,2 "$tmp_out" -o "$tmp_out"

  local selected
  selected=$(awk -F'|' '
    function pad(str, len) {
      if (length(str) > len) return substr(str, 1, len-3) "..."
      return str sprintf("%*s", len - length(str), "")
    }
    {
      printf "%s │ %s │ %s │ %s\n", pad($1, 15), pad($2, 35), pad($3, 20), $4
    }
  ' "$tmp_out" | fzf --ansi --prompt="VCS Hub > " --header="TYPE            │ REPOSITORY                          │ BRANCH               " --with-nth=1..3 --preview="bash -c 'source ~/.bash.d/01-ui/01-colors.sh; source ~/.bash.d/20-vcs/53-vcs-insight.sh; __mt_hub_preview \"{4}\" \"$cache_file\"'")

  rm -f "$tmp_out"

  if [ -n "$selected" ]; then
    local target_path
    target_path=$(echo "$selected" | awk -F' │ ' '{print $4}' | sed 's/^[ \t]*//;s/[ \t]*$//')
    echo -e "${CB_GREEN}📂 Navigating to: $target_path${C_RESET}"
    cd "$target_path" || true
  fi
}
