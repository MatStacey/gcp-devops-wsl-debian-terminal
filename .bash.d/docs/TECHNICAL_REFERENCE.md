# 🛠️ MT DevOps Framework - Technical Command Reference

> **Auto-generated Reference Document**  
> Generated: $(date)  
> Environment: $(uname -s) ($(uname -m))

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
- **`cat`** *(Modern CLI Replacements)*: CLI: bat - Print file contents with syntax highlighting
- **`ccat`** *(Modern CLI Replacements)*: CLI: bat - Print file contents with line numbers & Git gutters
- **`json-fmt`** *(Modern CLI Replacements)*: CLI: jq - Pretty-print JSON stream
- **`ll`** *(Modern CLI Replacements)*: CLI: eza - Detailed list with Git status
- **`ls`** *(Modern CLI Replacements)*: CLI: eza - List files with directories first
- **`rg`** *(Modern CLI Replacements)*: CLI: rg - Search with smart case, include hidden, ignore .git
- **`tree`** *(Modern CLI Replacements)*: CLI: eza - Display directory structure as a tree
- **`yaml-fmt`** *(Modern CLI Replacements)*: CLI: yq - Pretty-print YAML stream
- **`mt-search`** *(MyTools Documentation & Runner)*: MyTools: Search through available mytools commands (Alias)
- **`cd-mt-git-local`** *(Path & URL Launchers (Config-Driven))*: System: Change directory to dotfiles repository root (Alias)
- **`cd-bashd`** *(System & Navigation Aliases)*: System: Change directory to ~/.bash.d
- **`cd-git-home`** *(System & Navigation Aliases)*: System: Change directory to ~/vcs
- **`cd-git-personal`** *(System & Navigation Aliases)*: System: Change directory to ~/vcs/personal
- **`mt`** *(System & Navigation Aliases)*: System: Print all aliases and functions (MyTools Engine)
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

---

## 🛠️ Public Functions


### 📂 AI Workflows & LLM API Integration

#### `ai`
> AI: Query configured LLM with prompt and optional context

```bash
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
> AI: Explain a terminal command in detail

```bash
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
> AI: Debug and explain the last failed terminal command

```bash
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


### 📂 Base64 Encoding & Decoding Utilities

#### `base64-dec`
> System: Decode a Base64 string, file, or stream

```bash
base64-dec() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local input_file="" output_file="" input_str=""

  local OPTIND opt
  while getopts "f:o:" opt; do
    case ${opt} in
      f) input_file="$OPTARG" ;;
      o) output_file="$OPTARG" ;;
      \?)
        echo "Usage: base64-dec [-f file] [-o file] [string]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))
  input_str="$*"

  local decoded=""

  if [ -n "$input_file" ]; then
    if [ ! -f "$input_file" ]; then
      echo -e "${C_RED}🚨 Error: Input file '$input_file' not found.${C_RESET}" >&2
      return 1
    fi
    decoded=$(base64 -d < "$input_file")
  elif [ -n "$input_str" ]; then
    decoded=$(echo -n "$input_str" | base64 -d)
  else
    if [ ! -t 0 ]; then
      decoded=$(base64 -d)
    else
      echo "Usage: base64-dec [-f file] [-o file] [string]" >&2
      return 1
    fi
  fi

  if [ -n "$output_file" ]; then
    echo -n "$decoded" > "$output_file"
    echo -e "${C_GREEN}✅ Decoded output written to $output_file${C_RESET}"
  else
    echo "$decoded"
  fi
}
```

#### `base64-enc`
> System: Encode a string, file, or stream to Base64

```bash
base64-enc() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local input_file="" output_file="" input_str=""

  local OPTIND opt
  while getopts "f:o:" opt; do
    case ${opt} in
      f) input_file="$OPTARG" ;;
      o) output_file="$OPTARG" ;;
      \?)
        echo "Usage: base64-enc [-f file] [-o file] [string]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))
  input_str="$*"

  local encoded=""

  if [ -n "$input_file" ]; then
    if [ ! -f "$input_file" ]; then
      echo -e "${C_RED}🚨 Error: Input file '$input_file' not found.${C_RESET}" >&2
      return 1
    fi
    encoded=$(base64 < "$input_file")
  elif [ -n "$input_str" ]; then
    encoded=$(echo -n "$input_str" | base64)
  else
    if [ ! -t 0 ]; then
      encoded=$(base64)
    else
      echo "Usage: base64-enc [-f file] [-o file] [string]" >&2
      return 1
    fi
  fi

  if [ -n "$output_file" ]; then
    echo -n "$encoded" > "$output_file"
    echo -e "${C_GREEN}✅ Encoded output written to $output_file${C_RESET}"
  else
    echo "$encoded"
  fi
}
```


### 📂 Configuration Management

#### `mt-get-gemini-status`
> AI: Print current Gemini API model version and extended reasoning mode toggle

```bash
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
> Config: Forcefully re-parse config.yaml and reload environment variables

