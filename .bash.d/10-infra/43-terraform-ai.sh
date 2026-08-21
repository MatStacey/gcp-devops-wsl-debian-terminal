# shellcheck shell=bash
# ------------------------------------------
# Terraform & AI Integrations
# ------------------------------------------
# ~/.bash.d/10-infra/43-terraform-ai.sh

#######################################
# AI: Analyze Terraform codebase for IAM requirements and optionally generate script
# Usage: tf-iam [-g] [-m model]
# Options:
#   -g            Generate a provisioning script instead of just outputting a chat analysis
#   -m <model>    Override the default AI model (e.g., gemini, claude)
#   -h, --help    Show this help menu
#######################################
tf-iam() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local generate_script=false
  local override_ai=()

  local OPTIND opt
  while getopts "gm:" opt; do
    case ${opt} in
      g) generate_script=true ;;
      m) override_ai=("-m" "$OPTARG") ;;
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

  local prompt
  prompt=$(__get_prompt "tf_iam_base")

  if [ "$generate_script" = true ]; then
    local target_dir="${SCRIPTS_IAM_DIR:-/tmp/scripts/iam}"
    mkdir -p "$target_dir"
    local target_script="${target_dir}/${repo_name}.sh"

    local script_prompt
    script_prompt=$(__get_prompt "tf_iam_script")
    prompt="${prompt}\n\n${script_prompt}"

    echo "🤖 Analyzing Terraform codebase and generating IAM provisioning script..."
    ai "${override_ai[@]}" -e -t "${repo_name}-iam-provisioning" -o "$target_script" "$prompt"
  else
    local chat_prompt
    chat_prompt=$(__get_prompt "tf_iam_chat")
    prompt="${prompt}\n\n${chat_prompt}"
    echo "🤖 Analyzing Terraform codebase for IAM requirements..."
    ai "${override_ai[@]}" -e "$prompt"
  fi
}
