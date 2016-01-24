#!/bin/bash


url="http://$1.imgur.com/"

for album in $(curl -s $url | grep -i "imgur.com/a/" | sed s/^.*imgur.com/imgur.com/ | sed s/\"\>// | sed s/^/http:\\/\\//)
do
  echo "Downloading album: $album"
  ./imgur.sh $album
done

