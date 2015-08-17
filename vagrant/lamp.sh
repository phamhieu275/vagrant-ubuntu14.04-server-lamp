#!/bin/bash

php_config_file="/etc/php5/cli/php.ini"
xdebug_config_file="/etc/php5/mods-available/xdebug.ini"
directory_config_file="/etc/apache2/mods-enabled/dir.conf"
mysql_config_file="/etc/mysql/my.cnf"
mysql_root_password="root"

########################
#        Apache        #
########################

# Install apache2
echo "Installing Apache"
apt-get install apache2 libapache2-mod-php5 -y > /dev/null 2>&1

# Config servername
echo "ServerName localhost" > /etc/apache2/conf-available/fqdn.conf
a2enconf fqdn > /dev/null 2>&1

# Enable mod_rewrite
a2enmod rewrite > /dev/null 2>&1

# Enable mod_ssl
a2enmod ssl > /dev/null 2>&1


########################
#         MySQL        #
########################

# Set password for root account
echo "mysql-server mysql-server/root_password password "${mysql_root_password} | debconf-set-selections > /dev/null 2>&1
echo "mysql-server mysql-server/root_password_again password "${mysql_root_password} | debconf-set-selections > /dev/null 2>&1

# Install mysql-server
apt-get install mysql-server php5-mysql -y > /dev/null 2>&1

# Create informations
mysql_install_db > /dev/null 2>&1

# Allow connections to this server from outside
sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" ${mysql_config_file}
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '$mysql_root_password';"
mysql -uroot -proot -e "FLUSH PRIVILEGES;"


########################
#         PHP5         #
########################

# Install php5
echo "Installing PHP5"
apt-get install php5 php5-common php5-dev php5-cli php5-fpm -y > /dev/null 2>&1 # libapache2-mod-php5 - this library is bundeled with php5 metapackage; php5-mcrypt is required for Laravel and PHPMyAdmin

# Install PHP extensions
apt-get install curl php5-curl php5-gd php5-mcrypt php5-mysql php5-xdebug -y > /dev/null 2>&1
apt-get install php5-memcached php5-memcache php5-json -y > /dev/null 2>&1

# Enable php5-mcrypt mode
php5enmod mcrypt > /dev/null 2>&1

# Turn on display errorÏ
sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" ${php_config_file} > /dev/null 2>&1
sed -i "s/display_errors = Off/display_errors = On/g" ${php_config_file} > /dev/null 2>&1
sed -i "s/error_reporting = E_ALL & ~E_DEPRECATED/error_reporting = E_ALL | E_STRICT/g" ${php_config_file} > /dev/null 2>&1
sed -i "s/html_errors = Off/html_errors = On/g" ${php_config_file} > /dev/null 2>&1

# Sort directory index
sed -i "s/index.php //g" ${directory_config_file} > /dev/null 2>&1
sed -i "s/DirectoryIndex/DirectoryIndex index.php/g" ${directory_config_file} > /dev/null 2>&1

cat << EOF > ${xdebug_config_file}
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_host=10.0.2.2
EOF

# Restart mysql service
service mysql restart > /dev/null 2>&1

# Restart apache2 to reload the configuration
service apache2 restart > /dev/null 2>&1