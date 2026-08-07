# XDG base directories.
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export MANPAGER='nvim +Man!'
export EDITOR=nvim

export PATH="$HOMEBREW_PREFIX/bin:$PATH"

# Check if a local override file exists and source it.
[[ -f "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"

# https://wiki.archlinux.org/title/XDG_Base_Directory
export AZURE_CONFIG_DIR=$XDG_DATA_HOME/azure

export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod

export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

export K9SCONFIG="$XDG_CONFIG_HOME"/k9s

export NVM_DIR="$XDG_DATA_HOME"/nvm

export OMNISHARPHOME="$XDG_CONFIG_HOME/omnisharp"

export OPENSSL_ROOT_DIR="$HOMEBREW_PREFIX/opt/openssl"
export OPENSSL_LIBRARIES="${OPENSSL_ROOT_DIR}"
export LIBRARY_PATH="$LIBRARY_PATH:${OPENSSL_ROOT_DIR}/lib"

# export FZF_DEFAULT_OPTS=
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
