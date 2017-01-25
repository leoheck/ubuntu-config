#!/bin/bash

set -e -x 

function lxd_config {
    echo lxd bridge-ipv4 boolean true | debconf-set-selections -v
}

debconf-set-selections -v lxd_debconf.txt

add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
apt-get -qq update
apt-get -y install lxd htop tmux jq 
#newgrp lxd
lxd init --auto --storage-backend=dir || true

# test -f travis/lxd/ssh_keys/insecure || ssh-keygen -N "" -f travis/lxd/ssh_keys/insecure

lxc list -c n | grep -q fedora || lxc launch images:fedora/23/amd64 fedora

# At startup time there is some funky business going on with fedora, where dnf is doing something
# and locked. No matter what I have tried, nothing works except sleeping enough to give time dnf to settle down
sleep 30

lxc exec fedora -- bash -c 'while [ -f /var/cache/dnf/metadata_lock.pid ]; do sleep 1; done'
# https://bugzilla.redhat.com/show_bug.cgi?id=1224908
lxc exec fedora -- dnf install -y openssh-server | tee
lxc exec fedora -- systemctl start sshd
lxc exec fedora -- bash -c 'echo "root:12345678" | chpasswd'
lxc exec fedora -- mkdir -p /root/.ssh && chmod og-rwx /root/.ssh
lxc file push --uid=0 --gid=0 --mode=0400 travis/lxd/ssh_keys/insecure.pub fedora/root/.ssh/authorized_keys

lxc list fedora --format=json | jq '.[0].state.network.eth0.addresses[] | select(.family=="inet") | .address' | tr -d \" > FEDORA_IP.txt

touch ~/.ssh/known_hosts
ssh-keyscan -H -t dsa,ecdsa,ed25519,rsa $(cat FEDORA_IP.txt) >> ssh_keys/known_hosts
