export ZSH="/Users/ponti/.oh-my-zsh"

ZSH_THEME="amuse"
# ZSH_THEME="agnoster"

HIST_STAMPS="yyyy-mm-dd"

# alias uuu="pbpaste | sed 's/\[.*\]/[default]/g' > ~/.aws/credentials"
alias uuu="aws-azure-login --no-prompt && aws codeartifact login --tool npm --repository UpstreamProxy --domain woodside --domain-owner 278364088108 --duration-seconds 43200 --namespace @uxd"

plugins=(
  # Shortcuts available https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
  git
  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl
  kubectl
  helm
  kube-ps1
  zsh-syntax-highlighting
  vscode
  colored-man-pages
  dotenv  # Auto load .env file when you cd into project root directory
)
source $ZSH/oh-my-zsh.sh
# PROMPT=$PROMPT'$(kube_ps1) '
# RPROMPT='k8s: $(kube_ps1)'

# Ensure zsh plugins available
[ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

[ -x $(command -v brew) ] && \
  [ -f "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" && \
  bindkey '^ ' autosuggest-accept

alias uuid='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" |  pbcopy && echo "Copied guid to clipboard"'

export EDITOR=nvim

function tm {
  SESSION_NAME=${1:-default}
  tmux new-session -A -s "${SESSION_NAME}"
}

function new-tsc-project {
  npm init -y
  npm i -D @tsconfig/node14 @types/node ts-node typescript
  echo '{\n  "extends": "@tsconfig/node14"\n}' > tsconfig.json
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

# gcloud cli https://cloud.google.com/sdk/install
for file in $HOME/.gcloud/google-cloud-sdk/{path.zsh.inc,completion.zsh.inc}; do
  [ -f $file ] && source $file
done
unset file
export CLOUDSDK_PYTHON=python3

# Use llvm from homebrew
export PATH="$(brew --prefix llvm)/bin:$PATH"

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# Node and npm
export NODE_ENV=development
export PATH=$HOME/.npm_global/bin:$PATH
export NPM_CONFIG_PREFIX=$HOME/.npm_global

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
alias azswitch='az account set --subscription "$(az account list --output tsv --query "[].name" | fzf)"'
source /usr/local/etc/bash_completion.d/az

# k8s
export KUBE_EDITOR=nvim
# [[ -x $(command -v kubectl) ]] && source <(kubectl completion zsh) && complete -F __start_kubectl k
alias kcu='kcuc "$(kcgc -o name | fzf)"'

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
