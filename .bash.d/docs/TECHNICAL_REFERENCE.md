# 🛠️ MT DevOps Framework - Technical Command Reference

> **Auto-generated Reference Document**  
> Generated: Sat Aug 22 05:30:05 PM BST 2026  
> Environment: Linux (x86_64)

---


## 🔗 Shell Aliases

- **`mt-reload-config`** *(Configuration Management)*: Config: Forcefully re-parse config.yaml and reload environment variables
- **`k`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Core Kubectl Wrapper
- **`ka`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Apply configuration from file
- **`kak`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Apply configuration using Kustomize
- **`kd`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Describe resources
- **`kdcm`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Describe configmaps
- **`kddep`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Describe deployments
- **`kding`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Describe ingresses
- **`kdno`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Describe nodes
- **`kdpo`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Describe pods
- **`kdsec`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Describe secrets
- **`kdsts`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Describe statefulsets
- **`kdsvc`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Describe services
- **`kex`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Exec into a pod interactively
- **`kg`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Get resources
- **`kgall`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Get resources across all namespaces
- **`kgcm`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Get configmaps
- **`kgdep`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Get deployments
- **`kging`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Get ingresses
- **`kgno`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Get nodes
- **`kgns`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Get namespaces
- **`kgpo`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Get pods
- **`kgsec`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Get secrets
- **`kgsts`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Get statefulsets
- **`kgsvc`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Get services
- **`klo`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Tail logs for a pod
- **`klop`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Tail logs for a previous instance of a pod
- **`kpf`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Port forward to a pod or service
- **`krm`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Delete resources by name
- **`krmdep`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Delete deployments
- **`krmf`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Delete resources from file
- **`krmpo`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Delete pods
- **`ksys`** *(Container Orchestration (Kubernetes) Aliases)*: Kubernetes: Shortcut for the kube-system namespace
- **`boot-run`** *(Development & Build Tools)*: Dev: Spring Boot - Run application
- **`mci`** *(Development & Build Tools)*: Dev: Maven - Clean and Install
- **`pip-load`** *(Development & Build Tools)*: Dev: Python - Install pip requirements
- **`pip-save`** *(Development & Build Tools)*: Dev: Python - Save pip requirements
- **`ruff-fmt`** *(Development & Build Tools)*: Dev: Python - Format Python files and imports using Ruff (recursive)
- **`shfmtlw`** *(Development & Build Tools)*: Dev: Shell - Format all shell scripts in current directory (recursive)
- **`venv-make`** *(Development & Build Tools)*: Dev: Python - Create & active Python venv
- **`venv-up`** *(Development & Build Tools)*: Dev: Python - Activate existing Python venv
- **`gcpp`** *(GCP: Configuration & Authentication)*: GCP: Legacy shortcut to set project
- **`bq-ls`** *(GCP: Resources & Services)*: GCP: BigQuery - List datasets in project
- **`gce-ls`** *(GCP: Resources & Services)*: GCP: Compute - List all VM instances
- **`gce-ssh`** *(GCP: Resources & Services)*: GCP: Compute - SSH into an instance
- **`gcl-gar-ls`** *(GCP: Resources & Services)*: GCP: Artifact Registry - List repositories
- **`gcl-iam-ls`** *(GCP: Resources & Services)*: GCP: IAM - List service accounts in active project
- **`gcl-ps-subs`** *(GCP: Resources & Services)*: GCP: PubSub - List subscriptions
- **`gcl-ps-topics`** *(GCP: Resources & Services)*: GCP: PubSub - List topics
- **`gcp-crf-ls`** *(GCP: Resources & Services)*: GCP: Cloud Run Functions - List functions
- **`gcs-ls`** *(GCP: Resources & Services)*: GCP: Cloud Storage - List buckets or contents
- **`mt-history`** *(General System Utilities)*: System: Display history of executed framework commands (Alias)
- **`cat`** *(Modern CLI Replacements)*: CLI: bat - Print file contents with syntax highlighting
- **`ccat`** *(Modern CLI Replacements)*: CLI: bat - Print file contents with line numbers & Git gutters
- **`json-fmt`** *(Modern CLI Replacements)*: CLI: jq - Pretty-print JSON stream
- **`ll`** *(Modern CLI Replacements)*: CLI: eza - Detailed list with Git status
- **`ls`** *(Modern CLI Replacements)*: CLI: eza - List files with directories first
- **`rg`** *(Modern CLI Replacements)*: CLI: rg - Search with smart case, include hidden, ignore .git
- **`tree`** *(Modern CLI Replacements)*: CLI: eza - Display directory structure as a tree
- **`tree-clean`** *(Modern CLI Replacements)*: CLI: eza - Display directory structure ignoring bloat (.git, node_modules, etc)
- **`yaml-fmt`** *(Modern CLI Replacements)*: CLI: yq - Pretty-print YAML stream
- **`mt-search`** *(MyTools Documentation & Runner)*: MyTools: Search through available mytools commands (Alias)
- **`cd-mt-git-local`** *(Path & URL Launchers (Config-Driven))*: System: Change directory to dotfiles repository root (Alias)
- **`cd-bashd`** *(System & Navigation Aliases)*: System: Change directory to ~/.bash.d
- **`cd-git-home`** *(System & Navigation Aliases)*: System: Change directory to ~/vcs
- **`cd-git-personal`** *(System & Navigation Aliases)*: System: Change directory to ~/vcs/personal
- **`mt-home`** *(System & Navigation Aliases)*: System: Change directory to ~/.bash.d
- **`refresh`** *(System & Navigation Aliases)*: System: Reload Bash profile and caches
- **`reload`** *(System & Navigation Aliases)*: System: Reload Bash profile and caches
- **`sys-update-install`** *(System & Navigation Aliases)*: System: Update, Upgrade, Boostrap, and Reload
- **`tf`** *(Terraform Aliases)*: Terraform: Core Execution
- **`tfa`** *(Terraform Aliases)*: Terraform: Apply changes
- **`tfap`** *(Terraform Aliases)*: Terraform: Apply the saved plan file
- **`tfay`** *(Terraform Aliases)*: Terraform: Apply changes (Auto-Approve)
- **`tfc`** *(Terraform Aliases)*: Terraform: Open interactive console
- **`tfd`** *(Terraform Aliases)*: Terraform: Destroy infrastructure
- **`tfdy`** *(Terraform Aliases)*: Terraform: Destroy infrastructure (Auto-Approve)
- **`tff`** *(Terraform Aliases)*: Terraform: Format all files recursively
- **`tfin`** *(Terraform Aliases)*: Terraform: Initialize working directory
- **`tfinu`** *(Terraform Aliases)*: Terraform: Initialize and upgrade modules/providers
- **`tfo`** *(Terraform Aliases)*: Terraform: Read outputs from state
- **`tfp`** *(Terraform Aliases)*: Terraform: Generate execution plan
- **`tfpd`** *(Terraform Aliases)*: Terraform: Generate destruction plan
- **`tfpo`** *(Terraform Aliases)*: Terraform: Generate a saved plan file (tfplan)
- **`tf-refresh`** *(Terraform Aliases)*: Terraform: Refresh state without applying changes (Modern)
- **`tfs`** *(Terraform Aliases)*: Terraform: State management commands
- **`tfsh`** *(Terraform Aliases)*: Terraform: Show current state or plan
- **`tfsls`** *(Terraform Aliases)*: Terraform: List resources in state
- **`tfsmv`** *(Terraform Aliases)*: Terraform: Move an item in state
- **`tfsrm`** *(Terraform Aliases)*: Terraform: Remove an item from state
- **`tfssw`** *(Terraform Aliases)*: Terraform: Show a single resource in state
- **`tfv`** *(Terraform Aliases)*: Terraform: Validate configuration files
- **`tfw`** *(Terraform Aliases)*: Terraform: Workspace management commands
- **`tfwde`** *(Terraform Aliases)*: Terraform: Delete a workspace
- **`tfwls`** *(Terraform Aliases)*: Terraform: List workspaces
- **`tfwnw`** *(Terraform Aliases)*: Terraform: Create a new workspace
- **`tfwst`** *(Terraform Aliases)*: Terraform: Select an existing workspace
- **`tfwsw`** *(Terraform Aliases)*: Terraform: Show the current workspace name
- **`tfy`** *(Terraform Aliases)*: Terraform: Shortcut alias for tf-yaml
- **`tf-scan`** *(Terraform & Kubernetes Wrappers)*: Terraform: Scan local terraform directory (./terraform) with Checkov
- **`git-clean-local`** *(Version Control (Git) - Core Helpers)*: Git: Delete local and remote branches merged into default branch
- **`mt-hard-reload`** *(Zoxide (Smart cd replacement))*: System: Forcefully clear and rebuild all background caches and reload profile
- **`mtindp`** *(Zoxide (Smart cd replacement))*: MT-Framework: Update the DevOps-MT-Framework with Shellcheck and Backup Creation
- **`mtupd`** *(Zoxide (Smart cd replacement))*: Version Control (Git) - Profile Synchronisation: Auto-sync framework with Shellcheck, Backup and Auto-Merge
- **`mtupd-ai`** *(Zoxide (Smart cd replacement))*: Version Control (Git) - Update: Update Framework with Shellcheck, Backup, Auto-Merge and AI

---

## 🛠️ Public Functions


### 📂 AI Workflows & LLM API Integration


#### `ai`

> AI: Query configured LLM with prompt and optional context	/home/mst/.bash.d/30-ai/60-ai.sh

```bash
#######################################
# AI: Query configured LLM with prompt and optional context
# Globals:
#   DEFAULT_AI
# Usage: ai [OPTIONS] <prompt>
# Options:
#   -m <model>     Override provider model (gemini, claude, local)
#   -t <title>     Set context title
#   -e             Attach entire active directory as context
#   -f <file>      Attach a single file as context
#   -o <out_file>  Save output directly to specified file
#   -v <version>   Override model version
#   -x             Force extended reasoning mode
#   -h, --help     Show this help menu
#######################################
ai() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }

  local title="" export_context=false target_file="" explicit_out_file="" req_version="" req_extended=false
  local provider="${DEFAULT_AI:-gemini}" prompt=""

  OPTIND=1
  while getopts "m:t:ef:o:v:x" opt; do
    case ${opt} in
      m) provider="$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')" ;;
      t) title=$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]' | tr ' ' '-') ;;
      e) export_context=true ;;
      f) target_file="$OPTARG" ;;
      o) explicit_out_file="$OPTARG" ;;
      v) req_version="$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')" ;;
      x) req_extended=true ;;
      \?)
        echo "Usage: ai [-m gemini|claude] [-t title] [-e] [-f file] [-o out_file] [-v version] [-x] <prompt>" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))
  prompt="$*"

  [ -z "${prompt}" ] && {
    echo "Usage: ai [-m gemini|claude] [-t title] [-e] [-f file] [-o out_file] [-v version] [-x] <your question>" >&2
    return 1
  }

  local context_file
  if ! context_file=$(__ai_build_context "$target_file" "$export_context"); then
    return 1
  fi

  local content=""
  if [ "$provider" = "gemini" ]; then
    if ! content=$(__ai_query_gemini "$prompt" "$title" "$context_file" "$req_version" "$req_extended"); then return 1; fi
  elif [ "$provider" = "claude" ]; then
    if ! content=$(__ai_query_claude "$prompt" "$title" "$context_file" "$req_version"); then return 1; fi
  elif [ "$provider" = "local" ]; then
    if ! content=$(__ai_query_local "$prompt" "$title" "$context_file" "$req_version"); then return 1; fi
  else
    echo "🚨 Error: Invalid provider '$provider'." >&2
    return 1
  fi

  [ -f "$context_file" ] && rm -f "$context_file"

  __ai_parse_response "$content" "$provider" "$title" "$explicit_out_file"
}
```

#### `ai-explain`

> AI: Explain a terminal command in detail	/home/mst/.bash.d/30-ai/60-ai.sh

```bash
#######################################
# AI: Explain a terminal command in detail
# Usage: ai-explain "<command>"
# Arguments:
#   $1 - Command string to explain
#######################################
ai-explain() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$1" ]; then
    echo "Usage: ai-explain \"<command>\""
    return 1
  fi
  mt-log INFO "Asking AI to explain: $1..."
  ai -t "command-explanation" "Please explain this terminal command in detail, breaking down what each flag and argument does: $1"
}
```

#### `mt-ai-debug`

> AI: Debug and explain the last failed terminal command	/home/mst/.bash.d/30-ai/60-ai.sh

```bash
#######################################
# AI: Debug and explain the last failed terminal command
#######################################
mt-ai-debug() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local last_cmd
  last_cmd=$(fc -ln -2 | head -n 1 | xargs)

  mt-log INFO "Re-running and debugging: $last_cmd..."
  local err_out
  err_out=$(eval "$last_cmd" 2>&1 > /dev/null)

  if [ -z "$err_out" ]; then
    mt-log SUCCESS "Command executed successfully. No errors to debug!"
  else
    ai -t "debug-error" "The command \`$last_cmd\` failed with this stderr output:\n\n$err_out\n\nPlease explain why it failed and provide the exact command to fix it."
  fi
}
```

#### `mt-ai-quota`

> AI: Check API quota and rate limits for the active AI provider	/home/mst/.bash.d/30-ai/60-ai.sh

```bash
#######################################
# AI: Check API quota and rate limits for the active AI provider
# Usage: mt-ai-quota
# Globals:
#   DEFAULT_AI
#######################################
mt-ai-quota() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local provider="${DEFAULT_AI:-gemini}"

  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e "${CB_CYAN} 📊 AI Provider Quota Check (${provider^})${C_RESET}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"

  case "$provider" in
    claude) __mt_ai_quota_check_claude ;;
    gemini) __mt_ai_quota_check_gemini ;;
    local)
      echo -e "  ${CB_GREEN}✅ Local LLM selected.${C_RESET}"
      echo -e "  ${C_DIM}No cloud quotas apply to localhost environments! Run indefinitely.${C_RESET}"
      ;;
  esac

  echo -e "${CB_BLUE}==========================================================${C_RESET}"
}
```

### 📂 Base64 Encoding & Decoding Utilities


#### `base64-cli`

> System: Encode or decode a string, file, or stream to/from Base64	/home/mst/.bash.d/02-utilities/25-encoding.sh

```bash
#######################################
# System: Encode or decode a string, file, or stream to/from Base64
# Usage: base64-cli [-d] [-f file] [-o file] [string]
# Arguments:
#   -d          Decode instead of encode
#   -f <file>   Path to local input file
#   -o <file>   Path to write output file (defaults to stdout)
#   [string]    Literal string to encode/decode if no file or stdin is provided
#######################################
base64-cli() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local input_file="" output_file="" input_str="" decode=false

  local OPTIND opt
  while getopts "df:o:" opt; do
    case ${opt} in
      d) decode=true ;;
      f) input_file="$OPTARG" ;;
      o) output_file="$OPTARG" ;;
      \?)
        echo "Usage: base64-cli [-d] [-f file] [-o file] [string]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))
  input_str="$*"

  local b64_flag=() verb="Encoded"
  if [ "$decode" = true ]; then
    b64_flag=(-d)
    verb="Decoded"
  fi

  local result=""

  if [ -n "$input_file" ]; then
    if [ ! -f "$input_file" ]; then
      echo -e "${C_RED}🚨 Error: Input file '$input_file' not found.${C_RESET}" >&2
      return 1
    fi
    result=$(base64 "${b64_flag[@]}" < "$input_file")
  elif [ -n "$input_str" ]; then
    result=$(echo -n "$input_str" | base64 "${b64_flag[@]}")
  else
    if [ ! -t 0 ]; then
      result=$(base64 "${b64_flag[@]}")
    else
      echo "Usage: base64-cli [-d] [-f file] [-o file] [string]" >&2
      return 1
    fi
  fi

  if [ -n "$output_file" ]; then
    echo -n "$result" > "$output_file"
    echo -e "${C_GREEN}✅ ${verb} output written to $output_file${C_RESET}"
  else
    echo "$result"
  fi
}
```

#### `base64-dec`

> System: Decode a Base64 string, file, or stream (shortcut for `base64-cli -d`)	/home/mst/.bash.d/02-utilities/25-encoding.sh

```bash
#######################################
# System: Decode a Base64 string, file, or stream (shortcut for `base64-cli -d`)
# Arguments:
#   -f <file>   Path to local input file containing Base64 text
#   -o <file>   Path to write output file (defaults to stdout)
#   [string]    Literal Base64 string to decode if no file or stdin is provided
#######################################
base64-dec() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  base64-cli -d "$@"
}
```

#### `base64-enc`

> System: Encode a string, file, or stream to Base64 (shortcut for `base64-cli`)	/home/mst/.bash.d/02-utilities/25-encoding.sh

```bash
#######################################
# System: Encode a string, file, or stream to Base64 (shortcut for `base64-cli`)
# Arguments:
#   -f <file>   Path to local input file
#   -o <file>   Path to write output file (defaults to stdout)
#   [string]    Literal string to encode if no file or stdin is provided
#######################################
base64-enc() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  base64-cli "$@"
}
```

### 📂 Configuration Management


#### `mt-add-sync-url`

