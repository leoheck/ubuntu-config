#!/bin/bash

shellcheck ./configure.sh
shellcheck ./scripts/users-config.sh
shellcheck ./scripts/lightdm-config.sh  
shellcheck ./scripts/saltstack-config.sh  
shellcheck ./scripts/hosts-config.sh  
shellcheck ./scripts/initial-software.sh  
shellcheck ./scripts/extra-software.sh  
shellcheck ./scripts/customization.sh  
shellcheck ./scripts/misc-hacks.sh  
shellcheck ./scripts/config-printers.sh  
shellcheck ./scripts/admin-config.sh  
shellcheck ./scripts/nsswitch-config.sh  
shellcheck ./scripts/crontab-config.sh  
shellcheck ./scripts/fstab-config.sh  
shellcheck ./scripts/install-scripts.sh  
shellcheck ./scripts/nslcd-config.sh  
shellcheck ./etc/update-motd.d/99-gaph-banner.sh