#!/bin/bash

# GAPH Hosts main configuration script
# Leandro Sehnem Heck (leoheck@gmail.com)

# Ctrl+c function to halt execution
control_c()
{
	echo -e "\n\n$0 ended by user\n"
	exit $?
}

trap control_c SIGINT

# Check for super power
# if [ "$(id -u)" != "0" ]; then
	# echo "Hey kid, you need to have superior power, call your father."
	# exit 1
# fi

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
    printf "\n${YELLOW}GAPH configuration already appyled!${NORMAL}\n"
    exit 0
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

	rm -rf /tmp/master.zip
	rm -rf /tmp/master

	echo

  printf "${BLUE}  Donwloading package from github in /tmp/master.zip ...${NORMAL}\n"
  wget https://github.com/leoheck/gaph-os-scripts/archive/master.zip -O /tmp/master.zip 2> /dev/null

  printf "${BLUE}  Unpacking configuration scripts into /tmp/master ...${NORMAL}\n"
  unzip /tmp/master.zip -d /tmp/master > /dev/null



  printf "${GREEN}"
  echo '   _____  _____  _____  _____           _____  _____  _____  _____   '
  echo '  |   __||  _  ||  _  ||  |  |   ___   |  |  ||     ||   __||_   _|  '
  echo '  |  |  ||     ||   __||     |  |___|  |     ||  |  ||__   |  | |    '
  echo '  |_____||__|__||__|   |__|__|         |__|__||_____||_____|  |_|    '
  echo '                                                                     '
  echo "  CONFIGURATION SCRIPT "
  printf "${NORMAL}"

  echo
  echo "  [1] Turn machine into a GAPH host"
  echo "  [2] Turn machine into a GAPH-compatible host (install programs only)"
  echo "  [3] Remove configurations (revert configuration files only)"
  echo
  echo "${BLUE}  Hit Hit CTRL+C to exit${NORMAL}"
  echo
  while :;
  do
	  read -p '  #> ' choice
	  case $choice in
	  	1 ) break ;;
	  	2 ) break ;;
	  	3 ) break ;;
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
	echo "Configuring GAPH host"
}

configure_gaph_compatible()
{
	echo "Configuring GAPH COMPATIBLE host"
}

revert_configurations()
{
	echo "REMOVING configurations"
}

main

case $choice in
	1 ) configure_gaph_host ;;
	2 ) configure_gaph_compatible ;;
	3 ) revert_configurations ;;
esac


exit













logfile=configure.log
touch $logfile

export PATH=./scripts:$PATH

# TODO:
# ADD A NICE (AND SIMPLE) COMMAND-LINE INTERFACE TO THIS SCRIPT
# Melhorar os arquivos de skell
# Adicionar indicator de impressora online
# Adicionar impressora do andar...
# Remover opção GNOME, GNOME-SHELL, (black list it!)
# Ubuntu 16.04 tem o novo apt, usar somente ele

initial-software.sh | tee -a $logfile
fstab-config.sh     | tee -a $logfile
nslcd-config.sh     | tee -a $logfile
nsswitch-config.sh  | tee -a $logfile
admin-config.sh     | tee -a $logfile
lightdm-config.sh   | tee -a $logfile
crontab-config.sh   | tee -a $logfile
saltstack-config.sh | tee -a $logfile
config-printers.sh  | tee -a $logfile
users-config.sh     | tee -a $logfile
hosts-config.sh     | tee -a $logfile
misc-hacks.sh       | tee -a $logfile
extra-software.sh   | tee -a $logfile

#apt-get clean

# Reportar que o sitema vai reiniciar...
reboot -f now

# :)