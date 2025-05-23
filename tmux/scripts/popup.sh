#!/usr/bin/env bash

# 1. Select a tmux command
cmd=$(tmux list-commands | awk '{print $1}' | sort -u | fzf --prompt="Tmux Command > ")

# Exit if nothing selected
[ -z "$cmd" ] && exit

# 2. Prompt for arguments
read -rp "Arguments for '$cmd': " args

# 3. Execute the command with arguments
tmux "$cmd" $args


