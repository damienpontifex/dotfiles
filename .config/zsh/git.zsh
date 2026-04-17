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

function gl {
  if [[ "$(git rev-parse --is-bare-repository)" == "true" ]]; then
    git fetch
  else
    git pull
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
    git fetch origin --prune && \
      pushd "$(gwt_path $(git_main_branch))" && \
      git rebase \
      && popd
  elif [[ "$(git rev-parse --git-dir)" != "$(git rev-parse --git-common-dir)" ]]; then
      # You are in a linked git worktree
      # Jump across to worktree root
      cd "$(git rev-parse --git-common-dir)" && \
      git fetch origin --prune && \
      git worktree prune --no-expire && \
      pushd "$(gwt_path $(git_main_branch))" && \
      git rebase && popd
  else
    # You are in the main worktree or git with local branches
    git switch $(git_main_branch) && git pull --prune && git clean-gone
  fi
}

# New worktree and in that new directory. Usage: `gwta <worktree-name>`
function gwta {
  local worktree_name="${1:?Usage: gwta <worktree-name>}"
  # Ensure we're in the git common directory to ensure create worktree from there
  [[ "$(git rev-parse --git-dir)" != "$(git rev-parse --git-common-dir)" ]] \
    || cd "$(git rev-parse --git-common-dir)"

  # Ensure if name has path separators in it, the path and branch both have those separators
  git worktree add "$worktree_name" -b "$worktree_name"
  cd "$worktree_name"
  [[ -f .pre-commit-config.yaml ]] && pre-commit install
}
