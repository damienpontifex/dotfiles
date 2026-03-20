[ -d "$HOME/.dotnet/tools" ] && export PATH="$HOME/.dotnet/tools:$PATH"
[ -d /usr/local/share/dotnet ] && export PATH="/usr/local/share/dotnet:$PATH"
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
