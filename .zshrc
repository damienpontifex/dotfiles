export ZSH="/Users/ponti/.oh-my-zsh"

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

ZSH_THEME="amuse"
# ZSH_THEME="agnoster"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

HIST_STAMPS="yyyy-mm-dd"


plugins=(
  git
  kube-ps1
  zsh-syntax-highlighting
)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#3a3a3a" #,underline"
source $ZSH/oh-my-zsh.sh
# PROMPT=$PROMPT'$(kube_ps1) '
# RPROMPT='k8s: $(kube_ps1)'
# User configuration

# Ensure zsh plugins available
[ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

[ -x $(command -v brew) ] && \
  [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" && \
  bindkey '^ ' autosuggest-accept

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

alias uuid='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" |  pbcopy && echo "Copied guid to clipboard"'

export EDITOR=nvim

### dotfiles ###
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias config=dotfiles
[ -f $HOME/.git-completion.zsh ] && source $HOME/.git-completion.zsh

alias icloud='cd cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/'

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

export PATH="/usr/local/opt/llvm/bin:$PATH"

### Git aliases
alias gs='git status'
alias g='git'
alias gcm='git commit -m'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# added by travis gem
[ -f /Users/ponti/.travis/travis.sh ] && source /Users/ponti/.travis/travis.sh

# Node and npm
export NODE_ENV=development
export PATH=$HOME/.npm_global/bin:$PATH
export NPM_CONFIG_PREFIX=~/.npm_global

# golang
if [[ -x $(command -v go) ]]; then
  export PATH="$PATH:$(go env GOPATH)/bin"
  export GOPATH=$(go env GOPATH)
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
[[ -x $(command -v kubectl) ]] && source <(kubectl completion zsh) && complete -F __start_kubectl k
[[ -x $(command -v helm) ]] && source <(helm completion zsh)
alias k='kubectl'
alias kgp='kubectl get pods'
alias kcls='kubectl config get-contexts'
alias kcu='kubectl config use-context "$(kubectl config get-contexts -o name | fzf)"'
alias kctx='kubectl config current-context'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

export OPENSSL_ROOT_DIR=/usr/local/opt/openssl
export OPENSSL_LIBRARIES=/usr/local/opt/openssl
export LIBRARY_PATH="$LIBRARY_PATH:/usr/local/opt/openssl/lib"

# Use Moby BuildKit modern docker build engine
export DOCKER_BUILDKIT=1

function cd_with_fzf {
  cd $HOME && fd -t d | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden | xargs -I '{}' cd "{}"
}
zle -N cd_with_fzf
bindkey '^f' cd_with_fzf
function open_with_fzf {
  fd -t f -H -I | fzf | xargs -I '{}' open "{}"
}
zle -N open_with_fzf
bindkey '^o' open_with_fzf 

