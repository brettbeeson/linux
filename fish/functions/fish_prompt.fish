function fish_prompt
    set -l machine '?'

    if test -r ~/.machine
        set machine (string trim < ~/.machine)
        test -n "$machine"; or set machine '?'
    end

    printf '(%s) %s> ' "$machine" (__short_pwd)
end
