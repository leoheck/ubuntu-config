#!/bin/bash

USE_LOCAL_FILES=0

while getopts "c:l" opt; do
	case $opt in
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

REPO="ubuntu-config"
BRANCH="clean-release"

GITHUB="https://github.com/leoheck/$REPO/archive/"
PKG=$BRANCH.zip
LOCAL_PKG=$REPO-$BRANCH.zip

skip_donwload=0
PROJECTDIR=/tmp/$REPO-$BRANCH
export PATH=$PROJECTDIR/scripts:$PATH

mkdir -p /var/log/ubuntu-config/

if [ "$USE_LOCAL_FILES" == 1 ]; then
	skip_donwload=1
	PROJECTDIR=./
	export PATH=./scripts:$PATH
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

# Ctrl+c function to halt execution
control_c()
{
	tput el1
	echo
	echo "${YELLOW}  Bye! :D ${NORMAL}"
	echo
	pkill -P $$
	shutdown -c
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

download_configs()
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
}

main()
{
	download_configs

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
	# echo "  [2] Revert config"
	echo
	echo "${BLUE}  Hit CTRL+C to exit${NORMAL}"
	echo

	if [ ! "$choice" ]; then
		while :; do
		  read -r -p '  #> ' choice
		  case $choice in
			[1-2] ) break ;;
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

install_software()
{
	echo "  - Installing apps"
	echo "${GREEN}    - THIS CAN TAKE MANY MINUTES.${NORMAL}"
	echo "${BLUE}    - Using an external terminal for installation...${NORMAL}"
	xterm \
		-title 'Installing apps' \
		-fa 'Ubuntu Mono' -fs 12 \
		-bg 'black' -fg 'white' \
		-e "bash -c 'install-software.sh | tee /var/log/ubuntu-config/install-base.log'"
		tput cuu1;
		tput el;

	tput cuu1;
	tput el;

	echo "    - See logs in /var/log/ubuntu-config/install-base.log"
}

reboot_host()
{
	echo
	echo "${RED}  HEY YO, THE SYSTEM WILL REBOOT IN 5 MINUTES! ${NORMAL}"
	echo "  Cancel this with: shutdown -c "
	echo
	shutdown -r +5 2> /dev/null
}

apply_configs()
{
	echo
	echo "${YELLOW}  Applying configuration... ${NORMAL}"
	# install_software
	prepare-pkg-sources.sh
	install-packages.sh /tmp/$REPO-$BRANCH/scripts
	install-python-modules.sh /tmp/$REPO-$BRANCH/scripts
	crontab-config.sh -i
	admin-config.sh -i
	users-config.sh
	misc-hacks.sh
	reboot_host
}

clear
echo
main
clear

case $choice in
	1 ) apply_configs ;;
	# 2 ) revert_configs ;;
	* ) echo "Your choice ($choice) is missing!"; exit 1
esac
