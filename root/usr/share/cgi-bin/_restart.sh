#!/bin/sh
sleep 1
/etc/init.d/network restart > /dev/null 2>&1
/etc/init.d/netwait start > /dev/null 2>&1
/etc/init.d/dnsmasq reload > /dev/null 2>&1
/etc/init.d/named restart > /dev/null 2>&1
if [ -n "$lan" ];
 then
  /etc/init.d/lighttpd reload > /dev/null 2>&1
  /etc/init.d/dropbear restart > /dev/null 2>&1
fi
