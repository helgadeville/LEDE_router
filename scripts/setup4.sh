#!/bin/sh
# Luci etc.
echo Now preparing lighttpd
opkg update
opkg install lighttpd
opkg install lighttpd-mod-access lighttpd-mod-alias lighttpd-mod-auth lighttpd-mod-authn_file lighttpd-mod-cgi lighttpd-mod-evasive
echo Now preparing GUI
rmdir /etc/lighttpd/conf.d
cp /root/etc/lighttpd/lighttpd.conf /etc/lighttpd
cp /root/etc/lighttpd/.htdigest /etc/lighttpd
mkdir -p /usr/share/cgi-bin
cp /root/usr/share/cgi-bin/* /usr/share/cgi-bin
echo TODO
# restart server
/etc/init.d/lighttpd restart

