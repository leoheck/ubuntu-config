#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# INSTALL MINIMUM REQUIRED APLICATIONS

# Referencias:
# http://xmodulo.com/how-to-install-software-packages-in-non-interactive-batch-mode.html

APPSCSV=$(cat PACKAGES.csv)
APPS=$(echo "$APPSCSV" | sed '/^\s*\#.*$/d' | cut -d, -f1 | sed '/^\s*$/d')

if [ ! -f /etc/apt/sources.list.bkp ]; then
	cp /etc/apt/sources.list /etc/apt/sources.list.bkp
fi

# Enable extra repositories
sed -i "s/#deb http/deb http/" /etc/apt/sources.list
sed -i "s/#deb-src http/deb-src http/" /etc/apt/sources.list

# TO LEARN THE REQUIRED QUESTIONS
# 1. Install package
# 2. Run: sudo debconf-show [pkg-name]

# Installation
dpkg --add-architecture i386
apt-get update
apt-get install -f -y

# Install apps individually
for APP in $APPS; do
	dpkg -s "$APP" &> /dev/null
	if [ ! $? -eq 0 ]; then
		DEBIAN_FRONTEND=noninteractive apt-get install -y "$APP"
	fi
done
