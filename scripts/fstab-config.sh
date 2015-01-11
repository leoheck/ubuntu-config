#!/bin/bash

# Configure FSTAB
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures the network mount points
# Features:
# - Add /users entry
# - Add /soft64 entry
# - Add /grid entry
# - Add /sim entry

FILE=/etc/fstab
date=$(date +"%Y-%m-%d-%Hh%M")

# backup the original file
if [ -f ${FILE} ]; then
	cp ${FILE} ${FILE}-${date}
fi

mkdir -p users
mkdir -p soft64
mkdir -p grid
mkdir -p sim

# append the configuration
#==============================================================================
cat >> ${FILE} << END-OF-FILE

# [GAPH] Network mountoints
rodos.inf.pucrs.br:/home   /users  nfs acl,defaults 0 0
kriti.inf.pucrs.br:/soft64 /soft64 nfs ro,soft,intr 0 0
kriti.inf.pucrs.br:/grid   /grid   nfs defaults     0 0

# [GAPH] Local mountoints
# sdx /sim    nfs defaults     0 0

 END-OF-FILE
#==============================================================================


mount -a