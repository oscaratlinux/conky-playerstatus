#!/bin/bash


suena=$(pgrep rhythmbox)

if [ "$suena" = "" ]
then
	rm .playing
else
	suena=$(rhythmbox-client --no-start --print-playing)
	if [ "$suena" = " - " ]
	then
		rm .playing
	else
		touch .playing
		ultimodisco=$(cat .ultimo)
		actual=$(rhythmbox-client --no-start --print-playing-format=%at)
		quien=$(rhythmbox-client --no-start --print-playing-format=%aa)
		song=$(rhythmbox-client --no-start --print-playing-format="%tt")

		if [ "$ultimodisco" != "$actual" ]
		then
			grep "$actual" albumsxlinea | grep "$quien" > encontrarlo 
			awk 'BEGIN {FS="file...."}; {print $2}' encontrarlo > ruta
			imagen=$(awk 'BEGIN {FS="..s"}; {print $1}' ruta)
			cp .cache/rhythmbox/album-art/$imagen ~/portacd.jpg
			convert  -resize 96x96 .cache/rhythmbox/album-art/$imagen ~/miniporta.jpg
		fi
		echo $actual > .ultimo
		echo $quien > .quien
		echo $song > .song
	fi
fi

