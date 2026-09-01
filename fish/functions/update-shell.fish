function update-shell --description 'Update ~/linux and reload Fish'
    set -l repo "$HOME/linux"

    if not test -d "$repo/.git"
        echo "Not a Git checkout: $repo" >&2
        return 1
    end

    git -C "$repo" pull --ff-only; or return
    "$repo/install.sh"; or return

    exec fish
end
