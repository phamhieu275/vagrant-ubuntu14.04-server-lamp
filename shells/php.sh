#!/usr/bin/env bash

#######################
#         PHP         #
#######################

export LANG=C.UTF-8

PHP_TIMEZONE=${1:-UTC}

# Install php5
echo "Installing PHP $PHP_VERSION"
apt-get install php5 php5-common php5-dev php5-cli php5-fpm -y > /dev/null 2>&1

# Install PHP extensions
echo "Installing PHP extensions"
apt-get install php5-mysql php5-pgsql -y > /dev/null 2>&1
apt-get install curl php5-curl php5-gd php5-mcrypt php5-imagick php5-intl php5-xdebug -y > /dev/null 2>&1
apt-get install php5-memcached php5-memcache php5-json > /dev/null 2>&1

# Enable php5-mcrypt mode
php5enmod mcrypt > /dev/null 2>&1

# PHP Error Reporting Timezone Config
echo "Configuring PHP"
for ini in $(find /etc -name "php.ini")
do
    errRep=$(grep "^error_reporting = " "${ini}")
    sed -i "s/${errRep}/error_reporting = E_ALL | E_STRICT/g" ${ini} > /dev/null 2>&1

    dispErr=$(grep "^display_errors = " "${ini}")
    sed -i "s/${dispErr}/display_errors = On/g" ${ini} > /dev/null 2>&1

    dispStrtErr=$(grep "^display_startup_errors = " "${ini}")
    sed -i "s/${dispStrtErr}/display_startup_errors = On/g" ${ini} > /dev/null 2>&1

    dateTimezone=$(grep "^date.timezone = " "${ini}")
    sed -i "s/${dateTimezone}/date.timezone = ${PHP_TIMEZONE}/g" ${ini} > /dev/null 2>&1
done

# xdebug Config
echo "Configuring Xdebug"
cat > $(find /etc/php5 -name xdebug.ini) << EOF
    zend_extension=$(find /usr/lib/php5 -name xdebug.so)
    xdebug.remote_enable = 1
    xdebug.remote_connect_back = 1
    xdebug.remote_port = 9000
    xdebug.scream=0
    xdebug.cli_color=1
    xdebug.show_local_vars=1

    ; var_dump display
    xdebug.var_display_max_depth = 5
    xdebug.var_display_max_children = 256
    xdebug.var_display_max_data = 1024
EOF