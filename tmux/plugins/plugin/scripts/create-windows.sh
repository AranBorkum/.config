#!/bin/sh

session_name="$1"

# Log to debug (optional)
echo "Creating windows in session: $session_name" >> /tmp/tmux-hook.log

# Create three windows
tmux new-window -t "$session_name:" -n "win1"
tmux new-window -t "$session_name:" -n "win2"
tmux new-window -t "$session_name:" -n "win3"