> Config: Set the sync repository URL	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Set the sync repository URL
# Arguments:
#   $1 - Remote repository URL
#######################################
mt-add-sync-url() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$1" ]; then
    echo "Usage: mt-add-sync-url <repo_url>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "git" "sync_repo_url" "$1"
  export SYNC_REPO_URL="$1"
  echo "✅ Sync repository URL set to $1."
}
```

#### `mt-get-gemini-status`

> AI: Print current Gemini API model version and extended reasoning mode toggle	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# AI: Print current Gemini API model version and extended reasoning mode toggle
#######################################
mt-get-gemini-status() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e "${CB_BLUE}                 GEMINI CONFIGURATION                     ${C_RESET}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e " ${CB_CYAN}GEMINI_VERSION    ${C_RESET}: ${GEMINI_VERSION:-Not Set}"
  echo -e " ${CB_CYAN}GEMINI_EXTENDED   ${C_RESET}: ${GEMINI_EXTENDED:-false}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
}
```

#### `mt-load-config`

> Config: Forcefully re-parse config.yaml and reload environment variables	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Forcefully re-parse config.yaml and reload environment variables
#######################################
mt-load-config() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_BLUE}🔄 Forcefully re-parsing config.yaml...${C_RESET}"

  local env_cache="$HOME/.bash.d/data/cache/.env.cache"
  rm -f "$env_cache" "$HOME/.bash.d/config/.env.cache" 2> /dev/null

  if [ -f "$CONFIG_MANAGER" ]; then
    python3 "$CONFIG_MANAGER" load-env > "$env_cache"
    chmod 600 "$env_cache" 2> /dev/null
    # shellcheck disable=SC1090
    source "$env_cache"
    if [ -f "$HOME/vcs/secrets/secrets.sh" ]; then
      # shellcheck disable=SC1091
      source "$HOME/vcs/secrets/secrets.sh"
    fi
    echo -e "${CB_GREEN}✅ Config reloaded! Active variables updated.${C_RESET}"
  else
    echo -e "${CB_RED}🚨 Error: config_manager.py not found.${C_RESET}"
    return 1
  fi
}
```

#### `mt-open-config`

> Config: Open bash.d directory and config.yaml in IDE	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Open bash.d directory and config.yaml in IDE
# Usage: mt-open-config [-ide vscode|intellij]
# Options:
#   -ide <name>   Override default IDE launcher
#######################################
mt-open-config() {
  local selected_ide="${DEFAULT_IDE:-vscode}"
  local args=()

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
        args+=("$1")
        shift
        ;;
    esac
  done

  local config_dir="$HOME/.bash.d"
  local config_file="$config_dir/config/config.yaml"
  local yaml_tpl="$config_dir/lib/templates/config.yaml.tpl"

  if [ ! -s "$config_file" ]; then
    mkdir -p "$(dirname "$config_file")"
    [ -f "$yaml_tpl" ] && cp "$yaml_tpl" "$config_file"
  fi

  echo "🚀 Opening bash config in $selected_ide..."
  if [ "$selected_ide" = "intellij" ]; then
    __launch_intellij "$config_dir" "$config_file" || echo "⚠️ Could not launch IntelliJ. Ensure 'idea' is on PATH (JetBrains Toolbox), or install IntelliJ IDEA via Homebrew on macOS."
  else
    code "$config_dir" "$config_file"
  fi
}
```

#### `mt-set-cicd`

> Config: Set default CI/CD provider	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Set default CI/CD provider
# Usage: mt-set-cicd "github|bitbucket|gitlab|azure|jenkins"
# Arguments:
#   $1 - CI/CD provider identifier
#######################################
mt-set-cicd() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [[ "$1" != "github" && "$1" != "bitbucket" && "$1" != "gitlab" && "$1" != "azure" && "$1" != "jenkins" ]]; then
    echo "Usage: mt-set-cicd <github|bitbucket|gitlab|azure|jenkins>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "cicd" "provider" "$1"
  export CICD_PROVIDER="$1"
  echo "✅ CI/CD provider set to $1."
}
```

#### `mt-set-default-ai`

> Config: Set default AI model provider	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Set default AI model provider
# Usage: mt-set-default-ai "gemini|claude|local"
# Arguments:
#   $1 - AI provider identifier
#######################################
mt-set-default-ai() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [[ "$1" != "gemini" && "$1" != "claude" && "$1" != "local" ]]; then
    echo "Usage: mt-set-default-ai <gemini|claude|local>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "ai" "default_provider" "$1"
  export DEFAULT_AI="$1"
  echo "✅ Default AI set to $1."
}
```

#### `mt-set-default-ide`

> Config: Set default terminal IDE launcher	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Set default terminal IDE launcher
# Usage: mt-set-default-ide "vscode|intellij"
# Arguments:
#   $1 - IDE identifier (vscode or intellij)
#######################################
mt-set-default-ide() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [[ "$1" != "vscode" && "$1" != "intellij" ]]; then
    echo "Usage: mt-set-default-ide <vscode|intellij>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "system" "default_ide" "$1"
  export DEFAULT_IDE="$1"
  echo "✅ Default IDE set to $1."
}
```

#### `mt-set-theme`

> Config: Set terminal color theme	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Set terminal color theme
# Usage: mt-set-theme "theme_name"
# Arguments:
#   $1 - Valid theme name (e.g. default, dracula, monokai)
#######################################
mt-set-theme() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local theme="${1:-default}"

  if [ ! -f "$HOME/.bash.d/config/themes/$theme.sh" ]; then
    echo "🚨 Invalid theme. Ensure $theme.sh exists in $HOME/.bash.d/config/themes/"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "system" "theme" "$theme"
  export BASH_THEME="$theme"
  echo "✅ Terminal theme set to $theme."
}
```

#### `mt-setup`

> Config: Launch the interactive Master Setup Wizard Menu	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Launch the interactive Master Setup Wizard Menu
#######################################
mt-setup() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e "${CB_BLUE}        MT DEVOPS FRAMEWORK - MASTER SETUP WIZARD         ${C_RESET}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}\n"

  local options=(
    "1. Quick Setup (First-Time Defaults)"
    "2. System Configuration"
    "3. AI Provider Configuration"
    "4. Exports & Cleanup Configuration"
    "5. Workspace & Directory Paths"
    "6. Git & Version Control"
    "7. CI/CD Default Provider"
    "8. Docker Preferences"
    "9. Exit"
  )

  local choice
  choice=$(printf '%s\n' "${options[@]}" | fzf --prompt="⚙️ Select a category to configure > " --height=~15 --layout=reverse --border)

  case "$choice" in
    1*) __mt_setup_quick ;;
    2*) mt-wizard-system ;;
    3*) mt-wizard-ai ;;
    4*) mt-wizard-exports ;;
    5*) mt-wizard-paths ;;
    6*) mt-wizard-git ;;
    7*) mt-wizard-cicd ;;
    8*) mt-wizard-docker ;;
    *)
      echo "⚠️ Setup cancelled."
      return 0
      ;;
  esac

  mt-refresh-caches > /dev/null 2>&1
  echo -e "${CB_GREEN}✅ Configuration saved! Run 'reload' to apply changes fully.${C_RESET}"
}
```

#### `mt-setup-ai`

> Config: Interactive AI Setup Menu (deprecated alias)	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive AI Setup Menu (deprecated alias)
# Deprecated: use mt-wizard-ai instead.
#######################################
mt-setup-ai() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  mt-wizard-ai "$@"
}
```

#### `mt-setup-cicd`

> Config: Interactive CI/CD Setup Menu (deprecated alias)	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive CI/CD Setup Menu (deprecated alias)
# Deprecated: use mt-wizard-cicd instead.
#######################################
mt-setup-cicd() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  mt-wizard-cicd "$@"
}
```

#### `mt-setup-docker`

> Config: Interactive Docker Setup Menu (deprecated alias)	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive Docker Setup Menu (deprecated alias)
# Deprecated: use mt-wizard-docker instead.
#######################################
mt-setup-docker() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  mt-wizard-docker "$@"
}
```

#### `mt-setup-exports`

> Config: Interactive Exports Setup Menu (deprecated alias)	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive Exports Setup Menu (deprecated alias)
# Deprecated: use mt-wizard-exports instead.
#######################################
mt-setup-exports() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  mt-wizard-exports "$@"
}
```

#### `mt-setup-git`

> Config: Interactive Git Setup Menu (deprecated alias)	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive Git Setup Menu (deprecated alias)
# Deprecated: use mt-wizard-git instead.
#######################################
mt-setup-git() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  mt-wizard-git "$@"
}
```

#### `mt-setup-paths`

> Config: Interactive Paths Setup Menu (deprecated alias)	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive Paths Setup Menu (deprecated alias)
# Deprecated: use mt-wizard-paths instead.
#######################################
mt-setup-paths() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  mt-wizard-paths "$@"
}
```

#### `mt-set-upstream-path`

> Config: Set the upstream repository path for framework updates	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Set the upstream repository path for framework updates
# Arguments:
#   $1 - The repository path (e.g., "MatStacey/mt-devops-framework")
#######################################
mt-set-upstream-path() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$1" ]; then
    echo "Usage: mt-set-upstream-path <MatStacey/mt-devops-framework>"
    return 1
  fi
  python3 "$CONFIG_MANAGER" update "git" "upstream_repo_path" "$1"
  export UPSTREAM_REPO_PATH="$1"
  echo "✅ Upstream repository path set to $1."
}
```

#### `mt-setup-system`

> Config: Interactive System Setup Menu (deprecated alias)	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive System Setup Menu (deprecated alias)
# Deprecated: use mt-wizard-system instead.
#######################################
mt-setup-system() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  mt-wizard-system "$@"
}
```

#### `mt-toggle-ai`

> Config: Toggle global AI prompt and workflow integration (true/false)	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Toggle global AI prompt and workflow integration (true/false)
#######################################
mt-toggle-ai() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local new_val="true"
  [ "${AI_ENABLED:-true}" = "true" ] && new_val="false"
  python3 "$CONFIG_MANAGER" update "ai" "enabled" "$new_val"
  export AI_ENABLED="$new_val"
  echo "✅ AI integration set to $new_val."
}
```

#### `mt-toggle-format-on-push`

> Config: Toggle global format-on-push behavior (true/false)	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Toggle global format-on-push behavior (true/false)
#######################################
mt-toggle-format-on-push() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local current="${GIT_FORMAT_ON_PUSH:-true}"
  local next="true"
  [ "$current" = "true" ] && next="false"

  python3 "$CONFIG_MANAGER" update "git" "format_on_push" "$next"
  export GIT_FORMAT_ON_PUSH="$next"
  echo "✅ Format-on-push set to $next."
}
```

#### `mt-wizard-ai`

> Config: Interactive AI Setup Menu	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive AI Setup Menu
#######################################
mt-wizard-ai() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- AI Configuration ---${C_RESET}"
  read -r -p "Enable AI Features? (true/false) [${AI_ENABLED:-true}]: " enabled
  [ -n "$enabled" ] && python3 "$CONFIG_MANAGER" update "ai" "enabled" "$enabled"
  read -r -p "Default Provider (gemini/claude/local) [${DEFAULT_AI:-gemini}]: " prov
  [ -n "$prov" ] && python3 "$CONFIG_MANAGER" update "ai" "default_provider" "$prov"

  echo -e "\n${CB_CYAN}Gemini Settings:${C_RESET}"
  read -r -p "Gemini Model Version [${GEMINI_VERSION:-gemini-3.6-flash}]: " g_ver
  [ -n "$g_ver" ] && python3 "$CONFIG_MANAGER" update "ai.gemini" "version" "$g_ver"
  echo -e "  ${C_DIM}🔑 Manage your Gemini API Key directly in ~/vcs/secrets/secrets.sh${C_RESET}"

  echo -e "\n${CB_CYAN}Claude Settings:${C_RESET}"
  read -r -p "Claude Model Version [${CLAUDE_VERSION:-claude-3-7-sonnet-latest}]: " c_ver
  [ -n "$c_ver" ] && python3 "$CONFIG_MANAGER" update "ai.claude" "version" "$c_ver"
  echo -e "  ${C_DIM}🔑 Manage your Claude API Key directly in ~/vcs/secrets/secrets.sh${C_RESET}"

  echo -e "\n${CB_CYAN}Local AI Settings:${C_RESET}"
  read -r -p "Local AI Base URL [${LOCAL_AI_BASE_URL:-http://localhost:11434/v1}]: " l_url
  [ -n "$l_url" ] && python3 "$CONFIG_MANAGER" update "ai.local" "base_url" "$l_url"
  read -r -p "Local AI Model [${LOCAL_AI_MODEL:-llama3.2}]: " l_mod
  [ -n "$l_mod" ] && python3 "$CONFIG_MANAGER" update "ai.local" "model" "$l_mod"

  echo -e "${CB_GREEN}✅ AI config updated.${C_RESET}"
}
```

#### `mt-wizard-cicd`

> Config: Interactive CI/CD Setup Menu	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive CI/CD Setup Menu
#######################################
mt-wizard-cicd() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- CI/CD Configuration ---${C_RESET}"
  read -r -p "Default Provider (github/bitbucket/gitlab/azure/jenkins) [${CICD_PROVIDER:-github}]: " prov
  [ -n "$prov" ] && python3 "$CONFIG_MANAGER" update "cicd" "provider" "$prov"
  echo -e "${CB_GREEN}✅ CI/CD config updated.${C_RESET}"
}
```

#### `mt-wizard-docker`

> Config: Interactive Docker Setup Menu	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive Docker Setup Menu
#######################################
mt-wizard-docker() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- Docker Configuration ---${C_RESET}"
  read -r -p "Restart Blocklist (comma-separated) [${DOCKER_BLOCKLIST:-redis,postgres,local-db}]: " blk
  [ -n "$blk" ] && python3 "$CONFIG_MANAGER" update "docker" "restart_blocklist" "$blk"
  echo -e "${CB_GREEN}✅ Docker config updated.${C_RESET}"
}
```

#### `mt-wizard-exports`

> Config: Interactive Exports Setup Menu	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive Exports Setup Menu
#######################################
mt-wizard-exports() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- Exports Configuration ---${C_RESET}"
  read -r -p "Auto Cleanup Exports? (true/false) [${AUTO_CLEANUP_EXPORTS:-true}]: " cln
  [ -n "$cln" ] && python3 "$CONFIG_MANAGER" update "exports" "auto_cleanup" "$cln"
  read -r -p "Auto Cleanup Threshold (days) [${AUTO_CLEANUP_DAYS:-7}]: " days
  [ -n "$days" ] && python3 "$CONFIG_MANAGER" update "exports" "auto_cleanup_days" "$days"
  read -r -p "Regex Blocklist [${EXPORT_BLOCKLIST}]: " blk
  [ -n "$blk" ] && python3 "$CONFIG_MANAGER" update "exports" "blocklist" "$blk"
  echo -e "${CB_GREEN}✅ Exports config updated.${C_RESET}"
}
```

#### `mt-wizard-git`

> Config: Interactive Git Setup Menu	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive Git Setup Menu
#######################################
mt-wizard-git() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- Git Configuration ---${C_RESET}"
  local default_sync="${UPSTREAM_REPO_PATH:-MatStacey/mt-devops-framework}"
  read -r -p "Sync Repo URL [${SYNC_REPO_URL:-$default_sync}]: " sync_url
  [ -n "$sync_url" ] && python3 "$CONFIG_MANAGER" update "git" "sync_repo_url" "$sync_url"

  read -r -p "Upstream Framework Path [${UPSTREAM_REPO_PATH:-MatStacey/mt-devops-framework}]: " upstream
  [ -n "$upstream" ] && python3 "$CONFIG_MANAGER" update "git" "upstream_repo_path" "$upstream"

  read -r -p "Format on Push? (true/false) [${GIT_FORMAT_ON_PUSH:-true}]: " fmt
  [ -n "$fmt" ] && python3 "$CONFIG_MANAGER" update "git" "format_on_push" "$fmt"

  read -r -p "Feature Branch Prefix [${GIT_FEATURE_PREFIX:-feature/}]: " prefix
  [ -n "$prefix" ] && python3 "$CONFIG_MANAGER" update "git" "feature_prefix" "$prefix"

  read -r -p "AI Max Diff Bytes [${AI_MAX_DIFF_BYTES:-4000}]: " bytes
  [ -n "$bytes" ] && python3 "$CONFIG_MANAGER" update "git" "ai_max_diff_bytes" "$bytes"
  echo -e "${CB_GREEN}✅ Git config updated.${C_RESET}"
}
```

#### `mt-wizard-paths`

