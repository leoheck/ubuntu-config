#!/bin/bash

# Configure NSLCD
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures LDAP
# Features:
# - Maps /home folders to /users folder

# Needs:
# sudo aptitude install nslcd

FILE=/etc/nslcd.conf
date=$(date +"%Y-%m-%d-%Hh%M")

# backup the original file
if [ -f ${FILE} ]; then
	cp ${FILE} ${FILE}-${date}
fi

sed -i "s/^uri.*/uri ldap:\/\/rodos.inf.pucrs.br/" ${FILE}
sed -i "s/^base.*/base dc=gaph,dc=inf,dc=pucrs,dc=br/" ${FILE}

echo -e '\n# Change default home mountpoint' >> ${FILE}
echo -e '\nmap passwd homedirectory "/users/$uid"\n' >> ${FILE}

/etc/init.d/nslcd restart