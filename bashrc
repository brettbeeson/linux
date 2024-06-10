bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# function to set terminal title  
function st() {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}

alias sc='systemctl'
alias jc='journalctl'

PATH=$PATH:$HOME/.local/bin:$HOME/bin

vsh() {
ip=$(vip "$1")
if [ -n "$ip" ]; then 
echo "$ip"
ssh pi\@$"$ip" "${@:2}"
fi
}

vip() {
ssh live.phisaver.com vip "$1"
}

vips() {
ssh live.phisaver.com vips
}

# no event sub to stop ! password error
set +H

eval "$(direnv hook bash)"