> Config: Interactive Paths Setup Menu -- prompts for and persists the	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive Paths Setup Menu -- prompts for and persists the
# framework's core filesystem paths (VCS roots, dotfiles repo, AI
# workspace, IAM scripts, Docker root, export/backup directories)
# Usage: mt-wizard-paths
# Globals:
#   VCS_ROOT, VCS_PERSONAL, VCS_EXPORTS, DOTFILES_DIR, AI_WORKSPACE_DIR,
#   SCRIPTS_IAM_DIR, DOCKER_ROOT_DIR, EXPORT_DIR, BACKUP_DIR, CONFIG_MANAGER
#######################################
mt-wizard-paths() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- Paths Configuration ---${C_RESET}"
  local vcs_root_input
  read -r -p "VCS Root [${VCS_ROOT:-~/vcs}]: " vcs_root_input
  [ -n "$vcs_root_input" ] && python3 "$CONFIG_MANAGER" update "paths" "vcs_root" "$vcs_root_input"
  local vcs_personal_input
  read -r -p "VCS Personal [${VCS_PERSONAL:-~/vcs/personal}]: " vcs_personal_input
  [ -n "$vcs_personal_input" ] && python3 "$CONFIG_MANAGER" update "paths" "vcs_personal" "$vcs_personal_input"
  local vcs_exports_input
  read -r -p "VCS Exports [${VCS_EXPORTS:-~/vcs/personal/exports}]: " vcs_exports_input
  [ -n "$vcs_exports_input" ] && python3 "$CONFIG_MANAGER" update "paths" "vcs_exports" "$vcs_exports_input"
  local dotfiles_dir_input
  read -r -p "Dotfiles Repo [${DOTFILES_DIR:-~/vcs/personal/mt-devops-framework}]: " dotfiles_dir_input
  [ -n "$dotfiles_dir_input" ] && python3 "$CONFIG_MANAGER" update "paths" "dotfiles_dir" "$dotfiles_dir_input"
  local ai_workspace_input
  read -r -p "AI Workspace [${AI_WORKSPACE_DIR:-~/vcs/workspaces/ai}]: " ai_workspace_input
  [ -n "$ai_workspace_input" ] && python3 "$CONFIG_MANAGER" update "paths" "ai_workspace" "$ai_workspace_input"
  local iam_scripts_input
  read -r -p "IAM Scripts [${SCRIPTS_IAM_DIR:-/tmp/scripts/iam}]: " iam_scripts_input
  [ -n "$iam_scripts_input" ] && python3 "$CONFIG_MANAGER" update "paths" "scripts_iam" "$iam_scripts_input"
  local docker_root_input
  read -r -p "Docker Root [${DOCKER_ROOT_DIR:-~/.docker}]: " docker_root_input
  [ -n "$docker_root_input" ] && python3 "$CONFIG_MANAGER" update "paths" "docker_root" "$docker_root_input"
  local export_dir_input
  read -r -p "Export Dir [${EXPORT_DIR:-/tmp/exports}]: " export_dir_input
  [ -n "$export_dir_input" ] && python3 "$CONFIG_MANAGER" update "paths" "export_dir" "$export_dir_input"
  local backup_dir_input
  read -r -p "Backup Dir [${BACKUP_DIR:-~/backups}]: " backup_dir_input
  [ -n "$backup_dir_input" ] && python3 "$CONFIG_MANAGER" update "paths" "backup_dir" "$backup_dir_input"
  echo -e "${CB_GREEN}✅ Paths config updated.${C_RESET}"
}
```

#### `mt-wizard-system`

> Config: Interactive System Setup Menu	/home/mst/.bash.d/00-system/00-config.sh

```bash
#######################################
# Config: Interactive System Setup Menu
#######################################
mt-wizard-system() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- System Configuration ---${C_RESET}"
  read -r -p "Default IDE (vscode/intellij) [${DEFAULT_IDE:-vscode}]: " ide
  [ -n "$ide" ] && python3 "$CONFIG_MANAGER" update "system" "default_ide" "$ide"
  read -r -p "Max Parallel Threads [${MAX_PARALLEL_THREADS:-8}]: " threads
  [ -n "$threads" ] && python3 "$CONFIG_MANAGER" update "system" "max_parallel_threads" "$threads"
  read -r -p "Update Check TTL (seconds) [${UPDATE_CHECK_TTL_SEC:-43200}]: " ttl
  [ -n "$ttl" ] && python3 "$CONFIG_MANAGER" update "system" "update_check_ttl_sec" "$ttl"
  echo -e "${CB_GREEN}✅ System config updated.${C_RESET}"
}
```

### 📂 Container Orchestration


#### `kubectl`

> Kubernetes: Core kubectl wrapper (preserves args)	/home/mst/.bash.d/10-infra/40-terraform-k8s.sh

```bash
#######################################
# Kubernetes: Core kubectl wrapper (preserves args)
# Note: Does NOT intercept --help to preserve native kubectl help.
# Run `mt-help kubectl` for framework documentation.
#######################################
kubectl() {
  echo "+ kubectl $*" >&2
  command kubectl "$@"
}
```

### 📂 Container Orchestration (Kubernetes) Aliases


#### `kns`

> Kubernetes: Get or explicitly set the active namespace in the current context	/home/mst/.bash.d/10-infra/42-kubectl-aliases.sh

```bash
#######################################
# Kubernetes: Get or explicitly set the active namespace in the current context
# Arguments:
#   $1 - (Optional) Namespace name to switch to. If blank, prints active namespace.
#######################################
kns() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$1" ]; then
    local current
    current=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2> /dev/null)
    echo -e "${CB_CYAN}Current Namespace:${C_RESET} ${current:-default}"
  else
    kubectl config set-context --current --namespace="$1" > /dev/null
    echo -e "${CB_GREEN}✅ Active namespace set to: $1${C_RESET}"
  fi
}
```

### 📂 GCP: Configuration & Authentication


#### `gcl-config`

> GCP: List active configuration properties	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: List active configuration properties
# Arguments:
#   $@ - (Optional) Additional arguments passed directly to 'gcloud config list'
#######################################
gcl-config() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud config list "$@"
}
```

#### `gcl-export-vars`

> GCP: Export PROJECT_ID and PROJECT_NUMBER env vars to shell	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: Export PROJECT_ID and PROJECT_NUMBER env vars to shell
# Arguments:
#   $1 - (Optional) <project_id> to export.
#        Pass '-ls' to list available projects.
#        If left blank, opens an interactive fzf menu.
#######################################
gcl-export-vars() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  if [[ "$1" == "-ls" ]]; then
    gcloud projects list --format="table(projectId,name,projectNumber)"
    return 0
  fi

  local target_project="$1"

  if [ -z "$target_project" ]; then
    target_project=$(gcloud projects list --format="value(projectId)" | fzf --prompt="Select GCP Project to Export > ")
    if [ -z "$target_project" ]; then
      echo "⚠️ Project selection cancelled."
      return 0
    fi
  fi

  export PROJECT_ID="$target_project"

  if [ -n "$PROJECT_ID" ]; then
    export PROJECT_NUMBER
    PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format='value(projectNumber)')
    echo "✅ Exported PROJECT_ID=${PROJECT_ID} and PROJECT_NUMBER=${PROJECT_NUMBER}"
  else
    echo "🚨 Error: Could not determine active project ID."
  fi
}
```

#### `gcl-get`

> GCP: Print an active gcloud configuration property	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: Print an active gcloud configuration property
# Usage: gcl-get <project|project-number|region|user|zone>
#######################################
gcl-get() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  case "$1" in
    project) __get_gcp_config_val "project" ;;
    project-number)
      local project_id
      project_id=$(__get_gcp_config_val "project")
      [ -n "$project_id" ] && gcloud projects describe "$project_id" --format="value(projectNumber)"
      ;;
    region) __get_gcp_config_val "region" ;;
    zone) __get_gcp_config_val "zone" ;;
    user) __get_gcp_config_val "account" ;;
    *)
      echo "Usage: gcl-get <project|project-number|region|user|zone>" >&2
      return 1
      ;;
  esac
}
```

#### `gcl-get-project`

> GCP: Print active project ID (shortcut for `gcl-get project`)	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: Print active project ID (shortcut for `gcl-get project`)
#######################################
gcl-get-project() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcl-get project
}
```

#### `gcl-get-project-number`

> GCP: Print active project Number, API call required (shortcut for `gcl-get project-number`)	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: Print active project Number, API call required (shortcut for `gcl-get project-number`)
#######################################
gcl-get-project-number() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcl-get project-number
}
```

#### `gcl-get-region`

> GCP: Print active compute region (shortcut for `gcl-get region`)	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: Print active compute region (shortcut for `gcl-get region`)
#######################################
gcl-get-region() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcl-get region
}
```

#### `gcl-get-user`

> GCP: Print active user account (shortcut for `gcl-get user`)	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: Print active user account (shortcut for `gcl-get user`)
#######################################
gcl-get-user() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcl-get user
}
```

#### `gcl-get-zone`

> GCP: Print active compute zone (shortcut for `gcl-get zone`)	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: Print active compute zone (shortcut for `gcl-get zone`)
#######################################
gcl-get-zone() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcl-get zone
}
```

#### `gcl-org-policies`

> GCP: List org policies for active project	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: List org policies for active project
#######################################
gcl-org-policies() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local project_id
  project_id=$(gcl-get-project)
  [ -n "$project_id" ] && gcloud alpha resource-manager org-policies list --project="$project_id"
}
```

#### `gcl-update`

> GCP: Update Google Cloud CLI tools	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: Update Google Cloud CLI tools
#######################################
gcl-update() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo "Checking for Google Cloud CLI updates..."
  if command -v apt-get > /dev/null && dpkg -l | grep -q "google-cloud-cli"; then
    sudo apt-get update && sudo apt-get install --only-upgrade google-cloud-cli
  else
    gcloud components update
  fi
}
```

#### `gcp-login`

> GCP: Login to user & application default	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: Login to user & application default
#######################################
gcp-login() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud auth login && gcloud auth application-default login
}
```

#### `gcp-login-adc`

