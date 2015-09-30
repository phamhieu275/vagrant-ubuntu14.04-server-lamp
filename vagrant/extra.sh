#!/bin/bash

########################
#    Other Packages    #
########################

# Installing Composer
echo "Installing Composer"
curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
mv composer.phar /usr/local/bin/composer > /dev/null 2>&1

# Install Git
echo "Installing Git"
apt-get install git -y > /dev/null 2>&1

# Installing PHPUnit
echo "Installing PHPUnit"
apt-get install phpunit -y > /dev/null 2>&1

# Installing Node
echo "Installing Node"
curl -sL https://deb.nodesource.com/setup | sudo bash - > /dev/null 2>&1
apt-get install nodejs -y > /dev/null 2>&1
npm install npm -g > /dev/null 2>&1

echo "Installing Bower"
npm install bower -g > /dev/null 2>&1

echo "Installing Gulp"
npm install gulp -g > /dev/null 2>&1

echo "Installing Grunt"
npm install grunt-cli -g > /dev/null 2>&1