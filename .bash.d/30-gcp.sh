# ================================================================================#
#                                                                                 #
#                                   ALIASES                                       #
#                                                                                 #
# ================================================================================#

# ------------------------------------------
# Project
# ------------------------------------------
alias gccp="gc-set-project"                            # => GCP: Legacy shortcut to set project

# ------------------------------------------
# GCE
# ------------------------------------------
alias gc-vms='gcloud compute instances list'           # => Compute: List all VM instances
alias gc-ssh='gcloud compute ssh'                      # => Compute: SSH into an instance [Usage: gc-ssh <vm-name>]

# ------------------------------------------
# GCS
# ------------------------------------------
alias gcs-ls='gcloud storage ls'                       # => GCS: List buckets or contents [Usage: gcs-ls gs://bucket]

# ------------------------------------------
# List Resources
# ------------------------------------------
alias gc-iam-ls='gcloud iam service-accounts list'     # => IAM: List service accounts in active project
alias gcf-ls='gcloud functions list'                   # => Functions: List Cloud Run Functions
alias gc-ps-topics='gcloud pubsub topics list'         # => PubSub: List topics
alias gc-ps-subs='gcloud pubsub subscriptions list'    # => PubSub: List subscriptions
alias bq-ls='bq ls'                                    # => BigQuery: List datasets in project
alias gc-ar-ls='gcloud artifacts repositories list'    # => Artifacts: List Artifact Registry repos

# ================================================================================#
#                                                                                 #
#                                   FUNCTIONS                                     #
#                                                                                 #
# ================================================================================#

# ------------------------------------------
# GCloud Update
# ------------------------------------------
gc-update() { # => GCP: Update Google Cloud CLI tools
    echo "Checking for Google Cloud CLI updates..."
    if command -v apt-get >/dev/null && dpkg -l | grep -q "google-cloud-cli"; then
        sudo apt-get update && sudo apt-get install --only-upgrade google-cloud-cli
    else
        gcloud components update
    fi
}

# ------------------------------------------
# Auth
# ------------------------------------------
gc-login() { # => GCP: Login to user & application default
    gcloud auth login && gcloud auth application-default login
}
gc-login-adc() { # => GCP: Login to application default only
    gcloud auth application-default login
}

# ------------------------------------------
# Project Switching
# ------------------------------------------
gc-set-project() { # => GCP: Switch active project [Usage: gc-set-project <project_id>]
    gcloud config set project "$1"
}

gc-switch() { # => GCP: Interactive fuzzy project switcher using fzf
    local project
    project=$(gcloud projects list --format="value(projectId)" | fzf --prompt="Select GCP Project > ")
    [ -n "$project" ] && gc-set-project "$project"
}

# ------------------------------------------
# IAM
# ------------------------------------------
gc-iam-policy() { # => IAM: View IAM policy for active project
    gcloud projects get-iam-policy "$(gc-get-project)" --format="table(bindings.role, bindings.members)"
}

# ------------------------------------------
# Secret Manager
# ------------------------------------------
gc-secret-read() { # => Secrets: Read latest payload of a secret [Usage: gc-secret-read <secret-name>]
    gcloud secrets versions access latest --secret="$1"
}

# ------------------------------------------
# Logging
# ------------------------------------------
gcf-logs() { # => Functions: Tail last 50 logs of a function [Usage: gcf-logs <func-name>]
    gcloud functions logs read "$1" --limit=50
}

# ------------------------------------------
# BigQuery
# ------------------------------------------
bq-query() { # => BigQuery: Run standard SQL query [Usage: bq-query "SELECT..."]
    bq query --use_legacy_sql=false "$1"
}

# ------------------------------------------
# Artifact Registry
# ------------------------------------------
gc-ar-docker() { # => Artifacts: Configure Docker auth [Usage: gc-ar-docker <region>]
    gcloud auth configure-docker "$1-docker.pkg.dev"
}
gc-ps-pull() { # => PubSub: Pull and auto-ack one message [Usage: gc-ps-pull <sub-name>]
    gcloud pubsub subscriptions pull "$1" --auto-ack --limit=1
}

