# TP2 : Appréhender l'environnement Linux

# I. Service SSH

## 1. Analyse du service

🌞 **S'assurer que le service `sshd` est démarré**

```
[axel@LinuxTP2 ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2022-11-28 12:21:03 CET; 3min 3s ago
```

🌞 **Analyser les processus liés au service SSH**

```
[axel@LinuxTP2 ~]$ ps -ef | grep sshd
root         692       1  0 12:21 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         823     692  0 12:21 ?        00:00:00 sshd: axel [priv]
axel         838     823  0 12:21 ?        00:00:00 sshd: axel@pts/0
axel         878     839  0 12:26 pts/0    00:00:00 grep --color=auto sshd
```

🌞 **Déterminer le port sur lequel écoute le service SSH**

```
[axel@LinuxTP2 ~]$ ss | grep ssh
tcp   ESTAB  0      0                    192.168.57.12:ssh       192.168.57.1:43588
```

🌞 **Consulter les logs du service SSH**

```
[axel@LinuxTP2 ~]$ sudo cat /var/log/secure | tail -n 10
[sudo] password for axel: 
Nov 24 17:17:41 LinuxTP2 login[701]: pam_unix(login:auth): authentication failure; logname= uid=0 euid=0 tty=/dev/tty1 ruser= rhost=  user=axel
Nov 24 17:17:44 LinuxTP2 login[701]: FAILED LOGIN 1 FROM tty1 FOR axel, Authentication failure
Nov 24 17:17:49 LinuxTP2 systemd[840]: pam_unix(systemd-user:session): session opened for user axel(uid=1000) by (uid=0)
Nov 24 17:17:49 LinuxTP2 login[701]: pam_unix(login:session): session opened for user axel(uid=1000) by (uid=0)
Nov 24 17:17:49 LinuxTP2 login[701]: LOGIN ON tty1 BY axel
Nov 28 12:21:03 LinuxTP2 sshd[692]: Server listening on 0.0.0.0 port 22.
Nov 28 12:21:03 LinuxTP2 sshd[692]: Server listening on :: port 22.
Nov 28 12:21:15 LinuxTP2 sshd[823]: Accepted password for axel from 192.168.57.1 port 43588 ssh2
Nov 28 12:21:15 LinuxTP2 systemd[829]: pam_unix(systemd-user:session): session opened for user axel(uid=1000) by (uid=0)
Nov 28 12:21:15 LinuxTP2 sshd[823]: pam_unix(sshd:session): session opened for user axel(uid=1000) by (uid=0)
```

## 2. Modification du service


🌞 **Identifier le fichier de configuration du serveur SSH**

```
/etc/ssh/sshd_config
```

🌞 **Modifier le fichier de conf**

```
[axel@LinuxTP2 ssh]$ echo $RANDOM
15380

[axel@LinuxTP2 ssh]$ sudo cat sshd_config | grep Port
Port 15380
#GatewayPorts no

[axel@LinuxTP2 /]$ sudo firewall-cmd --remove-port=22/tcp --permanent
success

[axel@LinuxTP2 /]$ sudo firewall-cmd --add-port=15380/tcp --permanent
success

[axel@LinuxTP2 /]$ sudo firewall-cmd --list-all | grep port
  ports: 15380/tcp
  forward-ports: 
  source-ports
```

🌞 **Redémarrer le service**

```
[axel@LinuxTP2 /]$ sudo systemctl restart sshd
```
🌞 **Effectuer une connexion SSH sur le nouveau port**

```
[axel@desktop-r379g2a ~]$ ssh -p 15380 axel@LinuxTP2
axel@linuxtp2's password: 
Last login: Mon Nov 28 12:21:15 2022 from 192.168.57.1
[axel@LinuxTP2 ~]$ 
```

# II. Service HTTP

## 1. Mise en place


🌞 **Installer le serveur NGINX**

```
[axel@LinuxTP2 ~]$ sudo dnf install nginx
```

🌞 **Démarrer le service NGINX**

```
[axel@LinuxTP2 ~]$ sudo systemctl enable nginx

[axel@LinuxTP2 ~]$ sudo systemctl start nginx

[axel@LinuxTP2 ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
     Active: active (running) since Mon 2022-11-28 22:08:13 CET; 10s ago
```

🌞 **Déterminer sur quel port tourne NGINX**

```
[axel@LinuxTP2 ~]$ sudo cat /etc/nginx/nginx.conf | grep listen
        listen       80;
        listen       [::]:80;

[axel@LinuxTP2 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
[sudo] password for axel: 
success
```

🌞 **Déterminer les processus liés à l'exécution de NGINX**

```
[axel@LinuxTP2 ~]$ ps -ef | grep nginx
root         818       1  0 21:41 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx        821     818  0 21:41 ?        00:00:00 nginx: worker process
axel         866     841  0 21:42 pts/0    00:00:00 grep --color=auto nginx
```

🌞 **Euh wait**

