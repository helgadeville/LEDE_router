#!/bin/sh
[ -z "$peer" -a -z "$dns1" -a -z "$dns2" ] && exit 1
if [ -z "$peer" ];
 then
  uci set network.wan.peerdns='0'
 else
  uci del network.wan.peerdns > /dev/null 2>&1
fi
uci del network.wan.dns > /dev/null 2>&1
[ -n "$dns1" ] && uci add_list network.wan.dns="$dns1"
[ -n "$dns2" ] && uci add_list network.wan.dns="$dns2"
uci commit