# ------------------------------------------
# Output Format
# ------------------------------------------
gc-json() { # => Run gcloud command and output as formatted JSON
    gcloud "$@" --format="json" | jq '.'
}

# ------------------------------------------
# Native Config Parsing (Zero-Subshell)
# ------------------------------------------
__get_gcp_config_val() { # => Internal helper to read gcloud config files directly
    local target_key="$1"
    local gcp_active="default"
    
    # Determine the active configuration name
    if [ -f "$HOME/.config/gcloud/active_config" ]; then
        read -r gcp_active < "$HOME/.config/gcloud/active_config"
    fi
    
    local gcp_config_file="$HOME/.config/gcloud/configurations/config_${gcp_active}"
    
    # Parse the config file line-by-line natively in Bash
    if [ -f "$gcp_config_file" ]; then
        while read -r key equal val; do
            if [ "$key" = "$target_key" ]; then
                echo "$val"
                return 0
            fi
        done < "$gcp_config_file"
    fi
    return 1
}

# ------------------------------------------
# Get Config Details
# ------------------------------------------
gc-get-user() { # => GCP: Print active user account
    __get_gcp_config_val "account"
}

gc-get-project() { # => GCP: Print active project ID
    __get_gcp_config_val "project"
}

gc-get-region() { # => GCP: Print active compute region
    __get_gcp_config_val "region"
}

gc-get-zone() { # => GCP: Print active compute zone
    __get_gcp_config_val "zone"
}

gc-get-project-number() { # => GCP: Print active project Number (API call required)
    local project_id
    project_id=$(gc-get-project)
    [ -n "$project_id" ] && gcloud projects describe "$project_id" --format="value(projectNumber)"
}

gc-config() { # => GCP: List active configuration properties
    gcloud config list "$@"
}

gc-org-policies() { # => GCP: List org policies for active project
    local project_id
    project_id=$(gc-get-project)
    [ -n "$project_id" ] && gcloud alpha resource-manager org-policies list --project="$project_id"
}

# ------------------------------------------
# ENV Variables
# ------------------------------------------
gc-export-vars() { # => GCP: Export PROJECT_ID and PROJECT_NUMBER env vars to shell
    export PROJECT_ID=$(gc-get-project)
    
    if [ -n "$PROJECT_ID" ]; then
        # Project number still requires an API call as it is not cached locally
        export PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format='value(projectNumber)')
        echo "✅ Exported PROJECT_ID=${PROJECT_ID} and PROJECT_NUMBER=${PROJECT_NUMBER}"
    else
        echo "🚨 Error: Could not determine active project ID from local config."
    fi
}

# ------------------------------------------
# Autocomplete
# ------------------------------------------
_gc_set_project_completions() { COMPREPLY=( $(compgen -W "$(gcloud projects list --format="value(projectId)" 2>/dev/null)" -- "${COMP_WORDS[COMP_CWORD]}") ); }
complete -F _gc_set_project_completions gc-set-project gccp

_gc_secret_read_completions() { COMPREPLY=( $(compgen -W "$(gcloud secrets list --format="value(name)" 2>/dev/null)" -- "${COMP_WORDS[COMP_CWORD]}") ); }
complete -F _gc_secret_read_completions gc-secret-read

_gc_ssh_completions() { COMPREPLY=( $(compgen -W "$(gcloud compute instances list --format="value(name)" 2>/dev/null)" -- "${COMP_WORDS[COMP_CWORD]}") ); }
complete -F _gc_ssh_completions gc-ssh

_gcf_logs_completions() { COMPREPLY=( $(compgen -W "$(gcloud functions list --format="value(name)" 2>/dev/null)" -- "${COMP_WORDS[COMP_CWORD]}") ); }
complete -F _gcf_logs_completions gcf-logs