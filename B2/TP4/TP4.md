# TP4 : Hardening Script

## Sommaire

- [TP4 : Hardening Script](#tp4--hardening-script)
- [I. Setup initial](#i-setup-initial)
- [II. Hardening script](#ii-hardening-script)

# I. Setup initial

| Machine      | IP          | Rôle                       |
| ------------ | ----------- | -------------------------- |
| `rp.tp5.b2`  | `10.5.1.11` | reverse proxy (NGINX)      |
| `web.tp5.b2` | `10.5.1.12` | serveur Web (NGINX oci) |

```
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout server.key -out server.crt
```

```
[axel@web1tp5b2 ~]$ sudo cat /etc/nginx/conf.d/app_nulle.conf
server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root /var/www/app_nulle;
        location / {
            index index.html;
	    allow 10.5.1.11;
	    deny all;
        }
 }
```

```
[axel@rp1tp4b2 ~]$ sudo cat /etc/nginx/conf.d/proxy.conf
server {
    listen    80;
    server_name   app.tp5.b2;

    location / {
        proxy_pass http://10.5.1.12;
    }
}

server {
    listen    443 ssl;
    server_name   app.tp5.b2;

    ssl_certificate     /etc/pki/tls/certs/server.crt;
    ssl_certificate_key /etc/pki/tls/private/server.key;


    location / {
        proxy_pass http://10.5.1.12;
    }
} 
```

```
[axel@rp1tp4b2 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 80/tcp 443/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 

[axel@web1tp5b2 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 80/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules:
```

```
axel@debian:~$ curl http://10.5.1.11
ce site est vraiment claqué
axel@debian:~$ curl http://10.5.1.12
<html>
<head><title>403 Forbidden</title></head>
<body>
<center><h1>403 Forbidden</h1></center>
<hr><center>nginx/1.20.1</center>
</body>
</html>
axel@debian:~$ curl https://app.tp5.b2
curl: (60) SSL certificate problem: self-signed certificate
More details here: https://curl.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
axel@debian:~$ curl -k https://app.tp5.b2
ce site est vraiment claqué
```

A NOTER : Une configure plus sécurisée peut être trouvé [ici pour le proxy](./proxy.conf.secure) et [ici pour le serveur web](./nginx.conf.secure). C'est notamment ces 2 conf là qui ont été utilisées pour la partie scripting.

# II. Hardening script

Le script principale peut être trouvé [ici](./main.sh), il suffit de suivre le [README](./README.md) (promis c'est pas long)


# Note personnel

Salut Léo ! Si c'est possible de voudrais avoir ton retour par MP discord ou en personne (si on se croise) par rapport à mon script, je me suis appliqué à le faire, j'ai bien gagné en niveau selon moi et finalement le scripting bash c'est pas si mal x)

Je voudrais aussi te remercier pour ces 2 années de cours, c'était vraiment sympa, toujours un plaisir de venir en cours et j'ai vraiment appris beaucoup de choses.
J'aimerais avoir plus de profs comme toi.

Au plaisir de se revoir x)

![Goodbye](./giphy.gif)