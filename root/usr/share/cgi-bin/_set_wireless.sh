#!/bin/sh
# usage: _set_wireless.sh $device $iface $ssid $key $channel $disabled
# check parameters
if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$5" -o -z "$6" ] \
 || [ ${#4} -lt 8 -a "$disabled" == "0" ];
 then
  exit 1
fi
#
uci set wireless.$2.ssid=$3
if [ $? != 0 ];
 then
  exit 1
fi
#
uci set wireless.$2.key=$4
if [ $? != 0 ];
 then
  uci revert wireless.$2.ssid
  exit 1
fi
#
uci set wireless.$1.channel=$5
if [ $? != 0 ];
 then
  uci revert wireless.$2.ssid
  uci revert wireless.$2.key
  exit 1
fi
#
uci set wireless.$1.disabled=$6
if [ $? != 0 ];
 then
  uci revert wireless.$2.ssid
  uci revert wireless.$2.key
  uci revert wireless.$1.channel
  exit 1
fi
#
uci set wireless.$2.encryption=psk2
if [ $? != 0 ];
 then
  uci revert wireless.$2.ssid
  uci revert wireless.$2.key
  uci revert wireless.$1.channel
  uci revert wireless.$1.disabled
  exit 1
fi
uci commit
/etc/init.d/network reload
exit 0
