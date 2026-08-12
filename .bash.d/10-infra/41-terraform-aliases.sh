# ------------------------------------------
# Terraform
# ------------------------------------------

# Core Execution
alias tf='terraform'
alias tfa='terraform apply'
alias tfay='terraform apply -auto-approve'
alias tfc='terraform console'
alias tfd='terraform destroy'
alias tfdy='terraform destroy -auto-approve'
alias tfin='terraform init'
alias tfinu='terraform init -upgrade'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfpd='terraform plan -destroy'
alias tfv='terraform validate'

# Formatting (Recursive by default)
alias tff='terraform fmt -recursive'

# File-based Plan Workflow
alias tfpo='terraform plan -out=tfplan'
alias tfap='terraform apply tfplan'

# Modern Terraform Paradigms
alias tf-refresh='terraform apply -refresh-only'

# State Management
alias tfs='terraform state'
alias tfsh='terraform show'
alias tfsls='terraform state list'
alias tfsmv='terraform state mv'
alias tfsrm='terraform state rm'
alias tfssw='terraform state show'

# Workspace Management
alias tfw='terraform workspace'
alias tfwde='terraform workspace delete'
alias tfwls='terraform workspace list'
alias tfwnw='terraform workspace new'
alias tfwst='terraform workspace select'
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
  echo "🧹 Cleaning local Terraform caches..."
  find . -type d -name ".terraform" -exec rm -rf {} + 2> /dev/null
  find . -type f -name ".terraform.lock.hcl" -delete 2> /dev/null
  find . -type f -name "tfplan" -delete 2> /dev/null
  echo -e "${CB_GREEN}✅ Clean complete. Run 'tfin' to reinitialize.${C_RESET}"
}

#######################################
# Terraform: Wrapper to execute Terraform using a YAML config file for variables
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
  # If the next argument is not a known TF command or a flag, treat it as the environment key
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

    local tmp_globals=$(mktemp)
    local tmp_env=$(mktemp)

    # 1. Isolate global configurations (ignoring environments)
    yq 'del(.environments)' "$yaml_file" > "$tmp_globals"

    # 2. Extract specific environment configurations
    yq ".environments["${env_name}"]" "$yaml_file" > "$tmp_env"

    if [ "$(cat "$tmp_env")" = "null" ]; then
      echo -e "${CB_RED}🚨 Error: Environment '${env_name}' not found in ${yaml_file}.${C_RESET}"
      rm -f "$tmp_vars" "$tmp_globals" "$tmp_env"
      return 1
    fi

    # 3. Deep merge the globals and the environment together and convert to JSON
    yq -o=json eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "$tmp_globals" "$tmp_env" > "$tmp_vars"
    rm -f "$tmp_globals" "$tmp_env"
  else
    echo -e "${CB_BLUE}🔄 Parsing variables from ${yaml_file}...${C_RESET}"
    yq -o=json '.' "$yaml_file" > "$tmp_vars"
  fi

  echo -e "${CB_GREEN}🚀 Executing: terraform $* -var-file=...${C_RESET}"
  terraform "$@" -var-file="$tmp_vars"
  local tf_exit=$?

  # Cleanup temporary json payload
  rm -f "$tmp_vars"

  return $tf_exit
}

# Shortcut alias for tf-yaml
alias tfy='tf-yaml'
