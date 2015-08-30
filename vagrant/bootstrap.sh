#!/bin/bash

########################
#       General        #
########################

# Turn off debconf prompts
export DEBIAN_FRONTEND=noninteractive

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
apt-get upgrade > /dev/nul 2>&1

# Base packages
echo "Installing Base Packages"
apt-get install python-software-properties build-essential -y >/dev/null 2>&1