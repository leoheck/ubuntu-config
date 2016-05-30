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

echo wget $GITHUB/$PKG -O /tmp/$PKG 2> /dev/null

exit

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

clear

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

	if [ -f $PGK ];
	then
		printf "${BLUE}  Removing previows /tmp/$PGK ...${NORMAL}\n"
		rm -rf $PGK
	fi

	printf "${BLUE}  Donwloading an updated $PGK from github in /tmp ...${NORMAL}\n"
	wget $GITHUB/$PKG -O /tmp/$PKG 2> /dev/null

	if [ -d /tmp/$REPO-$BRANCH ];
	then
		printf "${BLUE}  Removing /tmp/$REPO-$BRANCH ...${NORMAL}\n"
		rm -rf /tmp/$REPO-$BRANCH
	fi

	printf "${BLUE}  Unpacking /tmp/$PGK into /tmp/$REPO-$BRANCH ...${NORMAL}\n"
	unzip /tmp/$PGK -d /tmp 2> /dev/null


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
	echo "  [2] Turn machine into a GAPH-compatible host (install programs only)"
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

configure_gaph_host()
{
	echo "  Configuring GAPH host"
	echo
	echo "${YELLOW}  initial-software.sh ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  fstab-config.sh     ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  nslcd-config.sh     ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  nsswitch-config.sh  ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  admin-config.sh     ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  lightdm-config.sh   ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  crontab-config.sh   ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  saltstack-config.sh ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  config-printers.sh  ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  users-config.sh     ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  hosts-config.sh     ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  misc-hacks.sh       ${NORMAL} | tee -a $logfile"
	echo "${YELLOW}  extra-software.sh   ${NORMAL} | tee -a $logfile"
	echo
	echo "${YELLOW}  apt-get clean ${NORMAL}"
	echo "${YELLOW}  reboot -f now ${NORMAL}"
	echo
}

apply_configurations()
{
	echo
	echo "${YELLOW}  Appling/updating configurations"
	crontab-config.sh
	install-scripts.sh /tmp/$REPO-$BRANCH
}

configure_gaph_compatible()
{
	echo "  Configuring GAPH COMPATIBLE host"
	echo
	echo "${YELLOW}  initial-software.sh ${NORMAL}| tee -a $logfile"
	echo "${YELLOW}  extra-software.sh   ${NORMAL}| tee -a $logfile"
	echo
	echo "${YELLOW}  apt-get clean ${NORMAL}"
	echo "${YELLOW}  reboot -f now ${NORMAL}"
	echo
}

revert_configurations()
{
	echo "  REMOVING configurations"
	echo
	echo "${YELLOW}  fstab-config.sh     -r ${NORMAL}| tee -a $logfile"
	echo "${YELLOW}  nslcd-config.sh     -r ${NORMAL}| tee -a $logfile"
	echo "${YELLOW}  nsswitch-config.sh  -r ${NORMAL}| tee -a $logfile"
	echo "${YELLOW}  admin-config.sh     -r ${NORMAL}| tee -a $logfile"
	echo "${YELLOW}  lightdm-config.sh   -r ${NORMAL}| tee -a $logfile"
	echo "${YELLOW}  crontab-config.sh   -r ${NORMAL}| tee -a $logfile"
	echo "${YELLOW}  saltstack-config.sh -r ${NORMAL}| tee -a $logfile"
	echo "${YELLOW}  config-printers.sh  -r ${NORMAL}| tee -a $logfile"
	echo "${YELLOW}  users-config.sh     -r ${NORMAL}| tee -a $logfile"
	echo "${YELLOW}  hosts-config.sh     -r ${NORMAL}| tee -a $logfile"
	echo "${YELLOW}  misc-hacks.sh       -r ${NORMAL}| tee -a $logfile"
	echo
}

main

logfile=configure.log
touch $logfile

export PATH=./scripts:$PATH

case $choice in
	1 ) configure_gaph_host ;;
	2 ) configure_gaph_compatible ;;
	3 ) apply_configurations ;;
	4 ) revert_configurations ;;
esac

exit
