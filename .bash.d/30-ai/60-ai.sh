# shellcheck shell=bash
# ------------------------------------------
# AI Workflows & LLM API Integration
# ------------------------------------------
# ~/.bash.d/30-ai/60-ai.sh

if [[ -z "${URI_GEMINI_MODELS:-}" ]]; then readonly URI_GEMINI_MODELS="https://generativelanguage.googleapis.com/v1beta/models"; fi
if [[ -z "${URI_CLAUDE_MESSAGES:-}" ]]; then readonly URI_CLAUDE_MESSAGES="https://api.anthropic.com/v1/messages"; fi

#######################################
# AI: Calculate next available minor patch version for a generated file
# Arguments:
#   $1 - Base file path without extension
#   $2 - File extension
# Outputs:
#   Prints semantic version string (e.g. v1.0.3) to STDOUT
#######################################
_ai_get_next_version() {
  local base_path="$1" ext="$2" major=1 minor=0 patch=0
  while [[ -f "${base_path}-v${major}.${minor}.${patch}.${ext}" ]]; do patch=$((patch + 1)); done
  echo "v${major}.${minor}.${patch}"
}

#######################################
# AI: Compile local codebase files into a single context payload
# Globals:
#   EXPORT_BLOCKLIST
# Arguments:
#   $1 - Explicit target file to serialize
#   $2 - Boolean flag to serialize entire active directory
# Outputs:
#   Prints temporary context file path to STDOUT
# Returns:
#   0 on success, 1 on error or user abort
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
    command cat "$target_file" >> "$context_file"
    echo "✅ File context attached." >&2
    echo "$context_file"
    return 0
  fi

  [ "$export_context" != true ] && return 0

  local file_count
  file_count=$(find . -type f -not -path "*/\.git/*" -not -path "*/node_modules/*" -not -path "*/venv/*" -not -path "*/\.terraform/*" 2> /dev/null | head -n 1000 | wc -l)
  if [ "$file_count" -ge 1000 ]; then
    echo -e "\n\e[33m⚠️  Warning: This directory contains 1000+ files. AI context may exceed limits.\e[0m" >&2
    read -p "Proceed anyway? [y/N] " -n 1 -r < /dev/tty
    echo > /dev/tty
    [ "$REPLY" != "y" ] && [ "$REPLY" != "Y" ] && {
      echo "🛑 Aborted." >&2
      return 1
    }
  fi

  echo "📦 Compiling local directory codebase for context..." >&2
  context_file=$(mktemp)
  local blocklist="${EXPORT_BLOCKLIST:-(secret|token|credential|password|passwd|id_rsa|id_ed25519|\.pem$|\.p12$|\.pfx$|\.npmrc$|\.netrc$|kubeconfig|service.?account.*\.json$|.*-key.*\.json$|\.tfvars(\.json)?$|(^|/)\.env(\..+)?$|lock\.hcl|__pycache__)}"
  find . -type f -not -path "*/\.git/*" -not -path "*/node_modules/*" -not -path "*/venv/*" -not -path "*/\.terraform/*" -print0 | while IFS= read -r -d '' file; do
    local clean_file="${file#./}"
    local lower_file="${clean_file,,}"
    [[ "$lower_file" =~ \.(png|jpe?g|gif|ico|pdf|zip|tar|gz|mp4|mp3|wav|exe|dll|so|class|jar|bin|o|pyc|tfstate)$ ]] && continue
    [[ "$lower_file" =~ $blocklist ]] && continue

    echo "==> ./$clean_file <==" >> "$context_file"
    command cat "$file" >> "$context_file"
    echo -e "\n" >> "$context_file"
  done
  echo "✅ Codebase context attached." >&2
  echo "$context_file"
}