```bash
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
    source "$env_cache"
    echo -e "${CB_GREEN}✅ Config reloaded! Active variables updated.${C_RESET}"
  else
    echo -e "${CB_RED}🚨 Error: config_manager.py not found.${C_RESET}"
    return 1
  fi
}
```

#### `mt-open-config`
> Config: Open bash.d directory and config.yaml in IDE

```bash
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
  [ "$selected_ide" = "intellij" ] &&
    { __launch_intellij "$config_dir" "$config_file" || echo "⚠️ Could not launch IntelliJ. Ensure 'idea' is on PATH (JetBrains Toolbox), or install IntelliJ IDEA via Homebrew on macOS."; } ||
    code "$config_dir" "$config_file"
}
```

#### `mt-set-default-ai`
> Config: Set default AI model provider

```bash
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
> Config: Set default terminal IDE launcher

```bash
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
> Config: Set terminal color theme

```bash
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
> Config: Launch the interactive Master Setup Wizard Menu

```bash
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
    2*) mt-setup-system ;;
    3*) mt-setup-ai ;;
    4*) mt-setup-exports ;;
    5*) mt-setup-paths ;;
    6*) mt-setup-git ;;
    7*) mt-setup-cicd ;;
    8*) mt-setup-docker ;;
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
> Config: Interactive AI Setup Menu

```bash
mt-setup-ai() {
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
  read -r -s -p "Update Gemini API Key (Leave blank to keep current): " g_key
  echo
  [ -n "$g_key" ] && python3 "$CONFIG_MANAGER" update "ai.gemini" "api_key" "$g_key"

  echo -e "\n${CB_CYAN}Claude Settings:${C_RESET}"
  read -r -p "Claude Model Version [${CLAUDE_VERSION:-claude-3-7-sonnet-latest}]: " c_ver
  [ -n "$c_ver" ] && python3 "$CONFIG_MANAGER" update "ai.claude" "version" "$c_ver"
  read -r -s -p "Update Claude API Key (Leave blank to keep current): " c_key
  echo
  [ -n "$c_key" ] && python3 "$CONFIG_MANAGER" update "ai.claude" "api_key" "$c_key"

  echo -e "\n${CB_CYAN}Local AI Settings:${C_RESET}"
  read -r -p "Local AI Base URL [${LOCAL_AI_BASE_URL:-http://localhost:11434/v1}]: " l_url
  [ -n "$l_url" ] && python3 "$CONFIG_MANAGER" update "ai.local" "base_url" "$l_url"
  read -r -p "Local AI Model [${LOCAL_AI_MODEL:-llama3.2}]: " l_mod
  [ -n "$l_mod" ] && python3 "$CONFIG_MANAGER" update "ai.local" "model" "$l_mod"

  echo -e "${CB_GREEN}✅ AI config updated.${C_RESET}"
}
```

#### `mt-setup-cicd`
> Config: Interactive CI/CD Setup Menu

