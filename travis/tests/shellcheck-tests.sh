#!/bin/bash

shellcheck ./configure.sh
shellcheck ./scripts/users-config.sh
shellcheck ./scripts/initial-software.sh  
shellcheck ./scripts/extra-software.sh  
shellcheck ./scripts/customization.sh  
shellcheck ./scripts/misc-hacks.sh  
shellcheck ./scripts/admin-config.sh  
shellcheck ./scripts/crontab-config.sh  
shellcheck ./scripts/install-scripts.sh  
