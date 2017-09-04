#!/bin/sh
[ -z "$1" -o -z "$2" ] && exit 1
echo "$1" > /etc/openvpn/.auth.txt
echo "$2" >> /etc/openvpn/.auth.txt
if [ "$3" -gt 0 ];
 then
  STATE=`/usr/share/cgi-bin/_vpnstate.sh`
  if [ "$STATE" = 'down' ];
   then
    /sbin/vpnonoff
   else
    /etc/init.d/openvpn restart
  fi
fi 
