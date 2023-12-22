# Module 1 : Reverse Proxy

🌞 **On utilisera NGINX comme reverse proxy**

```
[axel@proxy ~]$ sudo dnf install nginx
```
```
[axel@proxy ~]$ sudo systemctl start nginx

[axel@proxy ~]$ sudo systemctl enable nginx
```

```
[axel@proxy ~]$ sudo ss -altnp | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=1048,fd=6),("nginx",pid=1047,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=1048,fd=7),("nginx",pid=1047,fd=7))
```
```
[axel@proxy ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success

[axel@proxy ~]$ sudo firewall-cmd --reload
success
```
```
[axel@proxy ~]$ ps -ef | grep nginx
root        1047       1  0 16:23 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       1048    1047  0 16:23 ?        00:00:00 nginx: worker process
```

🌞 **Configurer NGINX**

```
[axel@proxy /]$ cat /etc/nginx/conf.d/tp6.conf | head -n 10
server {
    # On indique le nom que client va saisir pour accéder au service
    # Pas d'erreur ici, c'est bien le nom de web, et pas de proxy qu'on veut ici !
    server_name web.tp6.linux;

    # Port d'écoute de NGINX
    listen 80;

    location / {
        # On définit des headers HTTP pour que le proxying se passe bien
```
```
[axel@web /]$ sudo cat /var/www/tp5_nextcloud/config/config.php | head -n 9
<?php
$CONFIG = array (
  'instanceid' => 'ocbhtk15rdmw',
  'passwordsalt' => 'tJPBIxZvAbZ3YNMhXuIPWbpGIhvHpM',
  'secret' => 'Azpt3RgAWqvEL2+Q7AwHoHhNldyAhdJ/mpErqNEDMzALKBru',
  'trusted_domains' =>
  array (
    0 => 'web.tp5.linux',
    1 => 'web.tp6.linux',
```

➜ **Modifier votre fichier `hosts` de VOTRE PC**

```
[axel@fedora ~]$ sudo cat /etc/hosts | grep tp6
10.105.1.13 web.tp6.linux
```

🌞 **Faites en sorte de**

```
[axel@web /]$ sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="10.105.1.13/32" invert="True" drop' --permanent
success
```

🌞 **Une fois que c'est en place**

```
[axel@fedora ~]$ ping 10.105.1.13
PING 10.105.1.13 (10.105.1.13) 56(84) bytes of data.
64 bytes from 10.105.1.13: icmp_seq=1 ttl=64 time=0.570 ms
```
```
[axel@fedora ~]$ ping 10.105.1.11
PING 10.105.1.11 (10.105.1.11) 56(84) bytes of data.
^C
--- 10.105.1.11 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2066ms
```

# II. HTTPS

🌞 **Faire en sorte que NGINX force la connexion en HTTPS plutôt qu'HTTP**

```
[axel@proxy ~]$ openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout server.key -out server.crt
```
```
[axel@proxy ~]$ ls
server.crt  server.key
```
```
[axel@proxy ~]$ sudo cat /etc/nginx/conf.d/reverse_proxy.conf | grep ssl
listen 443 ssl;
ssl_certificate /home/axel/server.crt;
ssl_certificate_key /home/axel/server.key;
```
```
[axel@proxy ~]$ sudo cat /etc/nginx/conf.d/reverse_proxy.conf | grep 443
listen 443 ssl;
```

# Module 3 : Fail2Ban

🌞 **Faites en sorte que :**

```
[axel@db ~]$ sudo cat /etc/fail2ban/jail.local | grep 'maxretry\|findtime'
maxretry = 3
findtime  = 1m
```
```
[axel@web ~]$ ssh axel@10.105.1.12
ssh: connect to host 10.105.1.12 port 22: Connection refused
```
```
[axel@db ~]$ sudo fail2ban-client banned
[{'sshd': ['10.105.1.11']}]
```
```
[axel@db ~]$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     7
|  `- Journal matches:  _SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned: 1
   |- Total banned:     2
   `- Banned IP list:   10.105.1.11
```
```
[axel@db ~]$ sudo fail2ban-client set sshd unbanip 10.105.1.11
1
```

# Module 4 : Monitoring

🌞 **Installer Netdata**

```
[axel@web ~]$ sudo systemctl status netdata
● netdata.service - Real time performance monitoring
     Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; vendor preset: disabled)
     Active: active (running) since Mon 2023-01-25 21:18:27 CET; 13min ago
```
```
[axel@db ~]$ sudo systemctl status netdata
● netdata.service - Real time performance monitoring
     Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; vendor preset: disabled)
     Active: active (running) since Mon 2023-01-25 21:20:40 CET; 13min ago
```
```
[axel@web ~]$ sudo ss -alnpt | grep netdata
LISTEN 0      4096         0.0.0.0:19999      0.0.0.0:*    users:(("netdata",pid=26476,fd=6)) 
```

🌞 **Une fois Netdata installé et fonctionnel, déterminer :**

```
[axel@web ~]$ ps -aux | grep netdata.p
netdata    13303  2.5  4.7 354992 46332 ?        Ssl  21:32   0:00 /usr/sbin/netdata -P /run/netdata/netdata.pid -D
netdata    13448  0.0  0.3   4504  3424 ?        S    21:32   0:00 /usr/bin/bash /usr/libexec/netdata/plugins.d/tc-qos-helper.sh 1
netdata    13466  1.4  0.5 133452  5580 ?        Sl   21:32   0:00 /usr/libexec/netdata/plugins.d/apps.plugin 1
netdata    13469  5.6  2.6  30468 25952 ?        S    21:32   0:00 /usr/bin/python3 /usr/libexec/netdata/plugins.d/python.d.plugin 1
axel       13637  0.0  0.1   6272  1072 pts/0    R+   21:32   0:00 grep --color=auto netdata.p

```
```
[axel@web ~]$ sudo cat /etc/netdata/netdata.conf | grep ' port '
	# default port = 19999
	# default port = 8125
```
```
[axel@web ~]$ sudo cat /var/log/netdata/access.log
```

🌞 **Configurer Netdata pour qu'il vous envoie des alertes** 

```
[hugoa@webtp6linux ~]$ sudo cat /etc/netdata/health_alarm_notify.conf | head -6
###############################################################################
# sending discord notifications

# note: multiple recipients can be given like this:
#                  "CHANNEL1 CHANNEL2 ..."

# enable/disable sending discord notifications
SEND_DISCORD="YES"
```


