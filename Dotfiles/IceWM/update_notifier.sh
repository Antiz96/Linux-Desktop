#!/bin/bash

sed -i "5s/.*/Icon=\/usr\/share\/icons\/Tela-circle-blue\/16\/panel\/mintupdate-checking.svg/" ~/.local/share/applications/update.desktop

UPDATE_NUMBER=$( (/usr/bin/checkupdates ; /usr/bin/yay -Qua) | wc -l)

if [ "$UPDATE_NUMBER" -eq 1 ]; then
        sed -i "s/mintupdate-checking/mintupdate-updates-available/" ~/.local/share/applications/update.desktop
	DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send -i update Update "$UPDATE_NUMBER update available"
elif  [ "$UPDATE_NUMBER" -gt 1 ]; then
	sed -i "s/mintupdate-checking/mintupdate-updates-available/" ~/.local/share/applications/update.desktop
	DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send -i update Update "$UPDATE_NUMBER updates available"
else
        sed -i "s/mintupdate-checking/mintupdate-up-to-date/" ~/.local/share/applications/update.desktop
fi
