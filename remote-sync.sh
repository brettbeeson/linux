#!/usr/bin/env bash
set -euo pipefail

REPO="${LINUX_REPO:-https://github.com/brettbeeson/linux.git}"

usage() {
    cat <<'EOF'
Usage:
  remote-sync.sh hosts.txt
  remote-sync.sh host1 host2 user@host3

Optional:
  LINUX_REPO=https://github.com/brettbeeson/linux.git
EOF
}

if (($# == 0)); then
    usage
    exit 2
fi

hosts=()

if (($# == 1)) && [[ -f "$1" ]]; then
    while IFS= read -r line; do
        line="${line%%#*}"
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"
        [[ -n "$line" ]] && hosts+=("$line")
    done < "$1"
else
    hosts=("$@")
fi

for host in "${hosts[@]}"; do
    echo
    echo "===== $host ====="

    ssh "$host" bash -s -- "$REPO" <<'REMOTE'
set -euo pipefail

repo="$1"
dest="$HOME/linux"

if [[ -d "$dest/.git" ]]; then
    git -C "$dest" pull --ff-only
elif [[ -e "$dest" ]]; then
    echo "$dest exists but is not a Git checkout; refusing to overwrite." >&2
    exit 1
else
    git clone "$repo" "$dest"
fi

DOTFILES_DIR="$dest" "$dest/install.sh"
REMOTE
done
