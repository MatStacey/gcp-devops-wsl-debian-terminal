# shellcheck shell=bash
# ------------------------------------------
# System: Interactive Master Menu
# ------------------------------------------
# ~/.bash.d/03-mytools/09-menu.sh

#######################################
# System: Generic fzf submenu loop -- shows a numbered list of labeled
# actions, runs the selected one, and redisplays the same list until the
# user backs out (empty selection or the trailing "Back" entry)
# Arguments:
#   $1   - Submenu title, shown as the fzf prompt
#   $@   - Remaining args: alternating "label" "command" pairs. Each
#          command is a single already-defined command/function name
#          (no inline arguments) -- anything needing flags or prompted
#          input should be wrapped in its own tiny __mt_menu_* function
#          first, matching the pattern used elsewhere in this file.
#######################################
__mt_menu_submenu() {
  local title="$1"
  shift
  local -a labels=() commands=()
  while [ "$#" -gt 0 ]; do
    labels+=("$1")
    commands+=("$2")
    shift 2
  done
  local back_idx=$((${#labels[@]} + 1))

  while true; do
    local -a options=()
    local i
    for i in "${!labels[@]}"; do
      options+=("$((i + 1)). ${labels[$i]}")
    done
    options+=("${back_idx}. ⬅  Back")

    local choice
    choice=$(printf '%s\n' "${options[@]}" | fzf --prompt="${title} > " --height=~15 --layout=reverse --border)
    [ -z "$choice" ] && return 0

    local idx="${choice%%.*}"
    [ "$idx" -eq "$back_idx" ] && return 0

    "${commands[$((idx - 1))]}"

    echo -e "\n${C_DIM}Press Enter to continue...${C_RESET}"
    read -r < /dev/tty
  done
}

#######################################
# System: Prompt for a target path and copy it to the clipboard, since
# mt-copy itself takes a positional argument rather than prompting
#######################################
__mt_menu_copy_prompt() {
  local target
  read -r -p "Target path to copy [.]: " target < /dev/tty
  mt-copy "${target:-.}"
}

#######################################
# System: fzf-pick an installed theme and apply it via mt-set-theme
#######################################
__mt_menu_pick_theme() {
  local theme
  theme=$(find "$HOME/.bash.d/config/themes" -maxdepth 1 -name "*.sh" -exec basename {} .sh \; | fzf --prompt="🎨 Select Theme > " --height=~10 --layout=reverse --border)
  if [ -z "$theme" ]; then
    echo -e "${CB_YELLOW}⚠️  Theme selection cancelled.${C_RESET}"
    return 0
  fi
  mt-set-theme "$theme"
}

__mt_menu_export_interactive() { mt-export -i; }
__mt_menu_search_interactive() { mt-search -i; }
__mt_menu_list_func() { mt-list --func; }
__mt_menu_list_alias() { mt-list --alias; }

#######################################
# System: "Setup & Config" submenu
#######################################
__mt_menu_setup() {
  __mt_menu_submenu "⚙️  Setup & Config" \
    "System Configuration (mt-wizard-system)" mt-wizard-system \
    "AI Provider Configuration (mt-wizard-ai)" mt-wizard-ai \
    "Git Configuration (mt-wizard-git)" mt-wizard-git
}

#######################################
# System: "Code Exports" submenu
#######################################
__mt_menu_exports() {
  __mt_menu_submenu "📦 Code Exports" \
    "Interactive Export (mt-export -i)" __mt_menu_export_interactive \
    "Copy to Clipboard (mt-copy)" __mt_menu_copy_prompt
}

#######################################
# System: "Terminal UI" submenu
#######################################
__mt_menu_ui() {
  __mt_menu_submenu "🎨 Terminal UI" \
    "Change Theme (mt-set-theme)" __mt_menu_pick_theme \
    "Gemini Status (mt-get-gemini-status)" mt-get-gemini-status
}

#######################################
# System: "Search & Docs" submenu
#######################################
__mt_menu_docs() {
  __mt_menu_submenu "🔍 Search & Docs" \
    "Search Commands (mt-search -i)" __mt_menu_search_interactive \
    "Run a Command (mt-run)" mt-run \
    "List Functions (mt-list --func)" __mt_menu_list_func \
    "List Aliases (mt-list --alias)" __mt_menu_list_alias \
    "Browse Categories (mt-cats)" mt-cats
}

#######################################
# System: "Docker Tools" submenu
#######################################
__mt_menu_docker() {
  __mt_menu_submenu "🐳 Docker Tools" \
    "Shell into Container (docker-shell)" docker-shell \
    "Tail Container Logs (docker-tail)" docker-tail \
    "List Containers (docker-ls)" docker-ls \
    "Nuke Unused Resources (docker-nuke)" docker-nuke
}

#######################################
# System: "Cloud & Infra" submenu
#######################################
__mt_menu_infra() {
  __mt_menu_submenu "☁️  Cloud & Infra" \
    "Switch GCP Project (gcp-set-project)" gcp-set-project \
    "Validate All Terraform (tf-val-all)" tf-val-all \
    "Clean Terraform Caches (tf-clean)" tf-clean \
    "Generate IAM Bindings (tf-iam)" tf-iam
}

#######################################
# System: "Git Workflows" submenu
#######################################
__mt_menu_git() {
  __mt_menu_submenu "🌿 Git Workflows" \
    "Raise a Pull Request (git-raise-pr)" git-raise-pr \
    "Clean Merged Branches (git-clean-merged)" git-clean-merged \
    "AI-Grouped Push (git-ai-push-all)" git-ai-push-all
}

#######################################
# System: Launch the interactive master router for the entire framework
# Usage: mt-menu
#######################################
mt-menu() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  while true; do
    echo -e "${CB_BLUE}==========================================================${C_RESET}"
    echo -e "${CB_BLUE}              MT DEVOPS FRAMEWORK - MASTER MENU            ${C_RESET}"
    echo -e "${CB_BLUE}==========================================================${C_RESET}\n"

    local options=(
      "1. ⚙️  Setup & Config"
      "2. 📦 Code Exports"
      "3. 🎨 Terminal UI"
      "4. 🔍 Search & Docs"
      "5. 🐳 Docker Tools"
      "6. ☁️  Cloud & Infra"
      "7. 🌿 Git Workflows"
      "8. 🚪 Exit"
    )

    local choice
    choice=$(printf '%s\n' "${options[@]}" | fzf --prompt="🚀 Select a category > " --height=~15 --layout=reverse --border)

    case "$choice" in
      1*) __mt_menu_setup ;;
      2*) __mt_menu_exports ;;
      3*) __mt_menu_ui ;;
      4*) __mt_menu_docs ;;
      5*) __mt_menu_docker ;;
      6*) __mt_menu_infra ;;
      7*) __mt_menu_git ;;
      *) return 0 ;;
    esac
  done
}
