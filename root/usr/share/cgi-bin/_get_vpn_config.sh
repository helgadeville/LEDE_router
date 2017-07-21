#!/bin/sh
user=`head -n 1 /etc/openvpn/.auth.txt 2>/dev/null`
[ -n "$user" ] && echo "#user=$user"
cat /etc/openvpn/vpn.conf 2> /dev/null