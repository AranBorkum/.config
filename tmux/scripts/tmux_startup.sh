#!/bin/bash

VENV_PATH=".venv/bin/activate"

# Check if we are inside an existing tmux session
if [[ -n "$TMUX" ]]; then
    # Create a new window for each of the tasks
    tmux rename-window neovim ; source $VENV_PATH
    tmux new-window -n terminal; source $VENV_PATH
    tmux new-window -n mprocs; source $VENV_PATH
    tmux new-window -n terminal ; source $VENV_PATH
else
    echo "You must be inside a tmux session for this to work."
fi
