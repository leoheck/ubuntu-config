#!/bin/bash

# Leandro Sehnem Heck (leoheck@gmail.com)

# Install EXTRA APPLICATIONS

# Add google-chrome ppa
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google.list'

# Add virtualbox ppa
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -

ppas="\
	ppa:indicator-multiload/daily \
	ppa:shutter/ppa \
	ppa:webupd8team/java \
	ppa:webupd8team/sublime-text-3 \
	ppa:webupd8team/y-ppa-manager"



# Removed
# ppa:pgavin/ghdl \
# ppa:blahota/texstudio
# ppa:freyja-dev/unity-tweak-tool-daily
# ppa:tualatrix/ppa

# Add extra repositories
for ppa in ${ppas}; do
	apt-add-repository -y ${ppa}
done

# EXTRA SOFTWARE (organized in groups)

#===========================
read -r -d '' APPSCSV <<-EOM

# Texttools
wdiff,

# Administrator tools
htop,
bleachbit,
y-ppa-manager,
ppa-purge,
gufw,
x11vnc,
vncviewer,
vnc4server,
remmina,
remmina-plugin-nx,
remmina-plugin-rdp,
remmina-plugin-vnc,
remmina-plugin-gnome,
nmap,
nxserver,
nxclient,
nxnode,
tree,
dos2unix,
curl,
tcpdump,
gparted,
preload,
strace,
makedev,

# Shells and terminals
ipython,
terminator,
screen,
minicom,
cutecom,
gtkterm,
shellcheck,

# Window managers and tweak tools
compizconfig-settings-manager,
unity-tweak-tool,
sushi,

# Develop tools
valgrind,
flex,
bison,
autoconf,
zautomake,
cmake,
libboost-all-dev,
subversion,
rapidsvn,
mercurial,
git,
doxygen,
doxygen-latex,
glade,

# Editors, IDEs and Edition tools
sublime-text-installer,
geany,
geany-common,
geany-plugins,
geany-plugin-addons,
gedit-plugins,
vim,
texmaker,
texlive-full,
texstudio,
meld,
colordiff,
arduino,
codeblocks,
eric,

# Internet and communication
google-chrome-stable,
skype,

# Image edition
gimp,
inkscape,
shutter,

# Audio and Video
adobe-flashplugin,
ubuntu-restricted-extras,
vlc,
cheese,

# Android
android-rules,
android-tools-adb,
android-tools-fastboot,
android-tools-fsutils,
go-mtpfs,
go-mtpfs-unity,

# Required for others
libelf-dev,
libelf1,
libxss1,
ureadahead,

# Math tools
gnuplot,
octave,
scilab,
lp-solve,

# Hardware tools
iverilog
#ghdl

# Misc
oracle-java7-installer,
oracle-java8-installer,
oracle-java7-set-default,
nautilus-dropbox,
virtualbox,
gtkwave,
eagle,
graphviz,
p7zip-full,
p7zip-rar,
pdftk,
cups-pdf,
xpdf,
gv,
ghostscript,
opencv,

# Indicators
indicator-multiload,

# Python related
python-all,
python-all-dev,
python-dev,
python-drmaa,
python-glade2,
python-matplotlib,
python-mysqldb,
python-naturalsort,
python-natsort,
python-networkx,
python-numpy,
python-opencv,
python-pandas,
python-pip,
python-pydot,
python-pygraphviz,
python-qt4,
python-scikits-learn,
python-scikits.statsmodels,
python-scipy,
python-scitools,
python-serial,
python-setuptools,
python-simplejson,
python-sip,
python-sphinx,
python-spyderlib,
python-subversion,
python-tables,
python-webkit,
pyro,
pyro-gui,

# Extra scripts
tcl,
tcl-dev,
tk,
tk-dev,
ruby,
lua,
perl,
guile-1.8,

# Extra fonts
xfonts-base,
xfonts-scalable,
xfonts-100dpi,
xfonts-75dpi,
gsfonts-x11,
xfonts-100dpi-transcoded,
xfonts-75dpi-transcoded,
texlive-fonts-extra,
ttf-mscorefonts-installer,

# Language packs, dictionaries, helps and related tools
hyphen-en-us,
hunspell,
hunspell-tools,
hunspell-en-us,
myspell-pt-br,
ispell,
iamerican-insane,
ibrazilian,
wamerican-huge,
wbrazilian,
wbritish,
libreoffice-templates,
libreoffice-grammarcheck,
libreoffice-grammarcheck-en-us,
libreoffice-l10n-en-us,
libreoffice-help-pt-br,
libreoffice-l10n-pt-br,

# [SYNOPSYS TOOLS] Some required 32 bit libs
libncurses5:i386,
libxss1:i386,
libsm6:i386,
libxft2:i386,
libjpeg62:i386,
libtiff5:i386,
libmng2:i386,

libxp6,

EOM
#===========================

APPS=$(echo "$APPSCSV" | sed '/^\s*\#.*$/d' | cut -d, -f1 | sed '/^\s*$/d')

# Workaround for a bug related ttf-mscorefonts-installer
# https://bugs.launchpad.net/ubuntu/+source/aptitude/+bug/1543280
chmod 777 /var/lib/update-notifier/package-data-downloads/partial

# TO LEARN THE REQUIRED QUESTIONS
# 1. Install package
# 2. Run: sudo debconf-show [pkg-name]

# Configure required answares when it is needed
# FORMAT: <owner> <question name> <question type> <value>
debconf-set-selections <<< "d-i msttcorefonts/accepted-mscorefonts-eula select true"
debconf-set-selections <<< "d-i shared/accepted-oracle-license-v1-1 select true"
debconf-set-selections <<< "d-i shared/accepted-oracle-license-v1-1 seen true"

# This guy resets configs above (ISSUE)
#dpkg-reconfigure --force

# Installation process
export DEBIAN_FRONTEND=noninteractive
dpkg --add-architecture i386
apt-get update
apt-get install -f -y

# Install apps individually
for APP in $APPS;
do
	dpkg -s $APP &> /dev/null
	if [ ! $? -eq 0 ]; then
		DEBIAN_FRONTEND=noninteractive apt-get install -y $APP
	fi
done
