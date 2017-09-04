#!/bin/sh
# usage: /usr/share/cgi-bin/_ap_off.sh
# must have parameters: $device $proto, if $proto is static then must have $ipaddr and $netmask
# may have $switch $mac
# $device should be eth1 (default WAN port) and $switch should be eth0 (multiport)
# but this may vary
[ -z "$device" ] && exit 1
[ -n "$proto" -a "$proto" != "dhcp" -a "$proto" != "static" ] && exit 1
[ "$proto" = "static" ] && [ -z "$ipaddr" -o -z "$netmask" ] && exit 1
#
# enable rebind, was 0
uci set dhcp.@dnsmasq[0].rebind_protection=1
#
# restore wan ifname section
uci set network.wan.ifname=$device
uci del network.wan.disabled 2> /dev/null
if [ -n "$proto" ];
 then
  uci set network.wan.proto=$proto
fi
if [ "$proto" = "static" ];
 then
  uci set network.wan.ipaddr="$ipaddr"
  uci set network.wan.netmask="$netmask"
fi
if [ "$proto" = "dhcp" ];
 then
  uci del network.wan.ipaddr 2> /dev/null
  uci del network.wan.netmask 2> /dev/null
fi
if [ -n "$mac" ];
 then
  uci set network.wan.mac="$mac"
 else
  uci del network.wan.mac 2> /dev/null
fi
#
# remove setup wireless
uci set wireless.wan.disabled=1
uci del wireless.wan.device 2> /dev/null
#
# unbridge previous wan port from lan
if [ -n "$switch" ];
 then
  uci set network.lan.ifname=$switch
 else
  uci del network.lan.ifname 2> /dev/null
fi
#
# commit & reload
uci commit
