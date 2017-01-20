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
	cp -f "$SCRIPTDIR"/bin/debug-gaph-host /usr/bin

	# Nomes alternativos
	ln -sf /usr/bin/upgrade-gaph-host /usr/bin/gaph-host-upgrade
	ln -sf /usr/bin/debug-gaph-host   /usr/bin/gaph-host-debug

	# SSH login info
	cp -f "$SCRIPTDIR"/etc/update-motd.d/99-gaph-banner.sh /etc/update-motd.d/
	echo "/etc/update-motd.d/99-gaph-banner.sh" >> /etc/update-motd.d/00-header
}

remove_scripts()
{
	echo "  - Removing user scripts"
	rm -rf /usr/bin/upgrade-gaph-host
	rm -rf /usr/bin/gaph-host-upgrade
	rm -rf /usr/bin/debug-gaph-host
	rm -rf /usr/bin/gaph-host-debug

	# SSH Info
	rm -rf /etc/update-motd.d/99-gaph-banner.sh
	sed -i '/99-gaph-banner.sh/d' /etc/update-motd.d/00-header
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
