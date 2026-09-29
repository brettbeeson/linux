function fish_user_key_bindings
    # Up/Down search history using the current command-line prefix.
    bind \e\[A history-prefix-search-backward
    bind \e\[B history-prefix-search-forward

    # Application cursor-key mode used by some terminals.
    bind \eOA history-prefix-search-backward
    bind \eOB history-prefix-search-forward

    if type -q fzf
        # Ctrl-R: fuzzy history.
        bind \cr __fzf_history

        # Ctrl-T: fuzzy file selection.
        bind \ct __fzf_file

        # Alt-C: fuzzy directory selection and cd.
        bind \ec __fzf_cd
    end
end
