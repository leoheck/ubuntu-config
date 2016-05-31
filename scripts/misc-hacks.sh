#!/bin/bash

# Some hacks to support our CAD and misc customizations
# Leandro Sehnem Heck (leoheck@gmail.com)

echo "  - Applying MISC hacks"

# Update some lib paths (IMPORTANT)
sudo ln -s -f /usr/lib/x86_64-linux-gnu/crt?.o   /lib/
sudo ln -s -f /usr/lib/x86_64-linux-gnu/libm.so  /lib/libm.so
sudo ln -s -f /usr/lib/x86_64-linux-gnu/librt.so /lib/librt.so
sudo ln -s -f /usr/lib/x86_64-linux-gnu/libc.so  /lib/libc.so
sudo ln -s -f /usr/lib/x86_64-linux-gnu/libdl.so /lib/libdl.so
sudo ln -s -f /usr/lib/x86_64-linux-gnu/libdl.a  /lib/libdl.a

# Library for LEC
sudo ln -s -f /lib/x86_64-linux-gnu/libncurses.so.5.9 /lib/libtermcap.so.2

# Hack some shells
sudo rm -rf /bin/sh
sudo ln -s /bin/bash /bin/sh
sudo rm -rf /bin/csh
sudo ln -s /bin/tcsh /bin/csh

# Some symbolic links
sudo ln -s /usr/bin/basename /bin/basename
sudo ln -s /usr/bin/sort /bin/sort
sudo ln -s /usr/bin/make /usr/bin/gmake
sudo ln -s /usr/bin/awk /bin/awk
sudo ln -s /usr/bin/firefox /usr/bin/netscape

# Default paper size
echo "a4" > /etc/papersize

# Disable apport messages
sed -i 's/enabled=1/enabled=0/p' /etc/default/apport

# Hack for dropbox inodes
echo "fs.inotify.max_user_watches = 99999999999" >> /etc/sysctl.d/20-dropbox-inotify.conf
sysctl -p /etc/sysctl.d/20-dropbox-inotify.conf
