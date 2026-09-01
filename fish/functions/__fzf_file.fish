function __fzf_file
    type -q fzf; or return

    set -l selected

    if type -q fd
        set selected (
            fd --hidden --follow --exclude .git . |
            fzf --height=60% --reverse --border --prompt='file> '
        )
    else
        set selected (
            find . -path '*/.git' -prune -o -type f -print 2>/dev/null |
            string replace -r '^\./' '' |
            fzf --height=60% --reverse --border --prompt='file> '
        )
    end

    if test -n "$selected"
        commandline -i -- (string escape -- "$selected")
    end
end