> GCP: Login to application default only	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: Login to application default only
#######################################
gcp-login-adc() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud auth application-default login
}
```

#### `gcp-set-project`

> GCP: Switch active project	/home/mst/.bash.d/10-infra/30-gcp-config.sh

```bash
#######################################
# GCP: Switch active project
# Arguments:
#   $1 - (Optional) <project_id> to switch to.
#        Pass '-ls' to list available projects.
#        If left blank, opens an interactive fzf menu.
#######################################
gcp-set-project() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  if [[ "$1" == "-ls" ]]; then
    gcloud projects list --format="table(projectId,name,projectNumber)"
    return 0
  fi

  local project="$1"

  if [ -z "$project" ]; then
    project=$(gcloud projects list --format="value(projectId)" | fzf --prompt="Select GCP Project > ")
    if [ -z "$project" ]; then
      echo "⚠️ Project selection cancelled."
      return 0
    fi
  fi

  gcloud config set project "$project"
}
```

### 📂 GCP: Resources & Services


#### `bq-query`

> GCP: Run standard SQL query in BigQuery	/home/mst/.bash.d/10-infra/31-gcp-services.sh

```bash
#######################################
# GCP: Run standard SQL query in BigQuery
# Arguments:
#   $1 - SQL query string (e.g., "SELECT...")
# Outputs:
#   Prints query results table to STDOUT
#######################################
bq-query() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  bq query --use_legacy_sql=false "$1"
}
```

#### `gcl-as-json`

> GCP: Run any gcloud command and output as formatted JSON	/home/mst/.bash.d/10-infra/31-gcp-services.sh

```bash
#######################################
# GCP: Run any gcloud command and output as formatted JSON
# Arguments:
#   $@ - gcloud command and arguments
# Outputs:
#   Prints formatted JSON to STDOUT
#######################################
gcl-as-json() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud "$@" --format="json" | jq '.'
}
```

#### `gcp-crf-logs`

> GCP: Tail logs of a Cloud Run Function	/home/mst/.bash.d/10-infra/31-gcp-services.sh

```bash
#######################################
# GCP: Tail logs of a Cloud Run Function
# Arguments:
#   $1 - Function Name
#   $2 - Limit (default: 50)
# Outputs:
#   Prints log stream to STDOUT
#######################################
gcp-crf-logs() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local target_function="$1"
  local line_limit="${2:-50}"

  gcloud functions logs read "$target_function" --limit="$line_limit"
}
```

#### `gcp-gar-docker`

> GCP: Configure Docker auth for Artifact Registry	/home/mst/.bash.d/10-infra/31-gcp-services.sh

```bash
#######################################
# GCP: Configure Docker auth for Artifact Registry
# Arguments:
#   $1 - Region (e.g., us-central1)
#######################################
gcp-gar-docker() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud auth configure-docker "$1-docker.pkg.dev"
}
```

#### `gcp-get-secret`

> GCP: Read the latest payload of a secret	/home/mst/.bash.d/10-infra/31-gcp-services.sh

```bash
#######################################
# GCP: Read the latest payload of a secret
# Arguments:
#   $1 - Secret Name
# Outputs:
#   Prints secret payload string to STDOUT
#######################################
gcp-get-secret() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud secrets versions access latest --secret="$1"
}
```

#### `gcp-iam-show`

> GCP: View IAM policy for the active project	/home/mst/.bash.d/10-infra/31-gcp-services.sh

```bash
#######################################
# GCP: View IAM policy for the active project
# Globals:
#   gcl-get-project (Framework Function)
# Outputs:
#   Prints tabular IAM policy bindings to STDOUT
#######################################
gcp-iam-show() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud projects get-iam-policy "$(gcl-get-project)" --format="table(bindings.role, bindings.members)"
}
```

#### `gcp-ps-pull`

> GCP: Pull and auto-ack one message from a Pub/Sub subscription	/home/mst/.bash.d/10-infra/31-gcp-services.sh

```bash
#######################################
# GCP: Pull and auto-ack one message from a Pub/Sub subscription
# Arguments:
#   $1 - Subscription Name
# Outputs:
#   Prints the pulled message to STDOUT
#######################################
gcp-ps-pull() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud pubsub subscriptions pull "$1" --auto-ack --limit=1
}
```

### 📂 General System Utilities


#### `mt-alias`

> System: Interactively create or update an alias	/home/mst/.bash.d/02-utilities/99-utils.sh

```bash
#######################################
# System: Interactively create or update an alias
# Usage: mt-alias [-u alias_name] [-i]
# Options:
#   -u, --update <name>   Update a specific existing alias
#   -i, --interactive     Select an existing alias to update via fzf
#######################################
mt-alias() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local update_name="" interactive=false
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -u | --update)
        update_name="$2"
        shift 2
        ;;
      -i | --interactive)
        interactive=true
        shift
        ;;
      *)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
    esac
  done
  if [ "$interactive" = true ]; then
    update_name=$(awk -F'\t' '$1 == "alias" { printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv" | fzf --ansi --prompt="Select Alias to Update > " | awk '{print $1}')
    [ -z "$update_name" ] && return 0
  fi
  local alias_name="$update_name" default_cmd="" default_cat="User Custom" default_desc="" aliases_file="$HOME/.bash.d/02-utilities/20-aliases.sh"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  if [ -n "$alias_name" ]; then
    if ! grep -qE "^[ \t]*alias ${alias_name}=" "$aliases_file"; then
      echo -e "${CB_RED}🚨 Error: Alias '${alias_name}' not found.${C_RESET}"
      return 1
    fi
    echo -e "${CB_CYAN} 🛠️  Update Existing Alias: ${alias_name}${C_RESET}"
    default_cmd=$(grep -E "^[ \t]*alias ${alias_name}=" "$aliases_file" | sed -E "s/^[ \t]*alias ${alias_name}=['\"]?//;s/['\"]?$//")
    local tsv_line
    tsv_line=$(awk -F'\t' -v n="$alias_name" '$1=="alias" && $3==n {print $2 "|" $4}' "$HOME/.bash.d/data/cache/.mt_data.tsv" | head -n 1)
    if [ -n "$tsv_line" ]; then
      default_cat=$(echo "$tsv_line" | cut -d'|' -f1)
      default_desc=$(echo "$tsv_line" | cut -d'|' -f2)
    fi
  else
    echo -e "${CB_CYAN} 🛠️  Create New Alias${C_RESET}"
    read -r -p "1️⃣  Alias Name (e.g., kgpo)     : " alias_name
    [ -z "$alias_name" ] && return 1
    if grep -qE "^[ \t]*alias ${alias_name}=" "$aliases_file"; then
      echo -e "${CB_RED}🚨 Alias already exists. Use -u to update.${C_RESET}"
      return 1
    fi
  fi
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  local alias_cmd="" alias_cat="" alias_desc=""
  read -r -e -i "$default_cmd" -p "2️⃣  Target Command             : " alias_cmd
  [ -z "$alias_cmd" ] && return 1
  read -r -e -i "$default_cat" -p "3️⃣  Category (e.g., Docker)    : " alias_cat
  [ -z "$alias_cat" ] && alias_cat="User Custom"
  read -r -e -i "$default_desc" -p "4️⃣  Description                : " alias_desc
  [ -z "$alias_desc" ] && alias_desc="Custom shortcut for ${alias_cmd}"
  if [ -n "$update_name" ]; then
    python3 -c "import sys; p, n = sys.argv[1], sys.argv[2]
with open(p, 'r') as f: l = f.read().split('\n')
o, i = [], 0
while i < len(l):
    if l[i].startswith('#######################################'):
        if any(x.startswith(f'alias {n}=') for x in l[i+1:i+10]):
            while not l[i].startswith(f'alias {n}='): i += 1
            i += 1
            continue
    if l[i].startswith(f'alias {n}='): i += 1; continue
    o.append(l[i]); i += 1
while o and o[-1].strip() == '': o.pop()
with open(p, 'w') as f: f.write('\n'.join(o) + '\n')" "$aliases_file" "$alias_name"
  fi
  cat << ALIASEOF >> "$aliases_file"

alias ${alias_name}='${alias_cmd}'
ALIASEOF
  # shellcheck disable=SC1090
  source "$aliases_file"
  mt-refresh-caches > /dev/null 2>&1
  echo -e "${CB_GREEN}🎉 Success! You can now use '${alias_name}'.${C_RESET}"
}
```

#### `mt-apply`

> System: Safely execute or write clipboard code without terminal paste truncation	/home/mst/.bash.d/02-utilities/99-utils.sh

```bash
#######################################
# System: Safely execute or write clipboard code without terminal paste truncation
# Usage: mt-apply [optional_target_file_path]
#######################################
#######################################
# System: Safely execute or write clipboard code without terminal paste truncation
# Usage: mt-apply [optional_target_file_path]
#######################################
mt-apply() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local tmp_raw tmp_clean
  tmp_raw=$(mktemp /tmp/mt_apply_raw_XXXXXX)
  tmp_clean=$(mktemp /tmp/mt_apply_clean_XXXXXX)
  local target_file="${1:-}"

  if command -v powershell.exe > /dev/null 2>&1; then
    powershell.exe -Command "Get-Clipboard" | tr -d "\r" > "$tmp_raw"
  elif command -v xclip > /dev/null 2>&1; then
    xclip -o -selection clipboard > "$tmp_raw"
  elif command -v pbpaste > /dev/null 2>&1; then
    pbpaste > "$tmp_raw"
  else
    echo -e "${CB_RED}🚨 No clipboard helper found.${C_RESET}"
    rm -f "$tmp_raw" "$tmp_clean"
    return 1
  fi

  if [ ! -s "$tmp_raw" ]; then
    echo -e "${CB_YELLOW}⚠️ Clipboard is empty!${C_RESET}"
    rm -f "$tmp_raw" "$tmp_clean"
    return 1
  fi

  grep -v -E "^[[:space:]]*\`\`\`" "$tmp_raw" | sed -E "s/^[[:space:]]*\$[[:space:]]*//" > "$tmp_clean"

  if [ -n "$target_file" ]; then
    mkdir -p "$(dirname "$target_file")"
    mv "$tmp_clean" "$target_file"
    rm -f "$tmp_raw"
    echo -e "${CB_GREEN}✅ Successfully written clipboard content to ${target_file}!${C_RESET}"
    return 0
  fi

  if python3 -c 'import sys; txt=open(sys.argv[1]).read(); sys.exit(0 if ("import " in txt or "shutil." in txt or "os.path" in txt) and not "python3 -c" in txt else 1)' "$tmp_clean"; then
    echo -e "${CB_BLUE}⚡ Executing native Python script from clipboard...${C_RESET}"
    python3 "$tmp_clean"
  else
    echo -e "${CB_BLUE}⚡ Executing Bash script from clipboard...${C_RESET}"
    bash "$tmp_clean"
  fi

  local exit_code=$?
  rm -f "$tmp_raw" "$tmp_clean"
  return $exit_code
}
```

#### `mt-backup`

> System: Create an archive backup of the current directory	/home/mst/.bash.d/02-utilities/99-utils.sh

```bash
#######################################
# System: Create an archive backup of the current directory
# Usage: mt-backup [-f|--force] [-l|--list] [-o|--output format] [-d|--dir path]
# Options:
#   -l, --list     List existing backups for the current directory
#   -f, --force    Skip the size limit warning check
#   -o, --output   Archive format: zip (default), rar, tz, gzip
#   -d, --dir      Override the base destination directory
# Globals:
#   BACKUP_DIR
#######################################
mt-backup() {
  local force=false
  local list_mode=false
  local format="zip"

  local base_dest="${BACKUP_DIR:-/tmp/backups}"

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -l | --list) list_mode=true ;;
      -f | --force) force=true ;;
      -o | --output)
        format="${2,,}"
        shift
        ;;
      -d | --dir)
        base_dest="$2"
        shift
        ;;
      -h | --help)
        mt-help "${FUNCNAME[0]}"
        return 0
        ;;
      -*)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
      *) base_dest="$1" ;;
    esac
    shift
  done

  local threshold_mb="${BACKUP_WARNING_MB:-500}"

  if ! [[ "$threshold_mb" =~ ^[0-9]+$ ]]; then
    echo -e "${CB_RED}🚨 Error: 'backup_warning_mb' in config.yaml is invalid ('$threshold_mb'). It must be a whole number.${C_RESET}"
    return 1
  fi

  if [ "$list_mode" = false ]; then
    __mt_backup_check_size_warning || return 1
  fi

  # Sanitize target directory name (strip dots, special chars)
  local raw_dir_name
  raw_dir_name=$(basename "$(realpath "$PWD")")
  local safe_dir_name
  safe_dir_name=$(echo "$raw_dir_name" | tr -d '.' | sed 's/[^a-zA-Z0-9]/_/g')

  # Resolve base destination, expanding ~ if present
  local expanded_base="${base_dest/#\~/$HOME}"
  local dest="${expanded_base}/${safe_dir_name}"

  if [ "$list_mode" = true ]; then
    __mt_backup_list
    return 0
  fi

  __mt_backup_create
}
```

#### `mt-cmd-history`

> System: Display history of executed framework commands	/home/mst/.bash.d/02-utilities/99-utils.sh

```bash
#######################################
# System: Display history of executed framework commands
# Usage: mt-cmd-history [-i|--interactive] [-n count]
# Options:
#   -i, --interactive  Select a past framework command via fzf to re-run
#   -n, --lines <num>  Number of entries to show (default: 20)
#######################################
mt-cmd-history() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local interactive=false
  local limit=20

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -i | --interactive) interactive=true ;;
      -n | --lines)
        limit="$2"
        shift
        ;;
      *)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
    esac
    shift
  done

  local tsv_file="$HOME/.bash.d/data/cache/.mt_data.tsv"
  if [ ! -f "$tsv_file" ]; then
    mt-refresh-caches > /dev/null 2>&1
  fi

  local tmp_cmds tmp_hist
  tmp_cmds=$(mktemp)
  tmp_hist=$(mktemp)

  # Extract list of framework functions and aliases into a clean file
  awk -F"\t" "{print \$3}" "$tsv_file" | sort -u | grep -v "^$" > "$tmp_cmds"

  if [ ! -s "$tmp_cmds" ]; then
    echo -e "${CB_RED}🚨 Failed to load framework command definitions.${C_RESET}"
    rm -f "$tmp_cmds" "$tmp_hist"
    return 1
  fi

  # Flush current in-memory history to disk
  history -a 2> /dev/null || true

  local hist_source="$HOME/.bash_history"

  if [ -f "$hist_source" ]; then
    # Force grep -a (text mode) and strip non-printable characters
    strings "$hist_source" 2> /dev/null | grep -a -v -E "^(#|[[:space:]]*$)" |
      sed "s/^[[:space:]]*[0-9]*[[:space:]]*//" |
      awk -v cmd_file="$tmp_cmds" '
      BEGIN {
        while ((getline line < cmd_file) > 0) {
          if (line != "") cmds[line] = 1
        }
        close(cmd_file)
      }
      {
        cmd = $1
        sub(/^.*::/, "", cmd)
        
        # Match only if the FIRST word is an exact framework tool name
        if (cmd in cmds) {
          print $0
        }
      }
    ' | awk "!seen[\$0]++" | tail -n "$limit" > "$tmp_hist"
  fi

  rm -f "$tmp_cmds"

  if [ ! -s "$tmp_hist" ]; then
    echo -e "${CB_YELLOW}⚠️ No recorded framework commands found in shell history.${C_RESET}"
    rm -f "$tmp_hist"
    return 0
  fi

  if [ "$interactive" = true ]; then
    local selected_cmd
    selected_cmd=$(fzf --prompt="Re-run Framework Command > " --header="Framework Command History" < "$tmp_hist")
    rm -f "$tmp_hist"

    if [ -n "$selected_cmd" ]; then
      echo -e "${CB_GREEN}🚀 Executing:${C_RESET} ${selected_cmd}"
      eval "$selected_cmd"
    fi
  else
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    echo -e "${CB_CYAN} 📜 Recent Framework Command History${C_RESET}"
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    awk -v yellow="$CB_YELLOW" -v white="$C_WHITE" -v rst="$C_RESET" '{printf "  %s%3d%s  %s%s%s\n", yellow, NR, rst, white, $0, rst}' "$tmp_hist"
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    echo -e "${C_DIM}Run 'mt-history -i' to select and re-run a command via fzf.${C_RESET}"
    rm -f "$tmp_hist"
  fi
}
```

#### `mt-jobs`

> System: List and manage MT background jobs	/home/mst/.bash.d/02-utilities/99-utils.sh

```bash
#######################################
# System: List and manage MT background jobs
# Usage: mt-jobs [-i|--interactive] [-p|--purge] [-c|--clean]
#######################################
mt-jobs() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local jobs_file="$HOME/.bash.d/data/cache/.mt_jobs.tsv"

  local interactive=false do_purge=false do_clean=false
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -i | --interactive) interactive=true ;;
      -p | --purge) do_purge=true ;;
      -c | --clean) do_clean=true ;;
      *)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
    esac
    shift
  done

  if [ ! -f "$jobs_file" ] || [ ! -s "$jobs_file" ]; then
    echo -e "${CB_YELLOW}⚠️ No background jobs found.${C_RESET}"
    return 0
  fi

  local current_time
  current_time=$(date +%s)

  if [ "$do_purge" = true ]; then
    __mt_jobs_purge
    return 0
  fi

  if [ "$do_clean" = true ]; then
    __mt_jobs_clean
    return 0
  fi

  __mt_jobs_reap_orphans

  local tmp_out
  __mt_jobs_render_table

  if [ "$interactive" = false ]; then
    __mt_jobs_print_table
    return 0
  fi

  __mt_jobs_interactive_select
}
```

#### `mt-log`

> System: Centralized logging for MyTools	/home/mst/.bash.d/02-utilities/99-utils.sh

```bash
#######################################
# System: Centralized logging for MyTools
# Arguments:
#   $1 - Log level (INFO, SUCCESS, WARN, ERROR)
#   $2 - Message
#######################################
mt-log() {
  local level="$1"
  local msg="$2"
  local log_dir="${LOG_DIR:-$HOME/.bash.d/data/logs}"
  local log_file="$log_dir/framework.log"

  # Console Output
  case "$level" in
    INFO) echo -e "${CB_BLUE}ℹ️ ${msg}${C_RESET}" ;;
    SUCCESS) echo -e "${CB_GREEN}✅ ${msg}${C_RESET}" ;;
    WARN) echo -e "${CB_YELLOW}⚠️ ${msg}${C_RESET}" ;;
    ERROR) echo -e "${CB_RED}🚨 ${msg}${C_RESET}" >&2 ;;
    *) echo "$msg" ;;
  esac

  # File Logging (with 1MB basic rotation)
  mkdir -p "$log_dir" 2> /dev/null
  if [ -f "$log_file" ]; then
    local size
    size=$(wc -c < "$log_file" 2> /dev/null || echo 0)
    if [ "$size" -gt "${LOG_ROTATE_BYTES:-1048576}" ]; then
      mv "$log_file" "${log_file}.old" 2> /dev/null
    fi
  fi

  local ts
  ts=$(date +"%Y-%m-%d %H:%M:%S")
  echo "[$ts] [$level] $msg" >> "$log_file" 2> /dev/null
}
```

#### `mt-logs`

> System: View, filter, and manage framework logs	/home/mst/.bash.d/02-utilities/99-utils.sh

```bash
#######################################
# System: View, filter, and manage framework logs
# Usage: mt-logs [-n lines] [-l level] [-s keyword] [-o] [-f] [-c]
# Options:
#   -n, --lines <num>     Number of lines to display (default: 50)
#   -l, --level <level>   Filter by severity (INFO, SUCCESS, WARN, ERROR)
#   -s, --search <term>   Search for a specific keyword
#   -o, --open            Open the log file in your default IDE
#   -f, --follow          Tail the logs live
#   -c, --clear           Clear the log file
#######################################
mt-logs() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local log_file="${LOG_DIR:-$HOME/.bash.d/data/logs}/framework.log"
  local lines=50
  local level_filter=""
  local search_term=""
  local do_open=false
  local do_follow=false
  local do_clear=false

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -n | --lines)
        lines="$2"
        shift
        ;;
      -l | --level)
        level_filter="${2^^}"
        shift
        ;;
      -s | --search)
        search_term="$2"
        shift
        ;;
      -o | --open) do_open=true ;;
      -f | --follow) do_follow=true ;;
      -c | --clear) do_clear=true ;;
      -*)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
    esac
    shift
  done

  if [ ! -f "$log_file" ]; then
    echo -e "${CB_YELLOW}⚠️ No log file found at $log_file${C_RESET}"
    return 0
  fi

  if [ "$do_clear" = true ]; then
    true > "$log_file"
    echo -e "${CB_GREEN}✅ Log file cleared.${C_RESET}"
    return 0
  fi

  if [ "$do_open" = true ]; then
    echo -e "${CB_BLUE}📂 Opening $log_file in ${DEFAULT_IDE:-vscode}...${C_RESET}"
    if [ "${DEFAULT_IDE:-vscode}" = "intellij" ]; then
      idea "$log_file" 2> /dev/null || cat "$log_file"
    else
      code "$log_file" 2> /dev/null || cat "$log_file"
    fi
    return 0
  fi

  if [ "$do_follow" = true ]; then
    tail -f "$log_file"
    return 0
  fi

  local cmd="cat \"$log_file\""
  [ -n "$level_filter" ] && cmd="$cmd | grep \"\[$level_filter\]\""
  [ -n "$search_term" ] && cmd="$cmd | grep -i \"$search_term\""
  cmd="$cmd | tail -n $lines"

  echo -e "${CB_CYAN}📜 Showing last $lines lines of framework logs...${C_RESET}"
  [ -n "$level_filter" ] && echo -e "${C_DIM}   Level: $level_filter${C_RESET}"
  [ -n "$search_term" ] && echo -e "${C_DIM}   Search: $search_term${C_RESET}"
  echo -e "${CB_BLUE}----------------------------------------------------------${C_RESET}"

  eval "$cmd"
}
```

#### `mt-restore`

> System: Restore framework from a zip backup	/home/mst/.bash.d/02-utilities/99-utils.sh

```bash
#######################################
# System: Restore framework from a zip backup
# Usage: mt-restore [backup_file] [-i|--interactive]
# Options:
#   -i, --interactive  Choose a backup from an fzf menu
#######################################
mt-restore() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local selected_backup=""
  local backup_base_dir="${BACKUP_DIR:-$HOME/backups}"

  if [ -n "$1" ] && [ "$1" != "-i" ] && [ "$1" != "--interactive" ]; then
    if [ -f "$1" ]; then
      selected_backup="$1"
    elif [ -f "${backup_base_dir}/$1" ]; then
      selected_backup="${backup_base_dir}/$1"
    elif [ -f "${backup_base_dir}/bashd/$1" ]; then
      selected_backup="${backup_base_dir}/bashd/$1"
    else
      echo -e "${CB_RED}🚨 Backup file not found: $1${C_RESET}"
      return 1
    fi
  else
    echo -e "${CB_BLUE}🔍 Scanning for available backups in ${backup_base_dir}...${C_RESET}"
    local tmp_list
    tmp_list=$(mktemp)
    find "$backup_base_dir" -type f -name "*.zip" 2> /dev/null | sort -r > "$tmp_list"

    if [ ! -s "$tmp_list" ]; then
      echo -e "${CB_YELLOW}⚠️ No backup zip files found in ${backup_base_dir}.${C_RESET}"
      rm -f "$tmp_list"
      return 1
    fi

    selected_backup=$(fzf --prompt="Select Backup to Restore > " --header="Available Framework Backups" < "$tmp_list")
    rm -f "$tmp_list"

    [ -z "$selected_backup" ] && return 0
  fi

  echo -e "${CB_CYAN}📦 Selected Backup: ${selected_backup}${C_RESET}"
  read -r -p "🚀 Are you sure you want to restore this backup? [y/N] " -n 1
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${CB_RED}🛑 Restore aborted.${C_RESET}"
    return 0
  fi

  # 1. Pre-restore Safety Backup
  echo -e "${CB_BLUE}🛡️ Creating safety backup of current codebase before restoring...${C_RESET}"
  local pre_dest="${backup_base_dir}/pre-restore"
  mkdir -p "$pre_dest"
  local timestamp
  timestamp=$(date +"%Y%m%d_%H%M%S")
  local safety_file="${pre_dest}/pre_restore_safety_${timestamp}.zip"

  (
    cd "$HOME" || exit 1
    zip -q -r "$safety_file" .bash.d -x ".bash.d/.git/*" -x ".bash.d/data/cache/*" -x ".bash.d/node_modules/*" -x ".bash.d/**/__pycache__/*"
  )
  echo -e "${CB_GREEN}✅ Safety backup saved: ${safety_file}${C_RESET}"

  # 2. Extract selected backup
  echo -e "${CB_YELLOW}🔄 Restoring .bash.d directory...${C_RESET}"
  if ! unzip -q -o "$selected_backup" -d "$HOME/"; then
    echo -e "${CB_RED}🚨 Unzip failed during restore!${C_RESET}"
    return 1
  fi

  # 3. Sync to Git Workspace
  local git_repo_path="${DOTFILES_DIR:-$HOME/vcs/personal/mt-devops-framework}"
  if [ -d "$git_repo_path" ]; then
    echo -e "${CB_BLUE}🔄 Syncing restored files to Git workspace (${git_repo_path})...${C_RESET}"
    rsync -a -u --delete "$HOME/.bash.d/" "${git_repo_path}/.bash.d/"
  fi

  echo -e "${CB_GREEN}🎉 Restore complete! Rebuilding caches...${C_RESET}"
  mt-refresh-caches > /dev/null 2>&1
}
```

#### `mt-top-files`

> System: Display the top largest files in a directory	/home/mst/.bash.d/02-utilities/99-utils.sh

```bash
#######################################
# System: Display the top largest files in a directory
# Arguments:
#   $1 - Count (default: 10)
#   $2 - Target directory (default: .)
#######################################
mt-top-files() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local count="${1:-10}"
  local target_dir="${2:-.}"
  echo -e "${CB_BLUE}📊 Finding the top ${count} largest files in ${target_dir}...${C_RESET}"
  find "$target_dir" -type f -exec du -h {} + 2> /dev/null | sort -rh | head -n "$count"
}
```

#### `mt-vcs-audit`

> System: Audit VCS root for unorganized files and directories	/home/mst/.bash.d/02-utilities/99-utils.sh

```bash
#######################################
# System: Audit VCS root for unorganized files and directories
#######################################
mt-vcs-audit() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local vcs_dir="${VCS_ROOT:-$HOME/vcs}"
  echo -e "${CB_BLUE}🔍 Auditing ${vcs_dir} for unorganized items...${C_RESET}\n"

  if command -v eza > /dev/null 2>&1; then
    # Print a tree up to 3 levels deep, ignoring our organized folders
    eza -la --tree --level=3 --group-directories-first -I "external|personal|work|workspaces|misc|.git" "$vcs_dir"
  else
    # Fallback to standard ls if eza is unavailable
    # shellcheck disable=SC2010
    ls -la "$vcs_dir" | grep -vE "(external|personal|work|workspaces|misc)"
  fi
}
```

### 📂 Google Style Code Formatting


#### `google-fmt`

> Formats Python and Shell scripts according to Google Style Guides.	/home/mst/.bash.d/03-mytools/07-formatting.sh

```bash
#######################################
# Formats Python and Shell scripts according to Google Style Guides.
# Uses yapf for Python and shfmt for Shell scripts.
# Outputs:
#   Writes formatting status updates to STDOUT.
# Returns:
#   0 on success.
#######################################
google-fmt() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo "🔍 Linting and formatting Python scripts (Ruff)..."
  if command -v ruff > /dev/null 2>&1; then
    ruff check --fix .
    ruff format .
  fi

  echo "🎨 Formatting Python scripts (Google Python Style)..."
  if command -v yapf > /dev/null 2>&1; then
    yapf -r -i --style="{based_on_style: google, column_limit: 88, spaces_before_comment: 2}" .
    echo "✅ Python formatting complete."
  else
    echo "⚠️ 'yapf' not found. Run 'bootstrap' to install it."
  fi

  echo "🎨 Formatting Shell scripts (Google Shell Style Guide)..."
  if command -v shfmt > /dev/null 2>&1; then
    # Google Shell Style Guide: 2-space indents (-i 2), switch case indent (-ci), and space after redirects (-sr)
    shfmt -i 2 -ci -sr -w .
    echo "✅ Shell script formatting complete."
  else
    echo "⚠️ 'shfmt' not found."
  fi
}
```

### 📂 Infrastructure as Code


#### `tf-val-all`

> Terraform: Recursively validate and scan all Terraform directories	/home/mst/.bash.d/10-infra/40-terraform-k8s.sh

```bash
#######################################
# Terraform: Recursively validate and scan all Terraform directories
#######################################
tf-val-all() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local threads="${MAX_PARALLEL_THREADS:-8}"

  # shellcheck disable=SC2016  # inner bash -c script intentionally uses its own $1, passed via the trailing _ "{}" args
  find terraform/ -type f -name "*.tf" -exec dirname {} \; | sort -u | xargs -I {} -P "$threads" bash -c '
        echo -e "\n🔍 Validating $1..."
        terraform -chdir="$1" init -backend=false > /dev/null 2>&1
        if terraform -chdir="$1" validate; then
            echo -e "🛡️ Scanning $1 with Checkov..."
            checkov -d "$1" --framework terraform --quiet
        else
            echo -e "🚨 Validation failed for $1"
        fi
    ' _ "{}"
}
```

### 📂 LLM Context & Export Utilities


#### `mt-copy`

> LLM: Copy a file or directory tree to clipboard with headers and extension filters	/home/mst/.bash.d/03-mytools/06-llm-exports.sh

```bash
#######################################
# LLM: Copy a file or directory tree to clipboard with headers and extension filters
# Usage: mt-copy [-e <extensions>] <file-or-directory>
#######################################
mt-copy() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local ext_list="" target=""
  local OPTIND opt
  while getopts "e:" opt; do
    case ${opt} in
      e) ext_list="$OPTARG" ;;
      *)
        echo "Usage: mt-copy [-e <extensions>] <file-or-directory>" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  target="${1:-.}"
  if [ ! -e "$target" ]; then
    echo -e "${CB_RED}🚨 Error: '$target' missing.${C_RESET}"
    return 1
  fi

  local clip_cmd=""
  if command -v clip.exe > /dev/null 2>&1; then
    clip_cmd="clip.exe"
  elif command -v pbcopy > /dev/null 2>&1; then
    clip_cmd="pbcopy"
  elif command -v xclip > /dev/null 2>&1; then
    clip_cmd="xclip -selection clipboard"
  else
    echo "🚨 No clipboard utility."
    return 1
  fi

  echo -e "${CB_BLUE}🔍 Scanning '$target'...${C_RESET}"

  local temp_file
  temp_file=$(mktemp)

  local blocklist_regex="${EXPORT_BLOCKLIST:-(secret|token|credential|pass|key|rsa|env|lock\.hcl|__pycache__)}"

  local filter_ext=".*"
  if [ -n "$ext_list" ]; then
    local ext_fmt
    ext_fmt=$(echo "$ext_list" | sed 's/,/|/g; s/ //g')
    filter_ext="\.(${ext_fmt})$"
    echo -e "${C_DIM}   (Filtering for: $ext_list)${C_RESET}"
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
}
```

#### `mt-export`

> LLM: Export codebase to text/zip for LLM context window using dynamic schemas	/home/mst/.bash.d/03-mytools/06-llm-exports.sh

```bash
#######################################
# LLM: Export codebase to text/zip for LLM context window using dynamic schemas
# Usage: mt-export [-d dir] [-s schema] [-z] [-q] [-p] [-v] [-i]
# Options:
#   -d, --dir <path>     Target directory to export (default: current directory)
#   -s, --schema <name>  Export schema to apply (default, terraform, shell, python, springboot)
#   -z, --zip            Compress output into a .zip file
#   -q, --quiet          Do not automatically open the output directory
#   -p, --plan           Dry-run: show estimated size and included files, prompt to proceed
#   -v, --verbose        Show detailed terraform-style plan of inclusions/exclusions
#   -i, --interactive    Open an interactive menu to adjust export files, format, and schema
#######################################
mt-export() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local target_dir="."
  local schema_query="default"
  local zip_out=false
  local quiet_mode=false
  local plan_mode=false
  local verbose_mode=false
  local interactive_mode=false

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -d | --dir)
        target_dir="$2"
        shift
        ;;
      -s | --schema)
        schema_query="$2"
        shift
        ;;
      -z | --zip) zip_out=true ;;
      -q | --quiet) quiet_mode=true ;;
      -p | --plan) plan_mode=true ;;
      -v | --verbose) verbose_mode=true ;;
      -i | --interactive) interactive_mode=true ;;
      *) target_dir="$1" ;;
    esac
    shift
  done

  if [ ! -d "$target_dir" ]; then
    echo -e "${CB_RED}🚨 Error: Directory '$target_dir' not found.${C_RESET}"
    return 1
  fi

  local schemas_dir="$HOME/.bash.d/config/export/schemas"
  local schema_file=""
  local s_name="Code Export"
  local s_inc=".*"
  local s_exc=""

  local tmp_file="/tmp/mt_export_${RANDOM}.txt"
  local file_list="/tmp/mt_export_files_${RANDOM}.txt"
  local all_files="/tmp/mt_export_all_${RANDOM}.txt"

  local date_prefix
  date_prefix=$(date +"%Y%m%d")

  local safe_dir_name
  safe_dir_name=$(basename "$(realpath "$target_dir")" | tr '.' '_')

  local dest_dir="${EXPORT_DIR:-/tmp/exports}/${safe_dir_name}"
  mkdir -p "$dest_dir"
  local out_ext="txt"
  local v_num=1
  local base_out_name=""

  __mt_export_calc_output_name
  __mt_export_build_file_lists

  local __mt_export_aborted=false
  if [ "$interactive_mode" = true ]; then
    __mt_export_interactive_menu
    [ "$__mt_export_aborted" = true ] && return 0
  elif [ "$plan_mode" = true ]; then
    __mt_export_plan_mode
    [ "$__mt_export_aborted" = true ] && return 0
  fi

  __mt_export_check_file_count_guards || return 1

  if [ "$plan_mode" = false ] && [ "$interactive_mode" = false ]; then
    echo -e "${CB_BLUE}📦 Running: $s_name${C_RESET}"
  fi

  __mt_export_write_context_file
  __mt_export_finalize
}
```

#### `mt-export-cleanup`

> LLM: Safely remove stale mt-export output from EXPORT_DIR	/home/mst/.bash.d/03-mytools/06-llm-exports.sh

```bash
#######################################
# LLM: Safely remove stale mt-export output from EXPORT_DIR
# Usage: mt-export-cleanup [-f] [-q] [-b] [-B] [-i] [target_dir]
# Options:
#   -f, --force        Skip the pre-flight table and confirmation prompt
#   -q, --quiet        Suppress terminal output (implies --force)
#   -b, --backup       Zip each target directory to BACKUP_DIR before
#                      deleting (reuses mt-backup); a failed backup skips
#                      deletion for that directory only
#   -B, --background   Run as a background job (implies force and quiet);
#                      track and view its result via mt-jobs -i
#   -i, --interactive  Pick a target directory and toggle flags via fzf
#   target_dir         Optional: scope to one EXPORT_DIR subdirectory
#                      (name or path; defaults to all of EXPORT_DIR)
# Globals:
#   EXPORT_DIR, AUTO_CLEANUP_DAYS, LOG_DIR
#######################################
mt-export-cleanup() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local force=false quiet=false backup=false background=false interactive=false
  local target=""

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -f | --force) force=true ;;
      -q | --quiet)
        quiet=true
        force=true
        ;;
      -b | --backup) backup=true ;;
      -B | --background) background=true ;;
      -i | --interactive) interactive=true ;;
      -*)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        return 1
        ;;
      *) target="$1" ;;
    esac
    shift
  done

  if [ "$interactive" = true ] && [ "$background" = true ]; then
    echo -e "${CB_RED}🚨 Error: --interactive and --background cannot be combined.${C_RESET}"
    return 1
  fi

  local export_dir="${EXPORT_DIR:-/tmp/exports}"

  if [ "$interactive" = true ]; then
    __mt_export_cleanup_interactive
    return $?
  fi

  if [ "$background" = true ]; then
    force=true
    quiet=true
    local log_out
    log_out="${LOG_DIR:-$HOME/.bash.d/data/logs}/export_cleanup_$(date +%s).log"
    local cmd_str
    printf -v cmd_str '__mt_export_cleanup_run %q %q %q %q %q %q' \
      "$export_dir" "$target" "$force" "$quiet" "$backup" "$background"
    __mt_bg_run "mt-export-cleanup" "$log_out" "$cmd_str"
    return 0
  fi

  __mt_export_cleanup_run "$export_dir" "$target" "$force" "$quiet" "$backup" "$background"
}
```

### 📂 MT Repo Hub - AI & Heuristic Metadata Dashboard


#### `mt-hub`

> System: Interactive AI-powered Repository Dashboard	/home/mst/.bash.d/20-vcs/53-vcs-insight.sh

```bash
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
```

### 📂 MyTools Documentation & Runner


#### `mt`

> MyTools: Central dispatcher -- run any framework command as `mt <name>`	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: Central dispatcher -- run any framework command as `mt <name>`
# instead of typing its full `mt-<name>` form. Bare `mt` (no arguments)
# keeps today's behavior and prints the full command listing via mytools.
# Usage: mt <subcommand> [args...]
#######################################
mt() {
  if [ $# -eq 0 ]; then
    mytools
    return $?
  fi

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "mt"
    return 0
  fi

  local subcmd="$1"
  shift

  if [[ ! "$subcmd" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
    echo -e "${CB_RED}🚨 Error: invalid subcommand '$subcmd'.${C_RESET}"
    return 1
  fi

  local target_cmd="mt-${subcmd}"
  local kind
  kind=$(type -t "$target_cmd" 2> /dev/null)

  case "$kind" in
    function)
      "$target_cmd" "$@"
      ;;
    alias)
      # target_cmd was just built from a regex-validated, alnum/-/_-only
      # subcmd and confirmed by `type -t` to be a real registered alias,
      # so it is safe to re-parse here -- this is the only way to invoke
      # an alias whose name is held in a variable (bash does not expand
      # aliases through indirection).
      eval "$target_cmd \"\$@\""
      ;;
    *)
      echo -e "${CB_RED}🚨 Error: Framework command '${target_cmd}' not found.${C_RESET}"
      echo -e "${C_DIM}Run 'mt lookup ${subcmd}' or 'mt cat' to discover available tools.${C_RESET}"
      return 1
      ;;
  esac
}
```

