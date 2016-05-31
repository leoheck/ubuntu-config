#!/bin/bash

# Install extra software sources
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
	echo "Hey kid, you need to be root, call your father."
	exit 1
fi

# Add google-chrome ppa
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google.list'

# Add virtualbox ppa
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

ppas="\
	ppa:freyja-dev/unity-tweak-tool-daily \
	ppa:indicator-multiload/daily \
	ppa:shutter/ppa \
	ppa:tualatrix/ppa \
	ppa:webupd8team/java \
	ppa:webupd8team/sublime-text-3 \
	ppa:webupd8team/y-ppa-manager \
	ppa:blahota/texstudio"

# Add extra repositories
for ppa in ${ppas}; do
	apt-add-repository -y ${ppa}
done

apt update

#==============================================================================

# EXTRA SOFTWARE - Separated in sections

# Administrator tools
apt install -y bleachbit
apt install -y y-ppa-manager
apt install -y ppa-purge
apt install -y gufw
apt install -y x11vnc
apt install -y vncviewer
apt install -y vnc4server
apt install -y remmina
apt install -y remmina-plugin-nx
apt install -y remmina-plugin-rdp
apt install -y remmina-plugin-vnc
apt install -y remmina-plugin-gnome
apt install -y nmap
apt install -y nxserver
apt install -y nxclient
apt install -y nxnode
apt install -y tree
apt install -y dos2unix
apt install -y curl
apt install -y tcpdump
apt install -y gparted
apt install -y preload
apt install -y strace
apt install -y makedev

# Shels and terminals
apt install -y ipython
apt install -y terminator
apt install -y minicom
apt install -y cutecom
apt install -y gtkterm

# Window managers and tweak tools
apt install -y compizconfig-settings-manager
apt install -y unity-tweak-tool
apt install -y sushi

# Develop tools
apt install -y valgrind
apt install -y flex
apt install -y bison
apt install -y autoconf
apt install -y automake
apt install -y cmake
apt install -y libboost-all-dev
apt install -y subversion
apt install -y rapidsvn
apt install -y mercurial
apt install -y git
apt install -y doxygen
apt install -y doxygen-latex
apt install -y glade

# Editors, IDEs and Edition tools
apt install -y sublime-text-installer
apt install -y geany
apt install -y geany-common
apt install -y geany-plugins
apt install -y geany-plugin-addons
apt install -y gedit-plugins
apt install -y vim
apt install -y texmaker
apt install -y texlive-full
apt install -y texstudio
apt install -y meld
apt install -y colordiff
apt install -y arduino
apt install -y codeblocks
apt install -y eric

# Internet and communication
apt install -y google-chrome-stable
apt install -y skype

# Image edition
apt install -y gimp
apt install -y inkscape
apt install -y imagemagick
apt install -y shutter

# Audio and Video
apt install -y adobe-flashplugin
apt install -y ubuntu-restricted-extras
apt install -y vlc
apt install -y cheese

# Android
apt install -y android-rules
apt install -y android-tools-adb
apt install -y android-tools-fastboot
apt install -y android-tools-fsutils
apt install -y go-mtpfs
apt install -y go-mtpfs-unity

# Required for others
apt install -y libelf-dev
apt install -y libelf1
apt install -y libxss1
apt install -y ureadahead

# Math
apt install -y gnuplot
apt install -y octave
apt install -y scilab
apt install -y lp-solve

# MISC
apt install -y oracle-java7-installer
apt install -y oracle-java7-set-default
apt install -y nautilus-dropbox
apt install -y virtualbox
apt install -y gtkwave
apt install -y eagle
apt install -y graphviz
apt install -y p7zip-full
apt install -y p7zip-rar
apt install -y pdftk
apt install -y cups-pdf
apt install -y xpdf
apt install -y gv
apt install -y ghostscript
apt install -y opencv

# Indicators
apt install -y indicator-multiload

# Python related
apt install -y python-all
apt install -y python-dev
apt install -y python-all-dev
apt install -y python-setuptools
apt install -y python-pip
apt install -y python-matplotlib
apt install -y python-numpy
apt install -y python-scipy
apt install -y python-scitools
apt install -y python-mysqldb
apt install -y python-opencv
apt install -y python-qt4
apt install -y python-serial
apt install -y python-simplejson
apt install -y python-sip
apt install -y python-subversion
apt install -y python-webkit
apt install -y python-pandas
apt install -y python-networkx
apt install -y python-scikits-learn
apt install -y python-scikits.statsmodels
apt install -y python-sphinx
apt install -y python-spyderlib
apt install -y python-tables
apt install -y python-pydot
apt install -y python-pygraphviz
apt install -y python-drmaa
apt install -y python-glade2
apt install -y pyro
apt install -y pyro-gui
apt install -y tcl
apt install -y tcl-dev
apt install -y tk
apt install -y tk-dev
apt install -y ruby
apt install -y lua
apt install -y perl
apt install -y guile-1.8

# Extra fonts
apt install -y xfonts-base
apt install -y xfonts-scalable
apt install -y xfonts-100dpi
apt install -y xfonts-75dpi
apt install -y gsfonts-x11
apt install -y xfonts-100dpi-transcoded
apt install -y xfonts-75dpi-transcoded
apt install -y texlive-fonts-extra

# Language packs, dictionaries, helps and related tools
apt install -y hyphen-en-us
apt install -y hunspell
apt install -y hunspell-tools
apt install -y hunspell-en-us
apt install -y myspell-pt-br
apt install -y ispell
apt install -y iamerican-insane
apt install -y ibrazilian
apt install -y wamerican-huge
apt install -y wbrazilian
apt install -y wbritish
apt install -y libreoffice-templates
apt install -y libreoffice-grammarcheck
apt install -y libreoffice-grammarcheck-en-us
apt install -y libreoffice-l10n-en-us
apt install -y libreoffice-help-pt-br
apt install -y libreoffice-l10n-pt-br
