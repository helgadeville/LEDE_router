#!/bin/sh
if [ -z "$file" ];
 then
  user=`head -n 1 /etc/openvpn/.auth.txt 2>/dev/null`
  [ -n "$user" ] && echo "#user=$user"
  pass=`head -n 2 /etc/openvpn/.auth.txt 2>/dev/null`
  [ -n "$pass" ] && echo "#pass=$pass"
  cat /etc/openvpn/vpn.conf 2> /dev/null
 else
  cat "/etc/openvpn/configurations/$file" 2> /dev/null
fi
