#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# MAIN SCRIPT TO CONFIGURE INSTALL GAPH CONFIGS

# GITHUB REPOSITORY CONFIG
REPO="gaph-host-config"
BRANCH="master"

# TODO: MUDAR O NOME DO ZIP BAIXADO PRA $REPO-$BRANCH.zip
GITHUB="https://github.com/leoheck/$REPO/archive/"
PKG=$BRANCH.zip

PROJECTDIR=/tmp/$REPO-$BRANCH

export PATH=./scripts:$PATH
export PATH=$PROJECTDIR/scripts:$PATH

mkdir -p /var/log/gaph/

if [ "$1" == "-l" ]; then
	skip_donwload=1
else
	skip_donwload=0
fi

# Ctrl+c function to halt execution
control_c()
{
	clear
	echo -e "\n$0 interrupted by user :(\n"
	shutdown -r +3 2> /dev/null	
	kill -KILL $$
}

trap control_c SIGINT

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
	echo -e "\n${YELLOW}Hey kid, you need superior powers, Go call your father.${NORMAL}\n"
	exit 1
fi

main()
{
	# Perguntar se o user quer usar a pasta existente ou se quer baixar ela denovo.
	# Isso facilita o debug/teste sem ter que submeter o codigo pro github
	# MELHOR, adicionar uma flag de linhas de commando pra ativar o reuso... 

	if [ ! "$skip_donwload" = "1" ]; then
	
		if [ -f /tmp/$PKG ]; then
			printf "%s  Removing preview /tmp/$PKG ...%s\n" "${BLUE}" "${NORMAL}"
			rm -rf /tmp/$PKG
		fi

		# Mudar o nome do pacote baixado... usar o nome do repositorio que é melhor.
		printf "%s  Donwloading an updated $PKG from github in /tmp ...%s\n" "${BLUE}" "${NORMAL}"
		wget $GITHUB/$PKG -O /tmp/$PKG 2> /dev/null
	
		if [ -d $PROJECTDIR ]; then
			printf "%s  Removing $PROJECTDIR ...%s\n" "${BLUE}" "${NORMAL}"
			rm -rf $PROJECTDIR
		fi
	
		printf "%s  Unpacking /tmp/$PKG into $PROJECTDIR ...%s\n" "${BLUE}" "${NORMAL}"
		unzip -qq /tmp/$PKG -d /tmp > /dev/null
	else
		printf "%s  Using local files\n" "${YELLOW}" "${NORMAL}"
	fi

	# TODO: Como ver isso automatico? find na pasta baixada?
	echo
	echo "  Last update: xx/xx/xxxx xx:xx"

	echo "${GREEN}"
	echo "   _____  _____  _____  _____           _____  _____  _____  _____   "
	echo "  |   __||  _  ||  _  ||  |  |   ___   |  |  ||     ||   __||_   _|  "
	echo "  |  |  ||     ||   __||     |  |___|  |     ||  |  ||__   |  | |    "
	echo "  |_____||__|__||__|   |__|__|         |__|__||_____||_____|  |_|    "
	echo "                                                                     "
	echo "  CONFIGURATION SCRIPT (MADE FOR UBUNTU 16.04)${NORMAL}"
	echo
	echo "  [1] ${BOLD}TURN MACHINE INTO A GAPH HOST${NORMAL}"
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

install_base_software()
{
	echo "  - Instaling base apps"
	echo "${GREEN}    - THIS CAN TAKE SOME MINUTES.${NORMAL}"

	# TODO: TESTA SE TEM screen, SE nao instala...
	
	dpkg -s tmux &> /dev/null
	if [ ! $? -eq 0 ]; then sudo apt install tmux; fi
	
	dpkg -s screen &> /dev/null
	if [ ! $? -eq 0 ]; then sudo apt install screen; fi

	# TODO: Rodar tudo no tmux|screen ou outro, quando tiver que instalar, divide a tela... instala e desliga o terminal...
	# Dessa forma nao precisa usar a gui nunca
	#screen bash -c "initial-software.sh | tee /var/log/gaph/install-base.log"
	#tmux new top \; split-window -d sudo apt update


	# TESTA SE TEM DISPLAY 
	# Acho que que esse teste da problema para executar com root.
	xhost +si:localuser:$(whoami) &> /dev/null && {
		echo "${BLUE}    - Loading the GUI, please wait...${NORMAL}"
		xterm \
			-title 'Installing BASE Software' \
			-fa 'Ubuntu Mono' -fs 12 \
			-bg 'black' -fg 'white' \
			-e "bash -c 'initial-software.sh | tee /var/log/gaph/install-base.log'"
			tput cuu1;
			tput el;
	} || {
		bash -c "initial-software.sh | tee /var/log/gaph/install-base.log"
	}

	tput cuu1;
	tput el;

	echo "    - See logs in /var/log/gaph/install-base.log"
}

install_extra_software()
{
	echo "  - Instaling extra apps ..."
	echo "${GREEN}    - THIS CAN TAKE HOURS. Go take a coffe :)${NORMAL}"

	# TESTA SE TEM DISPLAY
	#xhost +si:localuser:$(whoami) >&/dev/null && {
		echo "${BLUE}    - Loading the GUI, please wait...${NORMAL}"
		xterm \
			-title 'Installing EXTRA Software' \
			-fa 'Ubuntu Mono' -fs 12 \
			-bg 'black' -fg 'white' \
			-e "bash -c 'extra-software.sh | tee /var/log/gaph/install-extra.log'"
			tput cuu1;
			tput el;
	#} || {
	#	bash -c "extra-software.sh | tee /var/log/gaph/install-extra.log"
	#}

	tput cuu1;
	tput el;
	echo "$(date)" > /var/log/gaph/install-extra.done
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

apply_and_upgrade_configs()
{
	echo
	echo "${YELLOW}  Appling/updating configurations ...${NORMAL}"
	install_base_software
	install-scripts.sh -i $PROJECTDIR | tee /var/log/gaph/install-scripts.log
	crontab-config.sh -i $PROJECTDIR | tee /var/log/gaph/crontab-config.log
	admin-config.sh -i | tee /var/log/gaph/admin-config.log
	config-printers.sh -i $PROJECTDIR | tee /var/log/gaph/config-printers.log
	fstab-config.sh -i | tee /var/log/gaph/fstab-config.log
	hosts-config.sh -i | tee /var/log/gaph/hosts-config.log
	lightdm-config.sh -i | tee /var/log/gaph/lightdm-config.log
	nslcd-config.sh -i | tee /var/log/gaph/nslcd-config.log
	nsswitch-config.sh -i | tee /var/log/gaph/nsswitch-config.log
	saltstack-config.sh -i | tee /var/log/gaph/saltstack-config.log
	users-config.sh | tee /var/log/gaph/users-config.log
	customization.sh -i $PROJECTDIR | tee /var/log/gaph/customization.log
	install_extra_software
	misc-hacks.sh | tee /var/log/gaph/misc-hacks.log
	echo "$(date)" > /var/log/gaph/install-configs.done
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
	customization.sh -r
	rm -f /var/log/gaph/install-configs.done
}

configure_gaph_host()
{
	echo
	echo "${YELLOW}  Configuring GAPH host ...${NORMAL}"
	install_base_software
	apply_and_upgrade_configs
	install_extra_software
	reboot_host
}

configure_gaph_compatible()
{
	echo
	echo "${YELLOW}  Configuring GAPH COMPATIBLE host ...${NORMAL}"
	install_base_software
	install_extra_software
	misc-hacks.sh
	reboot_host
}

clear
echo
main
clear

case $choice in
	1 ) configure_gaph_host ;;
	2 ) configure_gaph_compatible ;;
	3 ) apply_and_upgrade_configs ;;
	4 ) revert_configurations ;;
esac

echo "${YELLOW}  DONE! Bye :) ${NORMAL}"
echo
