#!/bin/sh
# usage: /usr/share/cgi-bin/_set_lan.sh $lan $ip $mask $dhcpstart $dhcpstop
# check parameters

DHCPIFACE=`uci show dhcp.lan.interface | sed "s/dhcp\.lan\.interface=//g" | sed "s/\'//g"`
if [ "$DHCPIFACE" == "$1" ];
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
PREVIOUS=`uci show network.lan.ipaddr | sed "s/network\.lan\.ipaddr=//g" | sed "s/\'//g"`
PREV_ESC=`echo $PREVIOUS | sed 's/\./\\\./g'`
#
uci set network.$1.ipaddr=$2
if [ $? != 0 ];
 then
  exit 1
fi
#
if [ -n "$USE_DHCP" ];
 then
  uci set dhcp.lan.dhcp_option=6,$2
  if [ $? != 0 ];
   then
    uci revert network.$1.ipaddr
    exit 1
  fi
#
  uci set dhcp.lan.start=$4
  if [ $? != 0 ];
   then
    uci revert network.$1.ipaddr
    uci revert dhcp.lan.dhcp_option
    exit 1
  fi
#
  uci set dhcp.lan.limit=$5
  if [ $? != 0 ];
   then
    uci revert network.$1.ipaddr
    uci revert dhcp.lan.dhcp_option
    uci revert dhcp.lan.start
    exit 1
  fi
fi
#
uci commit
( sleep 1 ;
# reload network
/etc/init.d/network restart > /dev/null 2>&1 && /etc/init.d/netwait start
# reload DHCP if needed
[ -n "$USE_DHCP" ] && /etc/init.d/dnsmasq restart
# those must be rewritten manually
TEST_NAMED=`grep "$PREV_ESC" /etc/bind/named.conf 2> /dev/null`
if [ -n "$TEST_NAMED" ];
 then
  sed -i "s/$PREV_ESC/$2/g" /etc/bind/named.conf
  /etc/init.d/named restart
fi
#
TEST_LIGHTTPD=`grep "$PREV_ESC" /etc/lighttpd/lighttpd.conf 2> /dev/null`
if [ -n "$TEST_LIGHTTPD" ];
 then
  sed -i "s/$PREV_ESC/$2/g" /etc/lighttpd/lighttpd.conf
  /etc/init.d/lighttpd restart
fi
#
) &
