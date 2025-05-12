#!/bin/bash

SESSION_NAME="$1"

# Only act if the session has only the default window (i.e., just created)
if [ "$(tmux list-windows -t "$SESSION_NAME" | wc -l)" -eq 1 ]; then
	# Rename first window to neovim and launch nvim
	tmux rename-window -t "$SESSION_NAME:1" neovim
  	tmux send-keys -t "$SESSION_NAME:1" 'nvim' C-m

  	# Add second terminal window
  	tmux new-window -t "$SESSION_NAME" -n terminal

  	# Add mprocs window
  	tmux new-window -t "$SESSION_NAME" -n mprocs

  	# Add fourth terminal window
  	tmux new-window -t "$SESSION_NAME" -n terminal

  	# Return to the first window (neovim)
  	tmux select-window -t "$SESSION_NAME:2"
  	tmux select-window -t "$SESSION_NAME:1"
fi

