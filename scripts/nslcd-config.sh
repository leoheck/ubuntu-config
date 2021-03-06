#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# Configure NSLCD

# This script configures LDAP
# Features:
# - Maps /home folders to /users folder

# Needs:
# sudo aptitude install nslcd

key="$1"

install_cmd()
{
	echo "  - Configuring /etc/nslcd.conf"

	# BACKUP
	if [ ! -f /etc/nslcd.conf.bkp ]; then
		if [ -f /etc/nslcd.conf ]; then
			cp /etc/nslcd.conf /etc/nslcd.conf.bkp
		fi
	else
		cp /etc/nslcd.conf.bkp /etc/nslcd.conf
	fi

	service nslcd stop &> /dev/null

	sed -i "s/^uri.*/uri ldap:\/\/rodos.inf.pucrs.br/" /etc/nslcd.conf
	sed -i "s/^base.*/base dc=gaph,dc=inf,dc=pucrs,dc=br/" /etc/nslcd.conf

	echo -e '\n# Change default home mountpoint' >> /etc/nslcd.conf
	echo -e "\nmap passwd homedirectory \"/users/\$uid\"\n" >> /etc/nslcd.conf

	service nslcd start &> /dev/null
}

remove_cmd()
{
	echo "  - Reverting /etc/nslcd.conf"

	service nslcd stop &> /dev/null

	if [ -f /etc/nslcd.conf.bkp ]; then
		mv /etc/nslcd.conf.bkp /etc/nslcd.conf
	fi

	service nslcd start &> /dev/null
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
