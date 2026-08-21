BEGIN { flag=0; buffer="" }

# Buffer consecutive comment lines
/^#/ {
    buffer = buffer $0 "\n"
    next
}

# If it's the target alias, print the buffer and the alias, then exit
$0 ~ "^alias " target "=" {
    printf "%s", buffer
    print $0
    exit
}

# If it's the target function, print the buffer, start the flag, and clear buffer
$0 ~ "^" target "\\(\\)[ \t]*\\{" {
    printf "%s", buffer
    print $0
    flag=1
    buffer=""
    next
}

# If we are inside the function, keep printing until the closing brace
flag {
    print $0
    if ($0 ~ /^}$/) exit
}

# If it's neither a comment nor the target, clear the buffer
{
    if (!flag) buffer=""
}
