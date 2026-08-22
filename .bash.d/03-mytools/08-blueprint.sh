# shellcheck shell=bash
# ------------------------------------------
# Framework: Repository Scaffolding from Blueprints
# ------------------------------------------
# ~/.bash.d/03-mytools/08-blueprint.sh

#######################################
# Framework: Resolve which blueprint to scaffold (via -t or an interactive
# fzf picker), warning first if the current directory isn't empty
# Arguments:
#   $1 - Requested blueprint name (empty = prompt via fzf)
#   $2 - Path to the blueprints directory
# Outputs:
#   Prints the chosen blueprint name, or nothing if cancelled
#######################################
__mt_blueprint_select() {
  local requested="$1" blueprints_dir="$2"
  local target="$requested"

  if [ -z "$target" ]; then
    target=$(find "$blueprints_dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | fzf --prompt="🏗️  Select Blueprint > " --height=~10 --layout=reverse --border)
  fi
  [ -z "$target" ] && return 0

  if [ "$(ls -A 2> /dev/null)" ]; then
    # All of this is user-facing status text, not the function's return
    # value -- it MUST go to stderr, since the caller captures this
    # function's stdout via `target=$(...)` to get the resolved name back.
    echo -e "\n${CB_YELLOW}⚠️  WARNING: The current directory is not empty.${C_RESET}" >&2
    echo -e "${CB_YELLOW}Applying this blueprint may overwrite existing files like README.md or .gitignore.${C_RESET}" >&2
    echo -n "Are you sure you want to proceed? [y/N] " >&2
    local REPLY
    read -r -n 1 REPLY < /dev/tty || REPLY="n"
    echo >&2
    [[ ! $REPLY =~ ^[Yy]$ ]] && return 0
  fi

  echo "$target"
}

#######################################
# Framework: Copy a blueprint's files into the current directory, replace
# {{PROJECT_NAME}} placeholders, and initialize git if not already tracked
# Arguments:
#   $1 - Path to the blueprint's source directory
# Globals:
#   OS_FAMILY
#######################################
__mt_blueprint_scaffold() {
  local source_dir="$1"
  local project_name
  project_name=$(basename "$PWD")

  cp -R "$source_dir/"* . 2> /dev/null || true
  cp -R "$source_dir/".[!.]* . 2> /dev/null || true

  local -a sed_inplace=(-i)
  [ "$OS_FAMILY" = "macos" ] && sed_inplace=(-i '')
  find . -type f -not -path "*/\.git/*" -print0 | xargs -0 -I {} sed "${sed_inplace[@]}" "s/{{PROJECT_NAME}}/$project_name/g" {} 2> /dev/null

  if [ ! -d ".git" ]; then
    echo "📦 Initializing Git repository..."
    git init -q
  fi
}

#######################################
# Framework: Inject the CI/CD pipeline template matching CICD_PROVIDER into
# the current directory, if the blueprint ships one
# Globals:
#   CICD_PROVIDER
#######################################
__mt_blueprint_route_cicd() {
  [ -d ".cicd_templates" ] || return 0

  local provider="${CICD_PROVIDER:-github}"
  if [ -d ".cicd_templates/$provider" ]; then
    echo -e "${CB_BLUE}⚙️  Injecting $provider pipeline configuration...${C_RESET}"
    cp -a ".cicd_templates/$provider/." .
  else
    mt-log WARN "No $provider pipeline template available for this blueprint. Skipping CI/CD generation."
  fi
  rm -rf ".cicd_templates"
}

#######################################
# Framework: Scaffold a new repository using standardized DevOps blueprints
# Usage: mt-blueprint [-t <blueprint_name>]
# Options:
#   -t <name>  Blueprint to apply (skips the interactive fzf picker)
# Globals:
#   CICD_PROVIDER
#######################################
mt-blueprint() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local blueprints_dir="$HOME/.bash.d/lib/blueprints"
  if [ ! -d "$blueprints_dir" ]; then
    mt-log ERROR "Blueprints directory not found at $blueprints_dir"
    return 1
  fi

  local requested=""
  local OPTIND opt
  while getopts "t:" opt; do
    case ${opt} in
      t) requested="$OPTARG" ;;
      \?)
        echo "Usage: mt-blueprint [-t <blueprint_name>]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  local target
  target=$(__mt_blueprint_select "$requested" "$blueprints_dir")
  if [ -z "$target" ]; then
    echo -e "${CB_YELLOW}⚠️  Blueprint selection cancelled.${C_RESET}"
    return 0
  fi

  local source_dir="${blueprints_dir}/${target}"
  if [ ! -d "$source_dir" ]; then
    mt-log ERROR "Blueprint '$target' does not exist."
    return 1
  fi

  echo -e "${CB_BLUE}🏗️  Scaffolding '$target' into $PWD...${C_RESET}"
  __mt_blueprint_scaffold "$source_dir"
  __mt_blueprint_route_cicd

  mt-log SUCCESS "Blueprint '$target' applied successfully!"
}
