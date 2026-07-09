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
# alias gd="git diff --ignore-all-space"
alias gd="hunk diff"
alias nd="nvim +DiffviewOpen"
alias gds="git diff --staged"
alias lg="lazygit"

function gl {
  if [[ "$(git rev-parse --is-bare-repository)" == "true" ]]; then
    # Bare repo: just refresh remotes. We never keep a local default branch;
    # worktrees branch off origin/<default> directly (see gwta), so there is
    # nothing to fast-forward here.
    git fetch --all --prune
  else
    # If no upstream is set, pull will fail so fetch only
    git pull --prune 2>/dev/null || git fetch --prune
  fi
}

# Remove worktrees whose upstream branch is gone (e.g. a merged PR branch that
# origin deleted, surfaced locally after `git fetch --prune`). Every other
# worktree is left untouched: the main/bare worktree, detached ones, branches
# that still track a live upstream, and branches with no upstream at all.
# `git worktree remove` (no --force) refuses to drop a dirty worktree, so
# uncommitted work is safe. After a worktree is removed its now-orphaned local
# branch is deleted too (skipped if the worktree was dirty and thus kept).
# Pass -n/--dry-run to preview without removing.
function gwt-clean {
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Not inside a git repository" >&2
    return 1
  fi

  local dry_run=0
  [[ "$1" == "-n" || "$1" == "--dry-run" ]] && dry_run=1

  # One record per branch straight from git: gone-status | worktree path (empty
  # if not checked out) | branch name. The delimiter must be NON-whitespace:
  # with a space/tab IFS, zsh collapses empty fields, so a live branch's empty
  # upstream:track would shift the columns. '|' preserves empty fields (and git
  # keeps it well away from these path/branch values in practice).
  local track path branch
  while IFS='|' read -r track path branch; do
    # Only branches whose upstream is gone AND that have a worktree checked out.
    [[ "$track" == "[gone]" && -n "$path" ]] || continue
    if (( dry_run )); then
      echo "[dry-run] would remove: $path (branch: $branch, upstream gone)"
    else
      echo "Removing worktree: $path (branch: $branch, upstream gone)"
      # Delete the local branch only if the worktree was actually removed
      # (remove refuses on a dirty worktree, in which case keep the branch).
      git worktree remove "$path" && git branch -D "$branch"
    fi
  done < <(git for-each-ref --format='%(upstream:track)|%(worktreepath)|%(refname:short)' refs/heads)
}

function git_main_branch {
  git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4
}

function gwt_path {
  local branch_name="$1"
  if [[ -z "$branch_name" ]]; then
    echo "Usage: gwt_path <branch-name>" >&2
    return 1
  fi
  # Empty output if the branch isn't checked out in any worktree.
  git for-each-ref --format='%(worktreepath)' "refs/heads/${branch_name}"
}

# Ensure our origin and main worktree is up to date. Cleanup any stale worktrees. Usage: `gmain`
function gmain {
  # trap 'set +x' EXIT
  # set -x;

  if [[ "$(git rev-parse --git-dir)" != "$(git rev-parse --git-common-dir)" ]]; then
    # You are in a linked git worktree
    # Jump across to worktree root
    cd "$(git rev-parse --git-common-dir)" && \
  fi

  if [[ "$(git rev-parse --is-bare-repository)" == "true" ]]; then
    # Fetch remove and ensure main branch is up to date
    git fetch --all --prune && git worktree prune --no-expire
  else
    # You are in the main worktree or git with local branches
    git switch $(git_main_branch) && git pull --prune && git clean-gone
  fi
}

# New worktree and in that new directory. Usage: `gwta <worktree-name>`
function gwta {
  local worktree_name="$1"
  if [[ -z "$worktree_name" ]]; then
    echo "Usage: gwta <worktree-name>" >&2
    return 1
  fi

  # Ensure we are in the git common directory to ensure create worktree from there
  if [[ "$(git rev-parse --git-dir)" != "$(git rev-parse --git-common-dir)" ]]; then
    cd "$(git rev-parse --git-common-dir)"
  fi

  # Refresh remote refs so we branch off the latest state, but stay usable
  # offline: hard-bound the fetch (~5s) so it can never hang, and fall back to
  # local refs if origin is unreachable instead of failing. ConnectTimeout
  # covers ssh; lowSpeed* covers a stalled https transfer; and timeout/gtimeout,
  # if present, is a wall-clock backstop for a hung TCP connect on any transport.
  local -a _to
  if (( $+commands[timeout] )); then _to=(timeout 5)
  elif (( $+commands[gtimeout] )); then _to=(gtimeout 5)
  fi
  if ! GIT_SSH_COMMAND='ssh -o ConnectTimeout=5' \
       $_to git -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=5 \
       fetch origin --prune --quiet 2>/dev/null; then
    echo "gwta: could not reach origin (offline?); using local refs" >&2
  fi

  # Check if matching remote branch
  if git rev-parse --verify "origin/$worktree_name" > /dev/null 2>&1; then
    # Ensure if name has path separators in it, the path and branch both have those separators
    git worktree add -b "$worktree_name" "$worktree_name" "origin/$worktree_name"
  else
    # No matching remote branch: base the new branch on the up-to-date remote
    # default (e.g. origin/master), NOT on local HEAD which may be stale if the
    # default branch is checked out in a worktree (see `gl`).
    local remote_main=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null)
    if [[ -z "$remote_main" ]]; then
      echo "gwta: origin/HEAD is not set; run 'git remote set-head origin --auto'" >&2
      return 1
    fi
    # Ensure if name has path separators in it, the path and branch both have those separators
    git worktree add -b "$worktree_name" "$worktree_name" "$remote_main"
  fi

  cd "$worktree_name"
  [[ -f .pre-commit-config.yaml ]] && pre-commit install
  [[ -d .run ]] && find .run -name '*.template' -exec bash -c 'for f; do cp "$f" "${f%.template}"; done' _ {} +
}
