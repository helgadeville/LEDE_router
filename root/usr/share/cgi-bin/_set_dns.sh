#!/bin/sh
# usage: /usr/share/cgi-bin/_set_dns.sh $dns1 $dns2
# check parameters
[ -z $1 ] && exit 1
DNS="$1;"
[ -n "$2" ] && DNS="$DNS $2;"
sed -n '1h;1!H;${;g;s/forwarders\s*{[^}]*}/forwarders { '"$DNS"' }/g;p;}' /etc/bind/named.conf > /etc/bind/_named.conf
if [ $? -gt 0 ];
 then
  exit 1
fi
mv /etc/bind/_named.conf /etc/bind/named.conf
/etc/init.d/named restart