#######################################
# AI: Query Google Gemini API with retries and rate-limit handling
# Globals:
#   GEMINI_API_KEY, GEMINI_VERSION, GEMINI_EXTENDED, URI_GEMINI_MODELS, AI_SYSTEM_PROMPT
# Arguments:
#   $1 - User prompt string
#   $2 - Output title context
#   $3 - Path to compiled context file
#   $4 - Override model version
#   $5 - Boolean flag to force extended reasoning model
# Outputs:
#   Prints API text response to STDOUT
# Returns:
#   0 on success, 99 on user skip, 100 on hard failure
#######################################
__ai_query_gemini() {
  local prompt="$1" title="$2" context_file="$3" req_version="$4" req_extended="$5"
  [ -z "${GEMINI_API_KEY}" ] && {
    echo "🚨 Error: GEMINI_API_KEY is not set. Run 'mt-add-gemini-key'." >&2
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

  local api_url="${URI_GEMINI_MODELS}/${final_model}:generateContent"

  local tmp_prompt
  tmp_prompt=$(mktemp)
  echo -n "$prompt" > "$tmp_prompt"

  local prompt_json
  if [ -f "$context_file" ]; then
    prompt_json=$(jq -n --arg t "${title}" --rawfile p "$tmp_prompt" --rawfile ctx "$context_file" '{ contents: [{ parts: [{ text: (if $t != "" then "Requested Title: " + $t + "\n" else "" end + "Prompt: " + $p + "\n\n=== LOCAL DIRECTORY CONTEXT ===\n" + $ctx) }] }] }')
  else
    prompt_json=$(jq -n --arg t "${title}" --rawfile p "$tmp_prompt" '{ contents: [{ parts: [{ text: (if $t != "" then "Requested Title: " + $t + "\n" else "" end + "Prompt: " + $p) }] }] }')
  fi
  rm -f "$tmp_prompt"

  local tmp_sys
  tmp_sys=$(mktemp)
  echo -n "${AI_SYSTEM_PROMPT}" > "$tmp_sys"
  local system_json
  system_json=$(jq -n --rawfile sp "$tmp_sys" '{ systemInstruction: { parts: [{ text: $sp }] } }')
  rm -f "$tmp_sys"

  local payload_file
  payload_file=$(mktemp)
  jq -s '.[0] * .[1] * .[2]' "$HOME/.bash.d/config/ai/gemini-config.json" <(echo "$system_json") <(echo "$prompt_json") > "$payload_file"

  echo "⏳ Querying Gemini ($final_model)..." >&2
  local response="" content=""
  local attempt=1 max_retries=3

  while [ $attempt -le $max_retries ]; do
    response=$(curl -s -X POST "${api_url}" -H "x-goog-api-key: ${GEMINI_API_KEY}" -H 'Content-Type: application/json' -d @"$payload_file")
    content=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text // empty')

    if [ -n "$content" ]; then
      break
    fi

    local err_msg
    err_msg=$(echo "$response" | jq -r '.error.message // "Unknown error"')

    if [[ "$err_msg" == *"Quota exceeded"* || "$err_msg" == *"429"* ]]; then
      local wait_time=25
      if [[ "$err_msg" =~ retry[[:space:]]in[[:space:]]([0-9]+) ]]; then
        wait_time=$((BASH_REMATCH[1] + 2))
      fi

      echo -e "\n\033[01;33m⏳ AI Rate limit hit! Required cooldown: ${wait_time}s (Attempt $attempt/$max_retries)\033[0m" >&2
      local user_input=""

      if [[ "$prompt" == "Analyze this git diff and group the changes"* ]]; then
        read -r -p "   Enter a commit message to bypass AI and push now (or press Enter to wait & retry): " user_input < /dev/tty
        if [ -n "$user_input" ]; then
          echo -e "\033[01;32m💡 Bypassing AI and committing manually...\033[0m" >&2
          git add . > /dev/null 2>&1
          git commit -m "$user_input" > /dev/null 2>&1
          return 99
        fi
      else
        read -r -p "   Press Enter to wait & retry, or type 'skip' to abort this specific AI task: " user_input < /dev/tty
        if [[ "${user_input,,}" == "skip" ]]; then
          echo -e "\033[01;32m💡 Skipping AI task...\033[0m" >&2
          return 99
        fi
      fi

      echo "⏳ Waiting ${wait_time}s..." >&2
      sleep "$wait_time"
      ((attempt++))
    else
      break
    fi
  done

  rm -f "$payload_file"

  [ -z "$content" ] && {
    echo -e "\n\033[01;31m🚨 Error: AI failed after $max_retries retries. Aborting process.\033[0m" >&2
    return 100
  }
  echo "$content"
}

#######################################
# AI: Query Anthropic Claude API with retries and rate-limit handling
# Globals:
#   CLAUDE_API_KEY, CLAUDE_VERSION, URI_CLAUDE_MESSAGES, AI_SYSTEM_PROMPT
# Arguments:
#   $1 - User prompt string
#   $2 - Output title context
#   $3 - Path to compiled context file
#   $4 - Override model version
# Outputs:
#   Prints API text response to STDOUT
# Returns:
#   0 on success, 99 on user skip, 100 on hard failure
#######################################
__ai_query_claude() {
  local prompt="$1" title="$2" context_file="$3" req_version="$4"
  [ -z "${CLAUDE_API_KEY}" ] && {
    echo "🚨 Error: CLAUDE_API_KEY is not set. Run 'mt-add-claude-key'." >&2
    return 1
  }

  local final_model="${req_version:-${CLAUDE_VERSION:-claude-3-7-sonnet-latest}}"
  local api_url="${URI_CLAUDE_MESSAGES}"

  local tmp_prompt
  tmp_prompt=$(mktemp)
  echo -n "$prompt" > "$tmp_prompt"

  local prompt_json
  if [ -f "$context_file" ]; then
    prompt_json=$(jq -n --arg t "${title}" --rawfile p "$tmp_prompt" --rawfile ctx "$context_file" '{ messages: [{ role: "user", content: (if $t != "" then "Requested Title: " + $t + "\n" else "" end + "Prompt: " + $p + "\n\n=== LOCAL DIRECTORY CONTEXT ===\n" + $ctx) }] }')
  else
    prompt_json=$(jq -n --arg t "${title}" --rawfile p "$tmp_prompt" '{ messages: [{ role: "user", content: (if $t != "" then "Requested Title: " + $t + "\n" else "" end + "Prompt: " + $p) }] }')
  fi
  rm -f "$tmp_prompt"

  local tmp_sys
  tmp_sys=$(mktemp)
  echo -n "${AI_SYSTEM_PROMPT}" > "$tmp_sys"
  local system_json
  system_json=$(jq -n --rawfile sp "$tmp_sys" '{ system: $sp }')
  rm -f "$tmp_sys"

  local payload_file
  payload_file=$(mktemp)
  jq -s '.[0] * .[1] * .[2] * {model: $model}' "$HOME/.bash.d/config/ai/claude-config.json" <(echo "$system_json") <(echo "$prompt_json") --arg model "$final_model" > "$payload_file"

  echo "⏳ Querying Claude ($final_model)..." >&2
  local response="" content=""
  local attempt=1 max_retries=3

  while [ $attempt -le $max_retries ]; do
    response=$(curl -s -X POST "${api_url}" -H "x-api-key: ${CLAUDE_API_KEY}" -H "anthropic-version: 2023-06-01" -H "content-type: application/json" -d @"$payload_file")
    content=$(echo "$response" | jq -r '.content[0].text // empty')

    if [ -n "$content" ]; then
      break
    fi

    local err_msg
    err_msg=$(echo "$response" | jq -r '.error.message // "Unknown error"')

    if [[ "$err_msg" == *"rate_limit_error"* || "$err_msg" == *"429"* || "$err_msg" == *"Overloaded"* ]]; then
      local wait_time=20
      echo -e "\n\033[01;33m⏳ AI Rate limit hit! Required cooldown: ${wait_time}s (Attempt $attempt/$max_retries)\033[0m" >&2
      local user_input=""

      if [[ "$prompt" == "Analyze this git diff and group the changes"* ]]; then
        read -r -p "   Enter a commit message to bypass AI and push now (or press Enter to wait & retry): " user_input < /dev/tty
        if [ -n "$user_input" ]; then
          echo -e "\033[01;32m💡 Bypassing AI and committing manually...\033[0m" >&2
          git add . > /dev/null 2>&1
          git commit -m "$user_input" > /dev/null 2>&1
          return 99
        fi
      else
        read -r -p "   Press Enter to wait & retry, or type 'skip' to abort this specific AI task: " user_input < /dev/tty
        if [[ "${user_input,,}" == "skip" ]]; then
          echo -e "\033[01;32m💡 Skipping AI task...\033[0m" >&2
          return 99
        fi
      fi

      echo "⏳ Waiting ${wait_time}s..." >&2
      sleep "$wait_time"
      ((attempt++))
    else
      break
    fi
  done

  rm -f "$payload_file"

  [ -z "$content" ] && {
    echo -e "\n\033[01;31m🚨 Error: AI failed after $max_retries retries. Aborting process.\033[0m" >&2
    return 100
  }
  echo "$content"
}

#######################################
# AI: Save generated LLM code payloads into structured directory trees
# Globals:
#   AI_WORKSPACE_DIR
# Arguments:
#   $1 - Explicit out file path
#   $2 - JSON category field
#   $3 - JSON language field
#   $4 - JSON extension field
#   $5 - Kebab-case title string
#   $6 - Raw code payload
# Outputs:
#   Prints final saved file path to STDOUT
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
    local version
    version=$(_ai_get_next_version "$base_name" "$ext")
    target_file_path="${base_name}-${version}.${ext}"
  fi

  echo "$code" > "$target_file_path"
  echo "$target_file_path"
}

