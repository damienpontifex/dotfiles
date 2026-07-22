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
alias gws="git switch"
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
  # trap 'set +x' EXIT
  # set -x;
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
  local track wtpath branch
  while IFS='|' read -r track wtpath branch; do
    # Only branches whose upstream is gone AND that have a worktree checked out.
    [[ "$track" == "[gone]" && -n "$wtpath" ]] || continue
    if (( dry_run )); then
      echo "[dry-run] would remove: $wtpath (branch: $branch, upstream gone)"
    else
      echo "Removing worktree: $wtpath (branch: $branch, upstream gone)"
      # Delete the local branch only if the worktree was actually removed
      # (remove refuses on a dirty worktree, in which case keep the branch).
      git worktree remove "$wtpath" && git branch -D "$branch"
    fi
  done < <(git for-each-ref --format='%(upstream:track)|%(worktreepath)|%(refname:short)' refs/heads/$USER)
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

# Overview of local branches: current marker, branch, upstream tracking state,
# worktree (if checked out), last-commit age, sha and subject. Read-only.
# Sorted most-recently-committed first. Scoped to refs/heads/$USER by default
# (matching gwta's namespacing); pass a sub-path to narrow, or '' for all:
#   gwt-status            -> refs/heads/$USER
#   gwt-status feature    -> refs/heads/feature
#   gwt-status ''         -> refs/heads (every local branch)
function gwt-status {
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Not inside a git repository" >&2
    return 1
  fi

  local pattern="refs/heads/${1-$USER}"
  local color=0; [[ -t 1 ]] && color=1   # only colorize for a terminal

  git for-each-ref --sort=-committerdate \
    --format='%(HEAD)%09%(refname:short)%09%(upstream:short)%09%(upstream:track,nobracket)%09%(worktreepath)%09%(objectname:short)%09%(committerdate:relative)%09%(contents:subject)' \
    "$pattern" |
  awk -F'\t' -v color="$color" '
    BEGIN {
      if (color) {
        reset="\033[0m"; red="\033[31m"; grn="\033[32m"; yel="\033[33m";
        dim="\033[2m"; cyan="\033[36m"; bold="\033[1m";
      }
      wb=6; ws=6; ww=8; wd=7;   # min widths: BRANCH STATUS WORKTREE UPDATED
    }
    {
      head=$1; branch=$2; up=$3; track=$4; wt=$5; sha=$6; date=$7; subj=$8;

      if      (track=="gone") { st="gone";  sc=red }   # upstream deleted
      else if (track!="")     { st=track;   sc=yel }   # ahead/behind
      else if (up!="")        { st="ok";    sc=grn }   # tracks upstream, in sync
      else                    { st="local"; sc=dim }   # no upstream

      if (wt!="") { n=split(wt,a,"/"); w=a[n] } else { w="-" }
      if (length(subj)>50) subj=substr(subj,1,49) "\342\200\246";  # ellipsis

      H[NR]=(head=="*")?"*":" "; B[NR]=branch; ST[NR]=st; SC[NR]=sc;
      W[NR]=w; D[NR]=date; SH[NR]=sha; SU[NR]=subj;

      if (length(branch)>wb) wb=length(branch);
      if (length(st)>ws)     ws=length(st);
      if (length(w)>ww)      ww=length(w);
      if (length(date)>wd)   wd=length(date);
      rows=NR;
    }
    END {
      if (rows==0) { print "No matching local branches"; exit }
      printf "%s  %-*s  %-*s  %-*s  %-*s  %-7s  %s%s\n",
        dim, wb,"BRANCH", ws,"STATUS", ww,"WORKTREE", wd,"UPDATED", "SHA", "MESSAGE", reset;
      for (i=1;i<=rows;i++) {
        hc=(H[i]=="*")?grn bold:"";
        printf "%s%s %-*s%s  %s%-*s%s  %s%-*s%s  %-*s  %s%-7s%s  %s\n",
          hc, H[i], wb, B[i], reset,
          SC[i], ws, ST[i], reset,
          cyan, ww, W[i], reset,
          wd, D[i],
          dim, SH[i], reset,
          SU[i];
      }
    }
  '
}
alias gwts="gwt-status"

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
