#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# MAIN SCRIPT TO CONFIGURE INSTALL GAPH CONFIGS

# TODO: APPLICAR ESSAS DEFINICOES GLOBALMENTE
# DEFINICOES:
# - DONWLOAD: /tmp
# - LOGS: /var/logs/gaph/
# - BKPs Suffix: TODO

# Command line parameters
# command="$1"

INSTALL_BASE=1
INSTALL_EXTRA=1
USE_LOCAL_FILES=0

while getopts "abec:l" opt; do
	case $opt in
	a)  # DISABLE INSTALL ALL PACKAGES
		INSTALL_BASE=0
		INSTALL_EXTRA=0
		;;
	b)  # DISABLE INSTALL BASIC PACKAGES
		INSTALL_BASE=0
		;;
	e)  # DISABLE INSTALL EXTRA PACKAGES
		INSTALL_EXTRA=0
		;;
	c)  # SELECT THE CHOICE
		choice=$OPTARG
		;;
	l)
		USE_LOCAL_FILES="1"
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		exit 1
		;;
	esac
done


# GITHUB REPOSITORY CONFIG
REPO="gaph-host-config"
BRANCH="clean-release"

# TODO: MUDAR O NOME DO ZIP BAIXADO PRA $REPO-$BRANCH.zip
GITHUB="https://github.com/leoheck/$REPO/archive/"
PKG=$BRANCH.zip
LOCAL_PKG=$REPO-$BRANCH.zip

skip_donwload=0
PROJECTDIR=/tmp/$REPO-$BRANCH
export PATH=$PROJECTDIR/scripts:$PATH

mkdir -p /var/log/gaph/

if [ "$USE_LOCAL_FILES" == 1 ]; then
	skip_donwload=1
	PROJECTDIR=./
	export PATH=./scripts:$PATH
fi

# Use colors only if connected to a terminal which supports them
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

# Ctrl+c function to halt execution
control_c()
{
	tput el1
	echo
	echo "${YELLOW}  FUCK, YOU KILLED ME! :( ${NORMAL}"
	echo
	pkill -P $$
	shutdown -c
	# echo "kill -KILL $!" | at now &> /dev/null
}

trap control_c SIGINT

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
set -e

# Prevent the cloned repository from having insecure permissions. Failing to do
# so causes compinit() calls to fail with "command not found: compdef" errors
# for users with insecure umasks (e.g., "002", allowing group writability). Note
# that this will be ignored under Cygwin by default, as Windows ACLs take
# precedence over umasks except for filesystems mounted with option "noacl".
umask g-w,o-w

# Check for super power
if [ "$(id -u)" != "0" ]; then
	echo -e "\nHey kid, you ${BOLD}need superior power${NORMAL}. Go call your father.${NORMAL}\n"
	exit 1
fi

main()
{
	if [ "$skip_donwload" != "1" ]; then

		if [ -f /tmp/$LOCAL_PKG ]; then
			printf "%s  Removing previous package ...%s\n" "${BLUE}" "${NORMAL}"
			rm -rf /tmp/$LOCAL_PKG
		fi

		if [ -d $PROJECTDIR ]; then
			#printf "%s  Removing $PROJECTDIR folder ...%s\n" "${BLUE}" "${NORMAL}"
			rm -rf $PROJECTDIR
		fi

		printf "%s  Downloading $LOCAL_PKG in /tmp ...%s\n" "${BLUE}" "${NORMAL}"
		wget $GITHUB/$PKG -O /tmp/$LOCAL_PKG 2> /dev/null
		chmod 777 /tmp/$LOCAL_PKG

		printf "%s  Unpacking /tmp/$LOCAL_PKG ...%s\n" "${BLUE}" "${NORMAL}"
		unzip -qq /tmp/$LOCAL_PKG -d /tmp > /dev/null
		chmod 777 /tmp/$REPO-$BRANCH -R
	else
		printf "%s  Using local files%s" "${YELLOW}" "${NORMAL}"
	fi



	# http://patorjk.com/software/taag/#p=display&f=Modular&t=HOST%20CONFIG
	# Font: Small
	echo "${BLUE}${BOLD}"
	echo '   _  _  ___  ___ _____    ___ ___  _  _ ___ ___ ___    '
	echo '  | || |/ _ \/ __|_   _|  / __/ _ \| \| | __|_ _/ __|   '
	echo '  | __ | (_) \__ \ | |   | (_| (_) | .` | _| | | (_ |   '
	echo '  |_||_|\___/|___/ |_|    \___\___/|_|\_|_| |___\___|   '
	echo "${NORMAL}${GREEN}"
	echo "  ~ CONFIGURATION SCRIPT FOR UBUNTU 17.04 ~${NORMAL}"
	echo
	echo "  [1] Apply config"
	echo "  [2] Revert config"
	echo
	echo "${BLUE}  Hit CTRL+C to exit${NORMAL}"
	echo

	if [ ! "$choice" ]; then
		while :; do
		  read -r -p '  #> ' choice
		  case $choice in
			[1-4] ) break ;;
			q|Q ) exit ;;
			* )
				tput cuu1
				tput el1
				tput el
				;;
		  esac
		done
	fi
}

