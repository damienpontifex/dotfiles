#!/bin/bash

# git
alias gs='git status'
alias gd='git diff'

alias vim=nvim
# alias vim=vi

### dotfiles ###
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias config=dotfiles

### Navigation ###
alias ls='ls -p'
alias c='clear'

### Jupyter Notebooks ###
alias jn='jupyter notebook'
alias jn-theme-dark='jt -t oceans16 -cellw 90%'
alias jn-theme-light='jt -t grade3 -cellw 90%'
alias jn-theme-reset='jt -r'

### Utility ###
alias check_disk='sudo fsck -fy'
alias getmyip='dig +short myip.opendns.com @resolver1.opendns.com'

### Static HTTP Server ###
alias http-server="python -m http.server"

### Powershell ###
if [ -x $(command -v pwsh) ]; then
    alias powershell=pwsh
fi

# weather
alias weather='curl -4 http://wttr.in/'

alias tm='$HOME/.tm'
alias t=tm
alias tvim='tm --vim'

function gi() {
  if [ $# -eq 0 ]; then
    echo 'Usage gi <comma-separated lang> >> .gitignore'
    echo 'Supported languages:'
    curl -L -s https://www.gitignore.io/api/list;
  else
    curl -L -s https://www.gitignore.io/api/$@
  fi
  
}

alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
