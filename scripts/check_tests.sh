#!/bin/bash

# Check for super power
if [ "$(id -u)" != "0" ]; then
	echo -e "\n${BOLD}You need superpowers to install apps${NORMAL}.\n"
	exit 1
fi

if which tput >/dev/null 2>&1; then
	ncolors=$(tput colors)
fi

if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
	RED="$(tput setaf 1)"
	GREEN="$(tput setaf 2)"
	YELLOW="$(tput setaf 3)"
	BLUE="$(tput setaf 4)"
	BOLD="$(tput bold)"
	NORMAL="$(tput sgr0)"
else
	RED=""
	GREEN=""
	YELLOW=""
	BLUE=""
	BOLD=""
	NORMAL=""
fi

COLUMNS=`tput cols`
LINES=`tput lines`
line=`expr $LINES / 2`
column=`expr \( $COLUMNS - 6 \) / 2`
tput sc
tput cup $line $column
tput rev
echo 'Hello, World'
tput sgr0
tput rc

apps_csv="$(cat APT_PACKAGES.csv)"
apps=$(echo "$apps_csv" | sed '/^\s*\#.*$/d' | cut -d, -f1 | sed '/^\s*$/d')
apps=$(echo $apps | sort | uniq)
nof_apps=$(echo "$apps" | wc -w)

echo "$apps" > pkgs_all.log
echo > pkgs_missing.log

cont=0 
for app in $apps; do
	cont=$((cont+1)) 
	dpkg -s "$app" &> /dev/null
	if [ ! $? -eq 0 ]; then
		printf "%s%4d/%d Installing %s...%s\n" ${YELLOW} ${cont} ${nof_apps} $app ${NORMAL}
		tput sc
		DEBIAN_FRONTEND=noninteractive apt-get install -y $app >/dev/null 2>&1
		install_status=$?
		if [ ! "$install_status" -eq 0 ]; then
			echo "${cont}/${nof_apps} Missing $app" >> pkgs_missing.log
			printf "%s- Error installing %s%s\n" ${RED} $app {NORMAL}
		else
			tput cuu1
			tput el1
			tput el
			printf "%s%4d/%d %s installed%s\n" ${BLUE} ${cont} ${nof_apps} $app ${NORMAL}
		fi
	else
		printf "%s%4d/%d %s already installed%s\n" ${NORMAL} ${cont} ${nof_apps} $app ${NORMAL}
	fi
done
