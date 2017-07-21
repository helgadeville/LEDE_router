#!/bin/sh
# accepted parameters: $file $factory
# check file
if [ -z "$file" ];
 then
  exit 1
fi
BASE="/etc/openvpn/configurations"
if [ -f "$BASE/$file" ];
 then
  rm "$BASE/$file""
 else
  exit 1
fi
