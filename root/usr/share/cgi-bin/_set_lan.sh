#!/bin/sh
# usage: /usr/share/cgi-bin/_set_lan.sh $lan $ip $mask $dhcpstart $dhcpstop
# check parameters

DHCPIFACE=`uci show dhcp.lan.interface | sed "s/dhcp\.lan\.interface=//g" | sed "s/\'//g"`
if [ "$DHCPIFACE" = "$1" ];
 then
  USE_DHCP=1
fi
if [ -z "$1" -o -z "$2" -o -z "$3" ] \
 || [ -n "$USE_DHCP" -a -z "$4" ] \
 || [ -n "$USE_DHCP" -a -z "$5" ];
 then
  exit 1
fi
#
uci set network.$1.ipaddr=$2
#
if [ -n "$USE_DHCP" ];
 then
  uci set dhcp.lan.dhcp_option=6,$2
  uci set dhcp.lan.start=$4
  uci set dhcp.lan.limit=$5
fi
#
uci commit
# those services must be rewritten manually
# named
sed -n '1h;1!H;${;g;s/listen-on\s*{[^}]*}/listen-on { 127.0.0.1; '"$2"'; }/g;p;}' /etc/bind/named.conf > /etc/bind/_named.conf
mv /etc/bind/_named.conf /etc/bind/named.conf
sed 's/^router\..*/router\.\t14400\tIN\tA\t'"$2"'/' /etc/bind/db.router > /etc/bind/_db.router
mv /etc/bind/_db.router /etc/bind/db.router
# lighttpd
sed -i "/^[[:space:]]*#/!s/server\.bind\s*=.*/server.bind = \""$2"\"/" /etc/lighttpd/lighttpd.conf
# ftp
if [ -f /etc/vsftpd.conf ];
 then
  sed 's/listen_address.*/listen_address='"$2"'/' /etc/vsftpd.conf > /etc/_vsftpd.conf
  mv /etc/_vsftpd.conf /etc/vsftpd.conf
fi
# restart network
lan=yes sudo -E /usr/share/cgi-bin/_restart.sh &
