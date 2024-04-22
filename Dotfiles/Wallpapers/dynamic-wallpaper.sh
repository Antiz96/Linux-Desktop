#!/bin/bash

current_hour=$(date +%H)

if [ "${current_hour}" -ge 8 ] && [ "${current_hour}" -lt 12 ]; then
	time="morning"
elif [ "${current_hour}" -ge 12 ] && [ "${current_hour}" -lt 18 ]; then
	time="day"
elif [ "${current_hour}" -ge 18 ] && [ "${current_hour}" -lt 22 ]; then
	time="evening"
else
	time="night"
fi

if command -v feh > /dev/null; then
	feh --bg-fill "${HOME}/Pictures/wallpapers/island-${time}.jpg"
elif command -v swaymsg > /dev/null; then
	swaymsg output "*" bg "${HOME}/Pictures/wallpapers/island-${time}.jpg" fill
fi
