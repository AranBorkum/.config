#!/bin/bash

SESSION_NAME="$1"

# Only act if the session has only the default window (i.e., just created)
if [ "$(tmux list-windows -t "$SESSION_NAME" | wc -l)" -eq 1 ]; then
	# Rename first window to neovim and launch nvim
	tmux rename-window terminal
fi

