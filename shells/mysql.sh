#!/usr/bin/env bash

########################
#         MySQL        #
########################

MYSQL_ROOT_PASSWORD=${1:-root} # default = root
MYSQL_ENABLE_REMOTE=${2:-true} # default = true

# Install MySQL without password prompt
# Set username and password to 'root'
echo "Setting MySQL Root Password"
echo "mysql-server mysql-server/root_password password "${MYSQL_ROOT_PASSWORD} | debconf-set-selections > /dev/null 2>&1
echo "mysql-server mysql-server/root_password_again password "${MYSQL_ROOT_PASSWORD} | debconf-set-selections > /dev/null 2>&1

# Install mysql-server
echo "Installing MySQL Server"
apt-get install mysql-server -y > /dev/null 2>&1

# Create informations
mysql_install_db > /dev/null 2>&1

# Make MySQL connectable from outside world without SSH tunnel
if [ $MYSQL_ENABLE_REMOTE = "true" ]; then
    # enable remote access
    echo "Turning on remote access"

    # setting the mysql bind-address to allow connections from everywhere
    sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

    # adding grant privileges to mysql root user from everywhere
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

    service mysql restart
fi