#!/usr/bin/env bash

set -euo pipefail

# Redirect all stdout (1) and stderr (2) to logger and viewable in console.app
# exec > >(logger -t "dev.pontifex.obsidian-git-sync:INFO") 2> >(logger -t "dev.pontifex.obsidian-git-sync:ERROR")

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
