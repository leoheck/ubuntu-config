#!/bin/bash

# GAPH Hosts main configuration script
# Leandro Sehnem Heck (leoheck@gmail.com)

# Check for super power
if [ "$(id -u)" != "0" ]; then
	echo "Hey kid, you need to be root, call your father."
	exit 1
fi

# install minimum but required software
./scripts/initial-software.sh
read

./scripts/fstab-config.sh
read

./scripts/nslcd-config.sh
read

./scripts/nsswitch-config.sh
read

./scripts/admin-config.sh
read
./scripts/lightdm-config.sh
read
./scripts/crontab-config.sh
read
./scripts/saltstack-config.sh
read

./scripts/config-printers.sh
read

./scripts/users-config.sh
read
./scripts/misc-hacks.sh
read

# install all other pakages

reboot -f now
