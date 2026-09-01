function fish_user_key_bindings
    # Prefix/stem history search.
    bind \e\[A history-prefix-search-backward
    bind \e\[B history-prefix-search-forward
    bind \eOA history-prefix-search-backward
    bind \eOB history-prefix-search-forward

    # Fuzzy tools.
    if type -q fzf
        bind \cr __fzf_history
        bind \ct __fzf_file
        bind \ec __fzf_cd
    end
end
