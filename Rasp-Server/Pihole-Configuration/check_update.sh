#!/bin/bash

##Dependencies : pacman-contrib

PACKAGES=$(/usr/bin/checkupdates | awk '{print $1}' && /usr/bin/yay -Qua | awk '{print $1}')

if [ -n "$PACKAGES" ]; then
        echo -e "Subject:Rasp server's package list available for update\n\nHello,\n\nThe following packages can be updated on the Rasp server :\n$PACKAGES" | /usr/sbin/sendmail yourmail@example.com, yourmail2@example.com
else
        echo -e "Subject:No packages to update on Rasp Server\n\nHello,\n\nThere is no packages to update on Rasp Server.\nThe Rasp server is up to date" | /usr/sbin/sendmail yourmail@example.com, yourmail2@example.com
fi
