#!/bin/bash

# Source all dotfiles
for file in $HOME/.{bash_aliases,}; do
    [ -f $file ] && source $file
done

# Use vim for editing
export VISUAL=vim
export EDITOR=vim

# Node and npm
export NODE_ENV=development
export PATH=$HOME/.npm_global/bin:$PATH
export NPM_CONFIG_PREFIX=~/.npm_global

# golang
[ -x $(command -v go) ] && \
    export PATH=$PATH:$(go env GOPATH)/bin

# Use Azure AD for storage access by default 
export AZURE_STORAGE_AUTH_MODE="login"

# ASP.NET Core
export ASPNETCORE_ENVIRONMENT=Development

# Look in /usr/local/bin first
export PATH=/usr/local/bin:$PATH

# cd autocomplete to directories only
complete -d cd

[ -f $HOME/.git-completion.bash ] && \
  source $HOME/.git-completion.bash

git_branch() {
  local branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [ $? -eq 0 -a "$branch_name" ]; then
    echo -n " ($branch_name"
  
    if [ "$(git status -s 2> /dev/null)" ]; then
      # Set star as has changes
      echo -n " *"
    fi
    
    echo -n ")"
  fi
}

GREEN=$(tput setaf 10)
RESET=$(tput sgr 0)
YELLOW=$(tput setaf 11)
NORMAL='\[\e[0m\]'

export PS1="${RESET}\u@\h:${GREEN}\w${YELLOW}\$(git_branch)${NORMAL}\n\$ "

export PATH="$HOME/.local/flutter/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"

for file in $HOME/.gcloud/google-cloud-sdk/{path.bash.inc,completion.bash.inc}; do
  if [[ -f $file ]]; then
    source $file
  fi
done
unset file

if [[ -x $(command -v pyenv) ]]; then
  # So it installs python as a framework
  export PYTHON_CONFIGURE_OPTS="--enable-framework"
  eval "$(pyenv init -)"
  # Auto activate virtualenvs
  eval "$(pyenv virtualenv-init -)"
  export PATH="$(pyenv root)/shims:$PATH"
  export PATH="$(dirname $(pyenv which python)):$PATH"
fi

export PATH="$HOME/.local/bin:$PATH"

export PATH="/usr/local/opt/llvm/bin:$PATH"
