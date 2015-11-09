#!/usr/bin/env bash

MYSQL_ROOT_PASS=${1:-root} # default = root
PHPMYADMIN_PASS=${2:-root} # default = root

echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/mysql/admin-user string root" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/mysql/admin-pass password "${MYSQL_ROOT_PASS} | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/mysql/app-pass password "${PHPMYADMIN_PASS} |debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/app-password-confirm password "${PHPMYADMIN_PASS} | debconf-set-selections > /dev/null 2>&1

echo "Installing PHPMyAdmin"
apt-get install phpmyadmin -y > /dev/null 2>&1

sh -c 'echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf'

service apache2 reload

