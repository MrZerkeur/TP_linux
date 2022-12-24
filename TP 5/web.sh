#!/bin/bash

#Vérification
if [[ ! -f /tmp/apache_config ]]; then
  echo "The configuration file is missing, please copy it from my github and paste it as /srv/apache_config or create your own and paste it in the same place. Once it's done, launch the script again"
  exit 0
fi

#Pré-config & installation
echo "Starting setup..."
setenforce 0
echo "SELINUX set to permissive"
echo 'web.tp5.linux' | tee /etc/hostname & echo "Hostname changed to :"
dnf install httpd -y > /dev/null
systemctl enable httpd
systemctl start httpd
firewall-cmd --add-port=80/tcp --permanent > /dev/null
firewall-cmd --reload > /dev/null
dnf config-manager --set-enabled crb -y > /dev/null
dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y > /dev/null
dnf module list php -y > /dev/null
dnf module enable php:remi-8.1 -y > /dev/null
dnf install -y php81-php > /dev/null
dnf install -y libxml2 openssl php81-php php81-php-ctype php81-php-curl php81-php-gd php81-php-iconv php81-php-json php81-php-libxml php81-php-mbstring php81-php-openssl php81-php-posix php81-php-session php81-php-xml php81-php-zip php81-php-zlib php81-php-pdo php81-php-mysqlnd php81-php-intl php81-php-bcmath php81-php-gmp > /dev/null
echo "Everything installed succesfully"
echo "Configuration..."

#Configuration
mkdir /var/www/tp5_nextcloud/
curl https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip -O > /dev/null
dnf install unzip -y > /dev/null
unzip nextcloud-25.0.0rc3.zip > /dev/null
mv nextcloud/.* /var/www/tp5_nextcloud/
mv nextcloud/* /var/www/tp5_nextcloud/
rm -r nextcloud
cd /var/www/tp5_nextcloud/
chown -R apache:apache .
cp /tmp/apache_config /etc/httpd/conf.d/tp5_nextcloud.conf
rm /tmp/apache_config
cd
systemctl restart httpd
echo "Installation finished succesfully"
echo "You may need to restart your device so all the changes are effective, like the hostname"