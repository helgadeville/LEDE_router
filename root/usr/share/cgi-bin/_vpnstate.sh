#!/bin/sh
VTUN=`ifconfig | grep tun`
[ -n "$VTUN" ] && VTUN=yes
OVPN=`pgrep openvpn`
VSTART=`ps | grep s[t]artingvpn`
VSTOP=`ps | grep s[t]oppingvpn`
VERR=`ps | grep e[r]rorvpn`
if [ -n "$VSTART" -o -n "$VSTOP" -o -n "$VERR" ];
 then
  [ -n "$VSTART" ] && VPN=starting
  [ -n "$VSTOP" ] && VPN=stopping
  [ -n "$VSTART" -a -n "$VSTOP" ] && VPN=error
  [ -n "$VERR" ] && VPN=error
 else
  if [ -n "$OVPN" -a -n "$VTUN" ];
   then
    VPN=up
   else
    VPN=down
    [ -n "$OVPN" -a -z "$VTUN" ] && VPN=stopping
    [ -z "$OVPN" -a -n "$VTUN" ] && VPN=error
  fi
fi
echo $VPN