#### `mt-aliases`

> MyTools: List all documented shell aliases (shortcut for `mt-list --alias`)	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: List all documented shell aliases (shortcut for `mt-list --alias`)
#######################################
mt-aliases() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mt-list --alias
}
```

#### `mt-cat`

> MyTools: List all tools within a specific category (shortcut for `mt-list <category>`)	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: List all tools within a specific category (shortcut for `mt-list <category>`)
# Arguments:
#   $1 - Category name
#######################################
mt-cat() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  [ -z "$1" ] && {
    echo "Usage: mt-cat <category>"
    mt-cats
    return 1
  }
  mt-list "$1"
}
```

#### `mt-cats`

> MyTools: List all available command categories (shortcut for `mt-list`)	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: List all available command categories (shortcut for `mt-list`)
#######################################
mt-cats() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mt-list
}
```

#### `mt-config`

> MyTools: Display active framework configuration variables	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: Display active framework configuration variables
#######################################
mt-config() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e "${CB_BLUE}                ACTIVE CONFIGURATION                      ${C_RESET}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e " ${CB_CYAN}DEFAULT_AI        ${C_RESET}: ${DEFAULT_AI:-gemini}"
  echo -e " ${CB_CYAN}GEMINI_VERSION    ${C_RESET}: ${GEMINI_VERSION:-gemini-1.5-pro}"
  echo -e " ${CB_CYAN}CLAUDE_VERSION    ${C_RESET}: ${CLAUDE_VERSION:-claude-3-7-sonnet-latest}"
  echo -e " ${CB_CYAN}VCS_ROOT          ${C_RESET}: ${VCS_ROOT}"
  echo -e " ${CB_CYAN}VCS_PERSONAL      ${C_RESET}: ${VCS_PERSONAL}"
  echo -e " ${CB_CYAN}DOTFILES_DIR      ${C_RESET}: ${DOTFILES_DIR:-$SYNC_REPO_DIR}"
  echo -e " ${CB_CYAN}AI_WORKSPACE      ${C_RESET}: ${AI_WORKSPACE_DIR}"
  echo -e " ${CB_CYAN}EXPORT_DIR        ${C_RESET}: ${EXPORT_DIR:-/tmp/exports}"
  echo -e " ${CB_CYAN}BACKUP_DIR        ${C_RESET}: ${BACKUP_DIR:-~/backups}"
  echo -e " ${CB_CYAN}AUTO_CLEANUP      ${C_RESET}: ${AUTO_CLEANUP_EXPORTS:-false} (${AUTO_CLEANUP_DAYS:-7} days)"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
}
```

#### `mt-dump`

> MyTools: Generate a detailed technical Markdown dump of all functions and aliases	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: Generate a detailed technical Markdown dump of all functions and aliases
# Usage: mt-dump [OPTIONS]
# Options:
#   -d, --dir <path>       Specify export directory (default: ~/.bash.d/docs)
#   --private              Include private/internal framework functions (starting with _ or __)
#   -h, --help             Show this help menu
#######################################
mt-dump() {
  local export_dir="$HOME/.bash.d/docs"
  local include_private=false

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -d | --dir)
        export_dir="$2"
        shift
        ;;
      --private)
        include_private=true
        ;;
      -h | --help)
        mt-help "${FUNCNAME[0]}"
        return 0
        ;;
      *)
        echo "Usage: mt-dump [-d <export_dir>] [--private]"
        return 1
        ;;
    esac
    shift
  done

  mkdir -p "$export_dir"
  local out_file="${export_dir}/TECHNICAL_REFERENCE.md"

  echo -e "${CB_BLUE}📝 Generating technical reference manual...${C_RESET}"

  cat << HDR > "$out_file"

> **Auto-generated Reference Document**  
> Generated: $(date)  
> Environment: $(uname -s) ($(uname -m))

---

