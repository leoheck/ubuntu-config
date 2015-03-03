#!/bin/bash

# Configure minimum REQUIRED software
# Leandro Sehnem Heck (leoheck@gmail.com)

# Referencias:
# http://xmodulo.com/how-to-install-software-packages-in-non-interactive-batch-mode.html

# Ctrl+c function to halt execution
control_c()
{
	echo -e "\n\n$0 ended by user\n"
	exit $?
}

trap control_c SIGINT

# Check for super power
if [ "$(id -u)" != "0" ]; then
	echo "Hey kid, you need to be root, call your father."
	exit 1
fi

# Enable partner repositories
sed -i "s/#deb http/deb http/" /etc/apt/sources.list
sed -i "s/#deb-src http/deb-src http/" /etc/apt/sources.list

apt-get update
apt-get full-upgrade

apt-get install -y aptitude                                  # Apt-get front end
apt-get install -y linux-headers-$(uname -r)                 # Linux Heders
apt-get install -y linux-headers-generic                     # Generic Kernel Headers
apt-get install -y build-essential                           # C compiler and build tools
apt-get install -y dkms                                      # Dynamic Kernel Module Support
apt-get install -y openssh-server                            # SSH conctivity tools
apt-get install -y sshfs                                     # Mount SSH filesystems
apt-get install -y ntfs-3g                                   # Mount NTFS filesystems
apt-get install -y cifs-utils                                # Mount CIFS/SMB filesystems
apt-get install -y nfs-common                                # Mount NFS filesystems, (instalation problem?)
apt-get install -y smbclient                                 # SMB conectivity tools
apt-get install -y winbind                                   # Resolve user and group information from Windows NT servers
apt-get install -y gcc-multilib                              # 32 bits libraries and multilib
apt-get install -y lsb                                       # Linux Standard Base
apt-get install -y debconf-utils                             # Required for salt
apt-get install -y python-software-properties                # Required for salt
apt-get install -y salt-minion                               # Remote host configuration management

DEBIAN_FRONTEND=noninteractive apt-get install -y nslcd      # LDAP login support (default configs)

# Clean old stuff
apt-get autoremove
apt-get clean
