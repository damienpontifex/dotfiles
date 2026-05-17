# Can use `reset` to reload

# zmodload zsh/zprof

# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# exec 3>&2 2> startlog.$$
# setopt xtrace prompt_subst

# Load completions
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
zstyle ':completion:*' sqeeze-slashes flase # explicit disable to allow /*/ expansion
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# Expand alias with tab
zstyle ':completion:*' completer _expand_alias _complete _ignored

# `man zshoptions`
# View all options and set values `set -o`
setopt alwaystoend
setopt append_history inc_append_history share_history
setopt hist_find_no_dups hist_ignore_all_dups hist_ignore_dups hist_ignore_space hist_save_no_dups
setopt auto_cd auto_pushd auto_param_slash
setopt auto_menu menu_complete
setopt complete_in_word no_case_glob no_case_match
setopt globdots extended_glob
setopt interactive_comments

unsetopt menu_complete
unsetopt flowcontrol

# make `help` available similar to bash for builtins
autoload -Uz run-help
unalias run-help 2>/dev/null
alias help=run-help

# XDG Base Directories
# https://wiki.archlinux.org/title/XDG_Base_Directory
# Applications that use this https://wiki.archlinux.org/title/XDG_Base_Directory#Support
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export PATH="$HOME/.local/bin:$PATH"

# History opts
HISTZIE=100000000
SAVEHIST=100000000
HISTFILE="$XDG_CACHE_HOME/zsh_history"
THIS_DIR="$XDG_CONFIG_HOME/zsh"

source "$THIS_DIR/prompt"

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

### dotfiles ###
alias config='/usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
alias lazyconfig='lazygit --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
# Enable completion for the function by telling Zsh to treat it like `git`
compdef dotfiles=git

source "$THIS_DIR/plugins/plugins"

eval "$(brew shellenv)"
export PATH="/opt/homebrew/bin:$PATH"

# Ensure postgresql tools are in path
export PATH="$PATH:${HOMEBREW_PREFIX}/opt/postgresql@16/bin"

# Ensure `code` command is available
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

if [[ -z "$NVIM" ]]; then
  # Don't enable vi-mode plugin when running terminal already inside neovim
  export VI_MODE_SET_CURSOR=true
  # Set Zsh Line Editor (ZLE) to Vi emulation mode
  bindkey -v
  set -o vi
  # Allow backspace to delete past the start of the current insert session
  bindkey -M viins '^?' backward-delete-char
  bindkey -M viins '^H' backward-delete-char

  # Function to change cursor shape
  # 2 = steady block, 6 = steady bar (use 1 and 5 for blinking versions)
  function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]]; then
      echo -ne '\e[2 q'
    else
      echo -ne '\e[5 q'
    fi
  }
  zle -N zle-keymap-select

  # Ensure the cursor starts as a bar when the prompt first appears
  zle-line-init() {
      zle -K viins
      echo -ne '\e[5 q'
  }
  zle -N zle-line-init

  # Fix cursor shape when a command finishes
  export KEYTIMEOUT=1
  _fix_cursor() {
     echo -ne '\e[5 q'
  }
  precmd_functions+=(_fix_cursor)
fi

# Keybindings
# https://zsh.sourceforge.io/Doc/Release/Editor-Functions-Index.html
# For list of things that could bind to `zle -al`

bindkey '^P' up-history
bindkey '^N' down-history

# Open buffer line in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Bind magic space
bindkey ' ' magic-space

bindkey '^e' end-of-line
bindkey '^a' beginning-of-line 

bindkey '^@' autosuggest-accept
bindkey '^f' forward-word  # Ctrl+F

# Copy current command buffer to clipboard (macOS)
function copy-buffer-to-clipboard() {
  echo -n "$BUFFER" | pbcopy
  zle -M "Copied to clipboard"
}
zle -N copy-buffer-to-clipboard
bindkey '^Xc' copy-buffer-to-clipboard

