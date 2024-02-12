# TP3 : Linux Hardening

# 1. Guides CIS

## Time Synchronization

2.1.1
```
[axel@b2tp3linuxsecu ~]$ rpm -q chrony
chrony-4.3-1.el9.x86_64
```
```
[axel@b2tp3linuxsecu ~]$ date
Thu Jan 11 10:21:30 AM CET 2024
```

2.1.2
```
[axel@b2tp3linuxsecu ~]$ grep -E "^(server|pool)" /etc/chrony.conf
pool 2.rocky.pool.ntp.org iburst
```
```
[axel@b2tp3linuxsecu ~]$ grep ^OPTIONS /etc/sysconfig/chronyd
OPTIONS="-u chrony"
```

## Disable unused network protocols and devices

3.1.1
```
[axel@b2tp3linuxsecu ~]$ grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && echo -e "\n -
IPv6 is enabled\n" || echo -e "\n - IPv6 is not enabled\n"

 -
IPv6 is enabled
```

3.1.2
```
[axel@b2tp3linuxsecu ~]$ sudo ./test.sh 

- Audit Result:
 ** PASS **

 - System has no wireless NICs installed
```

3.1.3
```
[axel@b2tp3linuxsecu ~]$ sudo ./test_tipc.sh
Usage: grep [OPTION]... PATTERNS [FILE]...
Try 'grep --help' for more information.
./test_tipc.sh: line 7: \h*modprobe:\h+FATAL:\h+Module\h+tipc\h+not\h+found\h+in\h+directory: command not found
./test_tipc.sh: line 6: [: missing `]'
./test_tipc.sh: line 8: ]: command not found

- Audit Result:
 ** PASS **

 - Module "tipc" doesn't exist on the
