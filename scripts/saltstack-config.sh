#!/bin/bash

# SaltStack Configuration
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures the saltstack minion

# Some informations
# http://docs.saltstack.com/en/latest/ref/configuration/minion.html

# Needs:
# sudo aptitude install salt-minion -y

FILE=/etc/salt/minion
date=$(date +"%Y-%m-%d-%Hh%M")

# backup the original file
if [ -f ${FILE} ]; then
	cp ${FILE} ${FILE}-${date}
fi

# Update the master address
sed -i "s/^[#]*master:/master: corfu/g" ${FILE}
