
## Machine 1 :
```
/boot/loader/entries/

Supprimer les 3 .conf
```

## Machine 2 :
```
/boot/grub2/
Supprimer grub.cfg
```

## Machine 3 :
```
/etc/
Supprimer shadow
```

## Machine 4 :
```
/root/.bashrc

Ajouter une fork bomb : :(){ :|:& };: 
```

## Machine 5 :
```
/root/.bashrc

Ajouter : sudo killall -u root (pour la session route)

Et ajouter : sudo killall -u uer (pour la session user si il en existe une)
```