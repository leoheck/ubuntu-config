#!/bin/bash

set -e -x 

# ssh root@$(cat FEDORA_IP.txt) -o UserKnownHostsFile=ssh_keys/known_hosts -i ssh_keys/insecure dnf -y upgrade 
# ssh root@$(cat FEDORA_IP.txt) -o UserKnownHostsFile=ssh_keys/known_hosts -i ssh_keys/insecure dnf -y install htop tmux  

echo
echo "LHECK TESTS <<<<====================="
echo

lxc exec fedora -- bash -c 'hostname'
lxc exec fedora -- bash -c 'pwd'
lxc exec fedora -- bash -c 'ls -lsa'
lxc exec fedora -- bash -c 'uname -a'
lxc exec fedora -- bash -c 'lsb_release'
lxc exec fedora -- bash -c 'cat /etc/hosts'
lxc exec fedora -- bash -c 'uptime'

echo
echo "TESTS DONE <<<<====================="
echo