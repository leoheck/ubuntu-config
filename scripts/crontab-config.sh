#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# CRONTAB CONFIGURATION
# This script creates periodic tasks to be executed by the cron

# http://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/
# * * * * * command to be executed
# - - - - -
# | | | | |
# | | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
# | | | ------- Month (1 - 12)
# | | --------- Day of month (1 - 31)
# | ----------- Hour (0 - 23)
# ------------- Minute (0 - 59)

key="$1"

install_cmd()
{
	SCRIPTDIR=$1

	echo "  - Installing cronjobs"

	# BACKUP
	if [ ! -f /var/log/ubuntu-config/cron.bkp ]; then
		crontab -l > /var/log/ubuntu-config/cron.bkp 2> /dev/null
	fi

	#===========================
	read -r -d '' CRONCONF <<-EOM

	# [WARNING] THE ROOT Crontab is updated automatically.
	# Put your cronjobs in the **user** crontab.

	EOM
	#===========================

	echo "$CRONCONF" | crontab -

	# Cria um ponto de restauracao do crontab
	mkdir -p /etc/ubuntu-config/
	echo "$CRONCONF" > /etc/ubuntu-config/crontab

	echo "  - Installing upstart script"
	cp -f "$SCRIPTDIR/init/ubuntu-config.conf" /etc/init/ubuntu-config.conf

	if [ -f /bin/systemctl ]; then
		echo "  - Installing systemd script"
		cp -f "$SCRIPTDIR/systemd/ubuntu-config.service" /lib/systemd/system/ubuntu-config.service
		/bin/systemctl daemon-reload
	fi
}

remove_crontab()
{
	echo "  - Removing cronjobs"

	# Restore backup
	if [ -f /var/log/ubuntu-config/cron.bkp ]; then
		cat /var/log/ubuntu-config/cron.bkp > crontab
	else
		crontab -r
	fi

	# Remove init script
	rm -rf /etc/init/ubuntu-config.conf
	rm -rf /lib/systemd/system/ubuntu-config.service
}

case $key in

	-i|--install)
	SCRIPTDIR="$2"
	install_cmd "$SCRIPTDIR"
	exit 0
	;;

	-r|--remove)
	remove_crontab
	exit 0
	;;

	*)
	echo "Unknonw option"
	exit 1

esac
