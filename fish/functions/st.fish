function st --description 'Set terminal title'
    if test (count $argv) -eq 0
        printf '\e]0;%s\a' (prompt_pwd)
    else
        printf '\e]0;%s\a' (string join ' ' $argv)
    end
end
