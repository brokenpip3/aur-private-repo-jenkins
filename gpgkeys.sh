#!/usr/bin/env bash

printf 'Removing comment \n'
sed -i -e "/\s*#.*/s/\s*#.*//" -e "/^\s*$/d" gpgkeys

printf 'Retriving gpgkeys \n'
while read line; do
        echo "### adding $line" 
		gpg --recv-keys --keyserver 'keyserver.ubuntu.com' $line
		echo "###"
done < gpgkeys
