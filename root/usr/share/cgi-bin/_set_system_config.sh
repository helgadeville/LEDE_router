#!/bin/sh
# accepted parameters: $file
# check file
if [ -z "$file" ];
 then
  exit 1
fi
BASE="/root/configurations"
[ "$file" = "factory" ] && factory=yes
if [ "$file" != "default" -a "$file" != "factory" ];
 then
  BASE="$BASE/custom"
 else
  file="$file.cgz"
fi
if [ ! -f "$BASE/$file" ];
 then
  exit 1
fi
# prepare tmp directory
TMP="/tmp/_config"
rm -rf "$TMP"
mkdir "$TMP"
cp "$BASE/$file" "$TMP"
cd "$TMP"
# unzip and copy all
skip=no
tar xzf "$file" 2> /dev/null
if [ $? -gt 0 ];
 then
 skip=yes
fi
rm "$file"
if [ "$skip" = "no" ];
 then
  if [ -z "$factory" ];
   then
    cp -R etc/* /etc/
   else
    cp -R * /
  fi
fi
cd /
rm -rf "$TMP"
[ "$skip" = "yes" ] && exit 1