HDR

  local tsv_index="$HOME/.bash.d/data/cache/.mt_data.tsv"
  mytools > /dev/null

  if [ -f "$tsv_index" ]; then
    # shellcheck disable=SC2129  # part of a long, loop/conditional-heavy markdown generator; grouping would require restructuring control flow
    echo "" >> "$out_file"
    echo "## 🔗 Shell Aliases" >> "$out_file"
    echo "" >> "$out_file"
    awk -F'\t' '$1 == "alias" { printf "- **`%s`** *(%s)*: %s\n", $3, $2, $4 }' "$tsv_index" >> "$out_file"
    echo "" >> "$out_file"
    echo "---" >> "$out_file"
    echo "" >> "$out_file"
    echo "## 🛠️ Public Functions" >> "$out_file"
    echo "" >> "$out_file"

    local current_cat=""
    while IFS=$'\t' read -r type cat name desc; do
      [ "$type" != "func" ] && continue

      if [ "$cat" != "$current_cat" ]; then
        current_cat="$cat"
        # shellcheck disable=SC2129
        echo "" >> "$out_file"
        echo "### 📂 ${current_cat}" >> "$out_file"
        echo "" >> "$out_file"
      fi

      # shellcheck disable=SC2129
      echo "" >> "$out_file"
      echo "#### \`$name\`" >> "$out_file"
      echo "" >> "$out_file"
      echo "> $desc" >> "$out_file"
      echo "" >> "$out_file"

      local src_file
      src_file=$(grep -rlE "^${name}\(\)[ \t]*\{" "$HOME/.bash.d/" 2> /dev/null | head -n 1)
      if [ -n "$src_file" ]; then
        # shellcheck disable=SC2129
        echo "\`\`\`bash" >> "$out_file"
        awk -v target="$name" -f "$HOME/.bash.d/lib/awk/mt_help.awk" "$src_file" >> "$out_file"
        echo "\`\`\`" >> "$out_file"
      fi
    done < <(sort -t$'\t' -k2,2 -k3,3 "$tsv_index")
  fi

  if [ "$include_private" = true ]; then
    # shellcheck disable=SC2129
    echo "" >> "$out_file"
    echo "---" >> "$out_file"
    echo "" >> "$out_file"
    echo "## 🔒 Internal Framework Helpers (Private Functions)" >> "$out_file"
    echo "" >> "$out_file"
    echo "Private functions prefixed with \`_\` or \`__\` used internally by the framework." >> "$out_file"

    find "$HOME/.bash.d" -type f -name "*.sh" -exec grep -HnE "^_{1,2}[a-zA-Z0-9_-]+\(\)[ \t]*\{" {} + | while read -r line; do
      local fpath
      fpath=$(echo "$line" | cut -d: -f1)
      local func_name
      func_name=$(echo "$line" | grep -oE "_{1,2}[a-zA-Z0-9_-]+")

      [ -z "$func_name" ] && continue
      local rel_fpath="${fpath#"$HOME"/.bash.d/}"

      # shellcheck disable=SC2129
      echo "" >> "$out_file"
      echo "### \`$func_name\` *(File: \`00-system/${rel_fpath}\`)*" >> "$out_file"
      echo "" >> "$out_file"
      echo "\`\`\`bash" >> "$out_file"
      awk -v target="$func_name" -f "$HOME/.bash.d/lib/awk/mt_help.awk" "$fpath" >> "$out_file"
      echo "\`\`\`" >> "$out_file"
    done
  fi

  echo -e "${CB_GREEN}✅ Technical reference generated at:${C_RESET} ${out_file}"

  if type __open_path_gui > /dev/null 2>&1; then
    __open_path_gui "$export_dir" 2> /dev/null || true
  fi
}
```

#### `mt-funcs`

> MyTools: List all documented shell functions (shortcut for `mt-list --func`)	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: List all documented shell functions (shortcut for `mt-list --func`)
#######################################
mt-funcs() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mt-list --func
}
```

#### `mt-fzf`

> MyTools: Interactive fuzzy-finder to search for a command	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: Interactive fuzzy-finder to search for a command
#######################################
mt-fzf() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  local selected
  selected=$(awk -F'\t' '{ printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv" | fzf --ansi --prompt="Search MyTools > " --header="COMMAND                  │ CATEGORY             │ DESCRIPTION")
  [ -n "$selected" ] && echo "$selected" | awk '{print $1}'
}
```

#### `mt-get-version`

> System: Print the current local version of the terminal profile	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# System: Print the current local version of the terminal profile
#######################################
mt-get-version() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  if [ -f "$HOME/.bash.d/data/.current_version" ]; then
    local current_version
    current_version=$(command cat "$HOME/.bash.d/data/.current_version")
    echo -e "${CB_CYAN}Profile Version:${C_RESET} ${current_version}"
  elif [ -n "$DOTFILES_DIR" ] && [ -d "$DOTFILES_DIR/.git" ] && command -v git > /dev/null 2>&1; then
    local current_version
    current_version=$(git -C "$DOTFILES_DIR" describe --tags --abbrev=0 2> /dev/null || echo "Local")
    echo -e "${CB_CYAN}Profile Version:${C_RESET} ${current_version}"
  elif [ -n "$SYNC_REPO_DIR" ] && [ -d "$SYNC_REPO_DIR/.git" ] && command -v git > /dev/null 2>&1; then
    local current_version
    current_version=$(git -C "$SYNC_REPO_DIR" describe --tags --abbrev=0 2> /dev/null || echo "Local")
    echo -e "${CB_CYAN}Profile Version:${C_RESET} ${current_version}"
  else
    echo -e "${CB_CYAN}Profile Version:${C_RESET} Local (Unversioned/Standalone)"
  fi
}
```

#### `mt-help`

> MyTools: Display detailed help and source code for a command	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: Display detailed help and source code for a command
# Usage: mt-help [-v|--verbose] <command>
# Arguments:
#   $1 - Command name or keyword
#######################################
mt-help() {
  local show_code=false
  local target=""

  # Parse Arguments
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -v | --verbose) show_code=true ;;
      -h | --help)
        echo -e "${CB_BLUE}Usage:${C_RESET} mt-help [-v|--verbose] <command>"
        return 0
        ;;
      -*)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        echo "Usage: mt-help [-v|--verbose] <command>"
        return 1
        ;;
      *) target="$1" ;;
    esac
    shift
  done

  [ -z "$target" ] && {
    echo "Usage: mt-help [-v|--verbose] <command>"
    return 1
  }

  __render_help() {
    local cmd="$1"
    local fpath="$2"
    local show_code="$3"

    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    echo -e "${CB_CYAN} 🛠️  ${cmd}${C_RESET}"
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    echo -e "${CB_YELLOW} 📄 File: ${C_RESET} $(wslpath -m "$fpath" 2> /dev/null || echo "$fpath")"
    echo -e "${CB_BLUE}----------------------------------------------------------${C_RESET}"

    # Use AWK to cleanly separate the docstring from the codeblock
    local raw_data
    raw_data=$(awk -v target="$cmd" '
      BEGIN { flag=0; doc=""; code="" }
      /^#######################################/ { next }
      /^#/ {
          line = substr($0, 2)
          sub(/^[ \t]/, "", line)
          doc = doc line "\n"
          next
      }
      $0 ~ "^alias " target "=" { code = $0 "\n"; exit }
      $0 ~ "^" target "\(\\)[ \t]*\{" { code = $0 "\n"; flag=1; next }
      flag { code = code $0 "\n"; if ($0 ~ /^}$/) exit }
      { if (!flag) { doc=""; code="" } }
      END { print doc; print "---MT_CODE_DELIMITER---"; print code }
    ' "$fpath")

    local docstring="${raw_data%%---MT_CODE_DELIMITER---*}"
    local codeblock="${raw_data#*---MT_CODE_DELIMITER---}"

    # Parse and colorize the documentation string
    local section="desc"
    while IFS= read -r line; do
      [ -z "$line" ] && continue

      # Catch Headers (Usage:, Options:, Arguments:, etc.)
      if [[ "$line" =~ ^(Usage|Options|Arguments|Returns|Outputs|Globals): ]]; then
        echo -e "\n${CB_CYAN}▶ ${line}${C_RESET}"
        section="details"
      elif [ "$section" = "desc" ]; then
        # Main description text is standard white
        echo -e "${C_WHITE}${line}${C_RESET}"
      else
        # In details sections, look for flags starting with a dash
        if [[ "$line" =~ ^[[:space:]]*- ]]; then
          # Color the flag yellow, and the description dim text
          echo -e "  ${CB_YELLOW}${line%%  *}${C_RESET}  ${C_DIM}${line#*  }${C_RESET}"
        else
          echo -e "  ${C_DIM}${line}${C_RESET}"
        fi
      fi
    done <<< "$docstring"

    # Only show source code if the flag was provided
    if [ "$show_code" = true ] && [ -n "$codeblock" ]; then
      echo -e "\n${CB_BLUE}▶ SOURCE CODE${C_RESET}"
      echo -e "${CB_BLUE}----------------------------------------------------------${C_RESET}"
      if command -v "$BAT_BIN" > /dev/null 2>&1; then
        echo "$codeblock" | "$BAT_BIN" --language=bash --style=plain --paging=never 2> /dev/null
      else
        echo -e "${C_DIM}${codeblock}${C_RESET}"
      fi
    fi
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
  }

  local file_path
  file_path=$(grep -rlE "^(alias ${target}=|${target}\(\)[ \t]*\{)" "$HOME/.bash.d/" 2> /dev/null | head -n 1)
  if [ -n "$file_path" ]; then
    __render_help "$target" "$file_path" "$show_code"
    return 0
  fi

  mytools > /dev/null
  local tsv_file="$HOME/.bash.d/data/cache/.mt_data.tsv"
  local candidates=()

  if [ -f "$tsv_file" ]; then
    while read -r match; do
      [ -n "$match" ] && candidates+=("$match")
    done < <(awk -F'\t' -v q="${target,,}" 'tolower($3) ~ q { print $3 }' "$tsv_file" | sort -u)
  fi

  local count="${#candidates[@]}"

  if [ "$count" -eq 1 ]; then
    local single_target="${candidates[0]}"
    file_path=$(grep -rlE "^(alias ${single_target}=|${single_target}\(\)[ \t]*\{)" "$HOME/.bash.d/" 2> /dev/null | head -n 1)
    if [ -n "$file_path" ]; then
      __render_help "$single_target" "$file_path" "$show_code"
      return 0
    fi
  elif [ "$count" -gt 1 ]; then
    echo -e "${CB_YELLOW}⚠️  No exact match found for '${target}'. Did you mean one of these?${C_RESET}\n"
    for cand in "${candidates[@]}"; do
      echo -e "  ${C_DIM}•${C_RESET} ${CB_CYAN}${cand}${C_RESET}"
    done
    echo ""
    return 0
  fi

  echo -e "${CB_RED}🚨 Error: '${target}' is not a recognized custom MyTools command.${C_RESET}"
  return 1
}
```

#### `mt-list`

> MyTools: List all available command categories	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: List all available command categories
#######################################
#######################################
# MyTools: List categories, functions, aliases, or a specific category's tools
# Usage: mt-list [category] [-f|--func] [-a|--alias]
# Arguments:
#   [category]   Category name -- list tools within it
#   -f, --func   List all documented shell functions
#   -a, --alias  List all documented shell aliases
#   (none)       List all available categories
#######################################
mt-list() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null

  case "$1" in
    "")
      echo -e "\n${CB_BLUE}▶ AVAILABLE CATEGORIES${C_RESET}"
      cut -f2 "$HOME/.bash.d/data/cache/.mt_data.tsv" 2> /dev/null | sort -u | while read -r cat; do
        [ -n "$cat" ] && echo -e "  ${CB_YELLOW}[${cat}]${C_RESET}"
      done
      echo ""
      ;;
    -f | --func)
      echo -e "\n${CB_BLUE}▶ FUNCTIONS${C_RESET}\n"
      awk -F'\t' -v dim="$C_DIM" -v cyan="$CB_CYAN" -v yellow="$CB_YELLOW" -v white="$C_WHITE" -v rst="$C_RESET" '$1 == "func" { printf "  %s•%s %s%-24s%s (%s%s%s) %s→%s %s%s%s\n", dim, rst, cyan, $3, rst, yellow, $2, rst, dim, rst, white, $4, rst }' "$HOME/.bash.d/data/cache/.mt_data.tsv"
      echo ""
      ;;
    -a | --alias)
      echo -e "\n${CB_BLUE}▶ ALIASES${C_RESET}\n"
      awk -F'\t' -v dim="$C_DIM" -v cyan="$CB_CYAN" -v yellow="$CB_YELLOW" -v white="$C_WHITE" -v rst="$C_RESET" '$1 == "alias" { printf "  %s•%s %s%-24s%s (%s%s%s) %s→%s %s%s%s\n", dim, rst, cyan, $3, rst, yellow, $2, rst, dim, rst, white, $4, rst }' "$HOME/.bash.d/data/cache/.mt_data.tsv"
      echo ""
      ;;
    *)
      local target_cat="${1,,}"
      echo -e "\n${CB_BLUE}▶ CATEGORY: ${1}${C_RESET}\n"
      awk -F'\t' -v target="$target_cat" -v dim="$C_DIM" -v cyan="$CB_CYAN" -v white="$C_WHITE" -v rst="$C_RESET" 'tolower($2) == target { printf "  %s•%s %s%-24s%s %s→%s %s%s%s\n", dim, rst, cyan, $3, rst, dim, rst, white, $4, rst }' "$HOME/.bash.d/data/cache/.mt_data.tsv"
      echo ""
      ;;
  esac
}
```

#### `mt-lookup`

