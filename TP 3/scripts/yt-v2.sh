#!/bin/bash

logfile='/var/log/yt/download.log'
dldir='/srv/yt/downloads'
list='/srv/yt/url_list.txt'

if [[ ! -f $logfile ]]
then
  echo "Veuillez créer le fichier /var/log/yt/download.log puis relancer le script"
  exit 0
fi

if [[ ! -d $dldir ]]
then
  echo "Veuillez créer le fichier /srv/yt/downloads puis relancer le script"
  exit 0
fi

if [[ ! -f $list ]]
then
  echo "Veuillez créer le fichier /srv/yt/url_list.txt puis relancer le script"
  exit 0
fi

while true
do
  nbr_line="$(wc -l < /srv/yt/url_list.txt)"
  if [[ ${nbr_line} -ne "0" ]]
  then
    url=$(cat /srv/yt/url_list.txt | head -n 1)
    sed -i '1d' /srv/yt/url_list.txt
    title="$(youtube-dl --get-title $url)"
    ext="$(youtube-dl --get-filename $url --restrict-filenames | cut -d'.' -f2)"
    mkdir /srv/yt/downloads/"$title"
    youtube-dl --get-description $url > /srv/yt/downloads/"$title"/description
    youtube-dl -o /srv/yt/downloads/"$title"/"$title.$ext" $url > /dev/null
    echo [$(date "+%D %T")] Video $url was downloaded. File path : /srv/yt/downloads/"$title"/"$title.$ext" >> $logfile
    echo "Video $1 was downloaded."
    echo File path : /srv/yt/downloads/"$title"/"$title.$ext"
  fi
  sleep 3
done