#######################################
# AI: Parse standard single JSON object response and save if required
# Arguments:
#   $1 - Content string
#   $2 - Provider name
#   $3 - Original title
#   $4 - Explicit out file
#######################################
__ai_parse_response() {
  local content="$1" provider="$2" title="$3" explicit_out_file="$4"

  local clean_content
  clean_content=$(echo "$content" | python3 "$HOME/.bash.d/lib/python/ai_parse_response.py" 2> /dev/null)

  local category lang ext code msg gen_title
  category=$(echo "$clean_content" | jq -r '.category // empty')
  lang=$(echo "$clean_content" | jq -r '.language // empty')
  ext=$(echo "$clean_content" | jq -r '.extension // empty')
  code=$(echo "$clean_content" | jq -r '.code // empty')
  msg=$(echo "$clean_content" | jq -r '.message // empty')
  gen_title=$(echo "$clean_content" | jq -r '.title // empty')

  local final_title="${title:-$gen_title}"
  final_title="${final_title:-untitled}"

  if [[ -z "$category" || "$category" == "chat" || "$category" == "null" ]]; then
    [[ "$msg" == "No IAM implementations required"* ]] &&
      echo -e "\e[38;5;208m${provider^}:\e[0m No IAM implementations required" ||
      echo -e "\e[38;5;208m${provider^}:\e[0m ${msg:-$content}"
    return 0
  fi

  local saved_path
  saved_path=$(__ai_save_output "$explicit_out_file" "$category" "$lang" "$ext" "$final_title" "$code")

  echo -e "\e[38;5;208m${provider^}:\e[0m $msg"
  echo -e "\e[32mSaved to:\e[0m $saved_path"
}

