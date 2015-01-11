#!/bin/bash

# LightDM Configuration
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures the main login screen (LightDM)
# Features:
# - Enable manual login (for network users)
# - Enable the guest login
# - Hide logged users

# Some informations
# https://wiki.ubuntu.com/LightDM

FILE=/etc/lightdm/lightdm.conf
date=$(date +"%Y-%m-%d-%Hh%M")

# backup the original file
if [ -f ${FILE} ]; then
	cp ${FILE} ${FILE}-${date}
fi

# update the content
#==============================================================================
cat > ${FILE} << \END-OF-CONFIG-FILE

[GuestAccount]
enabled = true

[SeatDefaults]
greeter-session = unity-greeter
greeter-show-manual-login = true
allow-guest = true

END-OF-CONFIG-FILE
#==============================================================================