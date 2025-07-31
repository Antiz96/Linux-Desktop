#!/bin/bash

option="${1}"
argument="${2}"
backup_dir="/run/media/antiz/data/Backup/System_Backup"

if [ "${EUID}" -ne 0 ]; then
	echo "Please, run as root"
	exit 1
fi

mkdir -p "${backup_dir}"

rsync_cmd() {
	rsync -aAXHv --delete \
	--exclude "${backup_dir}"'/*' \
	--exclude='/dev/*' \
	--exclude='/proc/*' \
	--exclude='/sys/*' \
	--exclude='/tmp/*' \
	--exclude='/run/*' \
	--exclude='/mnt/*' \
	--exclude='/media/*' \
	--exclude='/lost+found/' \
	--exclude='/opt/distrobox/*' \
	--exclude='/var/cache/pacman/pkg/*' \
	--exclude='/var/lib/archbuild/*' \
	--exclude='/var/lib/aurbuild/*' \
	--exclude='/var/lib/repro/*' \
	--exclude='/var/lib/docker/*' \
	--exclude='/root/*' \
	--exclude='/home/*' \
	"${source_dir}" "${dest_dir}"
}

case "${option}" in
	-C|--create)
		source_dir="/"
		
		if [ "${argument}" == "--scheduled" ]; then
			dest_dir="$(date +%d-%m-%Y_%H-%M)-scheduled"
		elif [ "${argument}" == "--on-demand" ]; then
			dest_dir="$(date +%d-%m-%Y_%H-%M)-on-demand"
		else
			echo -e >&2 "Invalid or missing argument\nUsage: --create --scheduled | --create --on-demand"
			exit 4
		fi

		# shellcheck disable=SC2015
		cd "${backup_dir}" && rsync_cmd && echo -e "\nSystem Backup complete" || { echo -e >&2 "\nSystem Backup failed" && sudo -u antiz DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send -u critical "System Backup" "System Backup failed" && rm -rf "${dest_dir}" ; exit 2; }
		find "${backup_dir}" -mindepth 1 -maxdepth 1 -type d -ctime +8 -exec rm -rf {} \;
	;;
	-R|--restore)
		if [ -n "${argument}" ]; then
			snapshot_dir="${argument}"
			source_dir="."
			dest_dir="/"
			
		 	# shellcheck disable=SC2015
			cd "${snapshot_dir}" && rsync_cmd && mkinitcpio -P && echo -e "\nThe restoration is done\nPlease, reboot the system" || { echo -e >&2 "\nAn error occurred during the restoration process"; exit 3; }
		else
			echo -e >&2 "Missing argument\nUsage: --restore '<path to snapshot>'"
			exit 4
		fi
	;;
	*)
		echo -e >&2 "Invalid option"
		exit 4
	;;
esac
