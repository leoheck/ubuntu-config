#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# Add some style

key="$1"

install_cmd()
{
	echo "  - Customizing GAPH host"

	SCRIPTDIR=$1

	# PLYMOUNTH BACKUP
	if [ ! -f /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png.bkp ]; then
		cp /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png.bkp
	fi

	convert -background none "$SCRIPTDIR"/images/plymouth/ubuntu-logo.svg /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png

	# UNITY-GREETER BACKUP
	if [ ! -f /usr/share/unity-greeter/logo.png.bkp ]; then
		cp /usr/share/unity-greeter/logo.png /usr/share/unity-greeter/logo.png.bkp
	fi

	sed -i "s|gaphl00|$(hostname)|g" "$SCRIPTDIR"/images/unity-greeter/logo.svg
	convert -background none "$SCRIPTDIR"/images/unity-greeter/logo.svg /usr/share/unity-greeter/logo.png

	# BACKUP
	if [ ! -f /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override ]; then
		cp /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override.bkp
	fi

	# Adiciona o papel de parede do GAPH pra tela de login
	cp "$SCRIPTDIR"/images/unity-greeter/night.png /usr/share/backgrounds/

	#===========================
	read -r -d '' GAPHCONF <<-EOM

	[com.canonical.unity-greeter]
	draw-user-backgrounds=false
	background='/usr/share/backgrounds/night.png'

	EOM
	#===========================

	echo "$GAPHCONF" >> /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override
	glib-compile-schemas /usr/share/glib-2.0/schemas/

}

remove_cmd()
{
	echo "  - Reverting GAPH host customization"

	if [ -f /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png.bkp ]; then
		mv /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png.bkp /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png
	fi

	if [ -f /usr/share/unity-greeter/logo.png.bkp ]; then
		mv /usr/share/unity-greeter/logo.png.bkp /usr/share/unity-greeter/logo.png
	fi

	if [ -f /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override.bkp ]; then
		mv /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override.bkp /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override
	fi
}

case $key in

	-i|--install)
	SCRIPTDIR="$2"
	install_cmd "$SCRIPTDIR"
	exit 0
	;;

	-r|--remove)
	remove_cmd
	exit 0
	;;

	*)
	echo "Unknonw option"
	exit 1

esac
