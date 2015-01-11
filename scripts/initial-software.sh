#!/bin/bash

# Configure minimum REQUIRED software
# Leandro Sehnem Heck (leoheck@gmail.com)

# Features:

# Enable partner repositories
sed -i "s/#deb http/deb http/" /etc/apt/sources.list
sed -i "s/#deb-src http/deb-src http/" /etc/apt/sources.list

apt-get update
apt-get full-upgrade -y