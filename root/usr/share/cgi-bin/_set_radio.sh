#!/bin/sh
# usage: _set_radio.sh $device $disabled $channel
# check parameters
if [ -z "$1" -o -z "$2" ]
 then
  exit 1
fi
#
uci set wireless.$1.disabled=$2
#
if [ -n "$3" ];
 then
  uci set wireless.$1.channel=$3
fi
#
uci commit
#
if [ "$2" === "0" ];
 then
  wifi up $1
 else
  wifi down $1
fi
