#!/bin/bash

options=("<span font='FontAwesome'></span> Lock" "<span font='FontAwesome'></span> Suspend" "<span font='FontAwesome'></span> Soft Reboot" "<span font='FontAwesome'></span> Reboot" "<span font='FontAwesome'></span> Shutdown")
rofi_menu_options=$(for option in "${options[@]}"; do echo "${option}"; done | rofi -dmenu -i -markup-rows -p "Power menu")

case "${rofi_menu_options}" in
	*Lock)
		i3lock -eti ~/.config/i3/lock.png
	;;
	*Suspend)
		i3lock -eti ~/.config/i3/lock.png && systemctl suspend 
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
