#!/bin/bash

options=("<span font='FontAwesome'></span> Lock" "<span font='FontAwesome'></span> Suspend" "<span font='FontAwesome'></span> Soft Reboot" "<span font='FontAwesome'></span> Reboot" "<span font='FontAwesome'></span> Shutdown")
rofi_menu_options=$(for option in "${options[@]}"; do echo "${option}"; done | rofi -dmenu -i -markup-rows -p "Power menu")

case "${rofi_menu_options}" in
	*Lock)
		if command -v i3lock > /dev/null; then
			i3lock -eti ~/Pictures/i3/lock.png
		elif command -v swaylock > /dev/null; then
			swaylock -feti ~/Pictures/Sway/lock.png
		fi
	;;
	*Suspend)
		if command -v i3lock > /dev/null; then
			i3lock -eti ~/Pictures/i3/lock.png && systemctl suspend
		elif command -v swaylock > /dev/null; then
			swaylock -feti ~/Pictures/Sway/lock.png && systemctl suspend
		fi
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
