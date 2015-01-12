#!/bin/bash

# Configure minimum REQUIRED software
# Leandro Sehnem Heck (leoheck@gmail.com)

# Referencias:
# http://xmodulo.com/how-to-install-software-packages-in-non-interactive-batch-mode.html

# Enable partner repositories
sed -i "s/#deb http/deb http/" /etc/apt/sources.list
sed -i "s/#deb-src http/deb-src http/" /etc/apt/sources.list

apt-get update
apt-get full-upgrade

sudo apt-get install -y aptitude                                  # Apt-get front end
sudo apt-get install -y linux-headers-$(uname -r)                 # Linux Heders
sudo apt-get install -y linux-headers-generic                     # Generic Kernel Headers
sudo apt-get install -y build-essential                           # C compiler and build tools
sudo apt-get install -y dkms                                      # Dynamic Kernel Module Support
sudo apt-get install -y openssh-server                            # SSH conctivity tools
sudo apt-get install -y sshfs                                     # Mount SSH filesystems
sudo apt-get install -y ntfs-3g                                   # Mount NTFS filesystems
sudo apt-get install -y cifs-utils                                # Mount CIFS/SMB filesystems
sudo apt-get install -y nfs-common                                # Mount NFS filesystems, (instalation problem?)
sudo apt-get install -y smbclient                                 # SMB conectivity tools
sudo apt-get install -y winbind                                   # Resolve user and group information from Windows NT servers
sudo apt-get install -y gcc-multilib                              # 32 bits libraries and multilib
sudo apt-get install -y lsb                                       # Linux Standard Base
sudo apt-get install -y debconf-utils                             # Required for salt
sudo apt-get install -y python-software-properties                # Required for salt
sudo apt-get install -y salt-minion                               # Remote host configuration management
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nslcd      # LDAP login support

# Clean old stuff
apt-get autoremove
apt-get clean
