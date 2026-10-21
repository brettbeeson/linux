default:
    just --list
    
run *args:
    test -z "$(git status --porcelain)" 
    {{ args }}
