# ~/.bash.d/lib/mytools.awk
BEGIN {
    cat = "Uncategorized"
    in_doc = 0
    doc_desc = ""
}

# 1. Category Header Tracking
/^# [-=]{10,}/ {
    if (prev_line ~ /^# [^=A-Za-z0-9]*[A-Za-z0-9]/ && prev2_line ~ /^# [-=]{10,}/) {
        cat_name = substr(prev_line, 3)
        sub(/^[ \t]+/, "", cat_name)
        sub(/[ \t#]+$/, "", cat_name)
        if (cat_name != "" && cat_name != "ALIASES" && cat_name != "FUNCTIONS") {
            cat = cat_name
        }
    }
}

# 2. Google Style Block Tracking
/^#######################################/ { 
    if (in_doc == 0) {
        in_doc = 1
        doc_desc = ""
    }
    # If in_doc is 1, it's the closing block. We skip it without wiping doc_desc.
    next 
}

# Capture the very first text line of the block as the short description
/^# [a-zA-Z]/ { 
    if (in_doc && doc_desc == "") {
        doc_desc = substr($0, 3)
    }
}

# Reset block tracking if we hit a blank line or non-comment
/^[^#]/ { 
    if (in_doc && !($0 ~ /^[a-zA-Z0-9_-]+\(\)[ \t]*\{/ || $0 ~ /^alias /)) {
        in_doc = 0
        doc_desc = ""
    }
}

# 3. Match Functions & Aliases immediately following a block
/^[a-zA-Z0-9_-]+\(\)[ \t]*\{/ {
    if (in_doc && doc_desc != "") {
        match($1, /^[a-zA-Z0-9_-]+/)
        name = substr($1, 1, RLENGTH)
        print "func\t" cat "\t" name "\t" doc_desc
    }
    in_doc = 0
    doc_desc = ""
}

/^alias [a-zA-Z0-9_-]+=/ {
    if (in_doc && doc_desc != "") {
        match($0, /^alias [a-zA-Z0-9_-]+/)
        name = substr($0, 7, RLENGTH - 6)
        print "alias\t" cat "\t" name "\t" doc_desc
    }
    in_doc = 0
    doc_desc = ""
}

{
    prev2_line = prev_line
    prev_line = $0
}
