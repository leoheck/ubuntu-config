#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# Install EXTRA APPLICATIONS

# Add google-chrome ppa
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google.list'

# Add virtualbox ppa
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -

ppas="\
	ppa:freyja-dev/unity-tweak-tool-daily \
	ppa:indicator-multiload/daily \
	ppa:js-reynaud/kicad-4 \
	ppa:shutter/ppa \
	ppa:tualatrix/ppa \
	ppa:webupd8team/java \
	ppa:webupd8team/sublime-text-3 \
	ppa:webupd8team/terminix \
	ppa:webupd8team/y-ppa-manager"

# Removed
# ppa:pgavin/ghdl
# ppa:blahota/texstudio

# Add extra repositories
for ppa in $ppas; do
	apt-add-repository -y "$ppa"
done

APPSCSV=$(cat PACKAGES.csv)
APPS=$(echo "$APPSCSV" | sed '/^\s*\#.*$/d' | cut -d, -f1 | sed '/^\s*$/d')

# Workaround for a bug related ttf-mscorefonts-installer
# https://bugs.launchpad.net/ubuntu/+source/aptitude/+bug/1543280
chmod 777 /var/lib/update-notifier/package-data-downloads/partial

# TO LEARN THE REQUIRED QUESTIONS
# 1. Install package
# 2. Run: sudo debconf-show [pkg-name]

# Configure required answares when it is needed
# FORMAT: <owner> <question name> <question type> <value>
debconf-set-selections <<< "d-i msttcorefonts/accepted-mscorefonts-eula select true"
debconf-set-selections <<< "d-i shared/accepted-oracle-license-v1-1 select true"
debconf-set-selections <<< "d-i shared/accepted-oracle-license-v1-1 seen true"

# This guy resets configs above (ISSUE)
#dpkg-reconfigure --force

# Installation process
export DEBIAN_FRONTEND=noninteractive
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
