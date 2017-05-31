#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# INSTALL MINIMUM REQUIRED APLICATIONS

# Referencias:
# http://xmodulo.com/how-to-install-software-packages-in-non-interactive-batch-mode.html

if [ ! -f /etc/apt/sources.list.bkp ]; then
	cp /etc/apt/sources.list /etc/apt/sources.list.bkp
fi

# Enable extra repositories
sed -i "s/#deb http/deb http/" /etc/apt/sources.list
sed -i "s/#deb-src http/deb-src http/" /etc/apt/sources.list

# Add google-chrome ppa
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google.list'

# Add virtualbox ppa
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -

# Workaround for a bug related ttf-mscorefonts-installer
# https://bugs.launchpad.net/ubuntu/+source/aptitude/+bug/1543280
chmod 777 /var/lib/update-notifier/package-data-downloads/partial

ppas="\
	ppa:freyja-dev/unity-tweak-tool-daily \
	ppa:indicator-multiload/daily \
	ppa:js-reynaud/kicad-4 \
	ppa:shutter/ppa \
	ppa:tualatrix/ppa \
	ppa:webupd8team/java \
	ppa:webupd8team/sublime-text-3 \
	ppa:webupd8team/terminix \
	ppa:webupd8team/y-ppa-manager \
	ppa:wine/wine-builds"


# Removed
# ppa:pgavin/ghdl
# ppa:blahota/texstudio

# Installation
export DEBIAN_FRONTEND=noninteractive
dpkg --add-architecture i386
apt-get update
apt-get install -f -y

# Add extra repositories
for ppa in $ppas; do
	apt-add-repository -y "$ppa"
done

# Configure required answares when it is needed
# FORMAT: <owner> <question name> <question type> <value>
debconf-set-selections <<< "d-i msttcorefonts/accepted-mscorefonts-eula select true"
debconf-set-selections <<< "d-i shared/accepted-oracle-license-v1-1 select true"
debconf-set-selections <<< "d-i shared/accepted-oracle-license-v1-1 seen true"
