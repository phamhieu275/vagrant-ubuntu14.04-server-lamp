#!/usr/bin/env bash

########################
#        Apache        #
########################

# Install Apache
echo "Installing Apache"
apt-get install apache2 libapache2-mod-php5 -y > /dev/null 2>&1

echo "Configuring Apache"

# Enable Rewrite SSL Module
a2enmod rewrite ssl > /dev/null 2>&1

# Config servername
echo "ServerName localhost" > /etc/apache2/conf-available/fqdn.conf
a2enconf fqdn > /dev/null 2>&1

DIR_FILE=/etc/apache2/mods-enabled/dir.conf
if [ -f $DIR_FILE ]; then
    sed -i "s/index.php //g" $DIR_FILE> /dev/null 2>&1
    sed -i "s/DirectoryIndex/DirectoryIndex index.php/g" $DIR_FILE > /dev/null 2>&1
fi

service apache2 restart