#!/bin/bash

apps_csv_path=$1
if [ ! -f ${apps_csv_path:-apps_csv_path}/APT_PACKAGES.csv ]; then
	printf "Missing %s file\n" ${apps_csv_path:-apps_csv_path}
	exit 1
fi

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

apps_csv="$(cat ${apps_csv_path}/APT_PACKAGES.csv)"
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
		printf "%4d/%d %s%sInstalling %s...%s\n" $cont $nof_apps $BOLD $YELLOW $app $NORMAL
		tput sc
		DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends $app >/dev/null 2>&1
		install_status=$?
		if [ ! "$install_status" -eq 0 ]; then
			echo "${cont}/${nof_apps} Missing $app" >> pkgs_missing.log
			tput cuu1
			tput el
			tput el1
			printf "%4d/%d %s%s%s was not installed!%s\n" $cont $nof_apps $BOLD $RED $app $NORMAL
		else
			tput cuu1
			tput el
			tput el1
			printf "%4d/%d %s%s%s was installed.%s\n" $cont $nof_apps $BOLD $BLUE $app $NORMAL
		fi
	else
		printf "%s%4d/%d %s was already installed.%s\n" $NORMAL $cont $nof_apps $app $NORMAL
	fi
done

apt-get autoclean