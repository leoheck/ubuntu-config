#!/bin/bash

set -e -x 

# ssh root@$(cat FEDORA_IP.txt) -o UserKnownHostsFile=ssh_keys/known_hosts -i ssh_keys/insecure dnf -y upgrade 
# ssh root@$(cat FEDORA_IP.txt) -o UserKnownHostsFile=ssh_keys/known_hosts -i ssh_keys/insecure dnf -y install htop tmux  

echo
echo "SCRIPT RUNNING <<<<====================="
echo
