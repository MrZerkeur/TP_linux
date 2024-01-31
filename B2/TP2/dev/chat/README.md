# CHATROOM PORT ET NOMBRE DE USER CUSTOM

Tout d'abord, il faut build l'image en se mettant dans le dossier où est ce README :
```
docker build . -t python_chat
```

Pour lancer le programme depuis l'image avec un port et un nombre de user maximum custom, on peut utiliser cette commande :
```
docker run -e CHAT_PORT=<port> MAX_USERS=<nombre de users> -d python_chat
```
Par défaut si CHAT_PORT n'est pas défini, le programme utilisera le port 8888.
Et si MAX_USERS n'est pas défini, le nombre maximum de user sera 16.

Enfin, pour lancer le programme depuis le docker compose, il suffit de faire cette commande :
```
docker compose up -d
```

Si vous voulez utiliser utiliser le docker compose et personnaliser le port ou le nombre maximum de user, il faudra modifier le docker compose comme ceci :
```
version: "3"

services:
  chat:
    image: python_chat
    ports:
      - <port>:8888
    environment:
      - MAX_USERS=<nombre de users>
```