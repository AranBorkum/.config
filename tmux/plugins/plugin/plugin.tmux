# plugin.tmux

set-hook -g session-created "run-shell 'sh ~/.tmux/plugins/tmux-open-windows/scripts/create-windows.sh #{session_name}'"

