# ~/.bash.d/lib/awk/mt_help.awk
# Extracts the documentation block and declaration for a specific target.
# Requires '-v target="<command_name>"'

/^#######################################/ { 
    if (in_block) {
        block = block $0 "\n"
    } else {
        in_block = 1
        block = $0 "\n"
    }
    next 
}
in_block && /^#/ { block = block $0 "\n"; next }
in_block && !/^#/ {
    if ($0 ~ "^"target"\(\) [ \t]*\{" || $0 ~ "^alias "target"=") {
        printf "%s", block
        print $0
        exit
    }
    in_block = 0
    block = ""
}
!in_block && ($0 ~ "^"target"\(\) [ \t]*\{" || $0 ~ "^alias "target"=") {
    print $0
    exit
}