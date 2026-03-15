#!/bin/bash

options=("<span font='FontAwesome'></span> Lock" "<span font='FontAwesome'></span> Suspend" "<span font='FontAwesome'></span> Soft Reboot" "<span font='FontAwesome'></span> Reboot" "<span font='FontAwesome'></span> Shutdown")
rofi_menu_options=$(for option in "${options[@]}"; do echo "${option}"; done | rofi -dmenu -i -markup-rows -p "Power menu")

case "${rofi_menu_options}" in
	*Lock)
		swaylock -feti ~/Pictures/Niri/lock.png -s fill
	;;
	*Suspend)
		swaylock -feti ~/Pictures/Niri/lock.png -s fill && systemctl suspend
	;;
	*Soft\ Reboot)
		systemctl soft-reboot
	;;
	*Reboot)
		systemctl reboot
	;;
	*Shutdown)
		systemctl poweroff
	;;
esac
