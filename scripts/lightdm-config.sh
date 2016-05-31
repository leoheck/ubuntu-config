#!/bin/bash

# LightDM Configuration (PRECISA REINICIAR PARA FUNCIONAR)
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures the main login screen (LightDM)
# Features:
# - Enable manual login (for network users)
# - Enable the guest login
# - Hide logged users

# Some informations
# https://wiki.ubuntu.com/LightDM
# http://askubuntu.com/questions/155611/no-unity-greeter-conf-file-in-etc-lightdm

key="$1"

install_cmd()
{
	echo "  - Configuring lightdm"

	# BACKUP
	if [ ! -f /etc/lightdm/lightdm.conf.bkp ]; then
		cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bkp
	fi

	#===========================
	read -r -d '' LIGHTDM <<-EOM

	[GuestAccount]
	enabled = true

	[SeatDefaults]
	greeter-session = unity-greeter
	greeter-show-manual-login = true
	allow-guest = true

	EOM
	#===========================

	echo "$LIGHTDM" > /etc/lightdm/lightdm.conf
}

remove_cmd()
{
	echo "  - Reverting lightdm configs"

	if [ -f /etc/lightdm/lightdm.conf.bkp ]; then
		mv /etc/lightdm/lightdm.conf.bkp /etc/lightdm/lightdm.conf
	fi
}

case $key in

	-i|--install)
	install_cmd
	exit 0
	;;

	-r|--remove)
	remove_cmd
	exit 0
	;;

	*)
	echo "Unknonw option"
	exit 1

esac
