# ~/.bash.d/30-ai/60-ai.sh

if [[ -z "${URI_GEMINI_MODELS:-}" ]]; then readonly URI_GEMINI_MODELS="https://generativelanguage.googleapis.com/v1beta/models"; fi
if [[ -z "${URI_CLAUDE_MESSAGES:-}" ]]; then readonly URI_CLAUDE_MESSAGES="https://api.anthropic.com/v1/messages"; fi

#######################################
# Calculates the next available minor patch version for a generated file.
# Arguments:
#   $1 - The base file path without extension.
#   $2 - The file extension.
# Outputs:
#   Writes the semantic version string (e.g. v1.0.3) to STDOUT.
#######################################
_ai_get_next_version() {
  local base_path="$1" ext="$2" major=1 minor=0 patch=0
  while [[ -f "${base_path}-v${major}.${minor}.${patch}.${ext}" ]]; do patch=$((patch + 1)); done
  echo "v${major}.${minor}.${patch}"
}

#######################################
# Compiles local codebase files into a single context document for LLMs.
# Globals:
#   PWD
# Arguments:
#   $1 - Explicit target file to serialize.
#   $2 - Boolean flag to serialize entire active directory.
# Outputs:
#   Writes path of temporary context file to STDOUT.
# Returns:
#   0 on success, 1 if target file is not found.
#######################################
__ai_build_context() {
  local target_file="$1" export_context="$2" context_file=""

  if [ -n "$target_file" ]; then
    [ ! -f "$target_file" ] && {
      echo "🚨 Error: Target context file '$target_file' not found." >&2
      return 1
    }
    echo "📦 Compiling target file '$target_file' for context..." >&2
    context_file=$(mktemp)
    echo "==> ./$target_file <==" >> "$context_file"
    cat "$target_file" >> "$context_file"
    echo "✅ File context attached." >&2
    echo "$context_file"
    return 0
  fi

  [ "$export_context" != true ] && return 0

  echo "📦 Compiling local directory codebase for context..." >&2
  context_file=$(mktemp)
  find . -type f -not -path "*/\.git/*" -not -path "*/node_modules/*" -not -path "*/venv/*" -not -path "*/\.terraform/*" -print0 | while IFS= read -r -d '' file; do
    local clean_file="${file#./}" lower_file="${clean_file,,}"
    [[ "$lower_file" =~ \.(png|jpe?g|gif|ico|pdf|zip|tar|gz|mp4|mp3|wav|exe|dll|so|class|jar|bin|o|pyc|tfstate)$ ]] && continue
    [[ "$lower_file" =~ (secret|token|credential|pass|key|rsa|env|lock\.hcl|__pycache__) ]] && continue

    echo "==> ./$clean_file <==" >> "$context_file"
    cat "$file" >> "$context_file"
    echo -e "\n" >> "$context_file"
  done
  echo "✅ Codebase context attached." >&2
  echo "$context_file"
}

#######################################
# Formats payload and queries the Google Gemini API.
# Globals:
#   URI_GEMINI_MODELS, GEMINI_API_KEY, GEMINI_VERSION, GEMINI_EXTENDED, AI_SYSTEM_PROMPT
# Arguments:
#   $1 - The user prompt string.
#   $2 - The generated output title context.
#   $3 - Path to the compiled context file.
#   $4 - Override model version argument.
#   $5 - Boolean flag to force extended reasoning model.
# Outputs:
#   Writes raw JSON response payload from Gemini to STDOUT.
# Returns:
#   0 on success, 1 on curl failure or missing API key.
#######################################
__ai_query_gemini() {
  local prompt="$1" title="$2" context_file="$3" req_version="$4" req_extended="$5"
  [ -z "${GEMINI_API_KEY}" ] && {
    echo "🚨 Error: GEMINI_API_KEY is not set. Run 'add-gemini-key'." >&2
    return 1
  }

  local final_model="${GEMINI_VERSION:-gemini-3.6-flash}"
  local is_extended="${GEMINI_EXTENDED:-false}"
  [ "$req_extended" = true ] && is_extended="true"

  if [ -n "$req_version" ]; then
    local base_prefix="gemini-3.6"
    [[ "$final_model" =~ ^(gemini-[0-9]+\.[0-9]+) ]] && base_prefix="${BASH_REMATCH[1]}"
    final_model="${base_prefix}-${req_version}"
  fi

  if [ "$is_extended" = "true" ]; then
    [[ "$final_model" == *-flash ]] && final_model="${final_model%-flash}-pro"
    [[ "$final_model" == *-flash-lite ]] && final_model="${final_model%-flash-lite}-pro"
  fi

  local api_url="${URI_GEMINI_MODELS}/${final_model}:generateContent?key=${GEMINI_API_KEY}"
  local prompt_json

  if [ -f "$context_file" ]; then
    prompt_json=$(jq -n --arg p "${prompt}" --arg t "${title}" --rawfile ctx "$context_file" '{ contents: [{ parts: [{ text: (if $t != "" then "Requested Title: " + $t + "\n" else "" end + "Prompt: " + $p + "\n\n=== LOCAL DIRECTORY CONTEXT ===\n" + $ctx) }] }] }')
  else
    prompt_json=$(jq -n --arg p "${prompt}" --arg t "${title}" '{ contents: [{ parts: [{ text: (if $t != "" then "Requested Title: " + $t + "\n" else "" end + "Prompt: " + $p) }] }] }')
  fi

  local system_json=$(jq -n --arg sp "${AI_SYSTEM_PROMPT}" '{ systemInstruction: { parts: [{ text: $sp }] } }')
  local payload_file=$(mktemp)
  jq -s '.[0] * .[1] * .[2]' "$HOME/.bash.d/config/gemini-config.json" <(echo "$system_json") <(echo "$prompt_json") > "$payload_file"

  echo "⏳ Querying Gemini ($final_model)..." >&2
  local response=$(curl -s -X POST "${api_url}" -H 'Content-Type: application/json' -d @"$payload_file")

  rm -f "$payload_file"
  local content=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text // empty')

  [ -z "$content" ] && {
    echo "🚨 Error: Failed to get a valid response from Gemini." >&2
    echo "$response" | jq -r '.error.message // "Unknown error"' >&2
    return 1
  }
  echo "$content"
}

