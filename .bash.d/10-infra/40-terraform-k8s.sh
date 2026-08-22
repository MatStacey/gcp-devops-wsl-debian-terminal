# shellcheck shell=bash
# ------------------------------------------
# Terraform & Kubernetes Wrappers
# ------------------------------------------
# ~/.bash.d/10-infra/40-terraform-k8s.sh

#######################################
# Terraform: Scan local terraform directory (./terraform) with Checkov
#######################################
alias tf-scan='checkov -d terraform/ --framework terraform --quiet'

#######################################
# Terraform: Core wrapper (preserves args)
# Note: Does NOT intercept --help to preserve native terraform help.
# Run `mt-help terraform` for framework documentation.
#######################################
terraform() {
  echo "+ terraform $*" >&2
  command terraform "$@"
}

# ------------------------------------------
# Container Orchestration
# ------------------------------------------

#######################################
# Kubernetes: Core kubectl wrapper (preserves args)
# Note: Does NOT intercept --help to preserve native kubectl help.
# Run `mt-help kubectl` for framework documentation.
#######################################
kubectl() {
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

# Bypass the custom kubectl wrapper when generating completions to prevent terminal echo.
# Cached: spawning `kubectl completion bash` fresh costs ~25ms every shell
# start, but its output only changes when the kubectl binary itself is
# upgraded, so generate it once and source the cached copy (same pattern as
# the zoxide cache in 02-utilities/20-aliases.sh).
if command -v kubectl > /dev/null 2>&1; then
  KUBECTL_COMPLETION_CACHE="$HOME/.bash.d/data/cache/.kubectl_completion.bash"
  if [ ! -f "$KUBECTL_COMPLETION_CACHE" ]; then
    mkdir -p "$HOME/.bash.d/data/cache"
    command kubectl completion bash > "$KUBECTL_COMPLETION_CACHE" 2> /dev/null
  fi
  # shellcheck disable=SC1090
  source "$KUBECTL_COMPLETION_CACHE"
fi
if command -v terraform > /dev/null 2>&1; then complete -C "$(which terraform)" terraform; fi
