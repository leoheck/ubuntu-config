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
if [ "$(id -u)" != "0" ]; then
	echo "Hey kid, you need the root power, call your father."
	exit 1
fi

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