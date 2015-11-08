#!/usr/bin/env bash

########################
#       General        #
########################

# Turn off debconf prompts
export DEBIAN_FRONTEND=noninteractive

SERVER_TIMEZONE=${1:-UTC}
echo "Setting Timezone & Locale to $SERVER_TIMEZONE & en_US.UTF-8"

ln -sf /usr/share/zoneinfo/$SERVER_TIMEZONE /etc/localtime
locale-gen en_US.UTF-8 > /dev/null 2>&1
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "export LANG=en_US.UTF-8" >> /home/vagrant/.bashrc
dpkg-reconfigure -f noninteractive locales > /dev/null 2>&1

echo "Updating Ubuntu"
apt-get update > /dev/null 2>&1
echo "Upgrading Ubuntu"
apt-get upgrade -y > /dev/nul 2>&1

# Base packages
echo "Installing Base Packages"
apt-get install python-software-properties build-essential -y >/dev/null 2>&1