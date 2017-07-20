#!/bin/sh
# check if wan accessed by wireless or wired
WIREDWAN=`uci get network.wan.ifname 2> /dev/null`
WIREDWAND=`uci get network.wan.disabled 2> /dev/null`
WIFIWAN=`uci get wireless.wan.device 2> /dev/null`
WIFIWAND=`uci get wireless.wan.disabled 2> /dev/null`

if [ -n "$WIREDWAN" -a "$WIREDWAND" != "1" ];
 then
  WIFIWAN='wired'
 else
  if [ -n "$WIFIWAN" -a "$WIFIWAND" != "1" ];
   then
    WIFIWAN='wireless'
  fi
fi
# now check if access-point enabled
IFACES=`uci show wireless | grep wifi-iface | grep -v '^wireless\.wan' | sed 's/wireless\.// ; s/=.*//'`
ACCESS_POINT=no
for iface in $IFACES
 do
  MODE=`uci get wireless."$iface".mode`
  [ "$MODE" = "ap" ] && ACCESS_POINT=yes
done
[ "$ACCESS_POINT" = "yes" ] && WIFIWAN="$WIFIWAN access-point"
# output result
echo $WIFIWAN
