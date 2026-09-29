# Directory shortcuts.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Listing.
alias ll='ls -lah'

# systemd.
alias sc='sudo systemctl'
alias jc='journalctl -f -n 50 -u'

# Default editor.
# local.fish may set EDITOR before this file is sourced.
if not set -q EDITOR
    if type -q nvim
        set -gx EDITOR nvim
    else if type -q vim
        set -gx EDITOR vim
    else
        set -gx EDITOR vi
    end
end

if not set -q VISUAL
    set -gx VISUAL $EDITOR
end
