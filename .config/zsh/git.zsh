# vim:ft=zsh

alias g=git
alias gc=git commit
alias gcm=git commit -m
alias gp=git push
alias gpf=git push --force-with-lease --force-if-includes

function gwt_path {
  local branch_name="${1:?Usage: gwt_path <branch-name>}"
  gwtls --porcelain | grep -B2 "^branch refs/heads/${branch_name}" | head -1 | cut -d' ' -f2
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

  git worktree add "$worktree_name"
  cd "$worktree_name"
}

