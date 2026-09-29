function __short_pwd
    set -l current (pwd)
    set -l home_re (string escape --style=regex "$HOME")

    if test "$current" = "$HOME"
        echo '~'
        return
    end

    # Inside home:
    # /home/user/phisaver/server -> ~/p/server
    if string match -rq "^$home_re/" "$current"
        set current (string replace -r "^$home_re/" '' "$current")
        set -l parts (string split / "$current")

        if test (count $parts) -eq 1
            echo "~/$parts[1]"
            return
        end

        set -l out '~'

        for i in (seq 1 (math (count $parts) - 1))
            set -l part $parts[$i]

            if test -n "$part"
                set out "$out/"(string sub -s 1 -l 1 -- "$part")
            end
        end

        echo "$out/$parts[-1]"
        return
    end

    # Outside home: abbreviate parent path components.
    set -l parts (string split / "$current")
    set -l nonempty

    for part in $parts
        test -n "$part"; and set -a nonempty "$part"
    end

    if test (count $nonempty) -le 1
        echo "$current"
        return
    end

    set -l out ''

    for i in (seq 1 (math (count $nonempty) - 1))
        set out "$out/"(string sub -s 1 -l 1 -- "$nonempty[$i]")
    end

    echo "$out/$nonempty[-1]"
end
