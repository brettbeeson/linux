default:
    just --list
    
update server:
    test -z "$(git status --porcelain)" 
    ./update-remote.sh {{ server }}
