#!/bin/sh

DATA=`df -h /storage | sed -n '/^\/dev/{s/^[^ ]\+ \+//; s/\/.*//; p}'`
TOTAL=`echo $DATA | sed 's/ .*//'`
USED=`echo $DATA | sed 's/[^ ]\+ // ; s/ .*//'`
AVAIL=`echo $DATA | sed 's/[^ ]\+ [^ ]\+ // ; s/ .*//'`
PERCENT=`echo $DATA | sed 's/[^ ]\+ [^ ]\+ [^ ]\+ // ; s/ .*//'`
RDO=`uci get samba.@sambashare[0].read_only 2> /dev/null`

echo "{\"status\":\"enabled\",\"total\":\"$TOTAL\",\"used\":\"$USED\",\"available\":\"$AVAIL\",\"percent\":\"$PERCENT\",\"readonly\":\"$RDO\"}"
