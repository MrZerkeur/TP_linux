```
[axel@b2tp3linuxsecu ~]$ rpm -q chrony
chrony-4.3-1.el9.x86_64
```
```
[axel@b2tp3linuxsecu ~]$ date
Thu Jan 11 10:21:30 AM CET 2024
```
```
[axel@b2tp3linuxsecu ~]$ grep -E "^(server|pool)" /etc/chrony.conf
pool 2.rocky.pool.ntp.org iburst
```
```
[axel@b2tp3linuxsecu ~]$ grep ^OPTIONS /etc/sysconfig/chronyd
OPTIONS="-u chrony"
```
```
[axel@b2tp3linuxsecu ~]$ grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && echo -e "\n -
IPv6 is enabled\n" || echo -e "\n - IPv6 is not enabled\n"

 -
IPv6 is enabled
```
```
[axel@b2tp3linuxsecu ~]$ cat test.sh
#!/usr/bin/env bash
{
l_output="" l_output2=""
module_chk()
{
# Check how module will be loaded
l_loadable="$(modprobe -n -v "$l_mname")"
if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
l_output="$l_output\n - module: \"$l_mname\" is not loadable:
\"$l_loadable\""
else
l_output2="$l_output2\n - module: \"$l_mname\" is loadable: \"$l_loadable\""
fi
# Check is the module currently loaded
if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
l_output="$l_output\n - module: \"$l_mname\" is not loaded"
else
l_output2="$l_output2\n - module: \"$l_mname\" is loaded"
fi
# Check if the module is deny listed
if modprobe --showconfig | grep -Pq -- "^\h*blacklist\h+$l_mname\b"; then
l_output="$l_output\n - module: \"$l_mname\" is deny listed in: \"$(grep -Pl
-- "^\h*blacklist\h+$l_mname\b" /etc/modprobe.d/*)\""
else
l_output2="$l_output2\n - module: \"$l_mname\" is not deny listed"
fi
}
if [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
l_dname=$(for driverdir in $(find /sys/class/net/*/ -type d -name wireless |
xargs -0 dirname); do basename "$(readlink -f "$driverdir"/device/driver/module)";done
| sort -u)
for l_mname in $l_dname; do
module_chk
done
fi
# Report results. If no failures output in l_output2, we pass
if [ -z "$l_output2" ]; then
echo -e "\n- Audit Result:\n ** PASS **"
if [ -z "$l_output" ]; then
echo -e "\n - System has no wireless NICs installed"
else
echo -e "\n$l_output\n"
fi
else
echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit
failure:\n$l_output2\n"
[ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
fi
}
```
```
[axel@b2tp3linuxsecu ~]$ sudo ./test.sh 

- Audit Result:
 ** PASS **

 - System has no wireless NICs installed
```
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
```
le script est pété
```
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
```
script pété
```
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
```
scripts pétés
```
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
3.3.3 :
```
script toujours pétés
```
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

3.3.4 :
```
script pété
```
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

3.3.5 :
```
script pété
```
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

3.3.6 :
```
script pété
```
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

3.3.7 :
```
script cassé
```
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

3.3.8 :
```
script cassé
```
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

3.3.9 :
```
script cassé
```
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

REFAIRE ??


5.2

```
[root@b2tp3linuxsecu ~]# cat /etc/ssh/sshd_config
#	$OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to no to disable s/key passwords
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in RHEL and may cause several
# problems.
#UsePAM no

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem	sftp	/usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server
```


5.2.1
```
[root@b2tp3linuxsecu ~]# stat -Lc "%n %a %u/%U %g/%G" /etc/ssh/sshd_config
/etc/ssh/sshd_config 600 0/root 0/root
```

5.2.2
```
script cassé
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
script cassés
```
```
[root@b2tp3linuxsecu ~]# cat /etc/ssh/sshd_config
#	$OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
AllowUsers axel user
.......
```

5.2.5
```
script cassés
```
```
[root@b2tp3linuxsecu ~]# cat /etc/ssh/sshd_config
#	$OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
AllowUsers axel user
#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
LogLevel VERBOSE
.......
```

5.2.6
```
script cassé
```
```
[root@b2tp3linuxsecu ~]# cat /etc/ssh/sshd_config
......
UsePAM yes
......
```

5.2.7
```
script cassé
```
```
......
PermitRootLogin no
......
```

5.2.8
```
script cassé
```
```
......
HostbasedAuthentication no
......
```

5.2.9
```
script cassé
```
```
......
PermitEmptyPasswords no
......
```

5.2.10
```
script cassé
```
```
......
PermitUserEnvironment no
......
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