#######################################
# AI: Extract a JSON array from raw LLM output text
# Arguments:
#   $1 - Raw LLM text payload
# Outputs:
#   Prints parsed JSON array string to STDOUT
#######################################
__ai_extract_json_array() {
  echo "$1" | python3 "$HOME/.bash.d/lib/python/ai_extract_json_array.py" 2> /dev/null
}

#######################################
# AI: Query configured LLM with prompt and optional context
# Globals:
#   DEFAULT_AI
# Usage: ai [OPTIONS] <prompt>
# Options:
#   -m <model>     Override provider model (gemini, claude, local)
#   -t <title>     Set context title
#   -e             Attach entire active directory as context
#   -f <file>      Attach a single file as context
#   -o <out_file>  Save output directly to specified file
#   -v <version>   Override model version
#   -x             Force extended reasoning mode
#   -h, --help     Show this help menu
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

  local context_file
  context_file=$(__ai_build_context "$target_file" "$export_context")
  [ $? -ne 0 ] && return 1

  local content=""
  if [ "$provider" = "gemini" ]; then
    content=$(__ai_query_gemini "$prompt" "$title" "$context_file" "$req_version" "$req_extended")
  elif [ "$provider" = "claude" ]; then
    content=$(__ai_query_claude "$prompt" "$title" "$context_file" "$req_version")
  elif [ "$provider" = "local" ]; then
    content=$(__ai_query_local "$prompt" "$title" "$context_file" "$req_version")
  else
    echo "🚨 Error: Invalid provider '$provider'." >&2
    return 1
  fi
  [ $? -ne 0 ] && return 1

  [ -f "$context_file" ] && rm -f "$context_file"

  __ai_parse_response "$content" "$provider" "$title" "$explicit_out_file"
}

