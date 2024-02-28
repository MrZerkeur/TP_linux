Instructions pour le script :

Il suffit de mettre tous les fichiers qui sont dans ce dossier (sauf les markdowns), de chmod +x main.sh et de le lancer avec les droits root !

A NOTER :

Pour l'exemple, nginx va cherche un fichier nommé index.html dans /var/www/app_nulle, il faut donc le créer pour avoir un truc affiché sur NGINX une fois le script terminé.
Il est évidemment possible d'utiliser un autre fichier HTML situé autre part mais dans ce cas, il faut modifier le nom du fichier et/ou le chemin dans [nginx.conf.secure](./nginx.conf.secure) et dans [proxy.conf.secure](./proxy.conf.secure).