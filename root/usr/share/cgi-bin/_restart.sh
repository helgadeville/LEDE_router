#!/bin/sh
sleep 1
/etc/init.d/network restart > /dev/null 2>&1
/etc/init.d/netwait start > /dev/null 2>&1
/etc/init.d/firewall reload > /dev/null 2>&1
/etc/init.d/dnsmasq reload > /dev/null 2>&1
/etc/init.d/named restart > /dev/null 2>&1
/etc/init.d/uhttpd reload > /dev/null 2>&1
/etc/init.d/dropbear reload > /dev/null 2>&1

[ -f /etc/vsftpd.conf ] && /etc/init.d/vsftpd restart > /dev/null 2>&1
[ -f /etc/samba/smb.conf ] && /etc/init.d/vsftpd restart > /dev/null 2>&1