#######################################
# Formats payload and queries the Anthropic Claude API.
# Globals:
#   URI_CLAUDE_MESSAGES, CLAUDE_API_KEY, CLAUDE_VERSION, AI_SYSTEM_PROMPT
# Arguments:
#   $1 - The user prompt string.
#   $2 - The generated output title context.
#   $3 - Path to the compiled context file.
#   $4 - Override model version argument.
# Outputs:
#   Writes raw JSON response payload from Claude to STDOUT.
# Returns:
#   0 on success, 1 on curl failure or missing API key.
#######################################
__ai_query_claude() {
  local prompt="$1" title="$2" context_file="$3" req_version="$4"
  [ -z "${CLAUDE_API_KEY}" ] && {
    echo "🚨 Error: CLAUDE_API_KEY is not set. Run 'add-claude-key'." >&2
    return 1
  }

  local final_model="${req_version:-${CLAUDE_VERSION:-claude-3-7-sonnet-latest}}"
  local api_url="${URI_CLAUDE_MESSAGES}"
  local prompt_json

  if [ -f "$context_file" ]; then
    prompt_json=$(jq -n --arg p "${prompt}" --arg t "${title}" --rawfile ctx "$context_file" '{ messages: [{ role: "user", content: (if $t != "" then "Requested Title: " + $t + "\n" else "" end + "Prompt: " + $p + "\n\n=== LOCAL DIRECTORY CONTEXT ===\n" + $ctx) }] }')
  else
    prompt_json=$(jq -n --arg p "${prompt}" --arg t "${title}" '{ messages: [{ role: "user", content: (if $t != "" then "Requested Title: " + $t + "\n" else "" end + "Prompt: " + $p) }] }')
  fi

  local system_json=$(jq -n --arg sp "${AI_SYSTEM_PROMPT}" '{ system: $sp }')
  local payload_file=$(mktemp)
  jq -s '.[0] * .[1] * .[2] * {model: $model}' "$HOME/.bash.d/config/claude-config.json" <(echo "$system_json") <(echo "$prompt_json") --arg model "$final_model" > "$payload_file"

  echo "⏳ Querying Claude ($final_model)..." >&2
  local response=$(curl -s -X POST "${api_url}" -H "x-api-key: ${CLAUDE_API_KEY}" -H "anthropic-version: 2023-06-01" -H "content-type: application/json" -d @"$payload_file")

  rm -f "$payload_file"
  local content=$(echo "$response" | jq -r '.content[0].text // empty')

  [ -z "$content" ] && {
    echo "🚨 Error: Failed to get a valid response from Claude." >&2
    echo "$response" | jq -r '.error.message // "Unknown error"' >&2
    return 1
  }
  echo "$content"
}

