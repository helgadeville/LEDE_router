#!/bin/sh
# usage: /usr/share/cgi-bin/_ap_on.sh 
# $wired $device $ssid $encryption $proto must be set
# when $proto=static then also ipaddr and netmask must be set
# $key, $switch and $mac are optional
# eth1 assumed to be blue "generic" WAN port, so "$wired" will be eth1 by default
# eth0 is the multiport LAN switch, so "$switch" will be eth0 by default
# check parameters
[ -z "$wired" -o -z "$device" -o -z "$ssid" -o -z "$encryption" -o -z "$proto" ] && exit 1
[ -n "$proto" -a "$proto" != "dhcp" -a "$proto" != "static" ] && exit 1
[ "$proto" = "static" ] && [ -z "$ipaddr" -o -z "$netmask" ] && exit 1
[ "$encryption" != "none" -a "$encryption" != "wep" -a "$encryption" != "psk" -a "$encryption" != "psk2" ] && exit 1
[ "$encryption" != "none" -a -z "$key" ] && exit 1
# save station
echo "encryption=$encryption" > "/root/stations/$ssid"
[ -n "$key" ] && echo "key=$key" >> "/root/stations/$ssid"
echo "proto=$proto" >> "/root/stations/$ssid"
[ -n "$ipaddr" ] && echo "ipaddr=$ipaddr" >> "/root/stations/$ssid"
[ -n "$netmask" ] && echo "netmask=$netmask" >> "/root/stations/$ssid"
[ -n "$mac" ]  && echo "mac=$mac" >> "/root/stations/$ssid"
# according to tutorial :)
# disable rebind, was 1
uci set dhcp.@dnsmasq[0].rebind_protection=0

# remove wan & wan6 ifname section, was 'eth1' originally
uci del network.wan.ifname 2> /dev/null
uci del network.wan.disabled 2> /dev/null

# enable device
uci set wireless."$device".disabled=0
# setup wireless
uci set wireless.wan=wifi-iface
uci set wireless.wan.device="$device"
uci set wireless.wan._device="$device"
uci set wireless.wan.network=wan
uci set wireless.wan.mode=sta

if [ -n "$proto" ];
 then
  uci set network.wan=interface
  uci set network.wan.proto="$proto"
fi

curr_gw=`uci get network.wan.gateway 2> /dev/null`
if [ -n "$curr_gw" ];
 then
  uci del_list network.wan.dns=$curr_gw 2> /dev/null
  uci del network.wan.gateway 2> /dev/null
fi

if [ "$proto" = "static" ];
 then
  uci set network.wan.ipaddr="$ipaddr"
  uci set network.wan.netmask="$netmask"
  if [ -n "$gateway" ];
   then
    uci set network.wan.gateway="$gateway"
    uci add_list network.wan.dns="$gateway"
  fi
fi

if [ "$proto" = "dhcp" ];
 then
  uci del network.wan.ipaddr 2> /dev/null
  uci del network.wan.netmask 2> /dev/null
fi

uci set wireless.wan.ssid="$ssid"
uci set wireless.wan.encryption="$encryption"
if [ "$encryption" = "none" ];
 then
  uci del wireless.wan.key 2> /dev/null
 else
  uci set wireless.wan.key="$key"
fi
# mac spoof ?
if [ -n "$mac" ];
 then
  uci set wireless.wan.macaddr="$mac"
 else
  uci del wireless.wan.macaddr 2> /dev/null
fi
uci del wireless.wan.disabled 2> /dev/null

# bridge previous wan port to lan, was eth0 originally
if [ -n "$switch" ];
 then
  uci set network.lan.ifname="$wired $switch"
 else
  uci set network.lan.ifname="$wired"
fi

# commit & reload
uci commit
