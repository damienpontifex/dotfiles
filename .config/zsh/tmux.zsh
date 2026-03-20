# Create or attach to a tmux session
function tm {
  local session="${1:-default}"

  if [ -n "${TMUX}" ]; then
    # Inside tmux: switch client to session, creating if needed
    tmux switch-client -t "$session" 2>/dev/null || tmux new-session -A -d -s "$session" \; switch-client -t "$session"
  else
    # Outside tmux: attach or create session
    tmux new-session -A -s "$session"
  fi
}
function _tm_complete {
  local sessions
  sessions=("${(@f)$(tmux list-sessions -F '#{session_name}' 2>/dev/null)}")
  compadd -Q -a sessions
}
compdef _tm_complete tm

