#!/bin/sh
# accepted parameters: $file $data, optional $archive
# check file
if [ -z "$file" -o -z "$data"];
 then
  exit 1
fi
# prepare tmp directory
TMP="/tmp/_config"
rm -rf "$TMP"
mkdir "$TMP"
echo "$data" | base64 --decode | openssl enc -d -aes-256-cbc -pass file:/root/password > "$TMP/$file"
#optional copy
if [ -n "$archive" ];
 then
  BASE="/root/configurations/custom"
  cp "$TMP/$file" "$BASE"
fi
cd "$TMP"
# unzip and copy all
skip=no
tar xzf "$file" 2> /dev/null
if [ $? -gt 0 ];
 then
  skip=yes
fi
rm "$file"
[ "$skip" = "no" ] && cp -R etc/* /etc/
cd /
rm -rf "$TMP"
[ "$skip" = "yes" ] && exit 1
