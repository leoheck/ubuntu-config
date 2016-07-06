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


# Test (1x/min)
# * * * * * touch /tmp/gaph-upgrade-\$(date +\%Y-\%m-\%d:\%H:\%M)

# Upgrade gaph config from github (1x/week)
# 0 0 * * 0 /usr/bin/upgrade-gaph-host

# Remove files older than n-days in /sim folder (1x/day)
#0 2 * * * root find /sim/ -mtime +25 -exec rm {} \;

# Backup main local user (UID=1000) files
# 0 2 * * * root rsync /home/.$USER-bkp (incremental..only diffs..)


# Verifying if init script works
# init-checkconf /etc/init/gaph.conf

install_cmd()
{
	SCRIPTDIR=$1

	echo "  - Installing cronjobs"

	# BACKUP
	if [ ! -f /var/log/gaph/cron.bkp ]; then
		crontab -l > /var/log/gaph/cron.bkp 2> /dev/null
	fi

	#===========================
	read -r -d '' CRONCONF <<-EOM

	# [WARNING] THE ROOT Crontab is updated automatically. 
	# Put your cronjobs in the **user** crontab.

	# TESTING (1x/day)
	0 0 * * * root /usr/bin/upgrade-gaph-host

	# Keep /etc/salt/minion updated and running (1x/day)
	0 2 * * * echo "$(hostname)" > /etc/salt/minion_id; sed -i "s/^[#]*master:.*/master: rodos/g" /etc/salt/minion; service salt-minion restart

	# Update /etc/hosts file (4x/day)
	30 7,12,18,23 * * * /soft64/admin/scripts/update-hosts.sh

	# Keep SGE running (1x/hour)
	0 * * * * root /etc/init.d/sgeexecd-ubuntu start > /dev/null 2>&1

	EOM
	#===========================

	echo "$CRONCONF" | crontab -


	# Cria um ponto de restauracao do crontab
	mkdir -p /etc/gaph/
	echo "$CRONCONF" > /etc/gaph/crontab

	echo "  - Installing upstart script"
	cp -f "$SCRIPTDIR/init/gaph.conf" /etc/init/gaph.conf

	echo "  - Installing systemd script"
	cp -f "$SCRIPTDIR/systemd/gaph.service" /lib/systemd/system/gaph.service
	systemctl daemon-reload
}

remove_crontab()
{
	echo "  - Removing cronjobs"

	# Restore backup
	if [ -f /var/log/gaph/cron.bkp ]; then
		cat /var/log/gaph/cron.bkp > crontab
	else
		crontab -r
	fi

	# Remove init script
	rm -rf /etc/init/gaph.conf
	rm -rf /lib/systemd/system/gaph.service
}

case $key in

	-i|--install)
	SCRIPTDIR="$2"
	install_cmd $SCRIPTDIR
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
