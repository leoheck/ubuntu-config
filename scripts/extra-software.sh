#!/bin/bash

# Install extra software sources
# Leandro Sehnem Heck (leoheck@gmail.com)


# Add google-chrome ppa
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google.list'

# Add virtualbox ppa
wget -q -O - http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc | apt-key add -
sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | tee /etc/apt/sources.list.d/virtualbox.list'

# Add extra ppas

ppas="\
	ppa:blahota/texstudio \
	ppa:freyja-dev/unity-tweak-tool-daily \
	ppa:indicator-multiload/daily \
	ppa:moka/stable \
	ppa:saltstack/salt \
	ppa:shutter/ppa \
	ppa:tualatrix/ppa \
	ppa:webupd8team/java \
	ppa:webupd8team/sublime-text-3 \
	ppa:webupd8team/y-ppa-manager"

# Extra repositories
for ppa in ${ppas}; do
	apt-add-repository -y ${ppa}
done

apt-get update

#==============================================================================

# EXTRA SOFTWARE - Separated in sections

# Administrator tools
apt-get install -y dconf-tools
apt-get install -y bleachbit
apt-get install -y y-ppa-manager
apt-get install -y ppa-purge
apt-get install -y gufw
apt-get install -y x11vnc
apt-get install -y vncviewer
apt-get install -y vnc4server
apt-get install -y remmina
apt-get install -y remmina-plugin-nx
apt-get install -y remmina-plugin-rdp
apt-get install -y remmina-plugin-vnc
apt-get install -y remmina-plugin-gnome
apt-get install -y nmap
apt-get install -y nxserver
apt-get install -y nxclient
apt-get install -y nxnode
apt-get install -y tree
apt-get install -y dos2unix
apt-get install -y curl
apt-get install -y tcpdump
apt-get install -y gparted
apt-get install -y preload
apt-get install -y strace
apt-get install -y makedev

# Shels and terminals
apt-get install -y csh
apt-get install -y ksh
apt-get install -y tcsh
apt-get install -y zsh
apt-get install -y ipython
apt-get install -y terminator
apt-get install -y minicom
apt-get install -y cutecom
apt-get install -y gtkterm

# Window managers and tweak tools
apt-get install -y compizconfig-settings-manager
apt-get install -y unity-tweak-tool
apt-get install -y sushi
apt-get install -y gnome-session-flashback

# Develop tools
apt-get install -y valgrind
apt-get install -y flex
apt-get install -y bison
apt-get install -y autoconf
apt-get install -y automake
apt-get install -y cmake
apt-get install -y libboost-all-dev
apt-get install -y subversion
apt-get install -y rapidsvn
apt-get install -y mercurial
apt-get install -y git
apt-get install -y doxygen
apt-get install -y doxygen-latex
apt-get install -y glade


# Editors, IDEs and Edition tools
apt-get install -y sublime-text-installer
apt-get install -y geany
apt-get install -y geany-common
apt-get install -y geany-plugins
apt-get install -y geany-plugin-addons
apt-get install -y gedit-plugins
apt-get install -y vim
apt-get install -y texmaker
apt-get install -y texlive-full
apt-get install -y texstudio
apt-get install -y meld
apt-get install -y colordiff
apt-get install -y arduino
apt-get install -y codeblocks
apt-get install -y eric

# Internet and communication
apt-get install -y google-chrome-stable
apt-get install -y skype

# Image edition
apt-get install -y gimp
apt-get install -y inkscape
apt-get install -y imagemagick
apt-get install -y shutter

# Audio and Video
apt-get install -y adobe-flashplugin
apt-get install -y ubuntu-restricted-extras
apt-get install -y vlc
apt-get install -y cheese

# Android
apt-get install -y android-rules
apt-get install -y android-tools-adb
apt-get install -y android-tools-fastboot
apt-get install -y android-tools-fsutils
apt-get install -y go-mtpfs
apt-get install -y go-mtpfs-unity

# Required for others
apt-get install -y libelf-dev
apt-get install -y libelf1
apt-get install -y libxss1
apt-get install -y ureadahead

# Math
apt-get install -y gnuplot
apt-get install -y octave
apt-get install -y scilab
apt-get install -y lp-solve

# MISC
apt-get install -y oracle-java7-installer
apt-get install -y nautilus-dropbox
apt-get install -y virtualbox-4.3
apt-get install -y gtkwave
apt-get install -y eagle:i386
apt-get install -y graphviz
apt-get install -y p7zip-full
apt-get install -y p7zip-rar
apt-get install -y pdftk
apt-get install -y cups-pdf
apt-get install -y xpdf
apt-get install -y gv
apt-get install -y ghostscript
apt-get install -y opencv

# Indicators
apt-get install -y indicator-multiload
apt-get install -y radiotray

# Python related
apt-get install -y python-all
apt-get install -y python-dev
apt-get install -y python-all-dev
apt-get install -y python-setuptools
apt-get install -y python-pip
apt-get install -y python-matplotlib
apt-get install -y python-numpy
apt-get install -y python-scipy
apt-get install -y python-scitools
apt-get install -y python-mysqldb
apt-get install -y python-opencv
apt-get install -y python-qt4
apt-get install -y python-serial
apt-get install -y python-simplejson
apt-get install -y python-sip
apt-get install -y python-subversion
apt-get install -y python-webkit
apt-get install -y python-pandas
apt-get install -y python-networkx
apt-get install -y python-scikits-learn
apt-get install -y python-scikits.statsmodels
apt-get install -y python-sphinx
apt-get install -y python-spyderlib
apt-get install -y python-tables
apt-get install -y python-pydot
apt-get install -y python-pygraphviz
apt-get install -y python-drmaa
apt-get install -y python-glade2
apt-get install -y pyro
apt-get install -y pyro-gui
apt-get install -y tcl
apt-get install -y tcl-dev
apt-get install -y tk
apt-get install -y tk-dev
apt-get install -y ruby
apt-get install -y lua
apt-get install -y perl
apt-get install -y guile-1.8


# Extra fonts
apt-get install -y xfonts-base
apt-get install -y xfonts-scalable
apt-get install -y xfonts-100dpi
apt-get install -y xfonts-75dpi
apt-get install -y gsfonts-x11
apt-get install -y xfonts-100dpi-transcoded
apt-get install -y xfonts-75dpi-transcoded
apt-get install -y texlive-fonts-extra


# Language packs, dictionaries, helps and related tools
apt-get install -y hyphen-en-us
apt-get install -y hunspell
apt-get install -y hunspell-tools
apt-get install -y hunspell-en-us
apt-get install -y myspell-pt-br
apt-get install -y myspell-pt-br
apt-get install -y ispell
apt-get install -y iamerican-insane
apt-get install -y ibrazilian
apt-get install -y wamerican-huge
apt-get install -y wbrazilian
apt-get install -y wbritish
apt-get install -y libreoffice-templates
apt-get install -y libreoffice-grammarcheck
apt-get install -y libreoffice-grammarcheck-en-us
apt-get install -y libreoffice-l10n-en-us
apt-get install -y libreoffice-help-pt-br
apt-get install -y libreoffice-l10n-pt-br