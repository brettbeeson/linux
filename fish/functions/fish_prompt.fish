function fish_prompt
    # Capture status immediately before any other command runs
    set -l last_status $status
    set -l machine '?'

    if test -r ~/.machine
        set machine (string trim < ~/.machine)
        test -n "$machine"; or set machine '?'
    end

    # Determine prompt color based on exit status
    set -l prompt_color normal
    if test $last_status -ne 0
        set_color red
        set prompt_color red
    end

    # Print the prompt with conditional coloring
    printf '(%s) %s%s> %s' "$machine" (__short_pwd) (set_color $prompt_color) (set_color normal)
end

