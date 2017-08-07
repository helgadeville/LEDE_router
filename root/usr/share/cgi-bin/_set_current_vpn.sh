#!/bin/sh
# accepted parameters: $current
# check file
if [ -z "$current" ];
 then
  exit 1
fi
VPN=`/usr/share/cgi-bin/_vpnstate.sh 2> /dev/null`
BASE="/etc/openvpn/vpn.conf"
current=`echo "$current" | sed 's/\r/\n/g'`
printf %s "$current" > "$BASE"
if [ "$VPN" != "down" ];
 then
  /usr/share/cgi-bin/_vpnrestart.sh
fi
