 #!/bin/bash
#lancer le script en root
echo "Machine name : $(hostname)"
echo "OS $(source /etc/os-release ; echo $NAME) and kernel version is $(uname -r)" 
echo "IP : $(ip a | grep -w inet | tr -s ' ' | tail -n 1 | cut -d' ' -f5)"
echo "RAM : $(free -h | grep Mem | tr -s ' ' | cut -d' ' -f4) memory available on $(free -h | grep Mem | tr -s ' ' | cut -d' ' -f2) total memory"
echo "Disk : $(df -h | grep '/$' | tr -s ' ' | cut -d' ' -f4) space left"
echo "Top 5 processes by RAM usage :"
for i in $(seq 1 5)
do
  echo "This programme : $(ps aux --no-headers --sort -rss | tr -s ' ' | cut -d' ' -f11 | sed -n ${i}p) is using $(ps aux --no-headers --sort -rss | tr -s ' ' | cut -d' ' -f4 | sed -n ${i}p)% of the RAM"
done
echo "Listening ports :"
command="$(ss -ltu4Hpn)"
while read line;
do
  port=$(echo ${line} | tr -s ' ' | cut -d' ' -f5 | cut -d':' -f2)
  type=$(echo ${line} | tr -s ' ' | cut -d' ' -f1)
  processus=$(echo ${line} | tr -s ' ' | cut -d' ' -f7 | cut -d'"' -f2)
  echo " - ${port} ${type} ":" ${processus}"
done <<< "${command}"

chat_pic=$(curl -s https://cataas.com/cat > chat)
ext=$(file --extension chat | cut -d' ' -f2 | cut -d'/' -f1)
if [[ ${ext} == "jpeg" ]]
then
  chat_ext="chat.${ext}"
elif [[ ${ext} == "png" ]]
then
  chat_ext="chat.${ext}"
else
  chat_ext="chat.gif"
fi
mv chat ${chat_ext}
chmod +x ${chat_ext}
echo " "
echo "Here is your random cat : ./${chat_ext}"