# Alias watch so we can use other aliases - a trailing space in VALUE causes the next word to be checked for alias substitution
alias watch='watch '

# ISO8601
alias utcnow='TZ=UTC strftime "%FT%T%z"'
alias perthnow='TZ=Australia/Perth strftime "%FT%T%z"'
alias sydneynow='TZ=Australia/Sydney strftime "%FT%T%z"'

# fzf search man entries
alias fman="man -k . | fzf --preview \"echo {} | awk '{print \$1}' | cut -d'(' -f1 | xargs man\" \
  --preview-window=right:60% \
  --bind \"enter:execute(echo {} | awk '{print \$1}' | cut -d'(' -f1 | xargs man)\""

# Suffix aliases - open files by extension
alias -s md=bat
alias -s rst=bat
alias -s go='$EDITOR'
alias -s yml=bat
alias -s yaml=bat
alias -s html=open
alias -s log=bat
alias -s txt=bat
alias -s json=jq

# Hooks on changing directory
autoload -Uz add-zsh-hook # Allow multiple hooks
function auto_nvm() {
  [[ -f .nvmrc ]] && nvm use
}
add-zsh-hook chpwd auto_nvm
function ls_on_cd {
  # eza --icons --long --group-directories-first    
}
add-zsh-hook chpwd ls_on_cd

# Disable AWS CLI pager
export AWS_PAGER=""
if [[ -x "$(command -v aws)" ]] && [[ -x "$(command -v aws_completer)" ]]; then
  complete -C "$(command -v aws_completer)" aws
fi


alias stat='stat -x'
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" |  pbcopy && echo "Copied guid to clipboard"'

alias gstl="git stash list | fzf --preview 'git stash show --patch --color=always \$(echo {} | cut -d: -f1)' --bind 'ctrl-d:preview-page-down' --bind 'ctrl-u:preview-page-up'"

# Replace cat with bat... use `\cat` to use original cat
alias cat='bat --paging=never'
alias ls='eza --icons --long --group-directories-first'                                                         # ls
alias l='eza -lbF --git'                                               # list, size, type, git
alias ll='eza -lbGF --git'                                             # long list
alias llm='eza -lbGF --git --sort=modified'                            # long list, modified date sort
alias lt='eza --long --tree --level=3'
alias la='eza -lbhHigUmuSa --time-style=long-iso --git --color-scale'  # all list
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list

# speciality views
alias lS='eza -1'                                                      # one column, just names
alias lt='eza --tree --level=2'                                        # tree

export EDITOR=nvim


# Get password value from keychain
# Example usage export MY_PASSWORD="$(get-pw MY_PASSWORD)"
alias get-pw="security find-generic-password -gw -a $USER -s"

alias set-pw="security add-generic-password -a "$USER" -s"

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

# --- Yazi Setup ---
function y {
  local tmp="$(mktemp -t "yazi-cmd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function no-history {
  unset HISTFILE
}

function update-packages {
  brew update
  brew bundle install --upgrade --cleanup --file ~/.config/homebrew/Brewfile # --verbose
  npm update --global
  dotnet tool update --global --all
  rustup update
  cargo update
  cargo install --list | grep : | awk '{print $1}' | xargs -I {} cargo install {}
  nvim --headless -c "lua vim.pack.update()" -c "qa"
  ~/.tmux/plugins/tpm/bin/clean_plugins
  ~/.tmux/plugins/tpm/bin/install_plugins
  ~/.tmux/plugins/tpm/bin/update_plugins all

  config submodule update --recursive --remote --init
}

source "${THIS_DIR}/tmux.zsh"
source "${THIS_DIR}/dev.zsh"
source "${THIS_DIR}/git.zsh"
source "${THIS_DIR}/kubernetes"

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



# az cli
alias azswitch='az account list --output tsv --query "[].name" --only-show-errors | fzf | xargs -r -I {} az account set --subscription "{}"'
[ -f /usr/local/etc/bash_completion.d/az ] && source /usr/local/etc/bash_completion.d/az

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
