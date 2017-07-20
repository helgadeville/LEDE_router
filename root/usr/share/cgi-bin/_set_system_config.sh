#!/bin/sh
# accepted parameters: $file $factory
# check file
if [ -z "$file" ];
 then
  exit 1
fi
BASE="/root/configurations"
if [ "$file" != "default" -a "$file" != "factory" ];
 then
  BASE="$BASE/custom"
fi
[ "$file" = "factory" ] && factory=yes
file="$file.cgz"
if [ -f "$BASE/$file" ];
 then
 else
  exit 1
fi
# prepare tmp directory
TMP="/tmp/_config"
rm -rf "$TMP"
mkdir "$TMP"
cp "$BASE/$file" "$TMP"
cd "$TMP"
# unzip and copy all
tar xzf "$file"
rm "$file"
if [ -z "$factory" ];
 then
  cp -R etc/* /etc/
 else
  cp -R * /
fi
cd /
rm -rf "$TMP"
