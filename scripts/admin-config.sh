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

# LDAP Domain Admins
echo -e '\n# LDAP Domain Admins' >> /etc/sudoers
echo -e '%Domain\ Admins ALL=(ALL) ALL\n\n' >> /etc/sudoers
