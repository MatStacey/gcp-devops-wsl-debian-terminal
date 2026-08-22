# shellcheck shell=bash
# ------------------------------------------
# Terraform Aliases
# ------------------------------------------
# ~/.bash.d/10-infra/41-terraform-aliases.sh

#######################################
# Terraform: Core Execution
#######################################
alias tf='terraform'

#######################################
# Terraform: Apply changes
#######################################
alias tfa='terraform apply'

#######################################
# Terraform: Apply changes (Auto-Approve)
#######################################
alias tfay='terraform apply -auto-approve'

#######################################
# Terraform: Open interactive console
#######################################
alias tfc='terraform console'

#######################################
# Terraform: Destroy infrastructure
#######################################
alias tfd='terraform destroy'

#######################################
# Terraform: Destroy infrastructure (Auto-Approve)
#######################################
alias tfdy='terraform destroy -auto-approve'

#######################################
# Terraform: Initialize working directory
#######################################
alias tfin='terraform init'

#######################################
# Terraform: Initialize and upgrade modules/providers
#######################################
alias tfinu='terraform init -upgrade'

#######################################
# Terraform: Read outputs from state
#######################################
alias tfo='terraform output'

#######################################
# Terraform: Generate execution plan
#######################################
alias tfp='terraform plan'

#######################################
# Terraform: Generate destruction plan
#######################################
alias tfpd='terraform plan -destroy'

#######################################
# Terraform: Validate configuration files
#######################################
alias tfv='terraform validate'

#######################################
# Terraform: Format all files recursively
#######################################
alias tff='terraform fmt -recursive'

#######################################
# Terraform: Generate a saved plan file (tfplan)
#######################################
alias tfpo='terraform plan -out=tfplan'

#######################################
# Terraform: Apply the saved plan file
#######################################
alias tfap='terraform apply tfplan'

#######################################
# Terraform: Refresh state without applying changes (Modern)
#######################################
alias tf-refresh='terraform apply -refresh-only'

#######################################
# Terraform: State management commands
#######################################
alias tfs='terraform state'

#######################################
# Terraform: Show current state or plan
#######################################
alias tfsh='terraform show'

#######################################
# Terraform: List resources in state
#######################################
alias tfsls='terraform state list'

#######################################
# Terraform: Move an item in state
#######################################
alias tfsmv='terraform state mv'

#######################################
# Terraform: Remove an item from state
#######################################
alias tfsrm='terraform state rm'

#######################################
# Terraform: Show a single resource in state
#######################################
alias tfssw='terraform state show'

#######################################
# Terraform: Workspace management commands
#######################################
alias tfw='terraform workspace'

#######################################
# Terraform: Delete a workspace
#######################################
alias tfwde='terraform workspace delete'

#######################################
# Terraform: List workspaces
#######################################
alias tfwls='terraform workspace list'

#######################################
# Terraform: Create a new workspace
#######################################
alias tfwnw='terraform workspace new'

#######################################
# Terraform: Select an existing workspace
#######################################
alias tfwst='terraform workspace select'

#######################################
# Terraform: Show the current workspace name
#######################################
alias tfwsw='terraform workspace show'

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

#######################################
# Terraform: Aggressively clean local caching (.terraform, locks, plans)
#######################################
tf-clean() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  echo -e "${CB_RED}⚠️ WARNING: This will delete .terraform directories, lock files, and saved plans.${C_RESET}"
  read -r -p "Are you sure you want to proceed? [y/N] " -n 1 < /dev/tty || REPLY="n"
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

#######################################
# Terraform: Shortcut alias for tf-yaml
#######################################
alias tfy='tf-yaml'
