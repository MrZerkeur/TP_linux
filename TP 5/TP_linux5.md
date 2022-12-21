# Partie 1 : Mise en place et maîtrise du serveur Web

## 1. Installation

🌞 **Installer le serveur Apache**

```
[axel@web ~]$ sudo dnf install httpd

[axel@web ~]$ sudo cat /etc/httpd/conf/httpd.conf 

ServerRoot "/etc/httpd"

Listen 80

Include conf.modules.d/*.conf

User apache
Group apache


ServerAdmin root@localhost


<Directory />
    AllowOverride none
    Require all denied
</Directory>


DocumentRoot "/var/www/html"

<Directory "/var/www">
    AllowOverride None
    Require all granted
</Directory>

<Directory "/var/www/html">
    Options Indexes FollowSymLinks

    AllowOverride None

    Require all granted
</Directory>

<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

<Files ".ht*">
    Require all denied
</Files>

ErrorLog "logs/error_log"

LogLevel warn

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

    <IfModule logio_module>
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>


    CustomLog "logs/access_log" combined
</IfModule>

<IfModule alias_module>


    ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"

</IfModule>

<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule mime_module>
    TypesConfig /etc/mime.types

    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz



    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>

AddDefaultCharset UTF-8

<IfModule mime_magic_module>
    MIMEMagicFile conf/magic
</IfModule>


EnableSendfile on

IncludeOptional conf.d/*.conf
```

🌞 **Démarrer le service Apache**

```
[axel@web ~]$ sudo systemctl start httpd
[axel@web ~]$ sudo systemctl enable httpd
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
```
```
[axel@web ~]$ sudo firewall-cmd --list-all | grep 80
  ports: 80/tcp
```

🌞 **TEST**

```
[axel@web ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
     Active: active (running) since Mon 2022-12-12 16:29:58 CET; 12min ago
```
```
[axel@web ~]$ sudo systemctl status httpd | grep enabled
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
```
```
[axel@web ~]$ curl localhost
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
      
      html {
        height: 100%;
        width: 100%;
      }  
        body {
  background: rgb(20,72,50);
etc ...  
```
```
[axel@fedora ~]$ curl 10.105.1.11
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
      
      html {
        height: 100%;
        width: 100%;
      }  
        body {
  background: rgb(20,72,50);
  background: -moz-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%)  ;
  background: -webkit-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%) ;
  background: linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%);
  background-repeat: no-repeat;
  background-attachment: fixed;
etc...
```

## 2. Avancer vers la maîtrise du service

🌞 **Le service Apache...**

```
[axel@web ~]$ cat /etc/httpd/conf/httpd.conf

ServerRoot "/etc/httpd"

Listen 80

Include conf.modules.d/*.conf

User apache
Group apache


ServerAdmin root@localhost


<Directory />
    AllowOverride none
    Require all denied
</Directory>


DocumentRoot "/var/www/html"

<Directory "/var/www">
    AllowOverride None
    Require all granted
</Directory>

<Directory "/var/www/html">
    Options Indexes FollowSymLinks

    AllowOverride None

    Require all granted
</Directory>

<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

<Files ".ht*">
    Require all denied
</Files>

ErrorLog "logs/error_log"

LogLevel warn

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

    <IfModule logio_module>
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>


    CustomLog "logs/access_log" combined
</IfModule>

<IfModule alias_module>


    ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"

</IfModule>

<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule mime_module>
    TypesConfig /etc/mime.types

    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz



    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>

AddDefaultCharset UTF-8

<IfModule mime_magic_module>
    MIMEMagicFile conf/magic
</IfModule>


EnableSendfile on

IncludeOptional conf.d/*.conf
```

🌞 **Déterminer sous quel utilisateur tourne le processus Apache**

```
[axel@web ~]$ cat /etc/httpd/conf/httpd.conf | grep User
User apache
```
```
[axel@web ~]$ ps -ef | grep apache
apache       893     892  0 16:29 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache       894     892  0 16:29 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache       895     892  0 16:29 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache       896     892  0 16:29 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
axel        1282     863  0 17:13 pts/0    00:00:00 grep --color=auto apache
```
```
[axel@web ~]$ ls -al /usr/share/testpage/
-rw-r--r--.  1 root root 7620 Jul 27 20:05 index.html
```

🌞 **Changer l'utilisateur utilisé par Apache**

