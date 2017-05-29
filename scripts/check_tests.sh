#!/bin/bash

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

apps_csv="$(cat APT_PACKAGES.csv)"

apps=$(echo "$apps_csv" | sed '/^\s*\#.*$/d' | cut -d, -f1 | sed '/^\s*$/d')
apps=$(echo $apps | sort | uniq)

echo "$apps" > pkgs_all.log
echo > pkgs_missing.log

for app in $apps; do
	dpkg -s "$app" &> /dev/null
	if [ ! $? -eq 0 ]; then
		echo "${YELLOW}Installing $app${NORMAL} ..."
		DEBIAN_FRONTEND=noninteractive apt-get install -y "$app" >/dev/null 2>&1
		install_status=$?
		if [ ! "$install_status" -eq 0 ]; then
			echo "Missing $app" >> pkgs_missing.log
			echo "${RED}Found problems during $app installation${NORMAL}"
		fi
	else
		echo "Already installed $app"
	fi
done

# PYTHON PACKAGES
#=================================

apps_csv="$(cat PYTHON_PACKAGES.csv)"

apps=$(echo "$apps_csv" | sed '/^\s*\#.*$/d' | cut -d, -f1 | sed '/^\s*$/d')
apps=$(echo $apps | sort | uniq)

echo "$apps" > pkgs_python_all.log
echo > pkgs_python_missing.log

#===
echo "${BLUE}# Python 2${NORMAL}"
pip2 install --upgrade pip

for app in $apps; do
	pip show "$app" >/dev/null 2>&1
	if [ ! $? -eq 0 ]; then
		echo "${YELLOW}Installing $app${NORMAL} ..."
		pip2 install --upgrade $app >/dev/null 2>&1
		install_status=$?
		if [ ! "$install_status" -eq 0 ]; then
			echo "Missing $app" >> pkgs_python_missing.log
			echo "${RED}Found problems during $app installation${NORMAL}"
		fi
	else
		echo "Already installed $app"
	fi
done

#===
echo "${BLUE}# Python 3${NORMAL}"
pip3 install --upgrade pip

for app in $apps; do
	pip3 show "$app" >/dev/null 2>&1
	if [ ! $? -eq 0 ]; then
		echo "${YELLOW}Installing $app${NORMAL} ..."
		pip3 install --upgrade $app >/dev/null 2>&1
		install_status=$?
		if [ ! "$install_status" -eq 0 ]; then
			echo "Missing $app" >> pkgs_python_missing.log
			echo "${RED}Found problems during $app installation${NORMAL}"
		fi
	else
		echo "Already installed $app"
	fi
done

