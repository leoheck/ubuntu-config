#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# Configure NSSWITCH

# This script configures the LDAP users accounts
# Features:
# - Enables the login by LDAP

key="$1"

install_cmd()
{
	echo "  - Configuring /etc/nsswitch.conf"

	# BACKUP
	if [ ! -f /etc/nsswitch.conf.bkp ]; then
		cp /etc/nsswitch.conf /etc/nsswitch.conf.bkp
	fi

	sed -i "s/^passwd:.*/passwd: compat ldap/" /etc/nsswitch.conf
	sed -i "s/^group:.*/group:  compat ldap/"  /etc/nsswitch.conf
	sed -i "s/^shadow:.*/shadow: compat ldap/" /etc/nsswitch.conf
}

remove_cmd()
{
	echo "  - Reverting /etc/nsswitch.conf"

	if [ -f /etc/nsswitch.conf.bkp ]; then
		mv /etc/nsswitch.conf.bkp /etc/nsswitch.conf
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