```
[axel@web ~]$ sudo useradd apacheTP -d /usr/share/httpd/ -s /sbin/nologin -u 2001
```
```
[axel@web ~]$ cat /etc/httpd/conf/httpd.conf | grep apacheTP
User apacheTP
Group apacheTP
```
```
[axel@web ~]$ ps -ef | grep apacheTP
apacheTP    1483    1481  0 14:31 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apacheTP    1484    1481  0 14:31 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apacheTP    1485    1481  0 14:31 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apacheTP    1486    1481  0 14:31 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
axel        1711    1056  0 14:32 pts/0    00:00:00 grep --color=auto apacheTP
```

🌞 **Faites en sorte que Apache tourne sur un autre port**

```
[axel@web ~]$ cat /etc/httpd/conf/httpd.conf | grep Listen
Listen 8765
```
```
[axel@web ~]$ sudo firewall-cmd --list-all | grep ports
  ports: 8765/tcp
```
```
[axel@web ~]$ sudo ss -altnp | grep httpd
LISTEN 0      511                *:8765            *:*    users:(("httpd",pid=1825,fd=4),("httpd",pid=1824,fd=4),("httpd",pid=1823,fd=4),("httpd",pid=1820,fd=4))
```
```
[axel@fedora ~]$ curl 10.105.1.11:8765
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
      
      html {
        height: 100%;
        width: 100%;
      }  
        body {
etc...
```

📁 [/etc/httpd/conf/httpd.conf](./httpd.conf)

# Partie 2 : Mise en place et maîtrise du serveur de base de données

🌞 **Install de MariaDB sur `db.tp5.linux`**

```
[axel@db ~]$ sudo dnf install mariadb-server
```
```
[axel@db ~]$ sudo systemctl enable mariadb
```
```
[axel@db ~]$ sudo systemctl start mariadb
```
```
[axel@db ~]$ sudo mysql_secure_installation
```

🌞 **Port utilisé par MariaDB**

```
[axel@db ~]$ sudo ss -alpn | grep mariadb
u_str LISTEN 0      80                      /var/lib/mysql/mysql.sock 36498                  * 0     users:(("mariadbd",pid=12881,fd=20))                                                         
tcp   LISTEN 0      80                                              *:3306                   *:*     users:(("mariadbd",pid=12881,fd=19))
```
```
[axel@db ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
```

🌞 **Processus liés à MariaDB**

```
[axel@db ~]$ ps -ef | grep mariadb
mysql      12881       1  0 15:00 ?        00:00:00 /usr/libexec/mariadbd --basedir=/usr
axel       13124     840  0 15:21 pts/0    00:00:00 grep --color=auto mariadb
```

# Partie 3 : Configuration et mise en place de NextCloud

## 1. Base de données

🌞 **Préparation de la base pour NextCloud**

```
[axel@db ~]$ sudo mysql -u root -p
[sudo] password for axel: 
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 18
Server version: 10.5.16-MariaDB MariaDB Serve
```
```
MariaDB [(none)]> CREATE USER 'nextcloud'@'10.105.1.11' IDENTIFIED BY 'pewpewpew';
Query OK, 0 rows affected (0.009 sec)
```
```
MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.001 sec)
```
```
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.105.1.11';
Query OK, 0 rows affected (0.008 sec)
```
```
MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.000 sec)
```

🌞 **Exploration de la base de données**

```
[axel@web ~]$ sudo dnf install mysql
```
```
[axel@web ~]$ sudo mysql -u nextcloud -h 10.105.1.12 -p
```
```
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| nextcloud          |
+--------------------+
2 rows in set (0.00 sec)
```
```
mysql> USE nextcloud;
Database changed
```
```
mysql> SHOW TABLES;
Empty set (0.00 sec)
```

🌞 **Trouver une commande SQL qui permet de lister tous les utilisateurs de la base de données**

```
MariaDB [(none)]> use mysql;

MariaDB [mysql]> SELECT user FROM user;
+-------------+
| User        |
+-------------+
| nextcloud   |
| mariadb.sys |
| mysql       |
| root        |
+-------------+
4 rows in set (0.002 sec)
```

## 2. Serveur Web et NextCloud

🌞 **Install de PHP**

```
[axel@web ~]$ sudo dnf config-manager --set-enabled crb
```
```
[axel@web ~]$ sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y
```
```
[axel@web ~]$ dnf module list php
```
```
[axel@web ~]$ sudo dnf module enable php:remi-8.1 -y
```
```
[axel@web ~]$ sudo dnf install -y php81-php
```

🌞 **Install de tous les modules PHP nécessaires pour NextCloud**

