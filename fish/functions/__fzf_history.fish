function __fzf_history
    type -q fzf; or return

    # Fish history is newest-first. Remove duplicates while preserving order.
    set -l selected (
        history |
        awk '!seen[$0]++' |
        fzf --height=60% --reverse --border --prompt='history> ' \
            --query=(commandline)
    )

    if test -n "$selected"
        commandline -- "$selected"
        commandline -f end-of-line
    end
end
