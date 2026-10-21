#!/usr/bin/env bash
set -euo pipefail

# Remote machines only need read access, so use the public HTTPS URL.
REPO="${LINUX_REPO:-https://github.com/brettbeeson/linux.git}"

usage() {
    cat <<'EOF'
Usage:
  remote-sync.sh hosts.txt
  remote-sync.sh host1 host2 user@host3

Examples:
  ~/linux/remote-sync.sh ~/linux/hosts.txt
  ~/linux/remote-sync.sh nbm01 nbm02 ubuntu@staging

Optional repo override:
  LINUX_REPO=https://github.com/brettbeeson/linux.git \
      ~/linux/remote-sync.sh host1
EOF
}

if (($# == 0)); then
    usage
    exit 2
fi

hosts=()

if (($# == 1)) && [[ -f "$1" ]]; then
    while IFS= read -r line; do
        # Remove comments.
        line="${line%%#*}"

        # Trim leading whitespace.
        line="${line#"${line%%[![:space:]]*}"}"

        # Trim trailing whitespace.
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
    echo "Updating $dest"
    git -C "$dest" pull --ff-only

elif [[ -e "$dest" ]]; then
    echo "$dest exists but is not a Git checkout." >&2
    echo "Refusing to overwrite it." >&2
    exit 1

else
    echo "Cloning:"
    echo "  $repo"
    echo "-> $dest"
    git clone "$repo" "$dest"
fi

LINUX_DIR="$dest" "$dest/install.sh"
REMOTE
done
