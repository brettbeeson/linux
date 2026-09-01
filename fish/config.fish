# Common Fish configuration.

set -g fish_greeting

# Keep user executables ahead of system defaults.
fish_add_path "$HOME/.local/bin" "$HOME/bin"

# Machine-specific overrides, deliberately outside the public repo.
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end

# direnv integration.
if type -q direnv
    direnv hook fish | source
end

# Prefix/stem history search.
bind \e\[A history-prefix-search-backward
bind \e\[B history-prefix-search-forward
bind \eOA history-prefix-search-backward
bind \eOB history-prefix-search-forward

# fzf integrations.
if type -q fzf
    bind \cr __fzf_history
    bind \ct __fzf_file
    bind \ec __fzf_cd
end

# Shared aliases / simple shell helpers.
if test -f ~/linux/fish/conf.d/aliases.fish
    source ~/linux/fish/conf.d/aliases.fish
end
