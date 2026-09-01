#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/linux}"

if [[ ! -d "$DOTFILES_DIR/fish" ]]; then
    echo "Expected repo at: $DOTFILES_DIR" >&2
    exit 1
fi

install_packages() {
    local missing=()

    command -v fish >/dev/null 2>&1 || missing+=(fish)
    command -v fzf >/dev/null 2>&1 || missing+=(fzf)
    command -v direnv >/dev/null 2>&1 || missing+=(direnv)

    if ((${#missing[@]} == 0)); then
        return
    fi

    echo "Installing: ${missing[*]}"

    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y "${missing[@]}"
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y "${missing[@]}"
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --needed --noconfirm "${missing[@]}"
    else
        echo "No supported package manager found." >&2
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
        echo "Backing up $target -> $backup"
        mv "$target" "$backup"
    fi

    ln -sfn "$source" "$target"
}

install_packages

mkdir -p "$HOME/.config/fish/functions"
mkdir -p "$HOME/.config/fish/completions"

safe_link "$DOTFILES_DIR/fish/config.fish" \
          "$HOME/.config/fish/config.fish"

for file in "$DOTFILES_DIR"/fish/functions/*.fish; do
    [[ -e "$file" ]] || continue
    safe_link "$file" "$HOME/.config/fish/functions/$(basename "$file")"
done

for file in "$DOTFILES_DIR"/fish/completions/*.fish; do
    [[ -e "$file" ]] || continue
    safe_link "$file" "$HOME/.config/fish/completions/$(basename "$file")"
done

if [[ ! -e "$HOME/.machine" ]]; then
    hostname -s > "$HOME/.machine"
    echo "Created ~/.machine: $(cat "$HOME/.machine")"
fi

if [[ ! -e "$HOME/.config/fish/local.fish" ]]; then
    cat > "$HOME/.config/fish/local.fish" <<'EOF'
# Machine-specific Fish configuration.
# This file is intentionally outside the public repo.
EOF
fi

echo
echo "Fish shell setup installed."
echo "Machine label: $(cat "$HOME/.machine")"
echo "Start with: fish"
echo "Optional login shell: chsh -s \"$(command -v fish)\""
