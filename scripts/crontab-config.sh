#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# CRONTAB CONFIGURATION
# This script creates periodic tasks to be executed by the cron

# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed

key="$1"

install_crontab()
{
	echo "  - Installing cronjobs"

	# BACKUP
	if [ ! -f /var/spool/cron/crontabs/root.bkp ]; then
		if [ -f /var/spool/cron/crontabs/root ]; then
			cp /var/spool/cron/crontabs/root /var/spool/cron/crontabs/root.bkp
		fi
	fi

	#===========================
	read -r -d '' CRONCONF <<-EOM

	# Test (1x/min)
	# * * * * * touch /tmp/gaph-upgrade-\$(date +\%Y-\%m-\%d:\%H:\%M)

	# Upgrade host from github (1x/day)
	0 2 * * * /usr/bin/upgrade-gaph-host

	# Keep /etc/salt/minion updated and running (1x/day)
	0 2 * * * echo "$(hostname)" > /etc/salt/minion_id; sed -i "s/^[#]*master:.*/master: rodos/g" /etc/salt/minion; service salt-minion restart

	# Update /etc/hosts file (4x/day)
	30 7,12,18,23 * * * /soft64/admin/scripts/update-hosts.sh

	# Keep SGE running (1x/hour)
	0 * * * * root /etc/init.d/sgeexecd-ubuntu start > /dev/null 2>&1

	# Remove files older than n-days in /sim folder (1x/day)
	#0 2 * * * root find /sim/ -mtime +25 -exec rm {} \;

	# Backup main local user (UID=1000) files
	# 0 2 * * * root rsync /home/.$USER-bkp (incremental..only diffs..)

	EOM
	#===========================

	echo "$CRONCONF" >> crontab
}

remove_crontab()
{
	echo "  - Removing cronjobs"

	if [ -f /var/spool/cron/crontabs/root.bkp ]; then
		mv /var/spool/cron/crontabs/root.bkp /var/spool/cron/crontabs/root
	else
		rm -f /var/spool/cron/crontabs/root
	fi
}

case $key in

	-i|--install)
	install_crontab
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
