#!/usr/bin/env bash
set -euo pipefail

LINUX_DIR="${LINUX_DIR:-$HOME/linux}"

if [[ ! -d "$LINUX_DIR/fish" ]]; then
    echo "Expected repository at: $LINUX_DIR" >&2
    exit 1
fi

install_packages() {
    local missing=()

    command -v fish >/dev/null 2>&1 || missing+=(fish)
    command -v fzf >/dev/null 2>&1 || missing+=(fzf)
    command -v direnv >/dev/null 2>&1 || missing+=(direnv)
    command -v just >/dev/null 2>&1 || missing+=(just)
    command -v podman >/dev/null 2>&1 || missing+=(podman)

    if ! command -v uv >/dev/null 2>&1; then
        if command -v snap >/dev/null 2>&1; then
            echo "Installing: astral-uv (snap)"
            sudo snap install astral-uv --classic
        else
            echo "snap not found; install uv manually: https://docs.astral.sh/uv/" >&2
        fi
    fi

    if ((${#missing[@]} == 0)); then
        return
    fi

    echo "Installing: ${missing[*]}"

    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y "${missing[@]}"
    # elif command -v dnf >/dev/null 2>&1; then
    #     sudo dnf install -y "${missing[@]}"
    # elif command -v pacman >/dev/null 2>&1; then
    #     sudo pacman -Sy --needed --noconfirm "${missing[@]}"
    else
        echo "Unsupported package manager." >&2
        echo "Install manually: ${missing[*]}" >&2
        exit 1
    fi
}

safe_link() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [[ -e "$target" && ! -L "$target" ]]; then
        local backup="${target}.pre-linux.$(date +%Y%m%d%H%M%S)"
        echo "Backing up:"
        echo "  $target"
        echo "-> $backup"
        mv "$target" "$backup"
    fi

    ln -sfn "$source" "$target"
}

remove_stale_links() {
    local directory="$1"
    local managed_directory="$2"
    local link source

    for link in "$directory"/*.fish; do
        [[ -L "$link" && ! -e "$link" ]] || continue
        source="$(readlink "$link")"
        if [[ "$source" == "$managed_directory/"* ]]; then
            rm "$link"
        fi
    done
}

ensure_interactive_fish_login() {
    local target="$HOME/.bashrc"
    local source_line="source \"$LINUX_DIR/bash/interactive-fish-login.bash\""

    touch "$target"
    if ! grep -Fqx "$source_line" "$target"; then
        {
            printf '\n# Start Fish for interactive logins; retain Bash for SSH commands.\n'
            printf '%s\n' "$source_line"
        } >> "$target"
    fi
}

# llm: set global git identity (only if unset, so existing config is never clobbered).
# Override per run with GIT_USER_NAME / GIT_USER_EMAIL.
ensure_git_identity() {
    local name="${GIT_USER_NAME:-Brett Beeson}"
    local email="${GIT_USER_EMAIL:-brettbeeson@fastmail.com}"

    command -v git >/dev/null 2>&1 || return 0

    if [[ -z "$(git config --global user.name || true)" ]]; then
        git config --global user.name "$name"
        echo "Set git user.name: $name"
    fi
    if [[ -z "$(git config --global user.email || true)" ]]; then
        git config --global user.email "$email"
        echo "Set git user.email: $email"
    fi
}

install_packages

ensure_git_identity

mkdir -p "$HOME/.config/fish/functions"
mkdir -p "$HOME/.config/fish/completions"

remove_stale_links \
    "$HOME/.config/fish/functions" \
    "$LINUX_DIR/fish/functions"

remove_stale_links \
    "$HOME/.config/fish/completions" \
    "$LINUX_DIR/fish/completions"

safe_link \
    "$LINUX_DIR/fish/config.fish" \
    "$HOME/.config/fish/config.fish"

for file in "$LINUX_DIR"/fish/functions/*.fish; do
    [[ -e "$file" ]] || continue
    safe_link \
        "$file" \
        "$HOME/.config/fish/functions/$(basename "$file")"
done

for file in "$LINUX_DIR"/fish/completions/*.fish; do
    [[ -e "$file" ]] || continue
    safe_link \
        "$file" \
        "$HOME/.config/fish/completions/$(basename "$file")"
done

ensure_interactive_fish_login

if [[ ! -e "$HOME/.machine" ]]; then
    hostname -s > "$HOME/.machine"
    echo "Created ~/.machine: $(cat "$HOME/.machine")"
fi

if [[ ! -e "$HOME/.config/fish/local.fish" ]]; then
    cat > "$HOME/.config/fish/local.fish" <<'EOF'
# Machine-specific Fish configuration.
#
# This file is intentionally outside the public ~/linux repository.
#
# Examples:
#
# set -gx AWS_PROFILE dev
# set -gx EDITOR nvim
EOF
fi

echo
echo "Fish shell setup installed."
echo
echo "Machine label: $(cat "$HOME/.machine")"
echo "Start Fish: fish"
echo
echo "Interactive Bash logins now start Fish; non-interactive SSH commands keep Bash."
