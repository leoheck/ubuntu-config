#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# CONFIG SUPERIOR ACCESS

key="$1"

# TO ENABLE SSH With ROOT:
# http://askubuntu.com/questions/469143/how-to-enable-ssh-root-access-on-ubuntu-14-04
# BY NOW THIS IS DISABLED!

install_cmd()
{
	echo "  - Configuring admins accesss"

	# To generate the cripto password: openssl passwd
	# echo "root:VLuxY7G/MDMO2" | chpasswd -e
}

remove_cmd()
{
	echo "  - Reverting admins access"

	# /etc/shadow
	# root:!:16927:0:99999:7:::
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
