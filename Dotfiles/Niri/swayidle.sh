#!/bin/bash

swayidle -w \
	timeout 840 'notify-send -e -t 60000 -i ~/Pictures/Niri/shutdown.svg "Auto lock" "Based on current inactivity, the system will be locked automatically in 1 minute\n\nDismiss this notification to abort"' \
	timeout 900 'swaylock -feti ~/Pictures/Niri/lock.png -s fill' \
	timeout 905 'niri msg action power-off-monitors' \
	timeout 1800 'systemctl suspend' \
	before-sleep 'swaylock -feti ~/Pictures/Niri/lock.png -s fill'
