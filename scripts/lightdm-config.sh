#!/bin/bash

# LightDM Configuration (PRECISA REINICIAR PARA FUNCIONAR)
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures the main login screen (LightDM)
# Features:
# - Enable manual login (for network users)
# - Enable the guest login
# - Hide logged users

# Some informations
# https://wiki.ubuntu.com/LightDM
# http://askubuntu.com/questions/155611/no-unity-greeter-conf-file-in-etc-lightdm

FILE=/etc/lightdm/lightdm.conf
date=$(date +"%Y-%m-%d-%Hh%M")

# backup the original file
if [ -f ${FILE} ]; then
	cp ${FILE} ${FILE}-${date}
fi

# update the content
#==============================================================================
cat > ${FILE} << END-OF-FILE

[GuestAccount]
enabled = true

[SeatDefaults]
greeter-session = unity-greeter
greeter-show-manual-login = true
allow-guest = true

END-OF-FILE
#==============================================================================

# Adiciona o papel de parede do GAPH pra tela de login
#cp imagens/gaphwall.jpg /usr/share/backgrounds/
#sudo -u lightdm dbus-launch gsettings set com.canonical.unity-greeter background '/usr/share/backgrounds/gaphwall.jpg'
