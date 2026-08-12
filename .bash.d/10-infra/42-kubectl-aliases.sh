# shellcheck shell=bash
# ------------------------------------------
# Container Orchestration (Kubernetes)
# ------------------------------------------

# Core Kubectl Wrapper
alias k='kubectl'

# Apply & Delete
alias ka='kubectl apply -f'
alias kak='kubectl apply -k'
alias krm='kubectl delete'
alias krmf='kubectl delete -f'

# Get & Describe Base
alias kg='kubectl get'
alias kgall='kubectl get --all-namespaces'
alias kd='kubectl describe'

# Pods
alias kgpo='kubectl get pods'
alias kdpo='kubectl describe pods'
alias krmpo='kubectl delete pods'

# Deployments & StatefulSets
alias kgdep='kubectl get deployment'
alias kddep='kubectl describe deployment'
alias krmdep='kubectl delete deployment'
alias kgsts='kubectl get statefulset'
alias kdsts='kubectl describe statefulset'

# Services & Ingress
alias kgsvc='kubectl get service'
alias kdsvc='kubectl describe service'
alias kging='kubectl get ingress'
alias kding='kubectl describe ingress'

# ConfigMaps & Secrets
alias kgcm='kubectl get configmap'
alias kdcm='kubectl describe configmap'
alias kgsec='kubectl get secret'
alias kdsec='kubectl describe secret'

# Nodes & Namespaces
alias kgno='kubectl get nodes'
alias kdno='kubectl describe nodes'
alias kgns='kubectl get namespaces'

# Troubleshooting & Exec
alias klo='kubectl logs -f'
alias klop='kubectl logs -f -p'
alias kex='kubectl exec -i -t'
alias kpf='kubectl port-forward'

# Kube-System shortcut
alias ksys='kubectl --namespace=kube-system'

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

_kns_completions() {
  COMPREPLY=($(compgen -W "$(kubectl get namespaces -o=jsonpath='{.items[*].metadata.name}' 2> /dev/null)" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _kns_completions kns
