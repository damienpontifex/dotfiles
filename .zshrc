# zmodload zsh/zprof

# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# exec 3>&2 2> startlog.$$
# setopt xtrace prompt_subst

export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="amuse"

HIST_STAMPS="yyyy-mm-dd"

# zstyle ':omz:update' mode auto
export DISABLE_AUTO_UPDATE="true"

# Ensure `code` command is available
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export PATH="$HOME/.local/bin:$PATH"

eval "$(brew shellenv)"
export PATH="/opt/homebrew/bin:$HOME/bin:$PATH"
[ -d "$HOME/.dotnet/tools" ] && export PATH="$HOME/.dotnet/tools:$PATH"
[ -d /usr/local/share/dotnet ] && export PATH="/usr/local/share/dotnet:$PATH"

# Ensure postgresql tools are in path
export PATH="$PATH:${HOMEBREW_PREFIX}/opt/postgresql@16/bin"

[ -d "$HOME/.oh-my-zsh/custom/plugins/you-should-use" ] || git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$HOME/.oh-my-zsh/custom/plugins/you-should-use"

plugins=(
  git # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
  zsh-syntax-highlighting
  vscode
  colored-man-pages
  dotenv
  docker
  docker-compose
  you-should-use
)
[ -f ~/.zshrc.plugins.local ] && source ~/.zshrc.plugins.local
if [[ -z "$NVIM" ]]; then
  # Don't enable vi-mode plugin when running terminal already inside neovim
  plugins+=(vi-mode)
  export VI_MODE_SET_CURSOR=true
fi
source $ZSH/oh-my-zsh.sh

if [[ " ${plugins[@]} " =~ " kube-ps1 " ]]; then
  RPROMPT='$(kube_ps1)'$RPROMPT
fi

# if [ -x "$(command -v az)" ]; then
#   RPROMPT="$RPROMPT\$(az account show --output tsv --query \"name\" --only-show-errors)"
# fi

# Disable AWS CLI pager
export AWS_PAGER=""
if [[ -x "$(command -v aws)" ]] && [[ -x "$(command -v aws_completer)" ]]; then
  complete -C "$(command -v aws_completer)" aws
fi

[ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

if [ -f "${HOMEBREW_PREFIX}/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "${HOMEBREW_PREFIX}/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  bindkey '^ ' autosuggest-accept
  bindkey '^f' forward-word  # Ctrl+F
fi

alias uuid='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" |  pbcopy && echo "Copied guid to clipboard"'

# Replace cat with bat... use `\cat` to use original cat
alias cat='bat --paging=never'
alias ls='eza'                                                         # ls
alias l='eza -lbF --git'                                               # list, size, type, git
alias ll='eza -lbGF --git'                                             # long list
alias llm='eza -lbGF --git --sort=modified'                            # long list, modified date sort
alias la='eza -lbhHigUmuSa --time-style=long-iso --git --color-scale'  # all list
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list

# speciality views
alias lS='eza -1'                                                      # one column, just names
alias lt='eza --tree --level=2'                                        # tree

export EDITOR=nvim

function gmain {
  git switch $(git_main_branch) && git pull --prune && git clean-gone
}
# Get password value from keychain
# Example usage export MY_PASSWORD="$(get_pw MY_PASSWORD)"
function get-pw {
  security find-generic-password -ga "$1" -w
}
function set-pw {
  security add-generic-password -a "$1" -s "$1" -w
}

alias nvim-config='(cd ~/.config/nvim; nvim init.lua)'
alias tmux-config='(cd ~/.config/tmux; nvim tmux.conf)'

function dotenv {
  local dotenv_file
  dotenv_file=${1:-.env}
  if [ ! -f "$dotenv_file" ]; then
    >&2 echo "File $dotenv_file does not exist."
    return 1
  fi
  set -a; source "./$dotenv_file"; set +a
}

function no-history {
  unset HISTFILE
}

function update-packages {
  brew update
  brew bundle install --upgrade --global --cleanup --verbose
  npm update --global
  dotnet tool update --global --all
  rustup update
  cargo install --list | grep : | awk '{print $1}' | xargs -I {} cargo install {}
  nvim --headless -c "Lazy! update" -c "qa"
  omz update
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

# Create or attach to a tmux session
function tm {
  local session="${1:-default}"

  if [ -n "${TMUX}" ]; then
    # Inside tmux: switch client to session, creating if needed
    tmux switch-client -t "$session" 2>/dev/null || tmux new-session -A -d -s "$session" \; switch-client -t "$session"
  else
    # Outside tmux: attach or create session
    tmux new-session -A -s "$session"
  fi
}
function _tm_complete {
  local sessions
  sessions=("${(@f)$(tmux list-sessions -F '#{session_name}' 2>/dev/null)}")
  compadd -Q -a sessions
}
compdef _tm_complete tm

### dotfiles ###
function config() {
  /usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}
alias lazyconfig='lazygit --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
# Enable completion for the function by telling Zsh to treat it like `git`
compdef dotfiles=git

### Secrets ###
if [ -f "$HOME/.secrets.sh" ]; then
  source "$HOME/.secrets.sh"
fi

### Utility ###
alias check_disk='sudo fsck -fy'
alias getmyip='dig +short myip.opendns.com @resolver1.opendns.com'

### Static HTTP Server ###
alias http-server="python3 -m http.server"
[ -d "${HOMEBREW_PREFIX}/opt/python3" ] && export PATH="${HOMEBREW_PREFIX}/opt/python3/libexec/bin:$PATH"

# Use llvm from homebrew
export PATH="${HOMEBREW_PREFIX}/opt/llvm/bin:$PATH"

# Node and npm
# export NODE_ENV=${NODE_ENV:-development}
if [[ -x $(command -v fnm) ]]; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# golang
if [[ -x $(command -v go) ]]; then
  export GOPATH=$(go env GOPATH)
  export PATH="$PATH:${GOPATH}/bin"
fi

# rust
export PATH="$PATH:${HOME}/.cargo/bin"

# .NET
export ASPNETCORE_ENVIRONMENT=Development

# Alias watch so we can use other aliases - a trailing space in VALUE causes the next word to be checked for alias substitution
alias watch='watch '

# az cli
alias azswitch='az account list --output tsv --query "[].name" --only-show-errors | fzf | xargs -r -I {} az account set --subscription "{}"'
[ -f /usr/local/etc/bash_completion.d/az ] && source /usr/local/etc/bash_completion.d/az

# k8s
export KUBE_EDITOR=nvim
[[ -x $(command -v kubectl) ]] && source <(kubectl completion zsh) && complete -F __start_kubectl k
# alias kcu='kubectl config get-contexts -o name | fzf | xargs -r -I {} kubectl config use-context "{}"'
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


export GPG_TTY=$(tty)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# zprof > /tmp/zprof

# unsetopt xtrace
# exec 2>&3 3>&-