```bash
mt-setup-cicd() {
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

#### `mt-setup-docker`
> Config: Interactive Docker Setup Menu

```bash
mt-setup-docker() {
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

#### `mt-setup-exports`
> Config: Interactive Exports Setup Menu

```bash
mt-setup-exports() {
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

#### `mt-setup-git`
> Config: Interactive Git Setup Menu

```bash
mt-setup-git() {
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

#### `mt-setup-paths`
> Config: Interactive Paths Setup Menu

```bash
mt-setup-paths() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_BLUE}--- Paths Configuration ---${C_RESET}"
  read -r -p "VCS Root [${VCS_ROOT:-~/vcs}]: " p1
  [ -n "$p1" ] && python3 "$CONFIG_MANAGER" update "paths" "vcs_root" "$p1"
  read -r -p "VCS Personal [${VCS_PERSONAL:-~/vcs/personal}]: " p2
  [ -n "$p2" ] && python3 "$CONFIG_MANAGER" update "paths" "vcs_personal" "$p2"
  read -r -p "VCS Exports [${VCS_EXPORTS:-~/vcs/personal/exports}]: " p3
  [ -n "$p3" ] && python3 "$CONFIG_MANAGER" update "paths" "vcs_exports" "$p3"
  read -r -p "Dotfiles Repo [${DOTFILES_DIR:-~/vcs/personal/mt-devops-framework}]: " p4
  [ -n "$p4" ] && python3 "$CONFIG_MANAGER" update "paths" "dotfiles_dir" "$p4"
  read -r -p "AI Workspace [${AI_WORKSPACE_DIR:-~/vcs/ai-workspace}]: " p5
  [ -n "$p5" ] && python3 "$CONFIG_MANAGER" update "paths" "ai_workspace" "$p5"
  read -r -p "IAM Scripts [${SCRIPTS_IAM_DIR:-~/vcs/scripts/iam}]: " p6
  [ -n "$p6" ] && python3 "$CONFIG_MANAGER" update "paths" "scripts_iam" "$p6"
  read -r -p "Docker Root [${DOCKER_ROOT_DIR:-~/.docker}]: " p7
  [ -n "$p7" ] && python3 "$CONFIG_MANAGER" update "paths" "docker_root" "$p7"
  echo -e "${CB_GREEN}✅ Paths config updated.${C_RESET}"
}
```

#### `mt-set-upstream-path`
> Config: Set the upstream repository path for framework updates

```bash
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
> Config: Interactive System Setup Menu

```bash
mt-setup-system() {
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

#### `mt-toggle-ai`
> Config: Toggle global AI prompt and workflow integration (true/false)

```bash
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
> Config: Toggle global format-on-push behavior (true/false)

```bash
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


### 📂 Container Orchestration

#### `kubectl`
> Kubernetes: Core kubectl wrapper (preserves args)

```bash
kubectl() {
  echo "+ kubectl $*" >&2
  command kubectl "$@"
}
```


### 📂 Container Orchestration (Kubernetes) Aliases

#### `kns`
> Kubernetes: Get or explicitly set the active namespace in the current context

```bash
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
> GCP: List active configuration properties

```bash
gcl-config() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud config list "$@"
}
```

#### `gcl-export-vars`
> GCP: Export PROJECT_ID and PROJECT_NUMBER env vars to shell

```bash
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

#### `gcl-get-project`
> GCP: Print active project ID

```bash
gcl-get-project() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __get_gcp_config_val "project"
}
```

#### `gcl-get-project-number`
> GCP: Print active project Number (API call required)

```bash
gcl-get-project-number() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local project_id
  project_id=$(gcl-get-project)
  [ -n "$project_id" ] && gcloud projects describe "$project_id" --format="value(projectNumber)"
}
```

#### `gcl-get-region`
> GCP: Print active compute region

```bash
gcl-get-region() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __get_gcp_config_val "region"
}
```

#### `gcl-get-user`
> GCP: Print active user account

```bash
gcl-get-user() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __get_gcp_config_val "account"
}
```

#### `gcl-get-zone`
> GCP: Print active compute zone

```bash
gcl-get-zone() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __get_gcp_config_val "zone"
}
```

#### `gcl-org-policies`
> GCP: List org policies for active project

```bash
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
> GCP: Update Google Cloud CLI tools

```bash
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
> GCP: Login to user & application default

```bash
gcp-login() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud auth login && gcloud auth application-default login
}
```

#### `gcp-login-adc`
> GCP: Login to application default only

```bash
gcp-login-adc() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud auth application-default login
}
```

#### `gcp-set-project`
> GCP: Switch active project

```bash
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
> GCP: Run standard SQL query in BigQuery

```bash
bq-query() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  bq query --use_legacy_sql=false "$1"
}
```

#### `gcl-as-json`
> GCP: Run any gcloud command and output as formatted JSON

```bash
gcl-as-json() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud "$@" --format="json" | jq '.'
}
```

#### `gcp-crf-logs`
> GCP: Tail logs of a Cloud Run Function

```bash
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
> GCP: Configure Docker auth for Artifact Registry

```bash
gcp-gar-docker() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud auth configure-docker "$1-docker.pkg.dev"
}
```

#### `gcp-get-secret`
> GCP: Read the latest payload of a secret

```bash
gcp-get-secret() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud secrets versions access latest --secret="$1"
}
```

#### `gcp-iam-show`
> GCP: View IAM policy for the active project

```bash
gcp-iam-show() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud projects get-iam-policy "$(gcl-get-project)" --format="table(bindings.role, bindings.members)"
}
```

#### `gcp-ps-pull`
> GCP: Pull and auto-ack one message from a Pub/Sub subscription

```bash
gcp-ps-pull() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud pubsub subscriptions pull "$1" --auto-ack --limit=1
}
```


### 📂 General System Utilities

#### `mt-top-files`
> System: Display the top largest files in a directory

