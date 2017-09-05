#!/bin/sh
VTUN=`ifconfig | grep tun`
[ -n "$VTUN" ] && VTUN=yes
OVPN=`ps | grep open[v]pn`
VSTART=`ps | grep s[t]artingvpn`
VSTOP=`ps | grep s[t]oppingvpn`
VERR=`ps | grep e[r]rorvpn`
if [ -n "$OVPN" -a -n "$VTUN" ];
 then
  VPN=up
 else
  VPN=down
fi
[ -n "$VSTART" ] && VPN=starting
[ -n "$VSTOP" ] && VPN=stopping
[ -n "$VSTART" -a -n "$VSTOP" ] && VPN=error
[ -n "$VERR" ] && VPN=error
echo $VPN
