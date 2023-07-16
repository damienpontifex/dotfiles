export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="amuse"

HIST_STAMPS="yyyy-mm-dd"



# Ensure `code` command is available
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

[ -d /opt/homebrew/bin ] && export PATH="/opt/homebrew/bin:$PATH"
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.dotnet/tools" ] && export PATH="$HOME/.dotnet/tools:$PATH"
[ -d /usr/local/share/dotnet ] && export PATH="/usr/local/share/dotnet:$PATH"

plugins=(
  # Shortcuts available https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
  git
  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl
  helm
  kube-ps1
  zsh-syntax-highlighting
  vscode
  colored-man-pages
  dotenv  # Auto load .env file when you cd into project root directory
  vi-mode
 kubectl)
source $ZSH/oh-my-zsh.sh
if [[ "$(tmux display-message -p '#S')" != stream ]]; then
  RPROMPT='$(az account show --output tsv --query "name") $(kube_ps1)'
fi

[ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

[ -x "$(command -v brew)" ] && \
  [ -f "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" && \
  bindkey '^ ' autosuggest-accept

alias uuid='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" |  pbcopy && echo "Copied guid to clipboard"'

export EDITOR=nvim

function tm {
  SESSION_NAME=${1:-default}
  tmux new-session -A -s "${SESSION_NAME}"
}

function set-proxy {
  https_proxy=wxmbp.localdomain:8080
}
function unset-proxy {
  unset https_proxy
}

export NVM_DIR="$HOME/.nvm"
mkdir -p "${NVM_DIR}"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

function new-tsc-project {
  npm init -y

  echo '{\n  "extends": "@tsconfig/node14"\n}' > tsconfig.json

  local PACKAGE_JSON=$(jq $'
  .scripts.build = "esbuild index.ts --bundle --minify --sourcemap --platform=node --outfile=bin/index.js" |
  .scripts.start = "nodemon --ext ts --ignore ./bin --exec \'npm run build && node --enable-source-maps ./bin/index.js\'"' package.json)
  echo $PACKAGE_JSON > package.json

  npm i -D @tsconfig/node14 @types/node ts-node typescript nodemon esbuild
  touch index.ts
}

### dotfiles ###
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias config=dotfiles

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
if [[ -x $(command -v nvm) ]]; then
  nvm use stable
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ponti/.google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ponti/.google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ponti/.google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ponti/.google-cloud-sdk/completion.zsh.inc'; fi

source /Users/ponti/.docker/init-zsh.sh || true # Added by Docker Desktop

