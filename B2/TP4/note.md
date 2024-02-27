Option pour verbosité (quel fichié a été update et comment), plusieurs niveau de verbosité ?
Option pour exit lors d'une erreur ou pas
Mettre les ✅ à gauche ?
Check si le main a été lancé avec sudo ou root


CIS ✅
SSH ✅
NGINX ✅
FAIL2BAN
Aide ?

Ecrire readme


dnf install epel-release -y
dnf install fail2ban -y
systemctl start fail2ban
systemctl enable fail2ban


VERIFIER NGINX, IL Y A UN TRUC BIZARRE
backend = systemd au lieu de backend = auto