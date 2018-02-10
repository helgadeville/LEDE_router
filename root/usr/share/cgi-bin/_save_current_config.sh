#!/bin/sh
find /etc/config/* -type f > /tmp/_current.list
find /etc/openvpn/* -type f | grep -v '\(/etc/openvpn/upvpn\|/etc/openvpn/downvpn\|/etc/openvpn/startingvpn\|/etc/openvpn/stoppingvpn\|/etc/openvpn/errorvpn\|/etc/openvpn/led\)' >> /tmp/_current.list
echo "/etc/httpd.conf" >> /tmp/_current.list
echo "/etc/vsftpd.conf" >> /tmp/_current.list
echo "/etc/samba/smb.conf" >> /tmp/_current.list
echo "/etc/bind/db.router" >> /tmp/_current.list
echo "/etc/dnsmasq.conf" >> /tmp/_current.list
tar czf "/root/configurations/custom/$file.cgz" -T /tmp/_current.list > /dev/null 2>&1
rm /tmp/_current.list