system
```

##  Network Parameters (Host Only)

3.2.1
```
[axel@b2tp3linuxsecu ~]$ sudo ./test_forwarding.sh 
./test_forwarding.sh: line 5: separated: command not found
./test_forwarding.sh: line 8: [: missing `]'
./test_forwarding.sh: line 9: ]: command not found
Usage: grep [OPTION]... PATTERNS [FILE]...
Try 'grep --help' for more information.
./test_forwarding.sh: line 16: \h*=\h*0\b\h*: command not found
Usage: grep [OPTION]... PATTERNS [FILE]...
Try 'grep --help' for more information.
./test_forwarding.sh: line 16: \h*=\h*0\b\h*: command not found

- Audit Result:
 ** PASS **

 - "net.ipv4.ip_forward" is set to
"0" in the running configuration
 - "net.ipv4.ip_forward" is set to "0"
in "/etc/sysctl.d/60-netipv4_sysctl.conf"
 - "net.ipv4.ip_forward" is not set incorectly in
a kernel parameter configuration file
 - "net.ipv6.conf.all.forwarding" is set to
"0" in the running configuration
 - "net.ipv6.conf.all.forwarding" is set to "0"
in "/etc/sysctl.d/60-netipv6_sysctl.conf"
 - "net.ipv6.conf.all.forwarding" is not set incorectly in
a kernel parameter configuration file
```

3.2.2
```
[root@b2tp3linuxsecu hugoa]# printf "
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
" >> /etc/sysctl.d/60-netipv4_sysctl.conf

[root@b2tp3linuxsecu hugoa]# {
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.route.flush = 1
```

## Network Parameters (Host and Router)

3.3.1
```
[root@b2tp3linuxsecu ~]# printf "
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
" >> /etc/sysctl.d/60-netipv4_sysctl.conf

[root@b2tp3linuxsecu ~]# {
sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0
sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.route.flush = 1

[root@b2tp3linuxsecu ~]# printf "
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
" >> /etc/sysctl.d/60-netipv6_sysctl.conf

[root@b2tp3linuxsecu ~]# {
sysctl -w net.ipv6.conf.all.accept_source_route=0
sysctl -w net.ipv6.conf.default.accept_source_route=0
sysctl -w net.ipv6.route.flush=1
}
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
net.ipv6.route.flush = 1
```

3.3.2
```
[root@b2tp3linuxsecu ~]# printf "
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
" >> /etc/sysctl.d/60-netipv4_sysctl.conf

[root@b2tp3linuxsecu ~]# {
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.route.flush = 1

[root@b2tp3linuxsecu ~]# printf "
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
" >> /etc/sysctl.d/60-netipv6_sysctl.conf

[root@b2tp3linuxsecu ~]# {
sysctl -w net.ipv6.conf.all.accept_redirects=0
sysctl -w net.ipv6.conf.default.accept_redirects=0
sysctl -w net.ipv6.route.flush=1
}
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv6.route.flush = 1
```

3.3.3
```
[root@b2tp3linuxsecu ~]# printf "
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
" >> /etc/sysctl.d/60-netipv4_sysctl.conf

[root@b2tp3linuxsecu ~]# {
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.route.flush = 1
```

3.3.4
```
[root@b2tp3linuxsecu ~]# printf "
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
" >> /etc/sysctl.d/60-netipv4_sysctl.conf

[root@b2tp3linuxsecu ~]# {
sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1
sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
net.ipv4.route.flush = 1
```

3.3.5
```
[root@b2tp3linuxsecu ~]# printf "
net.ipv4.icmp_echo_ignore_broadcasts = 1
" >> /etc/sysctl.d/60-netipv4_sysctl.conf

[root@b2tp3linuxsecu ~]# {
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.route.flush=1
}
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.route.flush = 1
```

3.3.6
```
[root@b2tp3linuxsecu ~]# printf "
net.ipv4.icmp_ignore_bogus_error_responses = 1
" >> /etc/sysctl.d/60-netipv4_sysctl.conf

[root@b2tp3linuxsecu ~]# {
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -w net.ipv4.route.flush=1
}
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.route.flush = 1
```

3.3.7
```
[root@b2tp3linuxsecu ~]# printf "
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
" >> /etc/sysctl.d/60-netipv4_sysctl.conf

[root@b2tp3linuxsecu ~]# {
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1
sysctl -w net.ipv4.route.flush=1
}
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.route.flush = 1
```

3.3.8
```
[root@b2tp3linuxsecu ~]# printf "
net.ipv4.tcp_syncookies = 1
" >> /etc/sysctl.d/60-netipv4_sysctl.conf

[root@b2tp3linuxsecu ~]# {
sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w net.ipv4.route.flush=1
}
net.ipv4.tcp_syncookies = 1
net.ipv4.route.flush = 1
```

3.3.9
```
[root@b2tp3linuxsecu ~]# printf "
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
" >> /etc/sysctl.d/60-netipv6_sysctl.conf

[root@b2tp3linuxsecu ~]# {
sysctl -w net.ipv6.conf.all.accept_ra=0
sysctl -w net.ipv6.conf.default.accept_ra=0
sysctl -w net.ipv6.route.flush=1
}
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
net.ipv6.route.flush = 1
```


## Configure SSH Server

Configuration initiale :
```
[axel@b2tp3linuxsecu ~]$ sudo cat /etc/ssh/sshd_config
Include /etc/ssh/sshd_config.d/*.conf
AuthorizedKeysFile	.ssh/authorized_keys
Subsystem	sftp	/usr/libexec/openssh/sftp-server
```

5.2.1
```
[root@b2tp3linuxsecu ~]# stat -Lc "%n %a %u/%U %g/%G" /etc/ssh/sshd_config
/etc/ssh/sshd_config 600 0/root 0/root
```

5.2.2
```
[root@b2tp3linuxsecu ~]# ls -al /etc/ssh
total 616
drwxr-xr-x.  4 root root       4096 Jan 11 09:59 .
drwxr-xr-x. 78 root root       8192 Jan 12 09:20 ..
-rw-r--r--.  1 root root     578094 Nov  2 20:33 moduli
-rw-r--r--.  1 root root       1921 Nov  2 20:33 ssh_config
drwxr-xr-x.  2 root root         28 Jan 11 09:59 ssh_config.d
-rw-------.  1 root root       3667 Nov  2 20:33 sshd_config
drwx------.  2 root root         59 Jan 11 09:59 sshd_config.d
-rw-r-----.  1 root ssh_keys    480 Nov 26  2022 ssh_host_ecdsa_key
-rw-r--r--.  1 root root        162 Nov 26  2022 ssh_host_ecdsa_key.pub
-rw-r-----.  1 root ssh_keys    387 Nov 26  2022 ssh_host_ed25519_key
-rw-r--r--.  1 root root         82 Nov 26  2022 ssh_host_ed25519_key.pub
-rw-r-----.  1 root ssh_keys   2578 Nov 26  2022 ssh_host_rsa_key
-rw-r--r--.  1 root root        554 Nov 26  2022 ssh_host_rsa_key.pub
```
```
[root@b2tp3linuxsecu ~]# chmod 600 /etc/ssh/ssh_host_ecdsa_key
[root@b2tp3linuxsecu ~]# chmod 600 /etc/ssh/ssh_host_ed25519_key
[root@b2tp3linuxsecu ~]# chmod 600 /etc/ssh/ssh_host_rsa_key
```
```
[root@b2tp3linuxsecu ~]# ls -al /etc/ssh
total 616
drwxr-xr-x.  4 root root       4096 Jan 11 09:59 .
drwxr-xr-x. 78 root root       8192 Jan 12 09:20 ..
-rw-r--r--.  1 root root     578094 Nov  2 20:33 moduli
-rw-r--r--.  1 root root       1921 Nov  2 20:33 ssh_config
drwxr-xr-x.  2 root root         28 Jan 11 09:59 ssh_config.d
-rw-------.  1 root root       3667 Nov  2 20:33 sshd_config
drwx------.  2 root root         59 Jan 11 09:59 sshd_config.d
-rw-------.  1 root ssh_keys    480 Nov 26  2022 ssh_host_ecdsa_key
-rw-r--r--.  1 root root        162 Nov 26  2022 ssh_host_ecdsa_key.pub
-rw-------.  1 root ssh_keys    387 Nov 26  2022 ssh_host_ed25519_key
-rw-r--r--.  1 root root         82 Nov 26  2022 ssh_host_ed25519_key.pub
-rw-------.  1 root ssh_keys   2578 Nov 26  2022 ssh_host_rsa_key
-rw-r--r--.  1 root root        554 Nov 26  2022 ssh_host_rsa_key.pub
```

5.2.3
```
Le script est cassé mais tout est bon
```
```
[root@b2tp3linuxsecu ~]# ls -al /etc/ssh
total 616
drwxr-xr-x.  4 root root       4096 Jan 11 09:59 .
drwxr-xr-x. 78 root root       8192 Jan 12 09:20 ..
-rw-r--r--.  1 root root     578094 Nov  2 20:33 moduli
-rw-r--r--.  1 root root       1921 Nov  2 20:33 ssh_config
drwxr-xr-x.  2 root root         28 Jan 11 09:59 ssh_config.d
-rw-------.  1 root root       3667 Nov  2 20:33 sshd_config
drwx------.  2 root root         59 Jan 11 09:59 sshd_config.d
-rw-------.  1 root ssh_keys    480 Nov 26  2022 ssh_host_ecdsa_key
-rw-r--r--.  1 root root        162 Nov 26  2022 ssh_host_ecdsa_key.pub
-rw-------.  1 root ssh_keys    387 Nov 26  2022 ssh_host_ed25519_key
-rw-r--r--.  1 root root         82 Nov 26  2022 ssh_host_ed25519_key.pub
-rw-------.  1 root ssh_keys   2578 Nov 26  2022 ssh_host_rsa_key
-rw-r--r--.  1 root root        554 Nov 26  2022 ssh_host_rsa_key.pub
```

5.2.4
```
AllowUsers axel user
```

5.2.5
```
LogLevel VERBOSE
```

5.2.6
```
UsePAM yes
```

5.2.7
```
PermitRootLogin no
```

5.2.8
```
HostbasedAuthentication no
```

5.2.9
```
PermitEmptyPasswords no
```

5.2.10
```
PermitUserEnvironment no
```

5.2.11
```
IgnoreRhosts yes
```

5.2.12
```
X11Forwarding no
```

5.2.13
```
AllowTcpForwarding no
```

5.2.14
```
grep -i '^\s*CRYPTO_POLICY=' /etc/sysconfig/sshd
*no output*
```

5.2.15
```
Banner /etc/issue.net
```

5.2.16
```
MaxAuthTries 4
```

5.2.17
```
MaxStartups 10:30:60
```

5.2.18
```
MaxSessions 10
```

5.2.19
```
LoginGraceTime 60
```

5.2.20
```
ClientAliveInterval 15
ClientAliveCountMax 3
```

Configuration finale :
```
[axel@b2tp3linuxsecu ~]$ sudo cat /etc/ssh/sshd_config
Include /etc/ssh/sshd_config.d/*.conf
AllowUsers axel user
LogLevel VERBOSE
LoginGraceTime 60
PermitRootLogin no
MaxAuthTries 4 
MaxSessions 10
AuthorizedKeysFile	.ssh/authorized_keys
HostbasedAuthentication no
IgnoreRhosts yes
PermitEmptyPasswords no
UsePAM yes
PermitUserEnvironment no
ClientAliveInterval 15
ClientAliveCountMax 3
MaxStartups 10:30:60
Banner /etc/issue.net
Subsystem	sftp	/usr/libexec/openssh/sftp-server
X11Forwarding no
AllowTcpForwarding no
```

## System File Permissions

6.1.1
```
[axel@b2tp3linuxsecu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/passwd
/etc/passwd 644 0/root 0/root
```

6.1.2
```
[axel@b2tp3linuxsecu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/passwd-
/etc/passwd- 644 0/root 0/root
```

6.1.3
```
[axel@b2tp3linuxsecu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/group
/etc/group 644 0/root 0/root
```

6.1.4
```
[axel@b2tp3linuxsecu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/group-
/etc/group- 644 0/root 0/root
```

6.1.5
```
[axel@b2tp3linuxsecu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/shadow
/etc/shadow 0 0/root 0/root
```

6.1.6
```
[axel@b2tp3linuxsecu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/shadow-
/etc/shadow- 0 0/root 0/root
```

6.1.7
```
[axel@b2tp3linuxsecu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/gshadow
/etc/gshadow 0 0/root 0/root
```

6.1.8
```
[axel@b2tp3linuxsecu ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/gshadow-
/etc/gshadow- 0 0/root 0/root
```

6.1.9
```
[axel@b2tp3linuxsecu ~]$ df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002
```

6.1.10
```
[axel@b2tp3linuxsecu ~]$ df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser
```

## User Accounts and Environment

5.6.1.1
```
PASS_MAX_DAYS   365
```

5.6.1.2
```
PASS_MIN_DAYS   1
```

5.6.1.3
```
PASS_WARN_AGE   7
```

5.6.1.4
```
[axel@b2tp3linuxsecu ~]$ sudo useradd -D -f 30
```

5.6.1.5
```
[axel@b2tp3linuxsecu ~]$ sudo chage -l toto | head -n 1
Last password change					: Feb 04, 2024

Same for all users
```

5.6.2
```
[axel@b2tp3linuxsecu ~]$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:65534:65534:Kernel Overflow User:/:/sbin/nologin
systemd-coredump:x:999:997:systemd Core Dumper:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
tss:x:59:59:Account used for TPM access:/dev/null:/sbin/nologin
sssd:x:998:995:User for sssd:/:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/usr/share/empty.sshd:/sbin/nologin
chrony:x:997:994::/var/lib/chrony:/sbin/nologin
systemd-oom:x:992:992:systemd Userspace OOM Killer:/:/usr/sbin/nologin
tcpdump:x:72:72::/:/sbin/nologin
axel:x:1000:1000:baba:/home/hugoa:/bin/bash
```

5.6.3
```
[axel@b2tp3linuxsecu ~]$ sudo cat /etc/profile.d/tmout.sh 
TMOUT=900
readonly TMOUT
export TMOUT
```

5.6.4
```
[axel@b2tp3linuxsecu ~]$ grep "^root:" /etc/passwd | cut -f4 -d:
0
```

5.6.5
```
[axel@b2tp3linuxsecu ~]$ sudo cat /etc/profile.d/set_umask.sh
umask 037
```

5.6.6
```
[axel@b2tp3linuxsecu ~]$ sudo passwd -S root
root PS 2023-10-15 0 99999 7 -1 (Password set, SHA512 crypt.)
```

# 2. Conf SSH

🌞 **Chiffrement fort côté serveur**

Source : https://www.ssh.com/academy/ssh/sshd_config

[Fichier de conf ssh](./sshd_config)

```
sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' < /dev/null
sudo ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' < /dev/null
sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' < /dev/null
```

```
sudo ssh-keygen -G /etc/ssh/moduli.safe 4096
sudo ssh-keygen -T /etc/ssh/moduli.tmp -f /etc/ssh/moduli.safe
sudo mv /etc/ssh/moduli.tmp /etc/ssh/moduli
```

🌞 **Clés de chiffrement fortes pour le client**

Source : https://www.ssh.com/academy/ssh/keygen

```
ssh-keygen -t ed25519
```

🌞 **Connectez-vous en SSH à votre VM avec cette paire de clés**

Le résultat de la commande : ssh -i ~/.ssh/tp3secu axel@10.1.1.11 -vvvv est [ICI](./ssh_verbose)

# 4. DoT

```
sudo dnf install systemd-resolved
```
```
ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```
```
sudo systemctl start systemd-resolved
```
```
sudo systemctl enable systemd-resolved
```
```
[axel@b2tp3linuxsecu ~]$ sudo cat /etc/systemd/resolved.conf 
...
[Resolve]
DNS=1.1.1.1
Domains=~
DNSSEC=yes
DNSOverTLS=yes
...
```

🌞 **Prouvez que les requêtes DNS effectuées par la machine...**

```
[axel@b2tp3linuxsecu ~]$ dig ynov.com

; <<>> DiG 9.16.23-RH <<>> ynov.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 40262
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;ynov.com.			IN	A

;; ANSWER SECTION:
ynov.com.		300	IN	A	104.26.10.233
ynov.com.		300	IN	A	172.67.74.226
ynov.com.		300	IN	A	104.26.11.233

;; Query time: 95 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Sat Feb 10 22:28:04 CET 2024
;; MSG SIZE  rcvd: 85
```

[Et la petite capture wireshark](./DNS_over_TLS.pcapng)

# 5. AIDE

🌞 **Installer et configurer AIDE**

```
[axel@b2tp3linuxsecu ~]$ sudo dnf install aide
[axel@b2tp3linuxsecu ~]$ sudo aide --init
[axel@b2tp3linuxsecu ~]$ sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
```

```
[axel@b2tp3linuxsecu ~]$ sudo cat /etc/aide.conf | tail -n 11
# ssh
/etc/ssh/sshd_config$ CONTENT_EX
/etc/ssh/ssh_config$ CONTENT_EX

# chrony
/etc/chrony.conf$ CONTENT_EX
/etc/chrony.keys$ CONTENT_EX

# systemd-networkd
/etc/systemd/resolved.conf$ CONTENT_EX
/etc/resolv.conf$ CONTENT_EX
```

🌞 **Scénario de modification**

```
[root@b2tp3linuxsecu etc]# echo '#coucou' >> /etc/ssh/sshd_config

[root@b2tp3linuxsecu etc]# aide --check
Start timestamp: 2024-02-11 19:55:37 +0100 (AIDE 0.16)
AIDE found differences between database and filesystem!!

Summary:
  Total number of entries:	39089
  Added entries:		0
  Removed entries:		0
  Changed entries:		1

---------------------------------------------------
Changed entries:
---------------------------------------------------

f   ...    .C... : /etc/ssh/sshd_config

---------------------------------------------------
Detailed information about changes:
---------------------------------------------------

File: /etc/ssh/sshd_config
  SHA512   : Xfiu531lV84nXNKCTph0oyo7suFzJO5c | Q6R3tkSd/Ko7Sz1zQnBd1uYGOx0/F434
             C4xETokrgrn7CL5sjKR5P7JIhGZj82nZ | IxIJrYjU5vWA0PKsCjXKYRSr4U+Wdgs0
             u3LC59L0FaW0k6UKabJO6w==         | +VdOSErPYSjG/GVznkMgZg==


---------------------------------------------------
The attributes of the (uncompressed) database(s):
---------------------------------------------------

/var/lib/aide/aide.db.gz
  MD5      : +NI+M3JC8xG7oIlHy71LJA==
  SHA1     : hs3YGjLdfEhFtVhmTxhUzcZlL5U=
  RMD160   : 527w6U6fAyvcQpMFgvnh8/pBejg=
  TIGER    : 02Pv3NSMa+3so2QUXjQpKXKQU8rU9RMv
  SHA256   : 5XS+H2Hnq/Pmpe8hhhX/QceyDE2/W4A9
             nBX0nN7/0a4=
  SHA512   : t8E+Ni0JBITAXW0QVNDvDv/J57r5WwgO
             VqK7thC0BOlal7/VkQokt9TEF+kyB9ye
             TcGCU4URitlZ0Mb22HcTrQ==


End timestamp: 2024-02-11 19:55:48 +0100 (run time: 0m 11s)
```

🌞 **Timer et service systemd**

Le script check.sh :
```
#!/bin/sh

aide --check
```

aide.service :
```
[Unit]
Description=Run AIDE check    

[Service]
ExecStart=/home/axel/check.sh

[Install]
WantedBy=default.target
```

aide.timer :
```
[Unit]
Description=Run the AIDE check each 60s

[Timer]
OnUnitActiveSec=60s
Unit=aide.service

[Install]
WantedBy=timers.target
```