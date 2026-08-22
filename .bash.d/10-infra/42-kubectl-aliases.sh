# shellcheck shell=bash
# ------------------------------------------
# Container Orchestration (Kubernetes) Aliases
# ------------------------------------------
# ~/.bash.d/10-infra/42-kubectl-aliases.sh

#######################################
# Kubernetes: Core Kubectl Wrapper
#######################################
alias k='kubectl'

#######################################
# Kubernetes: Apply configuration from file
#######################################
alias ka='kubectl apply -f'

#######################################
# Kubernetes: Apply configuration using Kustomize
#######################################
alias kak='kubectl apply -k'

#######################################
# Kubernetes: Delete resources by name
#######################################
alias krm='kubectl delete'

#######################################
# Kubernetes: Delete resources from file
#######################################
alias krmf='kubectl delete -f'

#######################################
# Kubernetes: Get resources
#######################################
alias kg='kubectl get'

#######################################
# Kubernetes: Get resources across all namespaces
#######################################
alias kgall='kubectl get --all-namespaces'

#######################################
# Kubernetes: Describe resources
#######################################
alias kd='kubectl describe'

#######################################
# Kubernetes: Get pods
#######################################
alias kgpo='kubectl get pods'

#######################################
# Kubernetes: Describe pods
#######################################
alias kdpo='kubectl describe pods'

#######################################
# Kubernetes: Delete pods
#######################################
alias krmpo='kubectl delete pods'

#######################################
# Kubernetes: Get deployments
#######################################
alias kgdep='kubectl get deployment'

#######################################
# Kubernetes: Describe deployments
#######################################
alias kddep='kubectl describe deployment'

#######################################
# Kubernetes: Delete deployments
#######################################
alias krmdep='kubectl delete deployment'

#######################################
# Kubernetes: Get statefulsets
#######################################
alias kgsts='kubectl get statefulset'

#######################################
# Kubernetes: Describe statefulsets
#######################################
alias kdsts='kubectl describe statefulset'

#######################################
# Kubernetes: Get services
#######################################
alias kgsvc='kubectl get service'

#######################################
# Kubernetes: Describe services
#######################################
alias kdsvc='kubectl describe service'

#######################################
# Kubernetes: Get ingresses
#######################################
alias kging='kubectl get ingress'

#######################################
# Kubernetes: Describe ingresses
#######################################
alias kding='kubectl describe ingress'

#######################################
# Kubernetes: Get configmaps
#######################################
alias kgcm='kubectl get configmap'

#######################################
# Kubernetes: Describe configmaps
#######################################
alias kdcm='kubectl describe configmap'

#######################################
# Kubernetes: Get secrets
#######################################
alias kgsec='kubectl get secret'

#######################################
# Kubernetes: Describe secrets
#######################################
alias kdsec='kubectl describe secret'

#######################################
# Kubernetes: Get nodes
#######################################
alias kgno='kubectl get nodes'

#######################################
# Kubernetes: Describe nodes
#######################################
alias kdno='kubectl describe nodes'

#######################################
# Kubernetes: Get namespaces
#######################################
alias kgns='kubectl get namespaces'

#######################################
# Kubernetes: Tail logs for a pod
#######################################
alias klo='kubectl logs -f'

#######################################
# Kubernetes: Tail logs for a previous instance of a pod
#######################################
alias klop='kubectl logs -f -p'

#######################################
# Kubernetes: Exec into a pod interactively
#######################################
alias kex='kubectl exec -i -t'

#######################################
# Kubernetes: Port forward to a pod or service
#######################################
alias kpf='kubectl port-forward'

#######################################
# Kubernetes: Shortcut for the kube-system namespace
#######################################
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
  mapfile -t COMPREPLY < <(compgen -W "$(kubectl get namespaces -o=jsonpath='{.items[*].metadata.name}' 2> /dev/null)" -- "${COMP_WORDS[COMP_CWORD]}")
}
complete -F _kns_completions kns
