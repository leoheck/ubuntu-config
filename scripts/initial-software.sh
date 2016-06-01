#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# INSTALL MINIMUM REQUIRED APLICATIONS

# Referencias:
# http://xmodulo.com/how-to-install-software-packages-in-non-interactive-batch-mode.html

#===========================
read -r -d '' APPSCSV <<-EOM

# REQUIRED
linux-headers-generic,      # Generic Kernel Headers
build-essential,            # C compiler and build tools
dkms,                       # Dynamic Kernel Module Support
openssh-server,             # SSH conctivity tools
sshfs,                      # Mount SSH filesystems
ntfs-3g,                    # Mount NTFS filesystems
cifs-utils,                 # Mount CIFS/SMB filesystems
nfs-common,                 # Mount NFS filesystems, (instalation problem?)
smbclient,                  # SMB conectivity tools
winbind,                    # Resolve user and group information from Windows NT servers
lsb-base,                   # Linux standard base
debconf-utils,              # Required for salt
salt-minion,                # Remote host configuration management
libnss-myhostname,          # Required plugin for the GNU Name Service Switch (NSS)

# TERMINALS
zsh,                        # Shell
tcsh,                       # Shell
csh,                        # Shell
ksh,                        # Shell

dconf-tools,                # Commandline configurations
gcc-multilib,               # 32 bits libraries and multilib
python-software-properties, # Required for salt
nslcd,                      # LDAP login support (default configs)
ldapscripts,                # LDAP acessory scripts

EOM
#===========================

APPS=$(echo $APPSCSV | sed '/^\s*\#.*$/d' | cut -d, -f1 | sed '/^\s*$/d')

if [ ! -f /etc/apt/sources.list.bkp ]; then
	cp /etc/apt/sources.list /etc/apt/sources.list.bkp
fi

# Enable extra repositories
sed -i "s/#deb http/deb http/" /etc/apt/sources.list
sed -i "s/#deb-src http/deb-src http/" /etc/apt/sources.list

# Blacklist some applications
apt-mark hold gdm > /dev/null
apt-mark hold gnome-shell > /dev/null
apt-mark hold gnome-session-flashback > /dev/null
apt-mark hold ubuntu-mate-core > /dev/null
apt-mark hold ubuntu-mate-desktop > /dev/null

# TO LEARN THE REQUIRED QUESTIONS
# 1. Install package
# 2. Run: sudo debconf-show [pkg-name]

# Configure required answares when it is needed
# FORMAT: <owner> <question name> <question type> <value>
debconf-set-selections <<< "d-i nslcd/ldap-uris: ldap://rodos.inf.pucrs.br/"
debconf-set-selections <<< "d-i nslcd/ldap-base: dc=gaph,dc=inf,dc=pucrs,dc=br"

# Installation
dpkg --add-architecture i386
apt update
apt install -f -y
apt install -y $APPS