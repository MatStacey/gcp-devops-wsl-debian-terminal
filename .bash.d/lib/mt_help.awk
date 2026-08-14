# ~/.bash.d/lib/mt_help.awk
# Extracts and colorizes the documentation block and declaration for a specific target.
# Requires '-v target="<command_name>"'

/^#######################################/ { block = $0 "\n"; in_block = 1; next }
in_block && /^#/ { block = block $0 "\n"; next }
in_block && !/^#/ {
    if ($0 ~ "^"target"\(\) [ \t]*\{" || $0 ~ "^alias "target"=") {
        print "\033[36m" block "\033[0m"
        print "\033[1;32m" $0 "\033[0m"
        exit
    }
    in_block = 0
    block = ""
}
!in_block && ($0 ~ "^"target"\(\) [ \t]*\{" || $0 ~ "^alias "target"=") {
    print "\033[1;32m" $0 "\033[0m"
    exit
}
