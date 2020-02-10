#!/bin/sh
opkg install uhttpd_2016-10-25-1628fa4b-1_mips_24kc.ipk
[ $? -gt 0 ] && exit 1
opkg remove lighttpd-mod-alias lighttpd-mod-authn_file lighttpd-mod-auth lighttpd-mod-cgi lighttpd-mod-evasive lighttpd
rm -rf /etc/lighttpd
/etc/init.d/uhttpd enable
ip=`uci get network.lan.ipaddr`
uci set uhttpd.main.listen_http="$ip:80"
uci del uhttpd.main.listen_https 2> /dev/null
uci commit
echo "A:*" > /etc/httpd.conf
echo "/:admin:\$p\$root" >> /etc/httpd.conf