```bash
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


### 📂 Google Style Code Formatting

#### `google-fmt`
> Formats Python and Shell scripts according to Google Style Guides.

```bash
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
> Terraform: Recursively validate and scan all Terraform directories

```bash
tf-val-all() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local threads="${MAX_PARALLEL_THREADS:-8}"

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

#### `mt-export`
> LLM: Export codebase to text/zip for LLM context window using dynamic schemas

```bash
mt-export() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local target_dir="."
  local schema_query="default"
  local zip_out=false
  local quiet_mode=false

  # Parse Arguments
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -d | --dir) target_dir="$2"; shift ;;
      -s | --schema) schema_query="$2"; shift ;;
      -z | --zip) zip_out=true ;;
      -q | --quiet) quiet_mode=true ;;
      *) target_dir="$1" ;; # Handle positional fallback
    esac
    shift
  done

  if [ ! -d "$target_dir" ]; then
    echo -e "${CB_RED}🚨 Error: Directory '$target_dir' not found.${C_RESET}"
    return 1
  fi

  local schemas_dir="$HOME/.bash.d/config/export/schemas"
  local schema_file=""

  # Resolve the correct schema using Python
  local py_script="
import os, yaml, sys
schemas_dir = sys.argv[1]
query = sys.argv[2].lower()
for f in os.listdir(schemas_dir):
    if not f.endswith('.yaml'): continue
    path = os.path.join(schemas_dir, f)
    try:
        with open(path, 'r') as yf:
            data = yaml.safe_load(yf)
            aliases = data.get('aliases', [])
            if query in aliases or query == data.get('name', '').lower() or query == f.split('.')[0]:
                print(path)
                sys.exit(0)
    except: pass
