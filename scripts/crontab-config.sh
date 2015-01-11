#!/bin/bash

# Crontab Configuration
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script creates periodic tasks to be executed by the con
# Features:
# - Update the hosts file
# - Check if the SGE is running

# References
# https://en.wikipedia.org/wiki/Cron

#==============================================================================
crontab << END-OF-CONFIG-FILE

# [GAPH] Update the hosts file
30 7,12,18,23 * * * /soft64/admin/scripts/update-hosts.sh

# [GAPH] Verify if SGE is running
0 * * * * root /etc/init.d/sgeexecd-ubuntu start > /dev/null 2>&1

END-OF-CONFIG-FILE
#==============================================================================