#######################################
# Formats and saves the generated code from LLMs into standard directories.
# Globals:
#   AI_WORKSPACE_DIR
# Arguments:
#   $1 - Explicit out file path if provided.
#   $2 - JSON category field (determines subfolder).
#   $3 - JSON language field.
#   $4 - JSON extension field.
#   $5 - Kebab-case title string.
#   $6 - The raw code payload.
# Outputs:
#   Writes the absolute saved file path to STDOUT.
#######################################
__ai_save_output() {
  local explicit_out_file="$1" category="$2" lang="$3" ext="$4" final_title="$5" code="$6" target_file_path=""

  if [ -n "$explicit_out_file" ]; then
    mkdir -p "$(dirname "$explicit_out_file")"
    target_file_path="$explicit_out_file"
  else
    local target_dir="" base_name=""
    case "$category" in
      gcloud)
        target_dir="${AI_WORKSPACE_DIR}/generated/gcloud"
        base_name="${target_dir}/${final_title}"
        ;;
      script)
        target_dir="${AI_WORKSPACE_DIR}/generated/scripts/${lang}"
        base_name="${target_dir}/${final_title}"
        ;;
      project | *)
        target_dir="${AI_WORKSPACE_DIR}/generated/projects"
        base_name="${target_dir}/${final_title}-${lang}"
        ;;
    esac

    mkdir -p "$target_dir"
    local version=$(_ai_get_next_version "$base_name" "$ext")
    target_file_path="${base_name}-${version}.${ext}"
  fi

  echo "$code" > "$target_file_path"
  echo "$target_file_path"
}

#######################################
# Consult universal AI
# Arguments:
#   -m <model>   gemini or claude
#   -t <title>   Title string to format output
#   -e           Flag to export full directory context
#   -f <file>    Explicit file path to attach as context
#   -o <file>    Explicit file path to save output to
#   -v <version> Specific model version override
#   -x           Enable extended reasoning logic
#######################################
ai() {
  [[ "$1" == "-h" || "$1" == "--help" ]] && {
    mt-help "${FUNCNAME[0]}"
    return 0
  }

  local title="" export_context=false target_file="" explicit_out_file="" req_version="" req_extended=false
  local provider="${DEFAULT_AI:-gemini}" prompt=""

  OPTIND=1
  while getopts "m:t:ef:o:v:x" opt; do
    case ${opt} in
      m) provider="$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')" ;;
      t) title=$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]' | tr ' ' '-') ;;
      e) export_context=true ;;
      f) target_file="$OPTARG" ;;
      o) explicit_out_file="$OPTARG" ;;
      v) req_version="$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')" ;;
      x) req_extended=true ;;
      \?)
        echo "Usage: ai [-m gemini|claude] [-t title] [-e] [-f file] [-o out_file] [-v version] [-x] <prompt>" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))
  prompt="$*"

  [ -z "${prompt}" ] && {
    echo "Usage: ai [-m gemini|claude] [-t title] [-e] [-f file] [-o out_file] [-v version] [-x] <your question>" >&2
    return 1
  }

  local context_file=$(__ai_build_context "$target_file" "$export_context")
  [ $? -ne 0 ] && return 1

  local content=""
  if [ "$provider" = "gemini" ]; then
    content=$(__ai_query_gemini "$prompt" "$title" "$context_file" "$req_version" "$req_extended")
  elif [ "$provider" = "claude" ]; then
    content=$(__ai_query_claude "$prompt" "$title" "$context_file" "$req_version")
  else
    echo "🚨 Error: Invalid provider '$provider'." >&2
    return 1
  fi
  [ $? -ne 0 ] && return 1

  [ -f "$context_file" ] && rm -f "$context_file"

  local clean_content=$(echo "$content" | python3 -c '
import sys, re
text = sys.stdin.read()
match = re.search(r"\{.*\}", text, re.DOTALL)
if match: print(match.group(0))
else: print(text)
' 2> /dev/null)

  local category=$(echo "$clean_content" | jq -r '.category // empty')
  local lang=$(echo "$clean_content" | jq -r '.language // empty')
  local ext=$(echo "$clean_content" | jq -r '.extension // empty')
  local code=$(echo "$clean_content" | jq -r '.code // empty')
  local msg=$(echo "$clean_content" | jq -r '.message // empty')
  local gen_title=$(echo "$clean_content" | jq -r '.title // empty')

  local final_title="${title:-$gen_title}"
  final_title="${final_title:-untitled}"

  if [[ -z "$category" || "$category" == "chat" || "$category" == "null" ]]; then
    [[ "$msg" == "No IAM implementations required"* ]] &&
      echo -e "\e[38;5;208m${provider^}:\e[0m No IAM implementations required" ||
      echo -e "\e[38;5;208m${provider^}:\e[0m ${msg:-$content}"
    return 0
  fi

  local saved_path=$(__ai_save_output "$explicit_out_file" "$category" "$lang" "$ext" "$final_title" "$code")

  echo -e "\e[38;5;208m${provider^}:\e[0m $msg"
  echo -e "\e[32mSaved to:\e[0m $saved_path"
}
