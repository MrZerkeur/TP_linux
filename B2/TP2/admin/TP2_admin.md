# TP2 admins : PHP stack

# I. Good practices

🌞 **Limiter l'accès aux ressources**

```
docker run --memory="1g" --cpus="1" hello-world
```

🌞 **No `root`**

```
docker run --memory="1g" --cpus="1" --user 1001 hello-world
```

# II. Reverse proxy buddy


## A. Simple HTTP setup

🌞 **Adaptez le `docker-compose.yml`** de [la partie précédente](./php.md)

```
version: "3"

services:
 phpapache:
    image: custom_php
    volumes:
      - "./src/:/var/www/html"

 mysql:
    image: mysql
    restart: always
    environment:
      - MYSQL_DATABASE=mysqldb
      - MYSQL_ROOT_PASSWORD=oui
    volumes:
      - "./sql/:/docker-entrypoint-initdb.d"

 phpmyadmin:
    image: phpmyadmin
    restart: always
    environment:
      - PMA_ARBITRARY=1
      - PMA_HOST=mysql
      - PMA_USER=root
      - PMA_PASSWORD=oui

 nginx:
    image: nginx:stable-alpine
    ports:
      - "80:80"
    volumes:
      - "./nginx.conf:/etc/nginx/nginx.conf"
```

```
axel@axel:~$ cat /etc/hosts
127.0.0.1	localhost
127.0.0.1	www.supersite.com
127.0.0.1	pma.supersite.com
```

Il faut faire :

```
docker compose up -d
```

## B. HTTPS auto-signé

🌞 **HTTPS** auto-signé

```
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -keyout www.supersite.com.key -out www.supersite.com.crt
```
```
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -keyout pma.supersite.com.key -out pma.supersite.com.crt
```

```
axel@debian:~$ cat /etc/hosts
127.0.0.1	www.supersite.com
127.0.0.1	pma.supersite.com
```

```
version: "3"

services:
 phpapache:
    image: custom_php
    volumes:
      - "./src/:/var/www/html"

 mysql:
    image: mysql
    restart: always
    environment:
      - MYSQL_DATABASE=mysqldb
      - MYSQL_ROOT_PASSWORD=oui
    volumes:
      - "./sql/:/docker-entrypoint-initdb.d"

 phpmyadmin:
    image: phpmyadmin
    restart: always
    environment:
      - PMA_ARBITRARY=1
      - PMA_HOST=mysql
      - PMA_USER=root
      - PMA_PASSWORD=oui

 nginx:
    image: nginx:stable-alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "./certs/www.supersite.com.crt:/etc/ssl/certs/www.supersite.com.crt"
      - "./certs/www.supersite.com.key:/etc/ssl/certs/www.supersite.com.key"
      - "./certs/www.supersite.com.crt:/etc/ssl/certs/pma.supersite.com.crt"
      - "./certs/www.supersite.com.key:/etc/ssl/certs/pma.supersite.com.key"
      - "./nginx.conf:/etc/nginx/nginx.conf"
```


## C. HTTPS avec une CA maison

🌞 **Générer une clé et un certificat de CA**

Mot de passe : ouinon

```
openssl genrsa -des3 -out CA.key 4096
openssl req -x509 -new -nodes -key CA.key -sha256 -days 1024  -out CA.pem
```
```
axel@debian:~/github/TP_linux/B2/TP2/admin/ca_maison$ ls
CA.key  CA.pem
```

🌞 **Générer une clé et une demande de signature de certificat pour notre serveur web**

```
openssl req -new -nodes -out www.supersite.com.csr -newkey rsa:4096 -keyout www.supersite.com.key
```
```
axel@debian:~/github/TP_linux/B2/TP2/admin/ca_maison$ ls
CA.key  CA.pem  www.supersite.com.csr  www.supersite.com.key
```

🌞 **Faire signer notre certificat par la clé de la CA**

```
axel@debian:~/github/TP_linux/B2/TP2/admin/ca_maison$ ls
CA.key  CA.srl  www.supersite.com.crt  www.supersite.com.key
CA.pem  v3.ext  www.supersite.com.csr
```

🌞 **Ajustez la configuration NGINX**

```
version: "3"

services:
 phpapache:
    image: custom_php
    volumes:
      - "./src/:/var/www/html"

 mysql:
    image: mysql
    restart: always
    environment:
      - MYSQL_DATABASE=mysqldb
      - MYSQL_ROOT_PASSWORD=oui
    volumes:
      - "./sql/:/docker-entrypoint-initdb.d"

 phpmyadmin:
    image: phpmyadmin
    restart: always
    environment:
      - PMA_ARBITRARY=1
      - PMA_HOST=mysql
      - PMA_USER=root
      - PMA_PASSWORD=oui

 nginx:
    image: nginx:stable-alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "./ca_maison/www.supersite.com.crt:/etc/ssl/certs/www.supersite.com.crt"
      - "./ca_maison/www.supersite.com.key:/etc/ssl/certs/www.supersite.com.key"
      - "./nginx.conf:/etc/nginx/nginx.conf"
```
```
events {}

http {
    server {

        listen       80;

        server_name www.supersite.com;

        return 301 https://$host$request_uri;

        # location / {
        #     proxy_pass   http://phpapache;
        # }

    }


    server {

        listen       443 ssl;

        server_name www.supersite.com;


        ssl_certificate      /etc/ssl/certs/www.supersite.com.crt;

        ssl_certificate_key /etc/ssl/certs/www.supersite.com.key;


        location / {

            proxy_pass   http://phpapache;

        }

    }

    server {
        listen       80;
        
        server_name  pma.supersite.com;
        
        # return 301 https://$host$request_uri;

        location / {
            proxy_pass   http://phpmyadmin;
        }
    }

}
```

🌞 **Prouvez avec un `curl` que vous accédez au site web**

```
axel@debian:~$ curl -k https://www.supersite.com
Table: 1<br>Table: 2<br>Table: 3<br>
```

🌞 **Ajouter le certificat de la CA dans votre navigateur**

Je ne sais pas comment prouver mais ça marche bien :)