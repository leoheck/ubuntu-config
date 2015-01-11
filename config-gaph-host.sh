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

./scripts/fstab-config.sh
./scripts/nslcd-config.sh
./scripts/nsswitch-config.sh

./scripts/admin-config.sh
./scripts/lightdm-config.sh
./scripts/crontab-config.sh
./scripts/saltstack-config.sh

./scripts/users-config.sh
./scripts/misc-hacks.sh

# install all other pakages