#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# HACKS to support our CAD and some misc customizations

echo "  - Applying MISC hacks"

# Faking a RedHat/Centos
read -r -d '' os_release <<-EOF
CentOS release 5.11 (Final) [faking]
EOF
echo "$os_release" > /etc/redhat-release

# Update some lib paths (IMPORTANT many CAD require this)
ln -sf /usr/lib/x86_64-linux-gnu/crt?.o        /lib/
ln -sf /usr/lib/x86_64-linux-gnu/libm.so       /lib/libm.so
ln -sf /usr/lib/x86_64-linux-gnu/librt.so      /lib/librt.so
ln -sf /usr/lib/x86_64-linux-gnu/libc.so       /lib/libc.so
ln -sf /usr/lib/x86_64-linux-gnu/libdl.so      /lib/libdl.so
ln -sf /usr/lib/x86_64-linux-gnu/libdl.a       /lib/libdl.a
ln -sf /usr/lib/x86_64-linux-gnu/libjpeg.so.8  /lib/libjpeg.so.62
ln -sf /lib/x86_64-linux-gnu/libncurses.so.5.9 /lib/libtermcap.so.2
ln -sf /lib/x86_64-linux-gnu/libreadline.so.6  /lib/x86_64-linux-gnu/libreadline.so.5
ln -sf /lib/x86_64-linux-gnu/libhistory.so.6   /lib/x86_64-linux-gnu/libhistory.so.5

# WORKAROUND for missing libxp6 library in Ubuntu 16.04
# Use libxp6 from Ubuntu 14.04 repositories
wget "http://mirrors.kernel.org/ubuntu/pool/main/libx/libxp/libxp6_1.0.2-1ubuntu1_amd64.deb" -P /tmp > /dev/null 2>&1
dpkg -i /tmp/libxp6_1.0.2-1ubuntu1_amd64.deb > /dev/null
rm -f /tmp/libxp6_1.0.2-1ubuntu1_amd64.deb

# ttf-mscorefonts-installer fix
apt-get purge -y ttf-mscorefonts-installer > /dev/null
wget "http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb" -P /tmp > /dev/null 2>&1
dpkg -i /tmp/ttf-mscorefonts-installer_3.6_all.deb > /dev/null
rm -f /tmp/libxp6_1.0.2-1ubuntu1_amd64.deb

# Fix some names
ln -sf /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libm.so

# Fix some version of 64 bit libs for Synopsys tools
ln -sf /usr/lib/x86_64-linux-gnu/libtiff.so.5 /usr/lib/x86_64-linux-gnu/libtiff.so.3 2> /dev/null
ln -sf /usr/lib/x86_64-linux-gnu/libmng.so.2.0.2 /usr/lib/x86_64-linux-gnu/libmng.so.1 2> /dev/null

# Fix some version of 32 bit libs for Synopsys tools
ln -sf /usr/lib/i386-linux-gnu/libtiff.so.5 /usr/lib/i386-linux-gnu/libtiff.so.3 2> /dev/null
ln -sf /usr/lib/i386-linux-gnu/libmng.so.2.0.2 /usr/lib/i386-linux-gnu/libmng.so.1 2> /dev/null

# Hack some shells
rm -rf /bin/sh
ln -sf /bin/bash /bin/sh
rm -rf /bin/csh
ln -sf /bin/tcsh /bin/csh

# Some symbolic links for binaries
ln -sf /usr/bin/basename /bin/basename
ln -sf /usr/bin/sort /bin/sort
ln -sf /usr/bin/make /usr/bin/gmake
ln -sf /usr/bin/awk /bin/awk
ln -sf /usr/bin/firefox /usr/bin/netscape

# Default paper size
echo "a4" > /etc/papersize

# Disable apport messages
sed -i 's/enabled=1/enabled=0/p' /etc/default/apport

# Hack for dropbox inodes
echo "fs.inotify.max_user_watches = 99999999999" >> /etc/sysctl.d/20-dropbox-inotify.conf
sysctl -p /etc/sysctl.d/20-dropbox-inotify.conf > /dev/null



# Install misc tools.....

# Install custom pygattlib (python 2.7)
hg clone https://bitbucket.org/arthurcburigo/pygattlib
cd pygattlib
make
sudo make install
make PYTHON_VER=3
sudo make install
rm -rf pygattlib

# Install hub
latest_hub=$(curl -s  https://github.com/github/hub/releases | grep "linux-amd64.*.tgz" | head -1 | cut -d\" -f2)
wget https://github.com/$latest_hub
hub_tarball=$(basename $latest_hub)
tar xvzf $hub_tarball
hub_folder=${hub_tarball%.*}
cd $hub_folder
sudo ./install
cd -
rm -rf run-linux*

# Envirnoment modules (tcl or c)
# http://modules.sourceforge.net/
git clone https://git.code.sf.net/p/modules/modules-tcl modules-tcl
cd modules-tcl
make -C doc all
make install
cd ..
rm -rf modules-tcl