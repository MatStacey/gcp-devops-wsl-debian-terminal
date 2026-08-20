BEGIN { flag=0 }
$0 ~ "^alias " target "=" { print; exit }
$0 ~ "^" target "\\(\\)[ \t]*\\{" { flag=1 }
flag { print; if ($0 ~ /^}$/) exit }
