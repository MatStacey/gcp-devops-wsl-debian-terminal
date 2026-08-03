BEGIN {
    cat = "Uncategorized"
    c_func  = "\033[1;34m"
    c_alias = "\033[1;32m"
    c_cat   = "\033[1;33m"
    c_item  = "\033[1;36m"
    c_reset = "\033[0m"
}

# Track 3-line header blocks: Dashed, Text, Dashed
{
    if ($0 ~ /^# [-=]{10,}/ && prev_line ~ /^# [^=A-Za-z0-9]*[A-Za-z0-9]/ && prev_line !~ /^# [-=]{10,}/ && prev2_line ~ /^# [-=]{10,}/) {
        cat_name = substr(prev_line, 3)
        sub(/^[ \t]+/, "", cat_name)
        
        # NEW: Also strip trailing '#' characters along with spaces
        sub(/[ \t#]+$/, "", cat_name)
        
        if (cat_name != "" && cat_name != "ALIASES" && cat_name != "FUNCTIONS") {
            cat = cat_name
        }
    }
    
    # Match Functions
    if ($0 ~ /^[a-zA-Z0-9_-]+\(\).*# => /) {
        match($0, /^[a-zA-Z0-9_-]+/)
        name = substr($0, 1, RLENGTH)
        desc = substr($0, index($0, "# => ") + 5)
        
        if (!f_seen[cat]++) f_order[++f_count] = cat
        funcs[cat] = funcs[cat] sprintf("    - %s%-25s%s %s\n", c_item, name, c_reset, desc)
    }
    
    # Match Aliases
    if ($0 ~ /^alias [a-zA-Z0-9_-]+=/ && $0 ~ /# => /) {
        match($0, /^alias [a-zA-Z0-9_-]+/)
        name = substr($0, 7, RLENGTH - 6)
        desc = substr($0, index($0, "# => ") + 5)
        
        if (!a_seen[cat]++) a_order[++a_count] = cat
        aliases[cat] = aliases[cat] sprintf("    - %s%-25s%s %s\n", c_item, name, c_reset, desc)
    }

    prev2_line = prev_line
    prev_line = $0
}

END {
    print c_func "FUNCTIONS" c_reset
    for (i = 1; i <= f_count; i++) {
        c = f_order[i]
        print "  " c_cat "[" c "]" c_reset
        print funcs[c]
    }
    
    print ""
    print c_alias "ALIASES" c_reset
    for (i = 1; i <= a_count; i++) {
        c = a_order[i]
        print "  " c_cat "[" c "]" c_reset
        print aliases[c]
    }
}
