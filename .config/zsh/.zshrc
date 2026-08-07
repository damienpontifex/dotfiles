# https://wiki.archlinux.org/title/Zsh
# Can use `reset` to reload

# zmodload zsh/zprof

# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# exec 3>&2 2> startlog.$$
# setopt xtrace prompt_subst

source "$ZDOTDIR/history"

# ==============================================
# Shell behaviour
# ==============================================
setopt auto_param_slash
setopt auto_pushd
setopt autocd
setopt nobeep
setopt numeric_glob_sort

# ==============================================
# Completions
# ==============================================
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
mkdir -p "$ZSH_CACHE_DIR/completions"
fpath=("$ZSH_CACHE_DIR/completions" $fpath)

zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache

# `man zshcompsys`
autoload -Uz compinit
compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
autoload -U +X bashcompinit && bashcompinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
zstyle ':completion:*' sqeeze-slashes flase # explicit disable to allow /*/ expansion

# https://github.com/aloxaf/fzf-tab#configure
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# Expand alias with tab
zstyle ':completion:*' completer _expand_alias _complete _ignored

# `man zshoptions`
# View all options and set values `set -o`
setopt alwaystoend
setopt auto_menu menu_complete
setopt complete_in_word no_case_glob no_case_match
setopt globdots extended_glob
setopt interactive_comments

unsetopt menu_complete
unsetopt flowcontrol

# make `help` available similar to bash for builtins https://wiki.archlinux.org/title/Zsh#Help_command
autoload -Uz run-help
(( ${+aliases[run-help]} )) && unalias run-help
alias help=run-help

source "$ZDOTDIR/prompt"
source "$ZDOTDIR/plugins"

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias watch='watch --color '

### dotfiles ###
alias config='/usr/bin/git --git-dir="$HOME/dotfiles"'
alias lazyconfig='lazygit --git-dir="$HOME/dotfiles"'
# Enable completion for the function by telling Zsh to treat it like `git`
compdef config=git

alias md="mkdir -p"

# Named directories, use with ~<name>
hash -d obsidian=~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents

# Ensure postgresql tools are in path
export PATH="$PATH:${HOMEBREW_PREFIX}/opt/postgresql@16/bin"

# Ensure `code` command is available
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

source "$ZDOTDIR/vi-mode"

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
alias utcnow='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias perthnow='TZ=Australia/Perth date +"%Y-%m-%dT%H:%M:%SZ"'
alias sydneynow='TZ=Australia/Sydney date +"%Y-%m-%dT%H:%M:%SZ"'
function rel-utcnow() {
  local offset="${1:?Provide a offset as parameter [+|-]val[y|m|w|d|H|M|S]}"
  date -u -v "$offset" +"%Y-%m-%dT%H:%M:%SZ"
}
function rel-perthnow() {
  local offset="${1:?Provide a offset as parameter [+|-]val[y|m|w|d|H|M|S]}"
  TZ=Australia/Perth date -v "$offset" +"%Y-%m-%dT%H:%M:%SZ"
}
function rel-sydneynow() {
  local offset="${1:?Provide a offset as parameter [+|-]val[y|m|w|d|H|M|S]}"
  TZ=Australia/Sydney date -v "$offset" +"%Y-%m-%dT%H:%M:%SZ"
}

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
function ls_on_cd {
  # eza --icons --long --group-directories-first    
}
add-zsh-hook chpwd ls_on_cd

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

# Get password value from keychain
# Example usage export MY_PASSWORD="$(get-pw MY_PASSWORD)"
alias get-pw="security find-generic-password -gw -a $USER -s"

alias set-pw="security add-generic-password -a "$USER" -s"

alias nvim-config='(cd ~/.config/nvim; nvim init.lua)'
alias tmux-config='(cd ~/.config/tmux; nvim tmux.conf)'

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
  brew bundle install --upgrade --global --jobs auto # --verbose
  npm update --global
  dotnet tool update --global --all
  rustup update
  cargo update
  nvim --headless -c "lua vim.pack.update(nil, { force = true })" -c "qa"
  ~/.tmux/plugins/tpm/bin/clean_plugins
  ~/.tmux/plugins/tpm/bin/install_plugins
  ~/.tmux/plugins/tpm/bin/update_plugins all

  tldr --update

  config submodule update --recursive --remote --init

  # Call `update-local-packages` if it is defined
  if typeset -f update-local-packages > /dev/null; then
    update-local-packages
  fi
}

source "${ZDOTDIR}/tmux.zsh"
source "${ZDOTDIR}/dev.zsh"
source "${ZDOTDIR}/git.zsh"
source "${ZDOTDIR}/kubernetes"
source "${ZDOTDIR}/docker"

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
