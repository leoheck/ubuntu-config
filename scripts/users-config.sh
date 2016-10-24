#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# CONFIGURE USER STUFF

# Features:
# - Remove unecessary folders and files
# - Update .bashrc
# - Update .cshrc

echo "  - Configuring user dots"

# remove unecessary stuff for new users
mkdir -p /etc/skel/www
rm -rf /etc/skel/examples.desktop*
rm -rf /etc/skel/Templates
rm -rf /etc/skel/Podcasts
rm -rf /etc/skel/Audiobooks

# remove unecessary stuff for the main (current) user
mkdir -p ~/www
rm -rf ~/examples.desktop*
rm -rf ~/Templates
rm -rf ~/Podcasts
rm -rf ~/Audiobooks


FILE=/etc/skel/.bashrc
#==============================================================================
cat >> ${FILE} << END_OF_FILE

# Habilita 256 cores no terminal
export TERM=xterm-256color

# Less colors
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;33m'       # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[01;44;33m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# Safe aliases
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias diff='colordiff'

check_mount()
{
    mountpoint='$1'
    mount | grep "$mountpoint" > /dev/null
    STATUS=$?
    echo "Status: $STATUS"
    if [[ $STATUS != 0 ]]; then
        echo "$1 not mounted"
    else
        echo "$1 mounted"
    fi
}

mount | grep "soft64" > /dev/null
if [[ $? != 0 ]]; then
    echo
    echo "INFO: /soft64 não está montado"
    echo "Ferramenta de módulos não estará disponível"
else
    # MODULES ENVIRONMENT
    if [ -f /soft64/Modules/default/init/bash ]; then
        source /soft64/Modules/default/init/bash
    fi
fi

# USER CUSTOM MODULES CAN BE ADDED TO MODULEPATH
#export MODULEPATH=${MODULEPATH}:$HOME/modulefiles

# How to load module automatically
#module load hemps &> /dev/null

END_OF_FILE
#==============================================================================
cp -f /etc/skel/.bashrc $HOME


FILE=/etc/skel/.cshrc
#==============================================================================
cat >> ${FILE} << END_OF_FILE

if ($?tcsh && $?prompt) then

	bindkey "\e[1~" beginning-of-line # Home
	bindkey "\e[7~" beginning-of-line # Home rxvt
	bindkey "\e[2~" overwrite-mode    # Ins
	bindkey "\e[3~" delete-char       # Delete
	bindkey "\e[4~" end-of-line       # End
	bindkey "\e[8~" end-of-line       # End rxvt

	set autoexpand
	set autolist
	set prompt = "%n@%m:%B%~%b%# "

endif

# Configura os modulos para o (t)csh
source /soft64/Modules/default/init/csh

# How to load module automatically
#module load hemps &> /dev/null

END_OF_FILE
#==============================================================================
cp -f /etc/skel/.cshrc $HOME



FILE=/etc/skel/.inputrc
#==============================================================================
cat >> ${FILE} << END_OF_FILE

# History search
"\e[A": history-search-backward
"\e[B": history-search-forward
"\e[C": forward-char
"\e[D": backward-char

# Mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving
"\e[1;5C": forward-word
"\e[1;5D": backward-word
"\e[5C": forward-word
"\e[5D": backward-word
"\e\e[C": forward-word
"\e\e[D": backward-word

END_OF_FILE
#==============================================================================
cp -f /etc/skel/.inputrc $HOME
