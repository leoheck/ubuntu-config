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
	echo "root:VLuxY7G/MDMO2" | chpasswd -e

	# Increase the LDAP domain admins powers
	echo -e '\n# LDAP Domain Admins' >> /etc/sudoers
	echo -e '%Domain\ Admins ALL=(ALL) ALL\n\n' >> /etc/sudoers
}

remove_cmd()
{
	echo "  - Reverting admins access"

	# /etc/shadow
	# root:!:16927:0:99999:7:::

	# Increase the LDAP domain admins powers
	sed -i '/# LDAP Domain Admins/d' /etc/sudoers
	sed -i '/%Domain\ Admins ALL=(ALL) ALL\n\n/d' /etc/sudoers
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