> MyTools: Search through available mytools commands with tab-completion	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: Search through available mytools commands with tab-completion
# Usage: mt-lookup [-i|--interactive] [-v|--verbose] [keyword]
# Arguments:
#   -i, --interactive  Open an fzf menu to select a tool
#   -v, --verbose      Open interactive menu and print the full code using mt-help -v
#   $1                 Search term or command name
#######################################
mt-lookup() {
  local interactive=false
  local verbose=false
  local query=""

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -i | --interactive) interactive=true ;;
      -v | --verbose) verbose=true ;;
      -h | --help)
        mt-help "${FUNCNAME[0]}"
        return 0
        ;;
      -*)
        echo -e "${CB_RED}🚨 Unknown option: $1${C_RESET}"
        echo "Usage: mt-lookup [-i|--interactive] [-v|--verbose] [keyword]"
        return 1
        ;;
      *) query="$1" ;;
    esac
    shift
  done

  mytools > /dev/null
  local tsv_file="$HOME/.bash.d/data/cache/.mt_data.tsv"

  # Trigger the menu if -i or -v is passed
  if [ "$interactive" = true ] || [ "$verbose" = true ]; then
    local selected
    if [ -n "$query" ]; then
      selected=$(awk -F'\t' -v q="${query,,}" 'tolower($0) ~ q { printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$tsv_file" | fzf --ansi --prompt="Select Tool > " --header="COMMAND                  │ CATEGORY             │ DESCRIPTION")
    else
      selected=$(awk -F'\t' '{ printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$tsv_file" | fzf --ansi --prompt="Select Tool > " --header="COMMAND                  │ CATEGORY             │ DESCRIPTION")
    fi

    if [ -n "$selected" ]; then
      local cmd_name
      cmd_name=$(echo "$selected" | awk '{print $1}')
      if [ "$verbose" = true ]; then
        mt-help -v "$cmd_name"
      else
        mt-help "$cmd_name"
      fi
    fi
  else
    if [ -z "$query" ]; then
      echo "Usage: mt-lookup [-i|--interactive] [-v|--verbose] <keyword|command>"
      return 1
    fi
    # Standard non-interactive output
    awk -F'\t' -v q="${query,,}" -v dim="$C_DIM" -v cyan="$CB_CYAN" -v yellow="$CB_YELLOW" -v white="$C_WHITE" -v rst="$C_RESET" 'tolower($0) ~ q { printf "  %s•%s %s%-24s%s (%s%s%s) %s→%s %s%s%s\n", dim, rst, cyan, $3, rst, yellow, $2, rst, dim, rst, white, $4, rst }' "$tsv_file"
  fi
}
```

#### `mt-refresh-caches`

> System: Forcefully clear and rebuild all background caches (.env, mytools, updates)	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# System: Forcefully clear and rebuild all background caches (.env, mytools, updates)
#######################################
mt-refresh-caches() {
  # Self-heal missing cache directories (e.g., after clean git clone or update)
  mkdir -p "$HOME/.bash.d/data/cache" "$HOME/.bash.d/data/logs" "$HOME/.bash.d/config"

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_YELLOW}🧹 Clearing background caches...${C_RESET}"
  rm -f "$HOME/.bash.d/data/cache/.env.cache"
  rm -f "$HOME/.bash.d/config/.env.cache" # stray pre-fix location, harmless no-op once cleaned up
  # Legacy pre-migration cache locations (harmless no-op post-migration)
  rm -f "$HOME/.bash.d/.mt_cache" "$HOME/.bash.d/.mt_cache.time" "$HOME/.bash.d/.mt_data.tsv" 2> /dev/null
  rm -f "$HOME/.bash.d/.zoxide_cache.sh" "$HOME/.bash.d/.update_check_cache" "$HOME/.bash.d/.update_pending" 2> /dev/null
  rm -f "$HOME/.bash.d/.profile_update_cache" "$HOME/.bash.d/.profile_update_pending" 2> /dev/null
  rm -f "$HOME/.bash.d/data/cache/.mt_cache" "$HOME/.bash.d/data/cache/.mt_cache.time" "$HOME/.bash.d/data/cache/.mt_data.tsv"
  rm -f "$HOME/.bash.d/data/cache/.update_check_cache" "$HOME/.bash.d/data/cache/.update_pending"
  rm -f "$HOME/.bash.d/data/cache/.zoxide_cache.sh"
  rm -f "$HOME/.bash.d/data/cache/.profile_update_cache" "$HOME/.bash.d/data/cache/.profile_update_pending"
  rm -f "$HOME/.bash.d/data/cache/.kubectl_completion.bash"
  rm -f "$HOME/.bash.d/data/cache/.deps_check_cache" "$HOME/.bash.d/data/cache/.deps_pending"

  echo -e "${CB_BLUE}🔄 Rebuilding configurations and tool indexes...${C_RESET}"
  if [ -f "$HOME/.bash.d/lib/python/config_manager.py" ]; then
    mkdir -p "$HOME/.bash.d/data/cache" "$HOME/.bash.d/data/logs" "$HOME/.bash.d/config"
    python3 "$HOME/.bash.d/lib/python/config_manager.py" load-env > "$HOME/.bash.d/data/cache/.env.cache"
    chmod 600 "$HOME/.bash.d/data/cache/.env.cache" 2> /dev/null
  fi

  __rebuild_mytools_cache

  source "$HOME/.bashrc"
  echo -e "${CB_GREEN}✅ All system caches refreshed successfully.${C_RESET}"
}
```

#### `mt-run`

> MyTools: Interactive fuzzy-finder to select and execute a command	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: Interactive fuzzy-finder to select and execute a command
#######################################
mt-run() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  local selected
  selected=$(awk -F'\t' '{ printf "%-24s │ %-20s │ %s\n", $3, $2, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv" | fzf --ansi --prompt="Run Tool > " --header="COMMAND                  │ CATEGORY             │ DESCRIPTION")
  if [ -n "$selected" ]; then
    local cmd_name
    cmd_name=$(echo "$selected" | awk '{print $1}')
    echo -e "${CB_GREEN}🚀 Executing:${C_RESET} ${cmd_name}"
    eval "$cmd_name"
  fi
}
```

#### `mt-status`

> System: Display a unified health check and status dashboard	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# System: Display a unified health check and status dashboard
#######################################
mt-status() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_BLUE}==========================================================${C_RESET}"
  echo -e "${CB_BLUE}                 MT DEVOPS DASHBOARD                      ${C_RESET}"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"

  local current_version="Local"
  [ -f "$HOME/.bash.d/data/.current_version" ] && current_version=$(tr -d '[:space:]' < "$HOME/.bash.d/data/.current_version")
  echo -e "${CB_YELLOW}▶ FRAMEWORK${C_RESET}"
  echo -e "  ${CB_CYAN}Version       ${C_RESET}: ${current_version}"
  echo -e "  ${CB_CYAN}Theme         ${C_RESET}: ${BASH_THEME:-default}"
  echo -e "  ${CB_CYAN}AI Enabled    ${C_RESET}: ${AI_ENABLED:-true} (${DEFAULT_AI:-gemini})"

  echo -e "\n${CB_YELLOW}▶ PROFILE SYNC REPO${C_RESET}"
  local repo_dir="${DOTFILES_DIR:-$SYNC_REPO_DIR}"
  if [ -n "$repo_dir" ] && [ -d "$repo_dir/.git" ]; then
    local branch
    branch=$(git -C "$repo_dir" branch --show-current 2> /dev/null)
    local changes
    changes=$(git -C "$repo_dir" status --porcelain 2> /dev/null | wc -l)
    echo -e "  ${CB_CYAN}Path          ${C_RESET}: ${repo_dir}"
    echo -e "  ${CB_CYAN}Branch        ${C_RESET}: ${branch}"
    if [ "$changes" -gt 0 ]; then
      echo -e "  ${CB_CYAN}Uncommitted   ${C_RESET}: ${CB_RED}${changes} file(s) (Run mt-push-update)${C_RESET}"
    else
      echo -e "  ${CB_CYAN}Uncommitted   ${C_RESET}: ${CB_GREEN}Clean${C_RESET}"
    fi
  else
    echo -e "  ${CB_RED}Not initialized or not a Git repository. Run mt-setup to configure.${C_RESET}"
  fi

  echo -e "\n${CB_YELLOW}▶ DOCKER ENVIRONMENT${C_RESET}"
  if command -v docker > /dev/null 2>&1 && docker info > /dev/null 2>&1; then
    local running
    running=$(docker ps -q 2> /dev/null | wc -l)
    local total
    total=$(docker ps -aq 2> /dev/null | wc -l)
    echo -e "  ${CB_CYAN}Daemon        ${C_RESET}: ${CB_GREEN}Running${C_RESET}"
    echo -e "  ${CB_CYAN}Containers    ${C_RESET}: ${running} running / ${total} total"
  else
    echo -e "  ${CB_CYAN}Daemon        ${C_RESET}: ${CB_RED}Stopped or Not Installed${C_RESET}"
  fi

  echo -e "\n${CB_YELLOW}▶ SYSTEM UPDATES${C_RESET}"
  if [ -f "$HOME/.bash.d/data/cache/.update_pending" ]; then
    local sys_updates
    sys_updates=$(tr -d '[:space:]' < "$HOME/.bash.d/data/cache/.update_pending")
    echo -e "  ${CB_CYAN}OS Packages   ${C_RESET}: ${CB_RED}${sys_updates} available (Run sys-install)${C_RESET}"
  else
    echo -e "  ${CB_CYAN}OS Packages   ${C_RESET}: ${CB_GREEN}Up to date${C_RESET}"
  fi

  if [ -f "$HOME/.bash.d/data/cache/.profile_update_pending" ]; then
    local prof_update
    prof_update=$(tr -d '[:space:]' < "$HOME/.bash.d/data/cache/.profile_update_pending")
    echo -e "  ${CB_CYAN}Framework     ${C_RESET}: ${CB_RED}${prof_update} available (Run mt-get-update)${C_RESET}"
  else
    echo -e "  ${CB_CYAN}Framework     ${C_RESET}: ${CB_GREEN}Up to date${C_RESET}"
  fi

  echo -e "${CB_BLUE}==========================================================${C_RESET}"
}
```

#### `mytools`

> MyTools: Primary runner and documentation index	/home/mst/.bash.d/03-mytools/05-mytools.sh

```bash
#######################################
# MyTools: Primary runner and documentation index
#######################################
mytools() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }

  local bashd_dir="$HOME/.bash.d"
  local cache_file="$bashd_dir/data/cache/.mt_cache"
  local time_file="${cache_file}.time"
  local latest_mod
  latest_mod=$(__bashd_latest_mod "$bashd_dir")

  if [ ! -f "$cache_file" ] || [ ! -f "$time_file" ] || [ "$(command cat "$time_file" 2> /dev/null)" != "$latest_mod" ]; then
    __rebuild_mytools_cache
  fi
  cat "$cache_file"
}
```

### 📂 Path & URL Launchers (Config-Driven)


#### `cd-ai-workspace`

> AI: Change directory to unified AI workspace	/home/mst/.bash.d/02-utilities/03-launcher.sh

```bash
#######################################
# AI: Change directory to unified AI workspace
# Globals:
#   AI_WORKSPACE_DIR
#######################################
cd-ai-workspace() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  cd "$AI_WORKSPACE_DIR" || echo "🚨 Error: AI_WORKSPACE_DIR not set."
}
```

#### `cd-win-docker`

> Docker: Change to Docker directory (from config.yaml) and open in Windows Explorer	/home/mst/.bash.d/02-utilities/03-launcher.sh

```bash
#######################################
# Docker: Change to Docker directory (from config.yaml) and open in Windows Explorer
#######################################
cd-win-docker() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local docker_path="$DOCKER_ROOT_DIR"

  if [ -d "$docker_path" ]; then
    echo -e "${CB_BLUE}📂 Navigating to ${docker_path}...${C_RESET}"
    cd "$docker_path" || return 1
    win-docker
  else
    echo -e "${CB_RED}🚨 Error: Directory does not exist on the Linux filesystem.${C_RESET}"
    return 1
  fi
}
```

#### `ide`

> System: Open current directory in the default IDE (VSCode/IntelliJ)	/home/mst/.bash.d/02-utilities/03-launcher.sh

```bash
#######################################
# System: Open current directory in the default IDE (VSCode/IntelliJ)
# Globals:
#   DEFAULT_IDE
#######################################
ide() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local selected_ide="${DEFAULT_IDE:-vscode}"
  echo -e "${CB_GREEN}🚀 Opening current directory in ${selected_ide}...${C_RESET}"

  if [ "$selected_ide" = "intellij" ]; then
    __launch_intellij . || echo -e "${CB_RED}⚠️ Could not launch IntelliJ. Ensure 'idea' is on PATH (JetBrains Toolbox), or install IntelliJ IDEA via Homebrew on macOS.${C_RESET}"
  else
    code .
  fi
}
```

#### `mt-dotfiles`

> System: Change directory to dotfiles repository root	/home/mst/.bash.d/02-utilities/03-launcher.sh

```bash
#######################################
# System: Change directory to dotfiles repository root
# Globals:
#   DOTFILES_DIR, SYNC_REPO_DIR
#######################################
mt-dotfiles() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local target="${DOTFILES_DIR:-$SYNC_REPO_DIR}"
  if [ -n "$target" ] && [ -d "$target" ]; then
    cd "$target" || return 1
  else
    echo "🚨 Error: DOTFILES_DIR is not set or directory does not exist."
    return 1
  fi
}
```

#### `mt-open-homepage`

> System: Open dotfiles repository remote URL in default web browser	/home/mst/.bash.d/02-utilities/03-launcher.sh

```bash
#######################################
# System: Open dotfiles repository remote URL in default web browser
# Globals:
#   SYNC_REPO_URL
#######################################
mt-open-homepage() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$SYNC_REPO_URL" ] || [ "$SYNC_REPO_URL" = "YOUR_SYNC_REPO_URL" ]; then
    echo "🚨 Error: No sync repository URL configured."
    return 1
  fi

  local web_url="$SYNC_REPO_URL"
  if [[ "$web_url" == git@* ]]; then
    web_url="${web_url#git@}"
    web_url="${web_url/:/\/}"
    web_url="https://${web_url}"
  fi
  web_url="${web_url%.git}"
  web_url=$(echo "$web_url" | sed -E 's#([^:])//+#\1/#g')

  echo "🌐 Opening $web_url in browser..."
  __open_url "$web_url"
}
```

#### `win-ai-workspace`

> AI: Open unified AI workspace in the platform's native file manager (shortcut for `win ai`)	/home/mst/.bash.d/02-utilities/03-launcher.sh

```bash
#######################################
# AI: Open unified AI workspace in the platform's native file manager (shortcut for `win ai`)
#######################################
win-ai-workspace() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  win ai
}
```

#### `win-docker`

> Docker: Open Docker root directory in the platform's native file manager (shortcut for `win docker`)	/home/mst/.bash.d/02-utilities/03-launcher.sh

```bash
#######################################
# Docker: Open Docker root directory in the platform's native file manager (shortcut for `win docker`)
#######################################
win-docker() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  win docker
}
```

#### `win-sync`

> System: Open sync repository in the platform's native file manager (shortcut for `win sync`)	/home/mst/.bash.d/02-utilities/03-launcher.sh

```bash
#######################################
# System: Open sync repository in the platform's native file manager (shortcut for `win sync`)
#######################################
win-sync() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  win sync
}
```

### 📂 System & Environment Bootstrap


#### `bootstrap`

> System: Bootstrap missing dependencies (Debian/WSL via APT, macOS via Homebrew)	/home/mst/.bash.d/00-system/04-bootstrap.sh

```bash
#######################################
# System: Bootstrap missing dependencies (Debian/WSL via APT, macOS via Homebrew)
# Usage: bootstrap [OPTIONS]
# Options:
#   -h, --help    Show this help menu
#######################################
bootstrap() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo "🔍 Scanning system for missing dependencies..."

  if [ "$OS_FAMILY" = "macos" ]; then
    __bootstrap_brew
  else
    __bootstrap_apt
  fi
  __bootstrap_python
  __bootstrap_yq
  __bootstrap_external
  __bootstrap_check_complex

  echo -e "\n🎉 Environment bootstrap complete!"

  if ! command -v gh > /dev/null 2>&1; then
    echo -e "${CB_BLUE}📦 Installing GitHub CLI...${C_RESET}"
    if command -v apt-get > /dev/null 2>&1; then
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null 2>&1
      sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt-get update > /dev/null 2>&1
      sudo apt-get install -y gh > /dev/null 2>&1
    else
      echo -e "${CB_YELLOW}⚠️ apt-get not found. Please install GitHub CLI manually.${C_RESET}"
    fi
  fi

  if ! command -v claude > /dev/null 2>&1; then
    if command -v npm > /dev/null 2>&1; then
      echo -e "${CB_BLUE}📦 Installing Claude Code...${C_RESET}"
      sudo npm install -g @anthropic-ai/claude-code > /dev/null 2>&1
    else
      echo -e "${CB_YELLOW}⚠️ npm not found. Skipping Claude Code install. (Please install Node.js first)${C_RESET}"
    fi
  fi
}
```

#### `sys-install`

> System: Updates system packages and clears pending-update marker	/home/mst/.bash.d/00-system/04-bootstrap.sh

```bash
#######################################
# System: Updates system packages and clears pending-update marker
# Usage: sys-install [OPTIONS]
# Options:
#   -h, --help    Show this help menu
#######################################
sys-install() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  sys-update
  rm -f "$HOME/.bash.d/data/cache/.update_pending"
}
```

#### `sys-update`

> System: Updates system packages (APT on Debian/WSL, Homebrew on macOS)	/home/mst/.bash.d/00-system/04-bootstrap.sh

```bash
#######################################
# System: Updates system packages (APT on Debian/WSL, Homebrew on macOS)
# Usage: sys-update [OPTIONS]
# Options:
#   -h, --help    Show this help menu
#######################################
sys-update() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ "$OS_FAMILY" = "macos" ]; then
    if ! command -v brew > /dev/null 2>&1; then
      echo "🚨 Homebrew not found. Run 'bootstrap' first."
      return 1
    fi
    brew update && brew upgrade
  else
    sudo apt update && sudo apt upgrade
  fi
}
```

### 📂 System & Navigation Aliases


#### `clip`

> System: Pipe output to the system clipboard (e.g. cat file | clip)	/home/mst/.bash.d/02-utilities/20-aliases.sh

```bash
#######################################
# System: Pipe output to the system clipboard (e.g. cat file | clip)
#######################################
clip() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __clip_copy
}
```

#### `win`

> System: Open a directory in the platform's native file manager	/home/mst/.bash.d/02-utilities/20-aliases.sh

```bash
#######################################
# System: Open a directory in the platform's native file manager
# Usage: win [sync|ai|docker|export|vcs]
# Globals:
#   DOTFILES_DIR, SYNC_REPO_DIR, AI_WORKSPACE_DIR, DOCKER_ROOT_DIR, VCS_EXPORTS, VCS_ROOT
#######################################
win() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local target="$PWD"
  case "$1" in
    "") ;;
    sync) target="${DOTFILES_DIR:-$SYNC_REPO_DIR}" ;;
    ai) target="$AI_WORKSPACE_DIR" ;;
    docker) target="$DOCKER_ROOT_DIR" ;;
    export) target="$VCS_EXPORTS" ;;
    vcs) target="$VCS_ROOT" ;;
    *)
      echo "Usage: win [sync|ai|docker|export|vcs]" >&2
      return 1
      ;;
  esac
  __open_path_gui "$target"
}
```

#### `win-export`

> System: Open ~/vcs/personal/exports in the platform's native file manager (shortcut for `win export`)	/home/mst/.bash.d/02-utilities/20-aliases.sh

```bash
#######################################
# System: Open ~/vcs/personal/exports in the platform's native file manager (shortcut for `win export`)
#######################################
win-export() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  win export
}
```

#### `win-vcs`

> System: Open ~/vcs in the platform's native file manager (shortcut for `win vcs`)	/home/mst/.bash.d/02-utilities/20-aliases.sh

```bash
#######################################
# System: Open ~/vcs in the platform's native file manager (shortcut for `win vcs`)
#######################################
win-vcs() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  win vcs
}
```

### 📂 Terraform & AI Integrations


#### `tf-iam`

> AI: Analyze Terraform codebase for IAM requirements and optionally generate script	/home/mst/.bash.d/10-infra/43-terraform-ai.sh

```bash
#######################################
# AI: Analyze Terraform codebase for IAM requirements and optionally generate script
# Usage: tf-iam [-g] [-m model]
# Options:
#   -g            Generate a provisioning script instead of just outputting a chat analysis
#   -m <model>    Override the default AI model (e.g., gemini, claude)
#   -h, --help    Show this help menu
#######################################
tf-iam() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local generate_script=false
  local override_ai=()

  local OPTIND opt
  while getopts "gm:" opt; do
    case ${opt} in
      g) generate_script=true ;;
      m) override_ai=("-m" "$OPTARG") ;;
      \?)
        echo "Usage: tf-iam [-g] [-m gemini|claude]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  local tf_count
  tf_count=$(find . -maxdepth 3 -name "*.tf" 2> /dev/null | wc -l)
  if [ "$tf_count" -eq 0 ]; then
    echo "terraform modules not found"
    return 0
  fi

  local repo_name
  repo_name=$(basename "$(git rev-parse --show-toplevel 2> /dev/null || pwd)")

  local prompt
  prompt=$(__get_prompt "tf_iam_base")

  if [ "$generate_script" = true ]; then
    local target_dir="${SCRIPTS_IAM_DIR:-/tmp/scripts/iam}"
    mkdir -p "$target_dir"
    local target_script="${target_dir}/${repo_name}.sh"

    local script_prompt
    script_prompt=$(__get_prompt "tf_iam_script")
    prompt="${prompt}\n\n${script_prompt}"

    echo "🤖 Analyzing Terraform codebase and generating IAM provisioning script..."
    ai "${override_ai[@]}" -e -t "${repo_name}-iam-provisioning" -o "$target_script" "$prompt"
  else
    local chat_prompt
    chat_prompt=$(__get_prompt "tf_iam_chat")
    prompt="${prompt}\n\n${chat_prompt}"
    echo "🤖 Analyzing Terraform codebase for IAM requirements..."
    ai "${override_ai[@]}" -e "$prompt"
  fi
}
```

### 📂 Terraform Aliases


#### `tf-clean`

> Terraform: Aggressively clean local caching (.terraform, locks, plans)	/home/mst/.bash.d/10-infra/41-terraform-aliases.sh

```bash
#######################################
# Terraform: Aggressively clean local caching (.terraform, locks, plans)
#######################################
tf-clean() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_RED}⚠️ WARNING: This will delete .terraform directories, lock files, and saved plans.${C_RESET}"
  read -r -p "Are you sure you want to proceed? [y/N] " -n 1
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "🛑 Aborted."
    return 0
  fi
  echo "🧹 Cleaning local Terraform caches..."

  find . -type d -name ".terraform" -exec rm -rf {} + 2> /dev/null
  find . -type f -name ".terraform.lock.hcl" -delete 2> /dev/null
  find . -type f -name "tfplan" -delete 2> /dev/null
  echo -e "${CB_GREEN}✅ Clean complete. Run 'tfin' to reinitialize.${C_RESET}"
}
```

#### `tf-replace`

> Terraform: Replace a specific resource (Modern alternative to taint)	/home/mst/.bash.d/10-infra/41-terraform-aliases.sh

```bash
#######################################
# Terraform: Replace a specific resource (Modern alternative to taint)
# Arguments:
#   $1 - The resource address to replace (e.g., google_compute_instance.web)
#######################################
tf-replace() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$1" ]; then
    echo "Usage: tf-replace <resource_address>"
    return 1
  fi
  echo "🔄 Planning replacement for: $1"
  terraform apply -replace="$1"
}
```

#### `tf-yaml`

> Terraform: Execute Terraform using a YAML config file for variables	/home/mst/.bash.d/10-infra/41-terraform-aliases.sh

```bash
#######################################
# Terraform: Execute Terraform using a YAML config file for variables
# Arguments:
#   $1 - Path to the YAML configuration file
#   $2 - (Optional) Target environment key if YAML is hierarchically structured
#   $@ - Terraform command and arguments (e.g., plan, apply)
#######################################
tf-yaml() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local yaml_file="$1"
  shift

  if [ -z "$yaml_file" ] || [ ! -f "$yaml_file" ]; then
    echo -e "${CB_RED}🚨 Error: You must provide a valid YAML file path.${C_RESET}"
    echo "Usage: tf-yaml <config.yaml> [environment] <terraform command> [args...]"
    return 1
  fi

  local env_name=""
  if [[ -n "$1" && ! "$1" =~ ^(-.*|plan|apply|destroy|init|validate|output|console|refresh|show|state|workspace|fmt|import)$ ]]; then
    env_name="$1"
    shift
  fi

  if [ $# -eq 0 ]; then
    echo -e "${CB_RED}🚨 Error: You must provide a Terraform command.${C_RESET}"
    echo "Usage: tf-yaml <config.yaml> [environment] <terraform command> [args...]"
    return 1
  fi

  if ! command -v yq > /dev/null 2>&1; then
    echo -e "${CB_RED}🚨 Error: 'yq' is not installed. Run 'bootstrap' to install it.${C_RESET}"
    return 1
  fi

  local tmp_vars
  tmp_vars=$(mktemp --suffix=.json)

  if [ -n "$env_name" ]; then
    echo -e "${CB_BLUE}🔄 Parsing variables for environment '${env_name}' from ${yaml_file}...${C_RESET}"
    local tmp_globals
    tmp_globals=$(mktemp)
    local tmp_env
    tmp_env=$(mktemp)

    yq 'del(.environments)' "$yaml_file" > "$tmp_globals"
    yq ".environments[\"${env_name}\"]" "$yaml_file" > "$tmp_env"

    if [ "$(command cat "$tmp_env")" = "null" ]; then
      echo -e "${CB_RED}🚨 Error: Environment '${env_name}' not found in ${yaml_file}.${C_RESET}"
      rm -f "$tmp_vars" "$tmp_globals" "$tmp_env"
      return 1
    fi

    yq -o=json eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "$tmp_globals" "$tmp_env" > "$tmp_vars"
    rm -f "$tmp_globals" "$tmp_env"
  else
    echo -e "${CB_BLUE}🔄 Parsing variables from ${yaml_file}...${C_RESET}"
    yq -o=json '.' "$yaml_file" > "$tmp_vars"
  fi

  echo -e "${CB_GREEN}🚀 Executing: terraform $* -var-file=...${C_RESET}"
  terraform "$@" -var-file="$tmp_vars"
  local tf_exit=$?

  rm -f "$tmp_vars"
  return $tf_exit
}
```

### 📂 Terraform & Kubernetes Wrappers


#### `terraform`

> Terraform: Core wrapper (preserves args)	/home/mst/.bash.d/10-infra/40-terraform-k8s.sh

```bash
#######################################
# Terraform: Core wrapper (preserves args)
# Note: Does NOT intercept --help to preserve native terraform help.
# Run `mt-help terraform` for framework documentation.
#######################################
terraform() {
  echo "+ terraform $*" >&2
  command terraform "$@"
}
```

### 📂 Version Control (Git) - AI Workflows


#### `git-ai-push-all`

> Git: Auto-format, stage, generate AI commits, and push all changes	/home/mst/.bash.d/20-vcs/51-git-ai.sh

```bash
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
```

#### `mt-ai-gitignore`

> AI: Generate a comprehensive .gitignore for the active repository	/home/mst/.bash.d/20-vcs/51-git-ai.sh

```bash
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
```

#### `mt-ai-readme`

> AI: Generate a comprehensive README.md for the active repository	/home/mst/.bash.d/20-vcs/51-git-ai.sh

```bash
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
```

### 📂 Version Control (Git) - Core Helpers


#### `git`

> Git: Intercept 'clone' to automatically route repositories into ~/vcs/	/home/mst/.bash.d/20-vcs/50-git.sh

```bash
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
```

#### `git-clean-merged`

> Git: Delete local and remote branches merged into the default branch	/home/mst/.bash.d/20-vcs/50-git.sh

```bash
#######################################
# Git: Delete local and remote branches merged into the default branch
#######################################
git-clean-merged() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local default_branch
  default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print$NF}')
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
      read -r -p "Delete remote branch 'origin/$r_branch'? [y/N] " -n 1 < /dev/tty
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin --delete "$r_branch"
      fi
    done
    echo -e "${CB_GREEN}✅ Remote cleanup complete.${C_RESET}"
  fi
}
```

#### `git-clone-ide`

> Git: Clone repository into ~/vcs/, navigate into it, and open in default IDE	/home/mst/.bash.d/20-vcs/50-git.sh

```bash
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

  if [ "$selected_ide" = "intellij" ]; then
    __launch_intellij . || echo "⚠️ Could not launch IntelliJ. Ensure 'idea' is on PATH (JetBrains Toolbox), or install IntelliJ IDEA via Homebrew on macOS."
  else
    code -n .
  fi
}
```

#### `git-default-rebase`

> Git: Fetch upstream origin and rebase current branch onto default branch	/home/mst/.bash.d/20-vcs/50-git.sh

```bash
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
  default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print$NF}')
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
```

#### `git-new-feature`

> Git: Create and checkout a new feature branch	/home/mst/.bash.d/20-vcs/50-git.sh

```bash
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
```

#### `git-nuke`

> Git: Hard reset local branch to upstream state and wipe untracked files	/home/mst/.bash.d/20-vcs/50-git.sh

```bash
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
  read -r -p "Reset '${current_branch}' to origin/${current_branch}? [y/N] " -n 1 < /dev/tty
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "💥 Nuking local environment..."
    git fetch origin > /dev/null 2>&1
    if ! git ls-remote --exit-code --heads origin "$current_branch" > /dev/null 2>&1; then
      echo -e "${CB_RED}🚨 Error: Upstream branch 'origin/$current_branch' does not exist. Cannot safely reset.${C_RESET}"
      return 1
    fi
    git reset --hard "origin/$current_branch"
    git clean -fd
    echo -e "${CB_GREEN}✅ Branch reset to upstream state.${C_RESET}"
  else
    echo "🛑 Aborted."
  fi
}
```

#### `git-pretty-log`

> Git: Print a clean, color-coded, single-line log graph	/home/mst/.bash.d/20-vcs/50-git.sh

```bash
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
```

#### `git-push-all`

> Git: Stage all files, commit with provided message, and push	/home/mst/.bash.d/20-vcs/50-git.sh

```bash
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
```

#### `git-raise-pr`

> Git: Push current branch and raise a Pull Request (GitHub/GitLab/Bitbucket)	/home/mst/.bash.d/20-vcs/50-git.sh

```bash
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
  default_branch=$(git remote show origin 2> /dev/null | awk '/HEAD branch/ {print$NF}')
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

  __git_raise_pr_sync_with_target || return 1

  local is_github=false
  local origin_url=""
  local __git_raise_pr_dead_pr_action="continue"
  __git_raise_pr_handle_dead_pr
  case "$__git_raise_pr_dead_pr_action" in
    done) return 0 ;;
    error) return 1 ;;
  esac

  __git_raise_pr_push_branch || return 1
  __git_raise_pr_create_or_open
}
```

#### `git-view-remote`

> Git: Open current repository remote URL in default web browser	/home/mst/.bash.d/20-vcs/50-git.sh

```bash
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
```

#### `mt-repos`

> Git: Scan VCS root and list all local repositories	/home/mst/.bash.d/20-vcs/50-git.sh

```bash
#######################################
# Git: Scan VCS root and list all local repositories
# Globals:
#   VCS_ROOT, WSL_DISTRO_NAME
#######################################
mt-repos() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local search_dir="${VCS_ROOT:-$HOME/vcs}"
  if [ ! -d "$search_dir" ]; then
    echo -e "${CB_RED}🚨 Error: VCS root directory '$search_dir' not found.${C_RESET}"
    return 1
  fi

  echo -e "${CB_BLUE}🔍 Scanning '$search_dir' for Git repositories...${C_RESET}"

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
    # Capitalize the first letter for a clean UI
    repo_type="$(tr '[:lower:]' '[:upper:]' <<< "${repo_type:0:1}")${repo_type:1}"

    local branch
    branch=$(git -C "$repo_path" branch --show-current 2> /dev/null || echo "HEAD detached")
    [ -z "$branch" ] && branch="No commits"

    local remote
    remote=$(git -C "$repo_path" config --get remote.origin.url 2> /dev/null || echo "No remote")

    echo "${repo_type}|${repo_name}|${branch}|${remote}|${repo_path}" >> "$tmp_out"
  done < <(find "$search_dir" -type d -exec test -d "{}/.git" \; -prune -print)

  local count
  count=$(wc -l < "$tmp_out")

  if [ "$count" -eq 0 ]; then
    echo -e "${CB_YELLOW}⚠️ No Git repositories found in $search_dir.${C_RESET}"
    rm -f "$tmp_out"
    return 0
  fi

  echo -e "\n${CB_CYAN}📦 Found $count repositories in $search_dir:${C_RESET}\n"

  sort -t'|' -k1,1 -k2,2 -k5,5 "$tmp_out" -o "$tmp_out"

  awk -F'|' -v home="$HOME" -v wsl_distro="${WSL_DISTRO_NAME:-Debian}" -v blue="$CB_BLUE" -v green="$CB_GREEN" -v yellow="$CB_YELLOW" -v dim="$C_DIM" -v rst="$C_RESET" -v magenta="$CB_MAGENTA" -v cyan="$CB_CYAN" '
    function pad(str, len) {
      if (length(str) > len) return substr(str, 1, len-3) "..."
      return str sprintf("%*s", len - length(str), "")
    }
    BEGIN {
      printf "%s%-15s %-35s %-20s %-50s %s%s\n", blue, "TYPE", "REPOSITORY", "BRANCH", "REMOTE URL", "PATH", rst
      printf "%s%s%s\n", blue, "---------------------------------------------------------------------------------------------------------------------------------------------------", rst
    }
    {
      type = pad($1, 15)
      repo = pad($2, 35)
      branch_raw = $3
      branch = pad(branch_raw, 20)
      branch_color = (branch_raw == "main" || branch_raw == "master") ? green : yellow
      
      remote_raw = $4
      remote_color = (remote_raw == "No remote") ? dim : rst
      remote_disp = pad(remote_raw, 50)
      
      # Robust URL transformation for both SSH (git@) and HTTPS
      web_url = remote_raw
      if (web_url ~ /^git@/) {
          sub(/^git@/, "", web_url)
          sub(/:/, "/", web_url)
          web_url = "https://" web_url
      }
      sub(/\.git$/, "", web_url)
      
      if (web_url ~ /^http/) {
          remote_linked = "\033]8;;" web_url "\033\\" remote_disp "\033]8;;\033\\"
      } else {
          remote_linked = remote_disp
      }
      
      path_full = $5
      path_disp = path_full
      if (index(path_disp, home) == 1) {
          path_disp = "~" substr(path_disp, length(home) + 1)
      }
      
      if (wsl_distro != "") {
          file_url = "file://wsl.localhost/" wsl_distro path_full
      } else {
          file_url = "file://" path_full
      }
      
      path_linked = "\033]8;;" file_url "\033\\" path_disp "\033]8;;\033\\"
      
      printf "%s%s%s %s%s%s %s%s%s %s%s%s %s\n", magenta, type, rst, cyan, repo, rst, branch_color, branch, rst, remote_color, remote_linked, rst, path_linked
    }
  ' "$tmp_out"

  echo ""
  rm -f "$tmp_out"
}
```

### 📂 Version Control (Git) - Profile Synchronization


#### `mt-download-release`

> System: Download a release zip from the remote repository	/home/mst/.bash.d/20-vcs/52-git-sync.sh

```bash
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
```

#### `mt-get-update`

> System: Download and install profile updates from GitHub releases	/home/mst/.bash.d/20-vcs/52-git-sync.sh

```bash
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

  local download_url="" tag_name=""
  __mt_get_update_resolve_release "$target_version"
  local resolve_status=$?
  [ "$resolve_status" -eq 2 ] && return 0
  [ "$resolve_status" -eq 1 ] && return 1

  local tmp_dir="" ext_root=""
  __mt_get_update_download_and_extract "$download_url" "$tag_name" || return 1

  if ! __mt_get_update_check_divergence "$ext_root"; then
    rm -rf "$tmp_dir"
    return 0
  fi

  __mt_get_update_install "$ext_root" "$tag_name"
  rm -rf "$tmp_dir"
}
```

#### `mt-push-update`

> System: Sync local bash configs to terminal dotfiles repo and create a Pull Request	/home/mst/.bash.d/20-vcs/52-git-sync.sh

```bash
#######################################
# System: Sync local bash configs to terminal dotfiles repo and create a Pull Request
# Usage: mt-push-update [-i|--issue issue_num] [-s|--shellcheck] [-b|--backup] [optional_message]
# Options:
#   -i, --issue <num>  Optional issue number to link to the Pull Request
#   -s, --shellcheck   Run ShellCheck locally before pushing to catch errors early
#   -b, --backup       Create a zip backup of .bash.d and .bashrc before syncing
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
  local prompt_remote=false
  local auto_merge=false
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
        # Check if the next argument is a message string and not another flag
        if [[ "$#" -gt 0 && "$1" != -* ]]; then
          user_msg="$1"
          shift
        fi
        ;;
      -d | --delete-merged)
        delete_merged=true
        shift
        ;;
      --prompt-remote)
        prompt_remote=true
        shift
        ;;
      -g | --merge)
        auto_merge=true
        shift
        ;;
      -*)
        echo "Usage: mt-push-update [-i|--issue <num>] [-s|--shellcheck] [-b|--backup] [-m|--no-ai] [-d|--delete-merged] [--prompt-remote] [-g|--merge] [message]" >&2
        return 1
        ;;
      *)
        if [ -z "$user_msg" ]; then
          user_msg="$1"
        else
          user_msg="${user_msg} $1"
        fi
        shift
        ;;
    esac
  done

  user_msg=$(echo "$user_msg" | xargs)

  if [ "$run_shellcheck" = true ]; then
    __mt_push_update_run_shellcheck || return 1
  fi

  local repo_dir="${DOTFILES_DIR:-$SYNC_REPO_DIR}"
  local remote_url="${SYNC_REPO_URL:-}"

  if [[ -z "$remote_url" || "$remote_url" == "YOUR_SYNC_REPO_URL" || "$remote_url" == "null" ]]; then
    echo -e "${CB_YELLOW}⚠️  Profile Sync Not Configured${C_RESET}"
    echo -e "The ${C_BOLD}push-profile-update${C_RESET} feature automatically versions and pushes your terminal configuration to a remote Git repository."
    echo "If you downloaded this profile as a standalone ZIP and do not wish to sync it, you can safely ignore this command."
    echo -e "\nTo enable syncing, link an empty remote Git repository by running:"
    echo -e "   ${CB_CYAN}mt-add-sync-url \"git@github.com:username/my-terminal-repo.git\"${C_RESET}\n"
    return 1
  fi

  if [ "$backup_before_sync" = true ]; then
    __mt_push_update_backup || return 1
  fi

  echo "🔄 Syncing bash configuration to $repo_dir..."
  __git_sync_init_repo "$repo_dir" "$remote_url"

  (__mt_push_update_reconcile_branch) || return 1

  __git_sync_copy_files "$repo_dir"

  (__mt_push_update_commit_and_raise_pr) || return 1
}
```
