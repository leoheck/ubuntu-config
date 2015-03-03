#!/bin/bash

# Configure NSSWITCH
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures the ldap logins
# Features:
# - Enables the login by LDAP

FILE=/etc/nsswitch.conf
date=$(date +"%Y-%m-%d-%Hh%M")

# backup the original file
if [ -f ${FILE} ]; then
	cp ${FILE} ${FILE}-${date}
fi

sed -i "s/^passwd:.*/passwd: compat ldap/" ${FILE}
sed -i "s/^group:.*/group:  compat ldap/"  ${FILE}
sed -i "s/^shadow:.*/shadow: compat ldap/" ${FILE}