print('')
"
  if command -v python3 > /dev/null 2>&1; then
      schema_file=$(python3 -c "$py_script" "$schemas_dir" "$schema_query")
  fi

  if [ -z "$schema_file" ] || [ ! -f "$schema_file" ]; then
    echo -e "${CB_YELLOW}⚠️ Schema '${schema_query}' not found. Falling back to default.${C_RESET}"
    schema_file="$schemas_dir/default.yaml"
  fi

  # Extract Schema Values using yq
  local s_name="Code Export"
  local s_inc=".*"
  local s_exc=""

  if command -v yq > /dev/null 2>&1; then
    s_name=$(yq -r '.name // "Code Export"' "$schema_file")
    s_inc=$(yq -r '.include_extensions // ".*"' "$schema_file")
    s_exc=$(yq -r '.exclude_patterns // ""' "$schema_file")
  fi

  echo -e "${CB_BLUE}📦 Running: $s_name${C_RESET}"

  # Resolve centralized exports directory
  local dest_dir="${AI_WORKSPACE_DIR:-$HOME/vcs/ai-workspace}/exports"
  mkdir -p "$dest_dir"

  # Build the dynamic filename
  local safe_dir_name
  safe_dir_name=$(basename "$(realpath "$target_dir")")
  local timestamp
  timestamp=$(date +"%Y%m%d_%H%M%S")
  local base_out_name="${timestamp}_${safe_dir_name}_${schema_query}"

  local tmp_file="/tmp/mt_export_${RANDOM}.txt"
  local file_list="/tmp/mt_export_files_${RANDOM}.txt"

  # Find files, exclude global blocklist, include specified extensions
  eval "find \"$target_dir\" -type f" 2> /dev/null |
    grep -E -vi "(${EXPORT_BLOCKLIST})" |
    grep -E -i "\.(${s_inc})$" > "$file_list"

  # Optionally filter out schema-specific excluded patterns
  if [ -n "$s_exc" ] && [ "$s_exc" != "null" ] && [ "$s_exc" != '""' ]; then
    grep -E -vi "(${s_exc})" "$file_list" > "${file_list}.filtered"
    mv "${file_list}.filtered" "$file_list"
  fi

  local total_files
  total_files=$(wc -l < "$file_list")

  if [ "$total_files" -eq 0 ]; then
    echo -e "${CB_YELLOW}⚠️ No files matched the schema '${schema_query}' in ${target_dir}.${C_RESET}"
    rm -f "$file_list"
    return 0
  fi

  # === AI Context Size Protection (Killswitch) ===
  if [ "$total_files" -gt 2000 ]; then
     echo -e "${CB_RED}🚨 KILLSWITCH: $total_files files detected. Export aborted to prevent system lockup and LLM overload.${C_RESET}"
     rm -f "$file_list"
     return 1
  elif [ "$total_files" -gt 500 ]; then
     echo -e "${CB_YELLOW}⚠️ Warning: $total_files files detected. This may exceed AI context limits.${C_RESET}"
     read -r -p "Proceed anyway? [y/N] " -n 1 < /dev/tty
     echo
     if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CB_RED}🛑 Aborted.${C_RESET}"
        rm -f "$file_list"
        return 1
     fi
  fi

  echo "=== MT DevOps Export: $s_name ===" > "$tmp_file"
  echo "Generated: $(date)" >> "$tmp_file"
  echo "Directory: $(realpath "$target_dir")" >> "$tmp_file"
  echo "Schema: $schema_query" >> "$tmp_file"
  echo "-----------------------------------" >> "$tmp_file"

  # Inject the directory tree overview
  echo "Directory Tree:" >> "$tmp_file"
  if command -v tree > /dev/null 2>&1; then
    tree -a -I '.git|.dev|.vscode|.idea|node_modules|__pycache__|.terraform|venv|.venv|.mt_cache*' "$target_dir" >> "$tmp_file" 2> /dev/null
  else
    # Fallback to sed-formatted find if tree is missing
    # shellcheck disable=SC2086
    find "$target_dir" -print | grep -E -v '/(\.git|\.dev|\.vscode|\.idea|node_modules|__pycache__|\.terraform|venv|\.venv)/' | sed -e 's;[^/]*/;|____;g;s;____|; |;g' >> "$tmp_file" 2> /dev/null
  fi
  echo "-----------------------------------" >> "$tmp_file"

  # Append actual file contents
  while IFS= read -r file; do
    echo -e "\n==> $file <==" >> "$tmp_file"
    cat "$file" >> "$tmp_file" 2> /dev/null || echo "[Unreadable File]" >> "$tmp_file"
  done < "$file_list"

  local final_out=""
  if [ "$zip_out" = true ]; then
    final_out="${dest_dir}/${base_out_name}.zip"
    zip -qj "$final_out" "$tmp_file" > /dev/null 2>&1
    echo -e "${CB_GREEN}✅ Export saved to $final_out${C_RESET}"
  else
    final_out="${dest_dir}/${base_out_name}.txt"
    cp "$tmp_file" "$final_out"
    echo -e "${CB_GREEN}✅ Export saved to $final_out${C_RESET}"
  fi

  rm -f "$tmp_file" "$file_list"

  # Open GUI Explorer unless quiet mode is on
  if [ "$quiet_mode" = false ]; then
    if type __open_path_gui > /dev/null 2>&1; then
      __open_path_gui "$dest_dir" 2> /dev/null || true
    fi
  fi
}
```


### 📂 MyTools Documentation & Runner

#### `mt-aliases`
> MyTools: List all documented shell aliases

```bash
mt-aliases() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  echo -e "\n${CB_BLUE}▶ ALIASES${C_RESET}\n"
  awk -F'\t' '$1 == "alias" { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m (\033[1;33m%s\033[0m) \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $2, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv"
  echo ""
}
```

#### `mt-cat`
> MyTools: List all tools within a specific category

```bash
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

  mytools > /dev/null
  local target_cat="${1,,}"

  echo -e "\n${CB_BLUE}▶ CATEGORY: ${1}${C_RESET}\n"
  awk -F'\t' -v target="$target_cat" 'tolower($2) == target { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv"
  echo ""
}
```

#### `mt-cats`
> MyTools: List all available command categories

```bash
mt-cats() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  echo -e "\n${CB_BLUE}▶ AVAILABLE CATEGORIES${C_RESET}"
  cut -f2 "$HOME/.bash.d/data/cache/.mt_data.tsv" 2> /dev/null | sort -u | while read -r cat; do
    [ -n "$cat" ] && echo -e "  ${CB_YELLOW}[${cat}]${C_RESET}"
  done
  echo ""
}
```

#### `mt-config`
> MyTools: Display active framework configuration variables

```bash
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
  echo -e " ${CB_CYAN}AUTO_CLEANUP      ${C_RESET}: ${AUTO_CLEANUP_EXPORTS:-false} (${AUTO_CLEANUP_DAYS:-7} days)"
  echo -e "${CB_BLUE}==========================================================${C_RESET}"
}
```

#### `mt-dump`
> MyTools: Generate a detailed technical Markdown dump of all functions and aliases

```bash
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

  cat << 'HDR' > "$out_file"
# 🛠️ MT DevOps Framework - Technical Command Reference

> **Auto-generated Reference Document**  
> Generated: $(date)  
> Environment: $(uname -s) ($(uname -m))

---

