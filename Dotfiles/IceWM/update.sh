#!/bin/bash

sed -i "5s/.*/Icon=\/usr\/share\/icons\/Tela-circle-blue\/16\/panel\/mintupdate-checking.svg/" ~/.local/share/applications/update.desktop

PACKAGES=$(/usr/bin/checkupdates | awk '{print $1}')
AURPACKAGES=$(/usr/bin/yay -Qua | awk '{print $1}')

if [ -n "$PACKAGES" ]; then
        echo -e "Packages :\n" && echo -e "$PACKAGES\n"
fi

if [ -n "$AURPACKAGES" ]; then
        echo -e "AUR Packages :\n" && echo -e "$AURPACKAGES\n"
fi

if [ -z "$PACKAGES" ] && [ -z "$AURPACKAGES" ]; then
	sed -i "s/mintupdate-checking/mintupdate-up-to-date/" ~/.local/share/applications/update.desktop
        echo -e "No update available\n" && read -n 1 -r -s -p $'Press \"enter\" to quit\n'
        exit 0
else
	sed -i "s/mintupdate-checking/mintupdate-updates-available/" ~/.local/share/applications/update.desktop
        read -n 1 -r -s -p $'Press \"enter\" to apply updates or \"ctrl + c\" to quit\n'
        sed -i "s/mintupdate-updates-available/mintupdate-installing/" ~/.local/share/applications/update.desktop
        sudo pacman -Syu && yay -Syu

        if [ "$?" -ne 0 ]; then
                sed -i "s/mintupdate-installing/mintupdate-updates-available/" ~/.local/share/applications/update.desktop
                echo -e "\nUpdates have been aborted\n" && read -n 1 -r -s -p $'Press \"enter\" to quit\n'
                exit 1
        fi

        sed -i "s/mintupdate-installing/mintupdate-up-to-date/" ~/.local/share/applications/update.desktop
        echo -e "\nUpdates have been applied\n" && read -n 1 -r -s -p $'Press \"enter\" to quit\n'
        exit 0
fi
