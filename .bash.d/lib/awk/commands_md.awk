# ~/.bash.d/lib/awk/commands_md.awk
BEGIN {
    FS = "\t"
    prev_cat = ""
}
$1 == target_type {
    if ($2 != prev_cat) {
        if (prev_cat != "") print ""
        print "### " $2
        print "| Command | Description |"
        print "|---|---|"
        prev_cat = $2
    }
    name = $3
    desc = $4
    gsub(/\|/, "\\|", name)
    gsub(/\|/, "\\|", desc)
    printf "| `%s` | %s |\n", name, desc
}
