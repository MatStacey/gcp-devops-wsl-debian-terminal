# ------------------------------------------
# Terraform & Kubernetes Wrappers
# ------------------------------------------

#######################################
# Checkov: Scan local terraform directory (./terraform)
#######################################
alias tf-scan='checkov -d terraform/ --framework terraform --quiet'

#######################################
# Terraform wrapper (preserves args)
#######################################
terraform() {
  # Deliberately does NOT intercept -h/--help here (unlike other mytools
  # wrappers) — this wraps a real command with its own --help. Use
  # `mt-help terraform` for the custom doc block instead.
  echo "+ terraform $*" >&2
  command terraform "$@"
}

# ------------------------------------------
# Container Orchestration
# ------------------------------------------
#######################################
# Kubectl wrapper (preserves args)
#######################################
kubectl() {
  # Deliberately does NOT intercept -h/--help here — see terraform() above.
  echo "+ kubectl $*" >&2
  command kubectl "$@"
}

# ------------------------------------------
# Infrastructure as Code
# ------------------------------------------
#######################################
# Terraform: Recursively validate and scan all Terraform directories
#######################################
tf-val-all() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local threads="${MAX_PARALLEL_THREADS:-8}"

  find terraform/ -type f -name "*.tf" -exec dirname {} \; | sort -u | xargs -I {} -P "$threads" bash -c '
        echo -e "\n🔍 Validating {}..."
        terraform -chdir="{}" init -backend=false > /dev/null 2>&1
        if terraform -chdir="{}" validate; then
            echo -e "🛡️ Scanning {} with Checkov..."
            checkov -d "{}" --framework terraform --quiet
        else
            echo -e "🚨 Validation failed for {}"
        fi
    '
}

# Bypass the custom kubectl wrapper when generating completions to prevent terminal echo
if command -v kubectl > /dev/null 2>&1; then source <(command kubectl completion bash); fi
if command -v terraform > /dev/null 2>&1; then complete -C "$(which terraform)" terraform; fi
