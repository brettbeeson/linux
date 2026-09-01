complete -c jc -f -a "(systemctl list-unit-files --type=service --no-legend 2>/dev/null | string replace -r '\.service\s+.*$' '')"
