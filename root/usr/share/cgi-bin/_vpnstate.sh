#!/bin/sh
VTUN=`ifconfig | grep tun`
OVPN=`pgrep openvpn`
VSTART=`pgrep startingvpn`
VSTOP=`pgrep stoppingvpn`
VERR=`pgrep errorvpn`
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
    [ -n "$OVPN" -o -n "$VTUN" ] && VPN=error
  fi
fi
echo $VPN
