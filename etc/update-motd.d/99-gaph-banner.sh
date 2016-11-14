#!/bin/bash

# /etc/update-motd.d/99-sample-banner.sh

clear

# Testar se tem cores.. se nao preto e branco mesmo..
# RED="$(tput setaf 1)"
# GREEN="$(tput setaf 2)"
# YELLOW="$(tput setaf 3)"
# BLUE="$(tput setaf 4)"
# BOLD="$(tput bold)"
# NORMAL="$(tput sgr0)"

RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
BOLD="\e[1m"
NORMAL="\e[0m"

# testar se terminal é >= a 80 colunas
# se nao colocar uma versao menor...
# tput cols


#echo -e "
#${BOLD}  Welcome to:
#${BOLD}${GREEN}  _______  _______  _______  __   __   ${NORMAL}${BOLD} __   __  _______  _______  _______
#${BOLD}${GREEN} |       ||   _   ||       ||  | |  |  ${NORMAL}${BOLD}|  | |  ||       ||       ||       |
#${BOLD}${GREEN} |    ___||  |_|  ||    _  ||  |_|  |  ${NORMAL}${BOLD}|  |_|  ||   _   ||  _____||_     _|
#${BOLD}${GREEN} |   | __ |       ||   |_| ||       |  ${NORMAL}${BOLD}|       ||  | |  || |_____   |   |
#${BOLD}${GREEN} |   ||  ||       ||    ___||       |  ${NORMAL}${BOLD}|       ||  |_|  ||_____  |  |   |
#${BOLD}${GREEN} |   |_| ||   _   ||   |    |   _   |  ${NORMAL}${BOLD}|   _   ||       | _____| |  |   |
#${BOLD}${GREEN} |_______||__| |__||___|    |__| |__|  ${NORMAL}${BOLD}|__| |__||_______||_______|  |___|"

# echo -ne "\033[0m"
# tput sgr0

Host=$(hostname)
Owner=$(grep 1000 /etc/passwd | cut -d: -f5 | cut -d, -f1 | sed -r 's/\<./\U&/g')
Uptime=$(uptime -p)
Users=$(users | tr ' ' '\n' | sort | uniq)
OS=$(lsb_release -s -d)
Kernel=$(uname -r)
#CPU=$(lscpu | grep 'Model name:' | cut -d: -f2 |awk '{print $0}' | sed -e 's/^[ \t]*//' | sed 's/[ \t]\+/ /g')
procs=$(($(grep processor /proc/cpuinfo | tail -1 | cut -d: -f2 | sed 's/\s//g')+1))
cores=$(grep -m 1 cores /proc/cpuinfo | cut -d: -f2 | sed 's/\s//g')
CPU=$(cat /proc/cpuinfo | grep -i "model name" | sed 's/\s\+/ /g' | cut -d: -f2 | sed 's/^ //g' | head -1)
Memory="$(echo "scale=1; $(cat /proc/meminfo | grep MemTotal |  sed 's/[\t ]\+/ /' | cut -d' ' -f 2) / (1000*1000)" | bc) GB"
UpgradeDate=$(cat /var/log/gaph/install-configs.done)

echo -e "
${BLUE}${BOLD}   Host: ${NORMAL}${Host}
${BLUE}${BOLD} Owener: ${NORMAL}${Owner}
${BLUE}${BOLD}     OS: ${NORMAL}${OS}
${BLUE}${BOLD} Kernel: ${NORMAL}${Kernel}
${BLUE}${BOLD}    CPU: ${NORMAL}${CPU}, Procs=${procs}, Cores=${ores}
${BLUE}${BOLD} Memory: ${NORMAL}${Memory}
${BLUE}${BOLD} Uptime: ${NORMAL}${Uptime}
${BLUE}${BOLD} GAPHOS: ${NORMAL}${UpgradeDate}
"

# echo -e "${NORMAL}${BOLD} Last Update: ${NORMAL} TODO"

#echo -e "
#${YELLOW}${BOLD} Problems can be reported at:
#${RED}${BOLD}    https://github.com/leoheck/gaph-host-config/issues
#${NORMAL}
"
