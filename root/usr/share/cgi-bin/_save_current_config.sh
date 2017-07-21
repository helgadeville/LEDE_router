#!/bin/sh
find /etc/config/* -type f > /tmp/_current.list
find /etc/lighttpd/* -type f | grep -v ".htaccess" >> /tmp/_current.list
find /etc/openvpn/* -type f | grep -v '\(/etc/openvpn/upvpn\|/etc/openvpn/downvpn\|/etc/openvpn/startingvpn\|/etc/openvpn/stoppingvpn\|/etc/openvpn/errorvpn\)' >> /tmp/_current.list
echo "/etc/bind/named.conf" >> /tmp/_current.list
echo "/etc/dnsmasq.conf" >> /tmp/_current.list
tar czf "/root/configurations/custom/$file.cgz" -T /tmp/_current.list > /dev/null 2>&1
rm /tmp/_current.list
