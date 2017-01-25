#!/bin/bash

bashate_color() {
 	RED="$(tput setaf 1)"; 
 	YEL="$(tput setaf 3)"; 
 	NOR="$(tput sgr0)"; 
 	bashate -i E002,E003,E006 $@ | \
 		sed "s/\(\[E\].*:.*:\)/$RED\1$NOR/g" | \
 		sed "s/\(\[W\].*:.*:\)/$YEL\1$NOR/g"
 }

bashate_color ./configure.sh
bashate_color ./scripts/users-config.sh
bashate_color ./scripts/lightdm-config.sh
bashate_color ./scripts/saltstack-config.sh
bashate_color ./scripts/hosts-config.sh
bashate_color ./scripts/initial-software.sh
bashate_color ./scripts/extra-software.sh
bashate_color ./scripts/customization.sh
bashate_color ./scripts/misc-hacks.sh
bashate_color ./scripts/config-printers.sh
bashate_color ./scripts/admin-config.sh
bashate_color ./scripts/nsswitch-config.sh
bashate_color ./scripts/crontab-config.sh
bashate_color ./scripts/fstab-config.sh
bashate_color ./scripts/install-scripts.sh
bashate_color ./scripts/nslcd-config.sh
bashate_color ./etc/update-motd.d/99-gaph-banner.sh