# shellcheck shell=bash
# ------------------------------------------
# Base64 Encoding & Decoding Utilities
# ------------------------------------------

#######################################
# Base64: Encode a string, file, or stream to Base64
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

  local input_file="" output_file="" input_str=""

  local OPTIND opt
  while getopts "f:o:" opt; do
    case ${opt} in
      f) input_file="$OPTARG" ;;
      o) output_file="$OPTARG" ;;
      \?)
        echo "Usage: base64-enc [-f file] [-o file] [string]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))
  input_str="$*"

  local encoded=""

  if [ -n "$input_file" ]; then
    if [ ! -f "$input_file" ]; then
      echo -e "${C_RED}🚨 Error: Input file '$input_file' not found.${C_RESET}" >&2
      return 1
    fi
    encoded=$(base64 < "$input_file")
  elif [ -n "$input_str" ]; then
    encoded=$(echo -n "$input_str" | base64)
  else
    if [ ! -t 0 ]; then
      encoded=$(base64)
    else
      echo "Usage: base64-enc [-f file] [-o file] [string]" >&2
      return 1
    fi
  fi

  if [ -n "$output_file" ]; then
    echo -n "$encoded" > "$output_file"
    echo -e "${C_GREEN}✅ Encoded output written to $output_file${C_RESET}"
  else
    echo "$encoded"
  fi
}

#######################################
# Base64: Decode a Base64 string, file, or stream
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

  local input_file="" output_file="" input_str=""

  local OPTIND opt
  while getopts "f:o:" opt; do
    case ${opt} in
      f) input_file="$OPTARG" ;;
      o) output_file="$OPTARG" ;;
      \?)
        echo "Usage: base64-dec [-f file] [-o file] [string]" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))
  input_str="$*"

  local decoded=""

  if [ -n "$input_file" ]; then
    if [ ! -f "$input_file" ]; then
      echo -e "${C_RED}🚨 Error: Input file '$input_file' not found.${C_RESET}" >&2
      return 1
    fi
    decoded=$(base64 -d < "$input_file")
  elif [ -n "$input_str" ]; then
    decoded=$(echo -n "$input_str" | base64 -d)
  else
    if [ ! -t 0 ]; then
      decoded=$(base64 -d)
    else
      echo "Usage: base64-dec [-f file] [-o file] [string]" >&2
      return 1
    fi
  fi

  if [ -n "$output_file" ]; then
    echo -n "$decoded" > "$output_file"
    echo -e "${C_GREEN}✅ Decoded output written to $output_file${C_RESET}"
  else
    echo "$decoded"
  fi
}