HDR

  local tsv_index="$HOME/.bash.d/data/cache/.mt_data.tsv"
  mytools > /dev/null

  if [ -f "$tsv_index" ]; then
    echo "## 🔗 Shell Aliases" >> "$out_file"
    awk -F'\t' '$1 == "alias" { printf "- **`%s`** *(%s)*: %s\n", $3, $2, $4 }' "$tsv_index" >> "$out_file"
    echo -e "\n---" >> "$out_file"

    echo -e "\n## 🛠️ Public Functions\n" >> "$out_file"

    local current_cat=""
    while IFS=$'\t' read -r type cat name desc; do
      [ "$type" != "func" ] && continue

      if [ "$cat" != "$current_cat" ]; then
        current_cat="$cat"
        echo -e "\n### 📂 ${current_cat}\n" >> "$out_file"
      fi

      echo -e "#### \`$name\`" >> "$out_file"
      echo -e "> $desc\n" >> "$out_file"

      local src_file
      src_file=$(grep -rlE "^${name}\(\)[ \t]*\{" "$HOME/.bash.d/" 2> /dev/null | head -n 1)
      if [ -n "$src_file" ]; then
        echo "\`\`\`bash" >> "$out_file"
        awk -v target="$name" -f "$HOME/.bash.d/lib/awk/mt_help.awk" "$src_file" >> "$out_file"
        echo -e "\`\`\`\n" >> "$out_file"
      fi
    done < <(sort -t$'\t' -k2,2 -k3,3 "$tsv_index")
  fi

  if [ "$include_private" = true ]; then
    echo -e "\n---\n\n## 🔒 Internal Framework Helpers (Private Functions)\n" >> "$out_file"
    echo "Private functions prefixed with \`_\` or \`__\` used internally by the framework." >> "$out_file"

    find "$HOME/.bash.d" -type f -name "*.sh" -exec grep -HnE "^_{1,2}[a-zA-Z0-9_-]+\(\)[ \t]*\{" {} + | while read -r line; do
      local fpath
      fpath=$(echo "$line" | cut -d: -f1)
      local func_name
      func_name=$(echo "$line" | grep -oE "_{1,2}[a-zA-Z0-9_-]+")

      [ -z "$func_name" ] && continue
      local rel_fpath="${fpath#"$HOME"/.bash.d/}"

      echo -e "\n### \`$func_name\` *(File: \`00-system/${rel_fpath}\`)*" >> "$out_file"
      echo "\`\`\`bash" >> "$out_file"
      awk -v target="$func_name" -f "$HOME/.bash.d/lib/awk/mt_help.awk" "$fpath" >> "$out_file"
      echo -e "\`\`\`\n" >> "$out_file"
    done
  fi

  echo -e "${CB_GREEN}✅ Technical reference generated at:${C_RESET} ${out_file}"

  if type __open_path_gui > /dev/null 2>&1; then
    __open_path_gui "$export_dir" 2> /dev/null || true
  fi
}
```

#### `mt-funcs`
> MyTools: List all documented shell functions

```bash
mt-funcs() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  mytools > /dev/null
  echo -e "\n${CB_BLUE}▶ FUNCTIONS${C_RESET}\n"
  awk -F'\t' '$1 == "func" { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m (\033[1;33m%s\033[0m) \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $2, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv"
  echo ""
}
```

#### `mt-fzf`
> MyTools: Interactive fuzzy-finder to search for a command

```bash
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
> System: Print the current local version of the terminal profile

```bash
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
> MyTools: Display detailed help and source code for a command

```bash
mt-help() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    echo "Usage: mt-help <command>"
    return 0
  }
  local target="$1"
  [ -z "$target" ] && {
    echo "Usage: mt-help <command>"
    return 1
  }

  __render_help() {
    local cmd="$1"
    local fpath="$2"
    echo -e "\033[1;34m==========================================================\033[0m"
    echo -e "\033[1;36m 🛠️  ${cmd}\033[0m"
    echo -e "\033[1;34m==========================================================\033[0m"
    echo -e "\033[1;33m 📄 File: \033[0m $(wslpath -m "$fpath" 2> /dev/null || echo "$fpath")"
    echo -e "\033[1;34m----------------------------------------------------------\033[0m"
    awk -v target="$cmd" -f "$HOME/.bash.d/lib/awk/mt_help.awk" "$fpath" | "$BAT_BIN" --language=bash --style=plain 2> /dev/null ||
      awk -v target="$cmd" -f "$HOME/.bash.d/lib/awk/mt_help.awk" "$fpath"
    echo -e "\033[1;34m==========================================================\033[0m"
  }

  local file_path
  file_path=$(grep -rlE "^(alias ${target}=|${target}\(\)[ \t]*\{)" "$HOME/.bash.d/" 2> /dev/null | head -n 1)
  if [ -n "$file_path" ]; then
    __render_help "$target" "$file_path"
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
      __render_help "$single_target" "$file_path"
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

