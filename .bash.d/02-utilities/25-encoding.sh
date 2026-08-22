# shellcheck shell=bash
# ------------------------------------------
# Base64 Encoding & Decoding Utilities
# ------------------------------------------
# ~/.bash.d/02-utilities/25-encoding.sh

#######################################
# System: Encode or decode a string, file, or stream to/from Base64
# Usage: base64-cli [-d] [-f file] [-o file] [string]
# Arguments:
#   -d          Decode instead of encode
#   -f <file>   Path to local input file
#   -o <file>   Path to write output file (defaults to stdout)
#   [string]    Literal string to encode/decode if no file or stdin is provided
#######################################
base64-cli() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi

  local input_file="" output_file="" input_str="" decode=false

  local OPTIND opt
  while getopts "df:o:" opt; do
    case ${opt} in
      d) decode=true ;;
      f) input_file="$OPTARG" ;;
      o) output_file="$OPTARG" ;;
      \?)
        echo "Usage: base64-cli [-d] [-f file] [-o file] [string]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))
  input_str="$*"

  local b64_flag=() verb="Encoded"
  if [ "$decode" = true ]; then
    b64_flag=(-d)
    verb="Decoded"
  fi

  local result=""

  if [ -n "$input_file" ]; then
    if [ ! -f "$input_file" ]; then
      echo -e "${C_RED}🚨 Error: Input file '$input_file' not found.${C_RESET}" >&2
      return 1
    fi
    result=$(base64 "${b64_flag[@]}" < "$input_file")
  elif [ -n "$input_str" ]; then
    result=$(echo -n "$input_str" | base64 "${b64_flag[@]}")
  else
    if [ ! -t 0 ]; then
      result=$(base64 "${b64_flag[@]}")
    else
      echo "Usage: base64-cli [-d] [-f file] [-o file] [string]" >&2
      return 1
    fi
  fi

  if [ -n "$output_file" ]; then
    echo -n "$result" > "$output_file"
    echo -e "${C_GREEN}✅ ${verb} output written to $output_file${C_RESET}"
  else
    echo "$result"
  fi
}

#######################################
# System: Encode a string, file, or stream to Base64 (shortcut for `base64-cli`)
# Arguments:
#   -f <file>   Path to local input file
#   -o <file>   Path to write output file (defaults to stdout)
#   [string]    Literal string to encode if no file or stdin is provided
#######################################
base64-enc() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  base64-cli "$@"
}

#######################################
# System: Decode a Base64 string, file, or stream (shortcut for `base64-cli -d`)
# Arguments:
#   -f <file>   Path to local input file containing Base64 text
#   -o <file>   Path to write output file (defaults to stdout)
#   [string]    Literal Base64 string to decode if no file or stdin is provided
#######################################
base64-dec() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    mt-help "${FUNCNAME[0]}"
    return 0
  fi
  base64-cli -d "$@"
}
