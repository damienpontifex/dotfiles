#!/usr/bin/env bash

set -euo pipefail
set -x

cd ~/.obsidian-vault

branch=$(git symbolic-ref --short HEAD)
git pull origin "$branch" --rebase

if [[ -n $(git status --porcelain) ]]; then
  # Ensure attributes are added first, then add everything else
  git add .gitattributes
  git add .
  git commit -m "Automated vault sync: $(date +'%Y-%m-%d %H:%M:%S') from $(hostname -s)"
fi

git push origin "$branch"
