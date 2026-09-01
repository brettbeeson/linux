function __fzf_cd
    type -q fzf; or return

    set -l selected

    if type -q fd
        set selected (
            fd --type d --hidden --follow --exclude .git . |
            fzf --height=60% --reverse --border --prompt='cd> '
        )
    else
        set selected (
            find . -path '*/.git' -prune -o -type d -print 2>/dev/null |
            string replace -r '^\./' '' |
            fzf --height=60% --reverse --border --prompt='cd> '
        )
    end

    if test -n "$selected"
        cd -- "$selected"
        commandline -f repaint
    end
end
