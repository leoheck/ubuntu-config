#!/bin/bash

# GAPH Hosts main configuration script
# Leandro Sehnem Heck (leoheck@gmail.com)

# Ctrl+c function to halt execution
control_c()
{
	echo -e "\n\n$0 ended by user\n"
	exit $?
}

trap control_c SIGINT

# Check for super power
if [ "$(id -u)" != "0" ]; then
	echo "Hey kid, you need the root power, call your father."
	exit 1
fi

touch gaphscripts.log

./scripts/initial-software.sh | tee -a gaphscripts.log

./scripts/fstab-config.sh     | tee -a gaphscripts.log      
./scripts/nslcd-config.sh     | tee -a gaphscripts.log      
./scripts/nsswitch-config.sh  | tee -a gaphscripts.log         
./scripts/admin-config.sh     | tee -a gaphscripts.log      
./scripts/lightdm-config.sh   | tee -a gaphscripts.log        
./scripts/crontab-config.sh   | tee -a gaphscripts.log        
./scripts/saltstack-config.sh | tee -a gaphscripts.log          
./scripts/config-printers.sh  | tee -a gaphscripts.log         
./scripts/users-config.sh     | tee -a gaphscripts.log      
./scripts/hosts-config.sh     | tee -a gaphscripts.log      
./scripts/misc-hacks.sh       | tee -a gaphscripts.log    

./scripts/extra-software.sh   | tee -a gaphscripts.log  

# :)
reboot -f now