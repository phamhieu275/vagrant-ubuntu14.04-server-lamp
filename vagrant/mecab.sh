#!/bin/bash
apt-get install mecab mecab-ipadic-utf8 libmecab-dev -y
pear channel-discover pecl.opendogs.org
pear remote-list -c opendogs
printf "no\n" | pecl install opendogs/mecab-beta
echo "extension=mecab.so" | sudo tee /etc/php5/mods-available/mecab.ini
hp5enmod mecab
service apache2 restart