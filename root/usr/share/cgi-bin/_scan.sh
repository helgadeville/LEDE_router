#!/bin/sh
# usage: _scan.sh $dev
if [ -z $1 ];
 then
  exit 1
fi
# if dev = radiox, will be changed to phyx
DEV=`echo $1 | sed 's/radio/phy/'`
# get platform
PLATFORM=`uci show wireless.$1.path | sed "s/wireless.*=// ; s/'//g"`
# check if interface is up
IFACE=`ls /sys/devices/$PLATFORM/net 2> /dev/null`
# generate random interface name to avoid collisions
if [ -z "$IFACE" ];
 then
  IFACE=`head /dev/urandom | tr -dc a-z0-9 | head -c 12`
# create interface
  iw phy "$DEV" interface add "$IFACE" type managed
  if [ $? != 0 ];
   then
    exit 1
  fi
  ifconfig "$IFACE" up
  DELFACE=YES
fi
SCAN=`iwinfo $IFACE scan`
if [ -n "$DELFACE" ];
 then
  ifconfig "$IFACE" down
  iw dev "$IFACE" del
fi
echo "$SCAN" | sed 's/Cell.*Address:/MAC:/ ; s/^[[:space:]]*// '
