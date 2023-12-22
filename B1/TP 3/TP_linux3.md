# TP 3 : We do a little scripting

# I. Script carte d'identité

📁 **Le script**  [/srv/idcard/idcard.sh](./scripts/idcard.sh)

Exemple de d'éxécution du code :
```
[axel@desktop-r379g2a idcard]$ sudo ./idcard.sh 
Machine name : desktop-r379g2a.home
OS Fedora Linux and kernel version is 6.0.10-200.fc36.x86_64
IP : 192.168.57.255
RAM : 2.4Gi memory available on 15Gi total memory
Disk : 33G space left
Top 5 processes by RAM usage :
This programme : /usr/lib64/firefox/firefox is using 5.1% of the RAM
This programme : /usr/libexec/packagekitd is using 3.1% of the RAM
This programme : /usr/lib64/firefox/firefox is using 3.0% of the RAM
This programme : /usr/bin/plasma-discover is using 2.8% of the RAM
This programme : /usr/lib64/firefox/firefox is using 2.4% of the RAM
Listening ports :
 - 53 udp : systemd-resolve
 - 53 udp : systemd-resolve
 - 323 udp : chronyd
 - 44120 udp : avahi-daemon
 - 5353 udp : avahi-daemon
 - 5355 udp : systemd-resolve
 - 6463 tcp : Discord
 - 53 tcp : systemd-resolve
 - 5355 tcp : systemd-resolve
 - 631 tcp : cupsd
 - 53 tcp : systemd-resolve
 
Here is your random cat : ./chat.jpeg
```

# II. Script youtube-dl

Exemple de l'éxécution du code :
```
[axel@desktop-r379g2a yt]$ sudo ./yt.sh https://www.youtube.com/watch?v=Wch3gJG2GJ4
Video https://www.youtube.com/watch?v=Wch3gJG2GJ4 was downloaded.
File path : /srv/yt/downloads/1 Second Video/1 Second Video.webm
```


📁 **Le script** [/srv/yt/yt.sh](./scripts/yt.sh)

📁 **Le fichier de log** [/var/log/yt/download.log](./log/download.log)

# III. MAKE IT A SERVICE

PROGRAMME FINI RESTE QUE A METTRE EN SERVICE

## Rendu

📁 **Le script** [/srv/yt/yt-v2.sh](./scripts/yt-v2.sh)

📁 **Fichier** [/etc/systemd/system/yt.service](./service/yt.service)

🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :

```
[axel@fedora video 2s]$ systemctl status yt
● yt.service - Entrez les url des vidéos que vous voulez télécharger dans le fichier /srv/yt/url_list.txt et le pro>
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: disabled)
     Active: active (running) since Mon 2022-12-05 15:09:52 CET; 2s ago
```

```
[axel@fedora video 2s]$ journalctl -xe -u yt
Dec 05 14:41:15 fedora systemd[1]: yt.service: Consumed 6.189s CPU time.
░░ Subject: Resources consumed by unit runtime
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ The unit yt.service completed and consumed the indicated resources.
Dec 05 14:44:32 fedora systemd[1]: Started yt.service - Entrez les url des vidéos que vous voulez télécharger dans >
░░ Subject: A start job for unit yt.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ A start job for unit yt.service has finished successfully.
░░ 
░░ The job identifier is 8198.
Dec 05 14:48:39 fedora systemd[1]: Stopping yt.service - Entrez les url des vidéos que vous voulez télécharger dans>
░░ Subject: A stop job for unit yt.service has begun execution
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ A stop job for unit yt.service has begun execution.
░░ 
░░ The job identifier is 8560.
Dec 05 14:48:39 fedora systemd[1]: yt.service: Deactivated successfully.
░░ Subject: Unit succeeded
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ The unit yt.service has successfully entered the 'dead' state.
```