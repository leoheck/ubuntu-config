#!/bin/bash

# Configure administration access
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures the main login screen (LightDM)
# Features:
# - Set de root password
# - Enable sudo for professors

# DEFAULT ROOT PASSWORD
# To generate the cripto password: openssl passwd
echo "root:VLuxY7G/MDMO2" | chpasswd -e

# Add admin (network) users to sudo group (professors)
usermod -G sudo -a moraes
usermod -G sudo -a calazans
usermod -G sudo -a aamory
usermod -G sudo -a emoreno
usermod -G sudo -a matheus
usermod -G sudo -a lheck