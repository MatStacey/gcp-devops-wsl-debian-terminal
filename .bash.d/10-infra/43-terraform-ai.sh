# ~/.bash.d/10-infra/43-terraform-ai.sh

#######################################
# Terraform: Ask AI to list required Service Accounts and least-privilege roles
# Arguments:
#   tf-iam [-g
#######################################
tf-iam() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local generate_script=false
  local override_ai=""

  local OPTIND opt
  while getopts "gm:" opt; do
    case ${opt} in
      g) generate_script=true ;;
      m) override_ai="-m $OPTARG" ;;
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

  local prompt="Analyze the local Terraform configuration context provided. "
  prompt+="Because I must create all GCP Service Accounts and assign roles outside of Terraform as a pre-requisite, identify all required Google Cloud Platform service accounts and their least-privilege role requirements needed to provision this infrastructure. "
  prompt+="Adhere strictly to the rule of least-privilege, avoiding custom roles. "
  prompt+="If there are absolutely no IAM requirements, your message MUST strictly evaluate to 'No IAM implementations required'. "

  if [ "$generate_script" = true ]; then
    local target_dir="${SCRIPTS_IAM_DIR:-$HOME/vcs/scripts/iam}"
    mkdir -p "$target_dir"
    local target_script="${target_dir}/${repo_name}.sh"

    prompt+="Generate a production-ready bash script containing the gcloud commands to create these service accounts and assign the required roles. "
    prompt+="Output the script strictly as code. Ensure the script is DRY."

    echo "🤖 Analyzing Terraform codebase and generating IAM provisioning script..."
    ai $override_ai -e -t "${repo_name}-iam-provisioning" -o "$target_script" "$prompt"
  else
    prompt+="Output the result as a copy-pastable comma-separated list of roles in 'roles/<role>' format for each service account, with the service account name as the header. Output this as a chat message, not a code block."
    echo "🤖 Analyzing Terraform codebase for IAM requirements..."
    ai $override_ai -e "$prompt"
  fi
}
