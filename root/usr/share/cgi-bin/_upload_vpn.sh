#!/bin/sh
# accepted parameters: $file $original
# check file
if [ -z "$file" -o -z "$original" ];
 then
  exit 1
fi
BASE="/etc/openvpn/configurations"
original=`echo "$original" | sed 's/\r/\n/g'`
printf %s "$original" > "$BASE/$file"
