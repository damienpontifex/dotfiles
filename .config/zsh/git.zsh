# vim:ft=zsh

alias g=git
alias ga="git add"
alias gst="git status"
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gpf="git push --force-with-lease --force-if-includes"
alias gwtls="git worktree list"
alias gwtrm="git worktree remove"
alias gswc="git switch -c"
alias gss="git stash show --patch"
alias gsl="git stash list"
alias gd="git diff --ignore-all-space"
alias nd="nvim +DiffviewOpen"
alias gds="git diff --staged"
alias lg="lazygit"

function gl {
  if [[ "$(git rev-parse --is-bare-repository)" == "true" ]]; then
    git fetch --all
    # Fast-forward the default branch to match origin, but only if it's not
    # checked out by any worktree (git branch --force fails in that case)
    local default=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
    if [[ -n "$default" ]]; then
      local branch_in_use=$(git worktree list --porcelain | awk -v b="refs/heads/$default" '$1=="branch" && $2==b {found=1} END {print found+0}')
      if [[ "$branch_in_use" == "0" ]]; then
        git branch --force "$default" "origin/$default"
      fi
    fi
  else
    # If no upstream is set, pull will fail so fetch only
    git pull --prune 2>/dev/null || git fetch --prune
  fi
}

# Remove worktrees whose tracking upstream branch no longer exists
function gwt-clean {
  # Must be run from within any worktree of the repo
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Not inside a git repository" >&2
    return 1
  fi

  # Parse worktree list (porcelain) to get path + branch for each
  git worktree list --porcelain | awk '
    $1 == "worktree" { path=$2 }
    $1 == "branch"   { branch=$2 }
    $1 == "HEAD"     {
      if (branch != "") {
        print path, branch
        branch=""
      }
    }
  ' | while read -r wt_path wt_branch; do
    # Skip the main worktree (no branch in porcelain output)
    if [ -z "$wt_branch" ]; then
      continue
    fi

    # Strip refs/heads/ prefix for easier use with @upstream
    short_branch="${wt_branch#refs/heads/}"

    # Determine upstream ref. If none configured, skip.
    upstream=$(git rev-parse --abbrev-ref --symbolic-full-name "${short_branch}@{upstream}" 2>/dev/null || true)
    if [ -z "$upstream" ]; then
      continue
    fi

    # If upstream ref does not exist anymore, this is a "gone" upstream
    if ! git show-ref --quiet "$upstream"; then
      echo "Removing worktree: $wt_path (branch: $short_branch, gone upstream: $upstream)"
      git worktree remove --force "$wt_path"
    fi
  done
}

function git_main_branch {
  git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4
}
function gwt_path {
  local branch_name="${1:?Usage: gwt_path <branch-name>}"
  git worktree list --porcelain | grep -B2 "^branch refs/heads/${branch_name}" | head -1 | cut -d' ' -f2
}

# Ensure our origin and main worktree is up to date. Cleanup any stale worktrees. Usage: `gmain`
function gmain {
  # trap 'set +x' EXIT
  # set -x;
  if [[ "$(git rev-parse --is-bare-repository)" == "true" ]]; then
    # Fetch remove and ensure main branch is up to date
    git fetch --all --prune && \
      pushd "$(gwt_path $(git_main_branch))" && \
      git rebase \
      && popd
  elif [[ "$(git rev-parse --git-dir)" != "$(git rev-parse --git-common-dir)" ]]; then
      # You are in a linked git worktree
      # Jump across to worktree root
      cd "$(git rev-parse --git-common-dir)" && \
      git fetch --all --prune && \
      git worktree prune --no-expire && \
      pushd "$(gwt_path $(git_main_branch))" && \
      git rebase && popd
  else
    # You are in the main worktree or git with local branches
    git switch $(git_main_branch) && git pull --prune && git clean-gone
  fi
}

function gwt-clean {
  git worktree list --porcelain | while read -r line; do
    # Capture the directory path of the worktree
    if [[ "$line" =~ ^worktree\ (.*) ]]; then
      wt_path="${BASH_REMATCH[1]}"
    fi

    # Capture the branch name of the worktree
    if [[ "$line" =~ ^branch\ refs/heads/(.*) ]]; then
      wt_branch="${BASH_REMATCH[1]}"

      # Check if the branch is marked as [gone]
      if git branch -vv | grep -E "^\*? +${wt_branch} " | grep -q ": gone]"; then
          echo "Removing worktree for deleted remote branch: $wt_branch"
          # git worktree remove "$wt_path"
      fi
    fi
  done
}

# New worktree and in that new directory. Usage: `gwta <worktree-name>`
function gwta {
  local worktree_name="${1:?Usage: gwta <worktree-name>}"
  # Ensure we're in the git common directory to ensure create worktree from there
  if [[ "$(git rev-parse --git-dir)" != "$(git rev-parse --git-common-dir)" ]]; then
    cd "$(git rev-parse --git-common-dir)"
  fi

  # Check if matching remote branch
  if git rev-parse --verify "origin/$worktree_name" > /dev/null 2>&1; then
    # Ensure if name has path separators in it, the path and branch both have those separators
    git worktree add -b "$worktree_name" "$worktree_name" "origin/$worktree_name"
  else
    # local remote_main=$(git rev-parse --abbrev-ref origin/HEAD)
    # Ensure if name has path separators in it, the path and branch both have those separators
    git worktree add -b "$worktree_name" "$worktree_name" # "$remote_main"
  fi

  cd "$worktree_name"
  [[ -f .pre-commit-config.yaml ]] && pre-commit install
  [[ -d .run ]] && find .run -name '*.template' -exec bash -c 'for f; do cp "$f" "${f%.template}"; done' _ {} +
}
