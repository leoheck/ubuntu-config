#!/bin/bash

# set -e -x 
# ssh root@$(cat FEDORA_IP.txt) -o UserKnownHostsFile=ssh_keys/known_hosts -i ssh_keys/insecure dnf -y upgrade 
# ssh root@$(cat FEDORA_IP.txt) -o UserKnownHostsFile=ssh_keys/known_hosts -i ssh_keys/insecure dnf -y install htop tmux  

echo
echo "LHECK TESTS <<<<=========================="
echo

lxc network list

# lxc exec fedora -- bash -c 'hostname'
# lxc exec fedora -- bash -c 'pwd'
# lxc exec fedora -- bash -c 'ls -lsa'
# lxc exec fedora -- bash -c 'uname -a'
# lxc exec fedora -- bash -c 'cat /etc/hosts'
# lxc exec fedora -- bash -c 'uptime'

# Isso ainda nao ta funcionando
# lxc exec fedora -- bash -c 'sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/leoheck/gaph-host-config/master/configure.sh)"'

echo
echo "LHECK TESTS DONE =====================>>>>"
echo