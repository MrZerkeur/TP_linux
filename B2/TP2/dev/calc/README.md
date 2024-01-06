Tout d'abord, commencer par build l'image :

```
docker build . -t python_calculatrice_modified
```

Pour lancer le serveur de la calculatrice, vous avez plusieurs choix :


# 1. Lancer avec le docker compose classique

```
docker compose up -d
```

Avec cette commande, vous allez lancer le serveur sur le port 13337.

# 2. Lancer le container avec un port custom

```
docker run -e CALC_PORT=port_souhaité python_calculatrice_modified
```

Cette fois-ci, vous allez lancer le container sans docker compose et avec le port que vous voulez

# 3. Lancer avec un port custom et en utilisant de docker compose

Pour celà, il faudra modifier le docker compose, y spécifier la valeur de la variable d'envionnement CALC_PORT et changer le port exposé à la même valeur.