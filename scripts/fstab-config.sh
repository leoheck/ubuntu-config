#!/bin/bash

# Configure FSTAB
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures the network mount points
# - Add /users entry
# - Add /soft64 entry
# - Add /grid entry
# - Add /sim entry

key="$1"

install_cmd()
{
	echo "  - Configuring /etc/fstab"

	# BACKUP
	if [ ! -f /etc/fstab.bkp ]; then
		cp /etc/fstab /etc/fstab.bkp
	fi

	mkdir -p /users
	mkdir -p /soft64
	mkdir -p /grid
	mkdir -p /sim

	#===========================
	read -r -d '' FSTAB <<-EOM

	# Local simulation drive
	#/dev/sdb1 /sim ext4 defaults 0 0

	# [GAPH] Network mountoints
	rodos.inf.pucrs.br:/home   /users  nfs acl,defaults 0 0
	kriti.inf.pucrs.br:/soft64 /soft64 nfs ro,soft,intr 0 0
	kriti.inf.pucrs.br:/grid   /grid   nfs defaults     0 0

	EOM
	#============================

	echo "$FSTAB" >> /etc/fstab

	# Mounta se der.. (espero que sempre de, coloquei isso pra testar o processo)
	ping -c 1 10.32.162.114 > /dev/null
	if [ "$?" -eq 0 ] ; then
		mount -a
	fi
}

remove_cmd()
{
	echo "  - Reverting /etc/fstab"

	umount -f /users 2> /dev/null
	umount -f /soft64 2> /dev/null
	umount -f /grid 2> /dev/null
	umount -f /sim 2> /dev/null

	rm -rf /users
	rm -rf /soft64
	rm -rf /grid
	rm -rf /sim

	if [ -f /etc/fstab.bkp ]; then
		mv /etc/fstab.bkp /etc/fstab
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