#######################################
# AI: Query local LLM endpoint (OpenAI-compatible)
# Globals:
#   LOCAL_AI_BASE_URL, LOCAL_AI_API_KEY, LOCAL_AI_MODEL, AI_SYSTEM_PROMPT
# Arguments:
#   $1 - User prompt string
#   $2 - Output title context
#   $3 - Path to compiled context file
#   $4 - Override model version
# Outputs:
#   Prints API text response to STDOUT
# Returns:
#   0 on success, 1 on curl failure or timeout
#######################################
__ai_query_local() {
  local prompt="$1" title="$2" context_file="$3" req_version="$4"
  local base_url="${LOCAL_AI_BASE_URL:-http://localhost:11434/v1}"
  local api_key="${LOCAL_AI_API_KEY:-ollama}"
  local final_model="${req_version:-${LOCAL_AI_MODEL:-llama3.2}}"

  local system_prompt="${AI_SYSTEM_PROMPT:-You are a helpful assistant.}"

  local tmp_prompt
  tmp_prompt=$(mktemp)
  echo -n "$prompt" > "$tmp_prompt"

  local tmp_sys
  tmp_sys=$(mktemp)
  echo -n "$system_prompt" > "$tmp_sys"

  local payload_file
  payload_file=$(mktemp)

  if [ -f "$context_file" ]; then
    jq -n \
      --arg model "$final_model" \
      --rawfile sys "$tmp_sys" \
      --arg t "$title" \
      --rawfile p "$tmp_prompt" \
      --rawfile ctx "$context_file" \
      '{
        model: $model,
        messages: [
          {role: "system", content: $sys},
          {role: "user", content: (if $t != "" then "Requested Title: " + $t + "\n" else "" end + "Prompt: " + $p + "\n\n=== LOCAL DIRECTORY CONTEXT ===\n" + $ctx)}
        ]
      }' > "$payload_file"
  else
    jq -n \
      --arg model "$final_model" \
      --rawfile sys "$tmp_sys" \
      --arg t "$title" \
      --rawfile p "$tmp_prompt" \
      '{
        model: $model,
        messages: [
          {role: "system", content: $sys},
          {role: "user", content: (if $t != "" then "Requested Title: " + $t + "\n" else "" end + "Prompt: " + $p)}
        ]
      }' > "$payload_file"
  fi

  rm -f "$tmp_prompt" "$tmp_sys"

  echo "⏳ Querying Local LLM ($final_model at $base_url)..." >&2
  local response
  response=$(curl -s -X POST "${base_url}/chat/completions" \
    -H "Authorization: Bearer ${api_key}" \
    -H "Content-Type: application/json" \
    -d @"$payload_file")

  rm -f "$payload_file"
  local content
  content=$(echo "$response" | jq -r '.choices[0].message.content // empty')

  [ -z "$content" ] && {
    echo "🚨 Error: Failed to get a valid response from Local LLM." >&2
    echo "$response" | jq -r '.error.message // "Unknown error"' >&2
    return 1
  }
  echo "$content"
}

#######################################
# AI: Explain a terminal command in detail
# Usage: ai-explain "<command>"
# Arguments:
#   $1 - Command string to explain
#######################################
ai-explain() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  if [ -z "$1" ]; then
    echo "Usage: ai-explain \"<command>\""
    return 1
  fi
  mt-log INFO "Asking AI to explain: $1..."
  ai -t "command-explanation" "Please explain this terminal command in detail, breaking down what each flag and argument does: $1"
}

#######################################
# AI: Debug and explain the last failed terminal command
#######################################
mt-ai-debug() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  local last_cmd
  last_cmd=$(fc -ln -2 | head -n 1 | xargs)

  mt-log INFO "Re-running and debugging: $last_cmd..."
  local err_out
  err_out=$(eval "$last_cmd" 2>&1 > /dev/null)

  if [ -z "$err_out" ]; then
    mt-log SUCCESS "Command executed successfully. No errors to debug!"
  else
    ai -t "debug-error" "The command \`$last_cmd\` failed with this stderr output:\n\n$err_out\n\nPlease explain why it failed and provide the exact command to fix it."
  fi
}
