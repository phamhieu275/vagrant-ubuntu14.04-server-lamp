#!/usr/bin/env bash

########################
#       General        #
########################

# Turn off debconf prompts
export DEBIAN_FRONTEND=noninteractive

# Setting timezone
SERVER_TIMEZONE=${1:-UTC}
echo "Setting Timezone & Locale to $SERVER_TIMEZONE & en_US.UTF-8"
ln -sf /usr/share/zoneinfo/$SERVER_TIMEZONE /etc/localtime

# Surpress the locale enviroment error
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LC_TYPE=en_US.UTF-8 > /dev/null 2>&1
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
locale-gen en_US.UTF-8 > /dev/null 2>&1
dpkg-reconfigure -f noninteractive locales > /dev/null 2>&1

echo "Updating Ubuntu"
apt-get update > /dev/null 2>&1
echo "Upgrading Ubuntu"
apt-get upgrade -y > /dev/nul 2>&1

# Base packages
echo "Installing Base Packages"
apt-get install python-software-properties build-essential -y >/dev/null 2>&1