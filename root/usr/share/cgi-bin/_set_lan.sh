#!/bin/sh
# usage: /usr/share/cgi-bin/_set_lan.sh $lan $ip $mask $dhcpstart $dhcpstop
# check parameters

DHCPIFACE=`uci show dhcp.lan.interface | sed "s/dhcp\.lan\.interface=//g" | sed "s/\'//g"`
if [ "$DHCPIFACE" = "$1" ];
 then
  USE_DHCP=1
fi
if [ -z "$1" -o -z "$2" -o -z "$3" ] \
 || [ -n "$USE_DHCP" -a -z "$4" ] \
 || [ -n "$USE_DHCP" -a -z "$5" ];
 then
  exit 1
fi
#
uci set network.$1.ipaddr=$2
#
if [ -n "$USE_DHCP" ];
 then
  uci set dhcp.lan.dhcp_option=6,$2
  uci set dhcp.lan.start=$4
  uci set dhcp.lan.limit=$5
fi
#
uci commit
( sleep 1 ;
# reload network
/etc/init.d/network restart > /dev/null 2>&1 && /etc/init.d/netwait start
# reload DHCP if needed
[ -n "$USE_DHCP" ] && /etc/init.d/dnsmasq restart
# those must be rewritten manually

sed -n '1h;1!H;${;g;s/listen-on\s*{[^}]*}/listen-on { 127.0.0.1; '"$2"'; }/g;p;}' /etc/bind/named.conf > /etc/bind/_named.conf
mv /etc/bind/_named.conf /etc/bind/named.conf
/etc/init.d/named.restart

sed -i "/^[[:space:]]*#/!s/server\.bind\s*=.*/server.bind = \""$2"\"/" /etc/lighttpd/lighttpd.conf
/etc/init.d/lighttpd restart

) &
