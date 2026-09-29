# Common Fish configuration.

# Disable Fish's default greeting.
set -g fish_greeting

# Common user executable locations.
fish_add_path "$HOME/.local/bin" "$HOME/bin"

# Machine-specific settings.
# This file is deliberately outside the public ~/linux repo.
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end

# direnv
if type -q direnv
    direnv hook fish | source
end

# Shared aliases/simple helpers.
if test -f ~/linux/fish/conf.d/aliases.fish
    source ~/linux/fish/conf.d/aliases.fish
end
