#!/usr/bin/env bash

set -euo pipefail

log_dir="$HOME/.local/state/obsidian-git-sync"
mkdir -p "$log_dir"
exec >>"$log_dir/sync.log" 2>&1
exec >>"$log_dir/sync.log" 2>&1

cd ~/.obsidian-vault

branch=$(git symbolic-ref --short HEAD)
git pull origin "$branch" --rebase

if [[ -n $(git status --porcelain) ]]; then
  # Ensure attributes are added first, then add everything else
  git add .gitattributes
  git add .
  git commit -m "Automated vault sync: $(date +'%Y-%m-%d %H:%M:%S') from $(hostname -s)"
  git push origin "$branch"
fi