```
[axel@web ~]$ sudo dnf install -y libxml2 openssl php81-php php81-php-ctype php81-php-curl php81-php-gd php81-php-iconv php81-php-json php81-php-libxml php81-php-mbstring php81-php-openssl php81-php-posix php81-php-session php81-php-xml php81-php-zip php81-php-zlib php81-php-pdo php81-php-mysqlnd php81-php-intl php81-php-bcmath php81-php-gmp
```

🌞 **Récupérer NextCloud**

```
[axel@web ~]$ sudo mkdir /var/www/tp5_nextcloud/
```
```
[axel@web ~]$ curl https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip -O
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  168M  100  168M    0     0  8168k      0  0:00:21  0:00:21 --:--:-- 8037k
```
```
[axel@web ~]$ unzip nextcloud-25.0.0rc3.zip
```
```
[axel@web ~]$ sudo mv -v /var/www/tp5_nextcloud/nextcloud/.* /var/www/tp5_nextcloud/
```
```
[axel@web tp5_nextcloud]$ sudo chown -R apache:apache .
```
```
[axel@web tp5_nextcloud]$ ls -al
total 140
drwxr-xr-x. 14 apache apache  4096 Dec 13 17:19 .
drwxr-xr-x.  5 root   root      54 Dec 13 16:47 ..
drwxr-xr-x. 47 apache apache  4096 Oct  6 14:47 3rdparty
drwxr-xr-x. 50 apache apache  4096 Oct  6 14:44 apps
-rw-r--r--.  1 apache apache 19327 Oct  6 14:42 AUTHORS
drwxr-xr-x.  2 apache apache    67 Oct  6 14:47 config
-rw-r--r--.  1 apache apache  4095 Oct  6 14:42 console.php
-rw-r--r--.  1 apache apache 34520 Oct  6 14:42 COPYING
drwxr-xr-x. 23 apache apache  4096 Oct  6 14:47 core
-rw-r--r--.  1 apache apache  6317 Oct  6 14:42 cron.php
drwxr-xr-x.  2 apache apache  8192 Oct  6 14:42 dist
-rw-r--r--.  1 apache apache  3253 Oct  6 14:42 .htaccess
-rw-r--r--.  1 apache apache   156 Oct  6 14:42 index.html
-rw-r--r--.  1 apache apache  3456 Oct  6 14:42 index.php
drwxr-xr-x.  6 apache apache   125 Oct  6 14:42 lib
-rw-r--r--.  1 apache apache   283 Oct  6 14:42 occ
drwxr-xr-x.  2 apache apache    23 Oct  6 14:42 ocm-provider
drwxr-xr-x.  2 apache apache    55 Oct  6 14:42 ocs
drwxr-xr-x.  2 apache apache    23 Oct  6 14:42 ocs-provider
-rw-r--r--.  1 apache apache  3139 Oct  6 14:42 public.php
-rw-r--r--.  1 apache apache  5426 Oct  6 14:42 remote.php
drwxr-xr-x.  4 apache apache   133 Oct  6 14:42 resources
-rw-r--r--.  1 apache apache    26 Oct  6 14:42 robots.txt
-rw-r--r--.  1 apache apache  2452 Oct  6 14:42 status.php
drwxr-xr-x.  3 apache apache    35 Oct  6 14:42 themes
drwxr-xr-x.  2 apache apache    43 Oct  6 14:44 updater
-rw-r--r--.  1 apache apache   101 Oct  6 14:42 .user.ini
-rw-r--r--.  1 apache apache   387 Oct  6 14:47 version.php
```

🌞 **Adapter la configuration d'Apache**

```
[axel@web ~]$ sudo cat /etc/httpd/conf.d/TP5nextcloud.conf
<VirtualHost *:80>
  # on indique le chemin de notre webroot
  DocumentRoot /var/www/tp5_nextcloud/
  # on précise le nom que saisissent les clients pour accéder au service
  ServerName  web.tp5.linux

  # on définit des règles d'accès sur notre webroot
  <Directory /var/www/tp5_nextcloud/> 
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```

🌞 **Redémarrer le service Apache** pour qu'il prenne en compte le nouveau fichier de conf

```
[axel@web ~]$ sudo systemctl restart httpd
```

## 3. Finaliser l'installation de NextCloud

🌞 **Exploration de la base de données**

```
[axel@web ~]$ mysql -u nextcloud -h 10.105.1.12 -p
```
```
mysql> SELECT COUNT(*) AS nb_tables FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
+-----------+
| nb_tables |
+-----------+
|        95 |
+-----------+
1 row in set (0.01 sec)
```

