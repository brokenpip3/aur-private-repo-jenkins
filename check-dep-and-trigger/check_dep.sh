#!/usr/bin/env bash

[[ -v REPONAME ]] || { printf "No reponame provided, exit"; exit 1; }

rundir=$(dirname "$(readlink -f "$0")")

printf "\n-- Check one time builded packages and them to pkglist --\n"

sudo pacman -Sy

pacman -Sl "${REPONAME}"

pacman -Sl "${REPONAME}" |awk '{print $2}' > "$rundir/actualpkglist"

sort "$rundir/pkglist" "$rundir/actualpkglist" | uniq > "$rundir/totalpkglist"

printf "\n-- Check packages dependencies --\n"

while read -r line; do
    echo $line
    aur depends -n "$line" >> "$rundir/pkg-depend-list-temp"
done < "$rundir/totalpkglist"

printf "\n-- Total pkg num --\n"

wc -l < "$rundir/pkg-depend-list-temp"

printf "\n-- Total pkg list --\n"

cat "$rundir/pkg-depend-list-temp" |sort -u > "$rundir/pkg-depend-list"
cat "$rundir/pkg-depend-list"
