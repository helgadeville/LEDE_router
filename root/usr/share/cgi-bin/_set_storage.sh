#!/bin/sh
# usage: /usr/share/cgi-bin/_set_lan.sh $lan $ip $mask $dhcpstart $dhcpstop
# check parameters
if [ -z "$1" ];
 then
  exit 1
fi

if [ "$1" = "0" ];
 then
  uci set samba.@sambashare[0].read_only='no'
  sed 's/write_enable.*/write_enable=YES/ ; s/anon_upload_enable.*/anon_upload_enable=YES/ ; s/anon_mkdir_write_enable.*/anon_mkdir_write_enable=YES/ ; s/anon_other_write_enable.*/anon_other_write_enable=YES/ ; s/anon_world_readable_only.*/anon_world_readable_only=NO/' /etc/vsftpd.conf
 else
  uci set samba.@sambashare[0].read_only='yes'
  sed 's/write_enable.*/write_enable=NO/ ; s/anon_upload_enable.*/anon_upload_enable=NO/ ; s/anon_mkdir_write_enable.*/anon_mkdir_write_enable=NO/ ; s/anon_other_write_enable.*/anon_other_write_enable=NO/ ; s/anon_world_readable_only.*/anon_world_readable_only=YES/' /etc/vsftpd.conf > /etc/_vsftpd.conf
fi
uci commit
mv /etc/_vsftpd.conf /etc/vsftpd.conf

/etc/init.d/samba restart
/etc/init.d/vsftpd restart
