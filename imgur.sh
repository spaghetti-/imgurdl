#!/bin/bash

#############################################################
#	Script to download all images in an imgur.com album
#	to disk.
#	USAGE: ./imgur.sh http://imgur.com/a/id
#
#############################################################

url=('')
ass=".tmp"

usage(){
	echo "USAGE: ./imgur.sh http://imgur.com/a/id"
}

url="${@: -1}"

if [[ -z $url ]]
then
	usage
	exit 1
fi

if [[ "$url" =~ "imgur.com/a/" ]]
then
	curl -s $url > $ass
	title=$(awk -F \" '/data-cover/ {print $6; exit}' $ass)
	if [[ -z $title ]]
	then
		title=$(awk -F \" '/data-cover/ {print $8}' $ass)
	fi

	title=${title// /_}

	dir="${title//[^a-zA-Z0-9_]/}"

	if [[ -d $dir ]]
	then
		echo "Directory exists, you may have downloaded this album before."
		exit 1
	else
		echo "Saving to $dir/"
		mkdir -p $dir	
	fi

	for image in $(awk -F \" '/data-src/ {print $10}' $ass | sed /^$/d | sed s/s.jpg/.jpg/)
	do
		filename=$(sed s/http:\\/\\/i.imgur.com\\/// <<< $image)
		curl -# $image > "$dir/$filename"
		ftype=$(file "$dir/$filename" | grep PNG | wc -l)
		if [[ $ftype == 1 ]]
		then
			mv "$dir/$filename" "$dir/${filename//.jpg/.png}"
		fi
	done
fi

echo "Done"
exit 0
