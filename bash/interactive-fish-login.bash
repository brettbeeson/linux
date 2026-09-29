# Source from ~/.bashrc to use Fish for interactive logins only.
# Non-interactive SSH commands retain Bash, preserving automation compatibility.
if [[ $- == *i* ]] && command -v fish >/dev/null 2>&1; then
    exec fish -l
fi
