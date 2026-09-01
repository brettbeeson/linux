function __short_pwd
    set -l current (pwd)
    set -l home_re (string escape --style=regex "$HOME")

    if test "$current" = "$HOME"
        echo '~'
        return
    end

    if string match -rq "^$home_re/" "$current"
        set current (string replace -r "^$home_re/" '' "$current")
        set -l parts (string split / "$current")

        if test (count $parts) -eq 1
            echo "~/$parts[1]"
            return
        end

        set -l out '~'
        for i in (seq 1 (math (count $parts) - 1))
            set -l p $parts[$i]
            if test -n "$p"
                set out "$out/"(string sub -s 1 -l 1 -- "$p")
            end
        end

        set out "$out/$parts[-1]"
        echo "$out"
        return
    end

    set -l parts (string split / "$current")
    set -l nonempty
    for p in $parts
        test -n "$p"; and set -a nonempty "$p"
    end

    if test (count $nonempty) -le 1
        echo "$current"
        return
    end

    set -l out ''
    for i in (seq 1 (math (count $nonempty) - 1))
        set out "$out/"(string sub -s 1 -l 1 -- "$nonempty[$i]")
    end
    set out "$out/$nonempty[-1]"
    echo "$out"
end
