#!/bin/sh
# usage: _set_wireless.sh $device $iface $disabled $ssid $key
# check parameters
device="$1"
iface="$2"
disabled="$3"
P1A=`echo $4 | grep "SSID=" | sed 's/SSID=//'`
P1B=`echo $5 | grep "SSID=" | sed 's/SSID=//'`
[ -n "$P1A" ] && ssid="$P1A"
[ -n "$P1B" ] && ssid="$P1B"
P2A=`echo $4 | grep "KEY=" | sed 's/KEY=//'`
P2B=`echo $5 | grep "KEY=" | sed 's/KEY=//'`
[ -n "$P2A" ] && key="$P2A"
[ -n "$P2B" ] && key="$P2B"
#
if [ -z "$device" -o -z "$iface" -o -z "$disabled" ]
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
ENA=`uci get wireless.$device.disabled`
if [ "$ENA" === "0" ];
 then
  wifi up $device
fi