#### `mt-lookup`
> MyTools: Search through available mytools commands with tab-completion

```bash
mt-lookup() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }
  [ -z "$1" ] && {
    echo "Usage: mt-lookup <keyword|command>"
    return 1
  }
  mytools > /dev/null
  awk -F'\t' -v q="${1,,}" 'tolower($0) ~ q { printf "  \033[2;37m•\033[0m \033[1;36m%-24s\033[0m (\033[1;33m%s\033[0m) \033[2;37m→\033[0m \033[0;37m%s\033[0m\n", $3, $2, $4 }' "$HOME/.bash.d/data/cache/.mt_data.tsv"
}
```

#### `mt-refresh-caches`
> System: Forcefully clear and rebuild all background caches (.env, mytools, updates)

```bash
mt-refresh-caches() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  echo -e "${CB_YELLOW}🧹 Clearing background caches...${C_RESET}"
  rm -f "$HOME/.bash.d/config/.env.cache"
  rm -f "$HOME/.bash.d/data/cache/.mt_cache" "$HOME/.bash.d/data/cache/.mt_cache.time" "$HOME/.bash.d/data/cache/.mt_data.tsv"
  rm -f "$HOME/.bash.d/data/cache/.update_check_cache" "$HOME/.bash.d/data/cache/.update_pending"
  rm -f "$HOME/.bash.d/data/cache/.zoxide_cache.sh"
  rm -f "$HOME/.bash.d/data/cache/.profile_update_cache" "$HOME/.bash.d/data/cache/.profile_update_pending"

  echo -e "${CB_BLUE}🔄 Rebuilding configurations and tool indexes...${C_RESET}"
  if [ -f "$HOME/.bash.d/lib/python/config_manager.py" ]; then
    python3 "$HOME/.bash.d/lib/python/config_manager.py" load-env > "$HOME/.bash.d/config/.env.cache"
    chmod 600 "$HOME/.bash.d/config/.env.cache" 2> /dev/null
  fi

  __rebuild_mytools_cache

  source "$HOME/.bashrc"
  echo -e "${CB_GREEN}✅ All system caches refreshed successfully.${C_RESET}"
}
```

#### `mt-run`
> MyTools: Interactive fuzzy-finder to select and execute a command

```bash
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
> System: Display a unified health check and status dashboard

```bash
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
> MyTools: Primary runner and documentation index

```bash
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
> AI: Change directory to unified AI workspace

```bash
cd-ai-workspace() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  cd "$AI_WORKSPACE_DIR" || echo "🚨 Error: AI_WORKSPACE_DIR not set."
}
```

#### `cd-win-docker`
> Docker: Change to Docker directory (from config.yaml) and open in Windows Explorer

```bash
cd-win-docker() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local docker_path
  docker_path=$(python3 -c 'import yaml, os; print(yaml.safe_load(open(os.path.expanduser("~/.bash.d/config/config.yaml"))).get("paths", {}).get("docker_root", ""))')
  docker_path=$(eval echo "$docker_path")

  if [ -z "$docker_path" ]; then
    echo -e "${CB_RED}🚨 Error: docker_root is not defined under paths in config.yaml.${C_RESET}"
    return 1
  fi

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
> System: Open current directory in the default IDE (VSCode/IntelliJ)

```bash
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
> System: Change directory to dotfiles repository root

```bash
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
> System: Open dotfiles repository remote URL in default web browser

```bash
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
> AI: Open unified AI workspace in the platform's native file manager

```bash
win-ai-workspace() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "$AI_WORKSPACE_DIR"
}
```

#### `win-docker`
> Docker: Open Docker root directory in the platform's native file manager

```bash
win-docker() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "$DOCKER_ROOT_DIR"
}
```

#### `win-sync`
> System: Open sync repository in the platform's native file manager

```bash
win-sync() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "${DOTFILES_DIR:-$SYNC_REPO_DIR}"
}
```


### 📂 System & Environment Bootstrap

#### `bootstrap`
> System: Bootstrap missing dependencies (Debian/WSL via APT, macOS via Homebrew)

```bash
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
> System: Updates system packages and clears pending-update marker

```bash
sys-install() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  sys-update
  rm -f "$HOME/.bash.d/.update_pending"
}
```

#### `sys-update`
> System: Updates system packages (APT on Debian/WSL, Homebrew on macOS)

