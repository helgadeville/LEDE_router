#!/bin/sh
# usage: _set_wireless.sh $device $iface $disabled $ssid $key $isolate
# check parameters
if [ -z "$device" -o -z "$iface" -o -z "$disabled" ];
 then
  exit 1
fi
# check hardware switch
SW=`/sbin/checkswitch`
if [ "$SW" = "none" ];
 then
  if [ "$disabled" = "0" ];
   then
    uci del wireless.$iface.disabled 2> /dev/null
   else
    uci set wireless.$iface.disabled=$disabled
  fi
fi
#
if [ -n "$ssid" ];
 then
  uci set wireless.$iface.ssid="$ssid"
fi
#
if [ -n "$key" ];
 then
  uci set wireless.$iface.key="$key"
fi
#
uci set wireless.$iface.encryption=psk2
#
if [ "$isolate" = "true" -o "$isolate" = "yes" -o "$isolate" = "1" ];
 then
  uci set wireless.$iface.isolate=1
 else
  uci del wireless.$iface.isolate > /dev/null 2>&1
fi
#
if [ "$hidden" = "true" -o "$hidden" = "yes" -o "$hidden" = "1" ];
 then
  uci set wireless.$iface.hidden=1
 else
  uci del wireless.$iface.hidden > /dev/null 2>&1
fi
# enable channels
uci set wireless.$iface.country='00'
#
uci commit
# do something only when radio enabled
ENA=`uci get wireless.$device.disabled 2> /dev/null`
if [ -n "$ENA" -o "$ENA" = "0" ];
 then
  wifi up $device
fi