# OLD ROUTINE TO SELECT BETWEEN GUI/CLI EXECUTIONS.
# install_software()
# {
# 	xhost +si:localuser:"$(whoami)" &> /dev/null && {
# 		echo "${BLUE}    - Running GUI, please wait...${NORMAL}"
# 		xterm \
# 			-title 'Installing BASE Software' \
# 			-fa 'Ubuntu Mono' -fs 12 \
# 			-bg 'black' -fg 'white' \
# 			-e "bash -c 'initial-software.sh | tee /var/log/gaph/install-base.log'"
# 			tput cuu1;
# 			tput el;
# 	} || {
# 		bash -c "initial-software.sh | tee /var/log/gaph/install-base.log"
# 	}
# }

install_base_software()
{
	echo "  - Installing base apps"
	echo "${GREEN}    - THIS CAN TAKE SOME MINUTES.${NORMAL}"

# 	which xterm 2>&1 > /dev/null
# 	if [ "$?" != "0" ]; then
# 		apt install xterm
# 	fi

	echo "${BLUE}    - Using an external terminal for installation...${NORMAL}"
	xterm \
		-title 'Installing BASE Software' \
		-fa 'Ubuntu Mono' -fs 12 \
		-bg 'black' -fg 'white' \
		-e "bash -c 'initial-software.sh | tee /var/log/gaph/install-base.log'"
		tput cuu1;
		tput el;

	tput cuu1;
	tput el;

	echo "    - See logs in /var/log/gaph/install-base.log"
}

install_extra_software()
{
	echo "  - Installing extra apps ..."
	echo "${GREEN}    - THIS CAN TAKE HOURS. Go take a coffee :)${NORMAL}"

	echo "${BLUE}    - Using an external terminal for installation...${NORMAL}"
	xterm \
		-title 'Installing EXTRA Software' \
		-fa 'Ubuntu Mono' -fs 12 \
		-bg 'black' -fg 'white' \
		-e "bash -c 'extra-software.sh | tee /var/log/gaph/install-extra.log'"
		tput cuu1;
		tput el;

	tput cuu1;
	tput el;
	date > /var/log/gaph/install-extra.done
	echo "    - See logs in /var/log/gaph/install-extra.log"
}

reboot_host()
{
	echo
	echo "${RED}  HEY YO, SYSTEM WILL REBOOT IN 3 MINUTES! ${NORMAL}"
	echo "  Cancel this with: shutdown -c "
	echo
	shutdown -r +3 2> /dev/null
}

quit()
{
	echo "${YELLOW}  DONE! Bye :) ${NORMAL}"
	echo
}

apply_configs()
{
	echo
	echo "${YELLOW}  Applying/updating configurations... ${NORMAL}"
	apply_and_upgrade_configs
}

revert_configs()
{
	echo
	echo "${YELLOW}  Removing configurations... ${NORMAL}"
	install-scripts.sh -r
	crontab-config.sh -r
	admin-config.sh -r
	config-printers.sh -r
	fstab-config.sh -r
	hosts-config.sh -r
	lightdm-config.sh -r
	nslcd-config.sh -r
	nsswitch-config.sh -r
	saltstack-config.sh -r
	# misc-hacks.sh
	# users-config.sh
	customization.sh -r
	rm -f /var/log/gaph/install-configs.done
	echo
}

# OPTION 2
configure_gaph_compatible()
{
	echo
	echo "${YELLOW}  Configuring GAPH COMPATIBLE host... ${NORMAL}"

	if [ "$INSTALL_BASE" == "1" ]; then
		install_base_software
	fi

	if [ "$INSTALL_EXTRA" == "1" ]; then
		install_extra_software
	fi

	misc-hacks.sh
	reboot_host
}

clear
echo
main
clear

case $choice in
	1 ) apply_configs ;;
	2 ) revert_configs ;;
    * ) echo "Your choice ($choice) is missing!"; exit 1
esac
