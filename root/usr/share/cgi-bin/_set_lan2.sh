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
  logger Stopping DHCP
  /etc/init.d/dnsmasq stop
#
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
# prepare all test conditions
TEST_NAMED=`grep "$PREV_ESC" /etc/bind/named.conf 2> /dev/null`
TEST_LIGHTTPD=`grep "$PREV_ESC" /etc/lighttpd/lighttpd.conf 2> /dev/null`
# stop servers
if [ -n "$TEST_LIGHTTPD" ];
 then
  logger Stopping lighttpd
  /etc/init.d/lighttpd stop
  sed -i "s/$PREV_ESC/$2/g" /etc/lighttpd/lighttpd.conf
fi
if [ -n "$TEST_NAMED" ];
 then
  logger Stopping named
  /etc/init.d/named stop
  sed -i "s/$PREV_ESC/$2/g" /etc/bind/named.conf
fi
# reload network
logger Restarting network
/etc/init.d/network reload > /dev/null 2>&1 && /etc/init.d/netwait start
# reload DHCP if needed
if [ -n "$USE_DHCP" ];
 then
  logger Starting DHCP
  /etc/init.d/dnsmasq start
fi
# those must be rewritten manually
if [ -n "$TEST_NAMED" ];
 then
  logger Starting named
  /etc/init.d/named start
fi
#
if [ -n "$TEST_LIGHTTPD" ];
 then
  logger Starting lighttpd
  /etc/init.d/lighttpd start
fi
#
) &
