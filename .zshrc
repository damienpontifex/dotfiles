export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="amuse"

HIST_STAMPS="yyyy-mm-dd"

zstyle ':omz:update' mode auto

# Ensure `code` command is available
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export XDG_CONFIG_HOME="$HOME/.config"

# Ensure postgresql tools are in path
export PATH="$PATH:$(brew --prefix postgresql@16)/bin"

[ -d /opt/homebrew/bin ] && export PATH="/opt/homebrew/bin:$PATH"
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.dotnet/tools" ] && export PATH="$HOME/.dotnet/tools:$PATH"
[ -d /usr/local/share/dotnet ] && export PATH="/usr/local/share/dotnet:$PATH"

[ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-nvm" ] || git clone https://github.com/lukechilds/zsh-nvm "${HOME}/.oh-my-zsh/custom/plugins/zsh-nvm"
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
[ -d "$HOME/.oh-my-zsh/custom/plugins/you-should-use" ] || git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$HOME/.oh-my-zsh/custom/plugins/you-should-use"

plugins=(
  git # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl
  # helm
  # kube-ps1
  # kubectl
  zsh-syntax-highlighting
  vscode
  colored-man-pages
  direnv
  # dotenv  # Auto load .env file when you cd into project root directory
  vi-mode
  # zsh-nvm
  docker
  docker-compose
  you-should-use
)
source $ZSH/oh-my-zsh.sh

if [ -x "$(command -v az)" ]; then
  RPROMPT='$(az account show --output tsv --query "name")'
fi
# Disable AWS CLI pager
export AWS_PAGE=""

[ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

[ -x "$(command -v brew)" ] && \
  [ -f "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" && \
  bindkey '^ ' autosuggest-accept

alias uuid='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" |  pbcopy && echo "Copied guid to clipboard"'

export EDITOR=nvim

function gmain {
  git switch $(git_main_branch) && git pull --prune && git clean-gone
}

function update-packages {
  brew update
  brew bundle install --upgrade --global --cleanup --verbose
  npm update --global
  dotnet tool update --global --all
  sudo dotnet workload update
  rustup update
  cargo install --list | grep : | awk '{print $1}' | xargs -I {} cargo install {}
  nvim --headless -c "Lazy! update" -c "MasonUpdate" -c "qa"
}

# Make sure we can run `make` in the current directory or any parent directory
function make {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/Makefile" ]; then
      command make -C "$dir" "$@"
      return
    fi
    dir="$(dirname "$dir")"
  done
  echo "No Makefile found in current or parent directories." >&2
  return 1
}

# Ensure brew packages are managed in ~/.Brewfile
# brew() {
#   if [[ "$1" == "install" ]]; then
#     echo "❌ Direct 'brew install' is disabled."
#     echo "✅ Please edit your ~/.Brewfile and use 'brew bundle' instead."
#     return 1
#   else
#     command brew "$@"
#   fi
# }

function tm {
  tmux new-session -A -s "${1:-default}"
}

### dotfiles ###
function config() {
  /usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}
# Enable completion for the function by telling Zsh to treat it like `git`
compdef dotfiles=git

alias icloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/'

### Utility ###
alias check_disk='sudo fsck -fy'
alias getmyip='dig +short myip.opendns.com @resolver1.opendns.com'

### Static HTTP Server ###
alias http-server="python3 -m http.server"
[ -x "$(command -v brew)" ] && [ -d "$(brew --prefix python3)" ] && export PATH="$(brew --prefix python3)/libexec/bin:$PATH"

# Use llvm from homebrew
if [ -x "$(command -v brew)" ]; then
  export PATH="$(brew --prefix llvm)/bin:$PATH"
fi

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# Node and npm
export NODE_ENV=development
if [[ -x $(command -v fnm) ]]; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# golang
if [[ -x $(command -v go) ]]; then
  export GOPATH=$(go env GOPATH)
  export PATH="$PATH:${GOPATH}/bin"
fi

# .NET
export ASPNETCORE_ENVIRONMENT=Development

# Alias watch so we can use other aliases - a trailing space in VALUE causes the next word to be checked for alias substitution
alias watch='watch '

# az cli
alias azswitch='az account list --output tsv --query "[].name" | fzf | xargs -r -I {} az account set --subscription "{}"'
[ -f /usr/local/etc/bash_completion.d/az ] && source /usr/local/etc/bash_completion.d/az

# anaconda
[[ -x $(command -v brew) ]] && export PATH="$(brew --prefix)/anaconda3/bin:$PATH"

# k8s
export KUBE_EDITOR=nvim
[[ -x $(command -v kubectl) ]] && source <(kubectl completion zsh) && complete -F __start_kubectl k
alias kcu='kubectl config get-contexts -o name | fzf | xargs -r -I {} kubectl config use-context "{}"'
function kgsecv {
  kgsec "${1}" -o yaml | yq '.data | map_values(@base64d)'
}

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

export OPENSSL_ROOT_DIR="/usr/local/opt/openssl"
export OPENSSL_LIBRARIES="${OPENSSL_ROOT_DIR}"
export LIBRARY_PATH="$LIBRARY_PATH:${OPENSSL_ROOT_DIR}/lib"

# Use Moby BuildKit modern docker build engine
export DOCKER_BUILDKIT=1

# TODO: Refine these
# function cd_with_fzf {
#   cd $HOME && fd -t d | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden | xargs -I '{}' cd "{}"
# }
# zle -N cd_with_fzf
# bindkey '^f' cd_with_fzf
# function open_with_fzf {
#   fd -t f -H -I | fzf | xargs -I '{}' open "{}"
# }
# zle -N open_with_fzf
# bindkey '^o' open_with_fzf

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"


# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/completion.zsh.inc"; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
. "/Users/ponti/.deno/env"

export GPG_TTY=$(tty)
