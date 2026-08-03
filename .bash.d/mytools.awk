# ~/.bash.d/mytools.awk

BEGIN {
    cat = "Uncategorized"
    
    # Abstracted ANSI color codes for cleaner rendering logic
    c_func  = "\033[1;34m"
    c_alias = "\033[1;32m"
    c_cat   = "\033[1;33m"
    c_item  = "\033[1;36m"
    c_reset = "\033[0m"
}

# 1. Parse Headers: Peek at the line directly following a dashed/equals divider
/^# [-=]{10,}/ {
    getline next_line
    if (next_line ~ /^# [a-zA-Z0-9 _&\/:-]+$/) {
        cat_name = substr(next_line, 3)
        sub(/[ \t]+$/, "", cat_name) # Trim trailing whitespace
        
        # Ignore generic top-level file banners
        if (cat_name != "ALIASES" && cat_name != "FUNCTIONS") {
            cat = cat_name
        }
    }
    next
}

# 2. Parse Functions: Matches "func_name() { # => desc"
/^[a-zA-Z0-9_-]+\(\).*# => / {
    match($0, /^[a-zA-Z0-9_-]+/)
    name = substr($0, 1, RLENGTH)
    desc = substr($0, index($0, "# => ") + 5)
    
    # Track insertion order and format output
    if (!f_seen[cat]++) f_order[++f_count] = cat
    funcs[cat] = funcs[cat] sprintf("    - %s%-25s%s %s\n", c_item, name, c_reset, desc)
}

# 3. Parse Aliases: Matches "alias name=... # => desc"
/^alias [a-zA-Z0-9_-]+=/ && /# => / {
    match($0, /^alias [a-zA-Z0-9_-]+/)
    name = substr($0, 7, RLENGTH - 6)
    desc = substr($0, index($0, "# => ") + 5)
    
    # Track insertion order and format output
    if (!a_seen[cat]++) a_order[++a_count] = cat
    aliases[cat] = aliases[cat] sprintf("    - %s%-25s%s %s\n", c_item, name, c_reset, desc)
}

# 4. Render Final Output
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