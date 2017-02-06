#!/bin/bash

# DESCRIPTION
# Run travis.yaml tests locally

# REQUIREMENTS 
# sudo -H pip install shyaml

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

# GET INSTALL SECTION
# install_cmds=$(cat .travis.yml| shyaml get-value 'install' | sed 's/-[\t ]\+//g')

# echo -e "\n\n${BOLD}+===================================================================+"
# echo    "| REQUIREMENTS FOR TESTS                                            |"
# echo -e "+===================================================================+${NORMAL}"

# IFS=$'\n'
# for cmd in $install_cmds; do
# 	echo -e "$cmd${NORMAL}"
# done


echo -e "\n\n${BOLD}+===================================================================+"
echo    "| RUNNING TESTS                                                     |"
echo -e "+===================================================================+${NORMAL}"

# GET SCRIPTS SECTION
script_cmds=$(cat .travis.yml| shyaml get-value 'script' | sed 's/-[\t ]\+//g')

n=1
summary="#CMD, COMMAND, RET_CODE, STATUS"
IFS=$'\n'
for cmd in $script_cmds; do

	echo
	if [[ $n > 1 ]]; then
	echo -e "====================================================================="
	fi
	# echo -e "${BLUE}${BOLD}RUNNING CMD $n:${NORMAL} $cmd"
	echo -e "${BLUE}${BOLD}RUNNING COMMAND $n${NORMAL}"
	echo -e "$cmd"
	eval $cmd
	status=$?
	if [[ $status == 0 ]]; then
		echo -e "${GREEN}${BOLD}CMD $n HAS PASSSED [STATUS $status]${NORMAL}"
		label="PASS"
	else
		echo -e "${RED}${BOLD}CMD $n HAS FAILED [STATUS $status]${NORMAL}"
		label="FAILED"
	fi
	summary="$summary\n$n, $cmd, $status, $label"
	echo
	n=$((n+1))
done


echo -e "\n\n${BOLD}+===================================================================+"
echo    "| TESTS SUMMARY                                                     |"
echo -e "+===================================================================+${NORMAL}"
echo -e "$summary" | column -t -s ,
# n=1
# IFS=$'\n'
# for line in $summary; do
# 	echo "$n - $line"
# done