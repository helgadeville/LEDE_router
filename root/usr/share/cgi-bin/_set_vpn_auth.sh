#!/bin/sh
[ -z "$1" -o -z "$2" ] && exit 1
echo "$1" > /etc/openvpn/auth
echo "$2" >> /etc/openvpn/auth
