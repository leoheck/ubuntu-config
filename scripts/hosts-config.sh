#!/bin/bash

# Configure hosts file
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures the /etc/hosts
# Features:
# - Set initial hosts file since it will be updated periodicaly

key="$1"

install_cmd()
{
	echo "  - Configuring /etc/hosts"

	# BACKUP
	if [ ! -f /etc/hosts.bkp ]; then
		cp /etc/hosts /etc/hosts.bkp
	fi

	HOSTNAME=$(hostname)
	IP=$(ifconfig | grep 10.32. | tr -s '[:space:]' | cut -d' ' -f3 | cut -d: -f2)

	# Inicialmente clona o arquivo pronto do soft64
	if [ -f /soft64/admin/etc/hosts_current ]; then
		cp -f /soft64/admin/etc/hosts_current /etc/hosts
		echo "$IP   $HOSTNAME" >> /etc/hosts
	fi
}

remove_cmd()
{
	echo "  - Reverting /etc/hosts"

	if [ -f /etc/hosts.bkp ]; then
		cp /etc/hosts.bkp /etc/hosts
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
