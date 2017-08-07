#!/bin/sh
# accepted parameters: $file $original
# check file
if [ -z "$file" -o -z "$original" ];
 then
  exit 1
fi
BASE="/etc/openvpn/configurations"
printf %s "$original" > "$BASE/$file"
