#!/usr/bin/env zsh

# Wait for Aerospace to be ready (adjust time as needed)
# sleep 2
typeset -A apps_to_spaces

apps_to_spaces=(
	"Zen" 1
	"Alacritty" 3
	"Slack" 5
	"Spotify" 6
	"Google Chrome" 7
	"WhatsApp" 8
	"Calendar" 8
	"Messages" 9
	"Mail" 9
)

# Open all apps
for app in ${(k)apps_to_spaces}; do
  open -a "$app"
done

for app in ${(k)apps_to_spaces}; do
	space=$apps_to_spaces[$app]
	window_id=$(aerospace list-windows --all | grep ${app} | awk '{print $1;}')
	if [[ -n "$window_id" ]]; then
		aerospace move-node-to-workspace ${space} --window-id "$window_id"
	else
		echo "${app} window not found"
	fi
done

aerospace workspace 3
