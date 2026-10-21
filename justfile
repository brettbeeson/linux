default:
    just --list
    
commit:
    git add . && git commit -m "auto" && git push

update server:
    test -z "$(git status --porcelain)" || echo "Git needs updating. Run `just commit`"
    ./update-remote.sh {{ server }}
