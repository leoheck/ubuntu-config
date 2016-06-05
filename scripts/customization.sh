#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# Add some style to the GAPH host

key="$1"

install_cmd()
{
	echo "  - Customizing GAPH host"

	SCRIPTDIR=$1

	# PLYMOUNTH BACKUP
	if [ ! -f /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png.bkp ]; then
		if [ -f /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png ]; then
			cp -f /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png.bkp
		fi
	fi

	# Plymouth on Ubuntu 16.04
	if [ -d /usr/share/plymouth/themes/ubuntu-logo/ ]; then
		cp -f $SCRIPTDIR/images/plymouth/ubuntu-logo.png /usr/share/plymouth/themes/ubuntu-logo/
	fi

	# Plymouth on Ubuntu 14.04
	if [ -d /lib/plymouth/themes/ubuntu-logo/ ]; then
		cp -f $SCRIPTDIR/images/plymouth/ubuntu-logo.png /lib/plymouth/themes/ubuntu-logo/
	fi

	# UNITY-GREETER BACKUP
	if [ ! -f /usr/share/unity-greeter/logo.png.bkp ]; then
		cp -f /usr/share/unity-greeter/logo.png /usr/share/unity-greeter/logo.png.bkp
	fi

	#sed -i "s|gaphlxx|$(hostname)|g" $SCRIPTDIR/images/unity-greeter/logo.svg
	# convert -background none $SCRIPTDIR/images/unity-greeter/logo.svg $SCRIPTDIR/images/unity-greeter/logo.svg
	#/usr/bin/inkscape --without-gui --export-png=/usr/share/unity-greeter/logo.png $SCRIPTDIR/images/unity-greeter/logo.svg > /dev/null
	if [ -d /usr/share/unity-greeter/ ]; then
		cp -f $SCRIPTDIR/images/unity-greeter/logo.png /usr/share/unity-greeter/
	fi

	# BACKUP
	if [ ! -f /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override.bkp ]; then
		if [ -f /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override ]; then
			cp -f /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override.bkp
		fi
	fi

	# Adiciona o papel de parede do GAPH pra tela de login
	cp $SCRIPTDIR/images/unity-greeter/night.png /usr/share/backgrounds/

	#===========================
	read -r -d '' GAPHCONF <<-EOM

	[com.canonical.unity-greeter]
	#draw-user-backgrounds=false
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
		mv -f /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png.bkp /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png
	fi

	if [ -f /usr/share/unity-greeter/logo.png.bkp ]; then
		mv -f /usr/share/unity-greeter/logo.png.bkp /usr/share/unity-greeter/logo.png
	fi

	if [ -f /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override.bkp ]; then
		mv -f /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override.bkp /usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override
	fi
}

case $key in

	-i|--install)
	SCRIPTDIR="$2"
	install_cmd $SCRIPTDIR
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
