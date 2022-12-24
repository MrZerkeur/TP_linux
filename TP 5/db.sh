#!/bin/bash

#Pré-config & installation
echo "Starting setup..."
setenforce 0
echo "SELINUX set to permissive"
echo 'db.tp5.linux' | tee /etc/hostname & echo "Hostname changed to :"
dnf install mariadb-server -y > /dev/null
systemctl enable mariadb
systemctl start mariadb
echo "MariaDB installed"

#Configuration & sécurisation
mysql -e "UPDATE mysql.global_priv SET priv=json_set(priv, '$.plugin', 'mysql_native_password', '$.authentication_string', PASSWORD('$esc_pass')) WHERE User='root';"
mysql -e "DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "UPDATE mysql.global_priv SET priv=json_set(priv, '$.password_last_changed', UNIX_TIMESTAMP(), '$.plugin', 'mysql_native_password', '$.authentication_string', 'invalid', '$.auth_or', json_array(json_object(), json_object('plugin', 'unix_socket'))) WHERE User='root';"
mysql -e "DELETE FROM mysql.global_priv WHERE User='';"
mysql -e "DROP DATABASE IF EXISTS test"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
mysql -e "FLUSH PRIVILEGES;"
firewall-cmd --add-port=3306/tcp --permanent > /dev/null
firewall-cmd --reload > /dev/null
systemctl restart mariadb

#User & privilèges
mysql -e "CREATE USER 'nextcloud'@'10.105.1.11' IDENTIFIED BY 'azerty';"
mysql -e "CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.105.1.11';"
mysql -e "FLUSH PRIVILEGES;"
echo "Installation finished succesfully"
echo "You may need to restart your device so all the changes are effective, like the hostname"