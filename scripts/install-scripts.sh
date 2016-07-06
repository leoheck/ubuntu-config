#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# INSTALL CUSTOM SCRIPTS
# Install scrips and customized executables

# Usage:
# install-scripts.sh -i <PATH>
# install-scripts.sh -r

key="$1"

install_scripts()
{
	SCRIPTDIR=$1
	echo "  - Installing user scripts"
	cp -f "$SCRIPTDIR"/bin/upgrade-gaph-host /usr/bin
	ln -sf /usr/bin/upgrade-gaph-host /usr/bin/gaph-host-upgrade
}

remove_scripts()
{
	echo "  - Removing user scripts"
	rm -rf /usr/bin/upgrade-gaph-host
}

case $key in

	-i|--install)
	SCRIPTDIR="$2"
	install_scripts "$SCRIPTDIR"
	exit 0
	;;

	-r|--remove)
	remove_scripts
	exit 0
	;;

	*)
	echo "Unknonw option"
	exit 1

esac
