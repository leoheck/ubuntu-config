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

install_crontab()
{
	echo "  - Installing cronjobs"

	mkdir -p /etc/gaph/cron/

	# BACKUP
	if [ ! -f /etc/gaph/cron/cron.bkp ]; then
		crontab -l > /etc/gaph/cron/cron.bkp
	fi

	#===========================
	read -r -d '' CRONCONF <<-EOM

	MAILTO="leoheck+gaphcron@gmail.com"

	# Test (1x/min)
	# * * * * * touch /tmp/gaph-upgrade-\$(date +\%Y-\%m-\%d:\%H:\%M)

	# Upgrade gaph config from github (1x/week)
	0 0 * * 0 /usr/bin/upgrade-gaph-host

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

	echo "$CRONCONF" | crontab -
}

remove_crontab()
{
	echo "  - Removing cronjobs"

	# Restore backup
	if [ -f /etc/gaph/cron/cron.bkp ]; then
		cat /etc/gaph/cron/cron.bkp > crontab
	else
		crontab -r
	fi

	rm -rf /etc/gaph/cron/
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
