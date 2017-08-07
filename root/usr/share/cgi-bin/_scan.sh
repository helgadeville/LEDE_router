#!/bin/sh
# usage: _scan.sh $dev
if [ -z $1 ];
 then
  exit 1
fi
SCAN=`/usr/bin/iwinfo "$1" scan`
echo "$SCAN" | sed 's/Cell.*Address:/MAC:/ ; s/^[[:space:]]*// '
