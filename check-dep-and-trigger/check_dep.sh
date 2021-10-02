#!/usr/bin/env bash

rundir=$(dirname "$(readlink -f "$0")")

echo "-- Check one time builded packages and them to pkglist"

sudo pacman -Sy

pacman -Sl needrelax

pacman -Sl needrelax |awk '{print $2}' > "$rundir/actualpkglist"

sort "$rundir/pkglist" "$rundir/actualpkglist" | uniq > "$rundir/totalpkglist"

echo "-- Check packages dependencies --"

while read -r line;
  do aur depends -n "$line" >> "$rundir/pkg-depend-list";
done < "$rundir/totalpkglist"

echo "-- Total pkg num --"

wc -l < "$rundir/pkg-depend-list"

echo "-- Total pkg list --"

cat "$rundir/pkg-depend-list"
