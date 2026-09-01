# Common interactive abbreviations / aliases.

# Directory shortcuts.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Listing.
alias ll='ls -lah'

# systemd.
alias sc='sudo systemctl'

# Editors: allow local.fish to override these.
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
