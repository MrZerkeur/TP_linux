#!/bin/bash

title="$(youtube-dl --get-title $1)"
ext="$(youtube-dl --get-filename $1 --restrict-filenames | cut -d'.' -f2)"

logfile='/var/log/yt/download.log'
dldir='/srv/yt/downloads'

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

mkdir /srv/yt/downloads/"$title"
youtube-dl --get-description $1 > /srv/yt/downloads/"$title"/description

youtube-dl -o /srv/yt/downloads/"$title"/"$title.$ext" $1 > /dev/null

echo [$(date "+%D %T")] Video $1 was downloaded. File path : /srv/yt/downloads/"$title"/"$title.$ext" >> $logfile
echo "Video $1 was downloaded."
echo File path : /srv/yt/downloads/"$title"/"$title.$ext"