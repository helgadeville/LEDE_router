#!/bin/sh
# accepted parameters: $file $factory
# check file
if [ -z "$current" ];
 then
  exit 1
fi
VPN=`/usr/share/cgi-bin/_vpnstate.sh`
BASE="/etc/openvpn/vpn.conf"
echo "$current" > "$BASE"
if [ "$VPN" != "down" ];
 then
  /usr/share/cgi-bin/_vpnrestart.sh
fi
