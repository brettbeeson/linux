function fish_prompt
    set -l machine '?'

    if test -r ~/.machine
        set machine (string trim < ~/.machine)
        test -n "$machine"; or set machine '?'
    end

    set -l pwd_display (__short_pwd)

    printf '(%s) %s> ' "$machine" "$pwd_display"
end
