#!/usr/bin/env bash

rundir=$(dirname "$(readlink -f "$0")")

printf 'Removing comment \n'
sed -i -e "/\s*#.*/s/\s*#.*//" -e "/^\s*$/d" "$rundir/gpgkeys"

printf 'Retriving gpgkeys \n'
while read -r line; do
	printf "\n-- adding %s --\n" "$line"
	gpg --recv-keys --keyserver 'keyserver.ubuntu.com' "$line"
	printf "\n--\n"
done < "$rundir/gpgkeys"
