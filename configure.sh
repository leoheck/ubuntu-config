#!/bin/bash

# GAPH Hosts main configuration script
# Leandro Sehnem Heck (leoheck@gmail.com)

# TODO:
# ADD A NICE (AND SIMPLE) COMMAND-LINE INTERFACE TO THIS SCRIPT
# fixar o wallpaper padrao do lightdm e colocar um padrao
# Melhorar os arquivos de skell
# Adicionar indicator de impressora online, e a impressora do andar no sistema
# Remover opção GNOME, GNOME-SHELL, (black list it!)
# Ubuntu 16.04 tem o novo apt, usar somente ele
# Criar arquivo /etc/gaph-host com a data da instalacao indicando que a maquina esta configurada
# Verificar a seguranca da senha padrao de root

REPO=gaph-host-config
GITHUB="https://github.com/leoheck/$REPO/archive/"
# BRANCH="master"
BRANCH="ubuntu-16.04"
PKG=$BRANCH.zip

LOCALDIR=/tmp/$REPO-$BRANCH

export PATH=$LOCALDIR/scripts:$PATH
export PATH=./scripts:$PATH

# Ctrl+c function to halt execution
control_c()
{
	echo -e "\n\n$0 ended by user\n"
	exit $?
}

trap control_c SIGINT

# Check for super power
if [ "$(id -u)" != "0" ]; then
	echo "Hey kid, you need superior powers, Go call your father."
	exit 1
fi

main()
{
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
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

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
	set -e

	# After install file /etc/gaph-host iscreated
	if [ -f /etc/gaph-host ]; then
		printf "${YELLOW}  GAPH configuration already appyled!${NORMAL}\n"
		exit 0
	fi

	# Prevent the cloned repository from having insecure permissions. Failing to do
	# so causes compinit() calls to fail with "command not found: compdef" errors
	# for users with insecure umasks (e.g., "002", allowing group writability). Note
	# that this will be ignored under Cygwin by default, as Windows ACLs take
	# precedence over umasks except for filesystems mounted with option "noacl".
	umask g-w,o-w

	echo

	if [ -f $PKG ];
	then
		printf "${BLUE}  Removing previows /tmp/$PKG ...${NORMAL}\n"
		rm -rf $PKG
	fi

	printf "${BLUE}  Donwloading an updated $PKG from github in /tmp ...${NORMAL}\n"
	wget $GITHUB/$PKG -O /tmp/$PKG 2> /dev/null

	if [ -d $LOCALDIR ];
	then
		printf "${BLUE}  Removing $LOCALDIR ...${NORMAL}\n"
		rm -rf $LOCALDIR
	fi

	printf "${BLUE}  Unpacking /tmp/$PKG into $LOCALDIR ...${NORMAL}\n"
	unzip -qq /tmp/$PKG -d /tmp > /dev/null


	printf "${GREEN}"
	echo '   _____  _____  _____  _____           _____  _____  _____  _____   '
	echo '  |   __||  _  ||  _  ||  |  |   ___   |  |  ||     ||   __||_   _|  '
	echo '  |  |  ||     ||   __||     |  |___|  |     ||  |  ||__   |  | |    '
	echo '  |_____||__|__||__|   |__|__|         |__|__||_____||_____|  |_|    '
	echo '                                                                     '
	echo "  CONFIGURATION SCRIPT (MADE FOR UBUNTU 16.04)"
	printf "${NORMAL}"

	echo
	echo "  [1] TURN MACHINE INTO A GAPH HOST"
	echo "  [2] Turn machine into a GAPH-COMPATIBLE host (install programs only)"
	echo "  [3] Apply/upgrade configurations only"
	echo "  [4] Remove configurations (revert configuration files only)"
	echo
	echo "${BLUE}  Hit CTRL+C to exit${NORMAL}"
	echo
	while :;
	do
	  read -p '  #> ' choice
	  case $choice in
		1 ) break ;;
		2 ) break ;;
		3 ) break ;;
		4 ) break ;;
		* )
			tput cuu1
			tput el1
			tput el
			;;
	  esac
	done
}

apply_configurations_only()
{
	echo
	echo "${YELLOW}  Appling/updating configurations ...${NORMAL}"

	if [ -f ! /etc/gaph ]; then
		gnome-terminal --hide-menubar -x bash -c "initial-software.sh | tee configure.log"
	fi

	install-scripts.sh -i $LOCALDIR
	crontab-config.sh -i $LOCALDIR
	admin-config.sh -i
	config-printers.sh -i
	fstab-config.sh -i
	hosts-config.sh -i
	lightdm-config.sh -i
	nslcd-config.sh -i
	nsswitch-config.sh -i
	saltstack-config.sh -i
	misc-hacks.sh
	users-config.sh

	echo "GAPH host installed on: $(date +%Y-%m-%d-%H-%M-%S)" > /etc/gaph
}

revert_configurations()
{
	echo
	echo "${YELLOW}  Removing configurations ...${NORMAL}"
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

	rm -f /etc/gaph
}

configure_gaph_host()
{
	echo
	echo "${YELLOW}  Configuring GAPH host ...${NORMAL}"
	echo "  - Instaling base apps"
	gnome-terminal --hide-menubar -x bash -c "initial-software.sh | tee configure.log"
	apply_configurations_only
	echo "  - Instaling extra apps, this can take hours, go take a coffe :) ... "
	gnome-terminal --hide-menubar -x bash -c "extra-software.sh | tee configure.log"
	misc-hacks.sh
	echo "${RED}  The system is going down for reboot in 5 minutes! ${NORMAL}"
	shutdown -r +5 > /dev/null
}

configure_gaph_compatible()
{
	echo
	echo "${YELLOW}  Configuring GAPH COMPATIBLE host ...${NORMAL}"
	echo "  - Instaling all apps, this can take hours, go take a coffe :) ... "
	gnome-terminal --hide-menubar -x bash -c "initial-software.sh | tee configure.log"
	gnome-terminal --hide-menubar -x bash -c "extra-software.sh | tee -a configure.log"
	misc-hacks.sh
	echo "${RED}  The system is going down for reboot in 5 minutes! ${NORMAL}"
	shutdown -r +5 > /dev/null
}


clear
main

case $choice in
	1 ) configure_gaph_host ;;
	2 ) configure_gaph_compatible ;;
	3 ) apply_configurations_only ;;
	4 ) revert_configurations ;;
esac

echo "${YELLOW}  DONE!${NORMAL}"
echo

exit 0
