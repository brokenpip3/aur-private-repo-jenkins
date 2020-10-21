#!bin/bash

printf "-- Removing comment -- \n"
sed -i -e "/\s*#.*/s/\s*#.*//" -e "/^\s*$/d" gpgkeys

printf "-- Retriving gpgkeys -- \n"
while read line; do 
		gpg --recv-keys --keyserver 'hkp://ipv4.pool.sks-keyservers.net' $line
done < gpgkeys
