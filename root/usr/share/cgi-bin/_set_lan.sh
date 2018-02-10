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
uci set uhttpd.main.listen_http="$2:80"
#
if [ -n "$USE_DHCP" ];
 then
  uci del dhcp.lan.dhcp_option > /dev/null 2>&1
  uci add_list dhcp.lan.dhcp_option="3,$2"
  uci add_list dhcp.lan.dhcp_option="6,$2"
  uci set dhcp.lan.start=$4
  uci set dhcp.lan.limit=$5
fi
#
uci commit
# those services must be rewritten manually
# ftp
if [ -f /etc/vsftpd.conf ];
 then
  sed 's/listen_address.*/listen_address='"$2"'/' /etc/vsftpd.conf > /etc/_vsftpd.conf
  mv /etc/_vsftpd.conf /etc/vsftpd.conf
fi
# restart network
sudo -b /usr/share/cgi-bin/_restart.sh
