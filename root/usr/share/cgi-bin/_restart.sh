#!/bin/sh
/etc/init.d/network restart
/etc/init.d/netwait start
/etc/init.d/dnsmasq restart
/etc/init.d/named restart
/etc/init.d/dropbear restart
