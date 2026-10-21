default:
    just --list
    
update server:
    test -z "$(git status --porcelain)" 
    remote-sync.sh {{ server }}
