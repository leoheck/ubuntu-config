#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# HACKS to support our CAD and some misc customizations

echo "  - Applying MISC hacks"

# Update some lib paths (IMPORTANT many CAD require this)
ln -s -f /usr/lib/x86_64-linux-gnu/crt?.o        /lib/
ln -s -f /usr/lib/x86_64-linux-gnu/libm.so       /lib/libm.so
ln -s -f /usr/lib/x86_64-linux-gnu/librt.so      /lib/librt.so
ln -s -f /usr/lib/x86_64-linux-gnu/libc.so       /lib/libc.so
ln -s -f /usr/lib/x86_64-linux-gnu/libdl.so      /lib/libdl.so
ln -s -f /usr/lib/x86_64-linux-gnu/libdl.a       /lib/libdl.a
ln -s -f /usr/lib/x86_64-linux-gnu/libjpeg.so.8  /lib/libjpeg.so.62
ln -s -f /lib/x86_64-linux-gnu/libncurses.so.5.9 /lib/libtermcap.so.2

# WORKAROUND for missing libxp6 library in Ubuntu 16.04
# Use libxp6 from Ubuntu 14.04 repositories
wget "http://mirrors.kernel.org/ubuntu/pool/main/libx/libxp/libxp6_1.0.2-1ubuntu1_amd64.deb" > /dev/null 2>&1
dpkg -i libxp6_1.0.2-1ubuntu1_amd64.deb > /dev/null
rm -f libxp6_1.0.2-1ubuntu1_amd64.deb 

# Hack some shells
rm -rf /bin/sh
ln -s -f /bin/bash /bin/sh
rm -rf /bin/csh
ln -s -f /bin/tcsh /bin/csh

# Some symbolic links
ln -s -f /usr/bin/basename /bin/basename
ln -s -f /usr/bin/sort /bin/sort
ln -s -f /usr/bin/make /usr/bin/gmake
ln -s -f /usr/bin/awk /bin/awk
ln -s -f /usr/bin/firefox /usr/bin/netscape

# Default paper size
echo "a4" > /etc/papersize

# Disable apport messages
sed -i 's/enabled=1/enabled=0/p' /etc/default/apport

# Hack for dropbox inodes
echo "fs.inotify.max_user_watches = 99999999999" >> /etc/sysctl.d/20-dropbox-inotify.conf
sysctl -p /etc/sysctl.d/20-dropbox-inotify.conf > /dev/null