```
[axel@LinuxTP2 ~]$ curl 192.168.57.12:80 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0   826k      0 --:--:-- --:--:-- --:--:--  930k
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
```

## 2. Analyser la conf de NGINX

🌞 **Déterminer le path du fichier de configuration de NGINX**

```
[axel@LinuxTP2 ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Oct 31 16:37 /etc/nginx/nginx.conf
```

🌞 **Trouver dans le fichier de conf**

```
[axel@LinuxTP2 ~]$ cat /etc/nginx/nginx.conf | grep "server {" -A 16
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
--
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
```
```
[axel@LinuxTP2 ~]$ cat /etc/nginx/nginx.conf | grep conf.d
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    include /etc/nginx/conf.d/*.conf;
```

## 3. Déployer un nouveau site web

🌞 **Créer un site web**

```
[axel@LinuxTP2 /]$ cat /var/www/tp2_linux/index.html 
<h1>MEOW mon premier serveur web</h1>
```

🌞 **Adapter la conf NGINX**

```
[axel@LinuxTP2 /]$ cat /etc/nginx/nginx.conf | grep "server {" -A 16
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
```
```
[axel@LinuxTP2 conf.d]$ echo $RANDOM
4742

[axel@LinuxTP2 conf.d]$ cat site.conf 
server {
  # le port choisi devra être obtenu avec un 'echo $RANDOM' là encore
  listen 4742;

  root /var/www/tp2_linux;
}

[axel@LinuxTP2 conf.d]$ sudo firewall-cmd --add-port=4742/tcp --permanent
success
```


🌞 **Visitez votre super site web**

```
[axel@LinuxTP2 conf.d]$ curl 192.168.57.12:4742
<h1>MEOW mon premier serveur web</h1>
```

# III. Your own services

## 1. Au cas où vous auriez oublié

## 2. Analyse des services existants

🌞 **Afficher le fichier de service SSH**

```
[axel@LinuxTP2 ~]$ cat /usr/lib/systemd/system/sshd.service | grep ExecStart=
ExecStart=/usr/sbin/sshd -D $OPTIONS
```

🌞 **Afficher le fichier de service NGINX**

```
axel@LinuxTP2 ~]$ cat /usr/lib/systemd/system/nginx.service | grep ExecStart=
ExecStart=/usr/sbin/nginx
```

## 3. Création de service

🌞 **Créez le fichier `/etc/systemd/system/tp2_nc.service`**

```
[axel@LinuxTP2 /]$ echo $RANDOM
8016

[axel@LinuxTP2 /]$ cat /etc/systemd/system/tp2_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 8016
```

🌞 **Indiquer au système qu'on a modifié les fichiers de service**

```
[axel@LinuxTP2 /]$ sudo systemctl daemon-reload
```

🌞 **Démarrer notre service de ouf**

```
[axel@LinuxTP2 /]$ sudo systemctl start tp2_nc
```

🌞 **Vérifier que ça fonctionne**

```
[axel@LinuxTP2 /]$ sudo systemctl status tp2_nc
● tp2_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp2_nc.service; static)
     Active: active (running) since Sat 2022-12-03 16:55:49 CET; 3min 0s ago
   Main PID: 967 (nc)
      Tasks: 1 (limit: 5905)
     Memory: 1.1M
        CPU: 2ms
     CGroup: /system.slice/tp2_nc.service
             └─967 /usr/bin/nc -l 8016
```
```
tcp   LISTEN 0      10                                        0.0.0.0:8016                    0.0.0.0:*     ino:20452 sk:47 cgroup:/system.slice/tp2_nc.service <->                 
tcp   LISTEN 0      10                                           [::]:8016                       [::]:*     ino:20451 sk:4a cgroup:/system.slice/tp2_nc.service v6only:1 <->
```

🌞 **Les logs de votre service**

```
[axel@LinuxTP2 ~]$ sudo journalctl -xe -u tp2_nc | grep Started
Dec 03 17:20:55 LinuxTP2 systemd[1]: Started Super netcat tout fou.

[axel@LinuxTP2 ~]$ sudo journalctl -xe -u tp2_nc | grep -F "nc["
Dec 03 17:21:05 LinuxTP2 nc[1147]: Ceci est un test
Dec 03 17:21:16 LinuxTP2 nc[1147]: Visiblement réalisé avec succès

[axel@LinuxTP2 ~]$ sudo journalctl -xe -u tp2_nc | grep -F "systemd[" | tail -n 1
Dec 03 17:21:20 LinuxTP2 systemd[1]: tp2_nc.service: Deactivated successfully.
```

🌞 **Affiner la définition du service**

```
[axel@LinuxTP2 ~]$ sudo cat /etc/systemd/system/tp2_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 8016
Restart=always
[axel@LinuxTP2 ~]$ sudo systemctl daemon-reload
[axel@LinuxTP2 ~]$ sudo systemctl start tp2_nc
```
