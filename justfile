default:
    just --list
    
commit:
    git add . && git commit -m "auto" && git push

update server:
    test -z "$(git status --porcelain)" 
    ./update-remote.sh {{ server }}
