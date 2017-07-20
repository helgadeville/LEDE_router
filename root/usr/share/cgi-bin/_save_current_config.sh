#!/bin/sh
files1=`find /etc/config/* -type f`
files2=`find /etc/lighttpd/* -type f | grep -v ".htaccess"`
files3=`find /etc/openvpn/* -type f | grep -v '\(/etc/openvpn/upvpn\|/etc/openvpn/downvpn\|/etc/openvpn/startingvpn\|/etc/openvpn/stoppingvpn\|/etc/openvpn/errorvpn\)'`
files4="/etc/bind/named.conf /etc/dnsmasq.conf"
files="$files1 $files2 $files3 $files4"
tar czf "/root/configurations/custom/$file.cgz" "$files" > /dev/null 2>&1
