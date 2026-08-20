# shellcheck shell=bash
# ------------------------------------------
# GCP: Resources & Services
# ------------------------------------------
# ~/.bash.d/10-infra/31-gcp-services.sh

#######################################
# GCP: Compute - List all VM instances
#######################################
alias gce-ls='gcloud compute instances list'

#######################################
# GCP: Compute - SSH into an instance
# Usage: gce-ssh <vm-name>
#######################################
alias gce-ssh='gcloud compute ssh'

#######################################
# GCP: Cloud Storage - List buckets or contents
# Usage: gcs-ls gs://bucket
#######################################
alias gcs-ls='gcloud storage ls'

#######################################
# GCP: BigQuery - List datasets in project
#######################################
alias bq-ls='bq ls'

#######################################
# GCP: Artifact Registry - List repositories
#######################################
alias gcl-gar-ls='gcloud artifacts repositories list'

#######################################
# GCP: IAM - List service accounts in active project
#######################################
alias gcl-iam-ls='gcloud iam service-accounts list'

#######################################
# GCP: PubSub - List subscriptions
#######################################
alias gcl-ps-subs='gcloud pubsub subscriptions list'

#######################################
# GCP: PubSub - List topics
#######################################
alias gcl-ps-topics='gcloud pubsub topics list'

#######################################
# GCP: Cloud Run Functions - List functions
#######################################
alias gcp-crf-ls='gcloud functions list'

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

#######################################
# GCP: Autocompletion for gcp-get-secret
#######################################
_gcp_sec_read_completions() {
  COMPREPLY=($(compgen -W "$(gcloud secrets list --format="value(name)" 2> /dev/null)" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _gcp_sec_read_completions gcp-get-secret

#######################################
# GCP: Autocompletion for gce-ssh
#######################################
_gce_ssh_completions() {
  COMPREPLY=($(compgen -W "$(gcloud compute instances list --format="value(name)" 2> /dev/null)" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _gce_ssh_completions gce-ssh

#######################################
# GCP: Autocompletion for gcp-crf-logs
#######################################
_gcp_crf_logs_completions() {
  COMPREPLY=($(compgen -W "$(gcloud functions list --format="value(name)" 2> /dev/null)" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _gcp_crf_logs_completions gcp-crf-logs
