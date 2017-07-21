#!/bin/sh
# accepted parameters: $file $factory
# check file
if [ -z "$file" -o -z "$original" ];
 then
  exit 1
fi
BASE="/etc/openvpn/configurations"
echo "$original" > "$BASE/$file"
