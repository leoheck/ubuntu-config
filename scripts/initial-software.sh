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

# Blacklist applications to avoid
# NEEDS tests
sudo apt-mark hold gnome-shell
sudo apt-mark hold gnome-session-flashback
sudo apt-mark hold gnome-desktop
sudo apt-mark hold ubuntu-mate-core
sudo apt-mark hold ubuntu-mate-desktop

# Enable extra repositories
sed -i "s/#deb http/deb http/" /etc/apt/sources.list
sed -i "s/#deb-src http/deb-src http/" /etc/apt/sources.list

apt update

apt install -y linux-headers-generic                     # Generic Kernel Headers
apt install -y linux-headers-$(uname -r)                 # Linux Heders
apt install -y build-essential                           # C compiler and build tools
apt install -y dkms                                      # Dynamic Kernel Module Support
apt install -y openssh-server                            # SSH conctivity tools
apt install -y sshfs                                     # Mount SSH filesystems
apt install -y ntfs-3g                                   # Mount NTFS filesystems
apt install -y cifs-utils                                # Mount CIFS/SMB filesystems
apt install -y nfs-common                                # Mount NFS filesystems, (instalation problem?)
apt install -y smbclient                                 # SMB conectivity tools
apt install -y winbind                                   # Resolve user and group information from Windows NT servers
apt install -y lsb                                       # Linux standard base
apt install -y debconf-utils                             # Required for salt
apt install -y salt-minion                               # Remote host configuration management
apt install -y libnss-myhostname                         # Required plugin for the GNU Name Service Switch (NSS)

apt install -y zsh
apt install -y tcsh
apt install -y csh
apt install -y ksh

DEBIAN_FRONTEND=noninteractive apt install -y nslcd      # LDAP login support (default configs)
apt install ldapscripts                                  # LDAP acessory scripts

apt install -y dconf-tools                               # Commandline configurations
apt install -y gcc-multilib                              # 32 bits libraries and multilib
apt install -y python-software-properties                # Required for salt
apt install -y aptitude                                  # Apt-get front end
