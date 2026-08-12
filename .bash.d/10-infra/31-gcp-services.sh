# shellcheck shell=bash
# ------------------------------------------
# GCP: Resources & Services
# ------------------------------------------

#######################################
# Compute: List all VM instances
#######################################
alias gce-ls='gcloud compute instances list'
#######################################
# Compute: SSH into an instance
# Arguments:
#   gce-ssh <vm-name>
#######################################
alias gce-ssh='gcloud compute ssh'
#######################################
# GCS: List buckets or contents
# Arguments:
#   gcs-ls gs://bucket
#######################################
alias gcs-ls='gcloud storage ls'
#######################################
# BigQuery: List datasets in project
#######################################
alias bq-ls='bq ls'
#######################################
# Artifacts: List Artifact Registry repos
#######################################
alias gcl-gar-ls='gcloud artifacts repositories list'
#######################################
# IAM: List service accounts in active project
#######################################
alias gcl-iam-ls='gcloud iam service-accounts list'
#######################################
# PubSub: List subscriptions
#######################################
alias gcl-ps-subs='gcloud pubsub subscriptions list'
#######################################
# PubSub: List topics
#######################################
alias gcl-ps-topics='gcloud pubsub topics list'
#######################################
# Functions: List Cloud Run Functions
#######################################
alias gcp-crf-ls='gcloud functions list'

#######################################
# IAM: View IAM policy for active project
#######################################
gcp-iam-show() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud projects get-iam-policy "$(gcl-get-project)" --format="table(bindings.role, bindings.members)"
}

#######################################
# Secrets: Read latest payload of a secret
# Arguments:
#   gcp-get-secret <secret-name>
#######################################
gcp-get-secret() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud secrets versions access latest --secret="$1"
}

#######################################
# Functions: Tail logs of a function
# Arguments:
#   gcp-crf-logs <func-name> [limit
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

#######################################
# BigQuery: Run standard SQL query
# Arguments:
#   bq-query "SELECT..."
#######################################
bq-query() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  bq query --use_legacy_sql=false "$1"
}

#######################################
# Artifacts: Configure Docker auth
# Arguments:
#   gcp-gar-docker <region>
#######################################
gcp-gar-docker() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud auth configure-docker "$1-docker.pkg.dev"
}

#######################################
# PubSub: Pull and auto-ack one message
# Arguments:
#   gcp-ps-pull <sub-name>
#######################################
gcp-ps-pull() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud pubsub subscriptions pull "$1" --auto-ack --limit=1
}

#######################################
# Run gcloud command and output as formatted JSON
#######################################
gcl-as-json() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  gcloud "$@" --format="json" | jq '.'
}

_gcp_sec_read_completions() {
  COMPREPLY=($(compgen -W "$(gcloud secrets list --format="value(name)" 2> /dev/null)" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _gcp_sec_read_completions gcp-get-secret

_gce_ssh_completions() {
  COMPREPLY=($(compgen -W "$(gcloud compute instances list --format="value(name)" 2> /dev/null)" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _gce_ssh_completions gce-ssh

_gcp_crf_logs_completions() {
  COMPREPLY=($(compgen -W "$(gcloud functions list --format="value(name)" 2> /dev/null)" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _gcp_crf_logs_completions gcp-crf-logs
