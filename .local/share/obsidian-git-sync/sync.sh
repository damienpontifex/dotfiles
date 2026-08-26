#!/usr/bin/env bash

set -euo pipefail

cd "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/ponti"

git pull origin main --rebase

if [[ -n $(git status --porcelain) ]]; then
  git add .
  git commit -m "Automated vault sync: $(date +'%Y-%m-%d %H:%M:%S')"
  git push origin main
fi
