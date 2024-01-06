# TP2 dév : packaging et environnement de dév local

# I. Packaging

## 1. Calculatrice

🌞 **Packager l'application de calculatrice réseau**

[Dockerfile](./calc_build/Dockerfile)

[Compose](./calc_build/docker-compose.yml)

[Read me](./calc_build/README.md)

🌞 **Environnement : adapter le code si besoin**

[Dockerfile](./calc_build_modified/Dockerfile)

[Compose](./calc_build_modified/docker-compose.yml)

[Read me](./calc_build_modified/README.md)

🌞 **Logs : adapter le code si besoin**

📜 **Dossier `tp2/calc/` dans le dépôt git de rendu**

[Dockerfile](./calc/Dockerfile)

[Compose](./calc/docker-compose.yml)

[Read me](./calc/README.md)

[calc.py](./calc/calc.py)

## 2. Chat room

Soucis de client, à voir plus tard

🌞 **Packager l'application de chat room**

- pareil : on package le serveur
- `Dockerfile` et `docker-compose.yml`
- code adapté :
  - logs en sortie standard
  - variable d'environnement `CHAT_PORT` pour le port d'écoute
  - variable d'environnement `MAX_USERS` pour limiter le nombre de users dans chaque room (ou la room s'il y en a qu'une)
- encore un README propre qui montre comment build et comment run (en démontrant l'utilisation des variables d'environnement)

📜 **Dossier `tp2/chat/` dans le dépôt git de rendu**

- `Dockerfile`
- `docker-compose.yml`
- `README.md`
- `chat.py` : le code de l'app chat room

➜ **J'espère que ces cours vous ont apporté du recul sur la relation client/serveur**

- deux programmes distincts, chacun a son rôle
  - le serveur
    - est le gardien de la logique, le maître du jeu, garant du respect des règles
    - c'est votre bébé vous le maîtrisez
    - opti et sécu en tête
  - le client c'est... le client
    - faut juste qu'il soit joooooli
    - garder à l'esprit que n'importe qui peut le modifier ou l'adapter
    - ou carrément dév son propre client
- y'a même des milieux comme le web, où les gars qui dév les serveurs (Apache, NGINX, etc) c'est pas DU TOUT les mêmes qui dévs les clients (navigateurs Web, `curl`, librairie `requests` en Python, etc)
