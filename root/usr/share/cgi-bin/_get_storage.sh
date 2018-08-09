#!/bin/sh

DATA=`df -h /storage | sed -n '/^\/dev/{s/^[^ ]\+ \+//; s/\/.*//; p}'`
TOTAL=`echo $DATA | sed 's/ .*//'`
USED=`echo $DATA | sed 's/[^ ]\+ // ; s/ .*//'`
AVAIL=`echo $DATA | sed 's/[^ ]\+ [^ ]\+ // ; s/ .*//'`
PERCENT=`echo $DATA | sed 's/[^ ]\+ [^ ]\+ [^ ]\+ // ; s/ .*//'`
RDO=`uci get samba.@sambashare[0].read_only 2> /dev/null`
IP=`uci show network.lan.ipaddr | sed "s/network.*=// ; s/'//g"`
NAME=`uci get samba.@samba[0].name 2>/dev/null`
echo "{\"status\":\"enabled\",\"total\":\"$TOTAL\",\"used\":\"$USED\",\"available\":\"$AVAIL\",\"percent\":\"$PERCENT\",\"readonly\":\"$RDO\",\"router\":\"$IP\",\"name\":\"$NAME\"}"