```bash
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
> System: Pipe output to the system clipboard (e.g. cat file | clip)

```bash
clip() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __clip_copy
}
```

#### `win`
> System: Open current directory in the platform's native file manager

```bash
win() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "$PWD"
}
```

#### `win-export`
> System: Open ~/vcs/personal/exports in the platform's native file manager

```bash
win-export() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "$VCS_EXPORTS"
}
```

#### `win-vcs`
> System: Open ~/vcs in the platform's native file manager

```bash
win-vcs() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  __open_path_gui "$VCS_ROOT"
}
```


### 📂 Terraform & AI Integrations

#### `tf-iam`
> AI: Analyze Terraform codebase for IAM requirements and optionally generate script

```bash
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
    local target_dir="${SCRIPTS_IAM_DIR:-$HOME/vcs/scripts/iam}"
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
> Terraform: Aggressively clean local caching (.terraform, locks, plans)

```bash
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
> Terraform: Replace a specific resource (Modern alternative to taint)

```bash
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
> Terraform: Execute Terraform using a YAML config file for variables

```bash
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
> Terraform: Core wrapper (preserves args)

```bash
terraform() {
  echo "+ terraform $*" >&2
  command terraform "$@"
}
```


### 📂 Version Control (Git) - AI Workflows

#### `git-ai-push-all`
> Git: Auto-format, stage, generate AI commits, and push all changes

```bash
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
> AI: Generate a comprehensive .gitignore for the active repository

```bash
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
> AI: Generate a comprehensive README.md for the active repository

```bash
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
> Git: Intercept 'clone' to automatically route repositories into ~/vcs/

```bash
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
> Git: Delete local and remote branches merged into the default branch

```bash
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
      read -r -p "Delete remote branch 'origin/$r_branch'? [y/N] " -n 1
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
> Git: Clone repository into ~/vcs/, navigate into it, and open in default IDE

```bash
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
```

#### `git-default-rebase`
> Git: Fetch upstream origin and rebase current branch onto default branch

```bash
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
> Git: Create and checkout a new feature branch

```bash
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
> Git: Hard reset local branch to upstream state and wipe untracked files

```bash
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
```

#### `git-pretty-log`
> Git: Print a clean, color-coded, single-line log graph

```bash
git-pretty-log() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all
}
```

#### `git-push-all`
> Git: Stage all files, commit with provided message, and push

```bash
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
> Git: Push current branch and raise a Pull Request (GitHub/GitLab/Bitbucket)

```bash
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
  elif [ "$pr_state" = "MERGED" ] || [ "$pr_state" = "CLOSED" ]; then
    echo -e "${CB_YELLOW}⚠️  This branch has a ${pr_state} PR (Dead Branch).${C_RESET}"
    read -r -p "Would you like to delete this branch locally and checkout a new one? [Y/n] " -n 1
    echo
    if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ] || [ -z "$REPLY" ]; then
      read -r -p "Delete the remote branch 'origin/$current_branch' as well? [Y/n] " -n 1
      echo
      if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ] || [ -z "$REPLY" ]; then
        echo -e "${CB_BLUE}🗑️  Deleting remote branch...${C_RESET}"
        git push origin --delete "$current_branch" 2> /dev/null || echo -e "${CB_YELLOW}⚠️  Remote branch already deleted or unreachable.${C_RESET}"
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
    if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ] || [ -z "$REPLY" ]; then
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
```

#### `git-view-remote`
> Git: Open current repository remote URL in default web browser

```bash
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


### 📂 Version Control (Git) - Profile Synchronization

#### `mt-download-release`
> System: Download a release zip from the remote repository

```bash
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
> System: Download and install profile updates from GitHub releases

```bash
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
    echo "$tag_name" > "$HOME/.bash.d/data/.current_version"
  else
    echo -e "${CB_RED}🚨 Error: install.sh missing from downloaded release.${C_RESET}"
  fi

  rm -rf "$tmp_dir"
}
```

#### `mt-push-update`
> System: Sync local bash configs to terminal dotfiles repo and create a Pull Request

```bash
mt-push-update() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local issue_num=""
  local run_shellcheck=false
  local OPTIND opt
  while getopts "i:s" opt; do
    case ${opt} in
      i) issue_num="$OPTARG" ;;
      s) run_shellcheck=true ;;
      \?)
        echo "Usage: mt-push-update [-i <issue_number>] [-s] [optional message]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

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

  local user_msg="$*"
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

    __git_sync_ai_docs "$repo_dir"
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

    if [ -z "$user_msg" ]; then
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

    git-raise-pr -b "$default_branch" -t "$pr_title" -m "$(echo -e "$pr_body")"
  ) || return 1
}
```

