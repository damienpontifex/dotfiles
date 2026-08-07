#!/bin/sh

export PATH="$HOME/.local/bin:$PATH"

# Homebrew initialization (adds brew to $PATH)
eval "$(/opt/homebrew/bin/brew shellenv)"
