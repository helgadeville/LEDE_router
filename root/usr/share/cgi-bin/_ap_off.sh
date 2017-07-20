#!/bin/sh
# usage: /usr/share/cgi-bin/_ap_off.sh
# must have parameters: $device $switch $proto, if $proto is static then must have $ipaddr and $netmask
# may have $mac
# $device should be eth1 (default WAN port) and $switch should be eth0 (multiport)
# but this may vary
[ -z "$device" -o -z "$switch" ] && exit 1
[ "$proto" = "static" ] && [ -z "$ipaddr" -o -z "$netmask" ] && exit 1
#
logger Restoring AP-only configuration, unbridging WAN port and setting WAN port as Internet source
#
# enable rebind, was 0
uci set dhcp.@dnsmasq[0].rebind_protection=1
#
# restore wan ifname section
uci set network.wan.ifname=$device
uci set network.wan.disabled=0
uci set network.wan.proto=$proto
if [ "$proto" = "static" ];
 then
  uci set network.wan.ipaddr="$ipaddr"
  uci set network.wan.netmask="$netmask"
 else
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
uci set network.lan.ifname=$switch
#
# commit & reload
uci commit
/etc/init.d/network restart
/etc/init.d/netwait start
/etc/init.d/dnsmasq restart
/etc/init.d/named restart
/etc/init.d/dropbear restart
