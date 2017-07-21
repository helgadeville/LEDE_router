#!/bin/sh
# usage: _set_wireless.sh $device $iface $disabled $ssid $key
# check parameters
if [ -z "$device" -o -z "$iface" -o -z "$disabled" ];
 then
  exit 1
fi
#
uci set wireless.$iface.disabled=$disabled
#
if [ -n "$ssid" ];
 then
  uci set wireless.$iface.ssid=$ssid
fi
#
if [ -n "$key" ];
 then
  uci set wireless.$iface.key=$key
fi
#
uci set wireless.$iface.encryption=psk2
uci commit
# do something only when radio enabled
ENA=`uci get wireless.$device.disabled 2> /dev/null`
if [ "$ENA" = "0" ];
 then
  wifi up $device
fi
