#!/bin/sh
# Luci etc.
echo Now preparing lighttpd
opkg update
opkg install lighttpd
opkg install lighttpd-mod-access lighttpd-mod-alias lighttpd-mod-auth lighttpd-mod-authn_file lighttpd-mod-cgi lighttpd-mod-evasive
opkg install coreutils-base64 openssl-util curl
echo Now preparing GUI
rmdir /etc/lighttpd/conf.d
cp /root/etc/lighttpd/lighttpd.conf /etc/lighttpd
cp /root/etc/lighttpd/.htdigest /etc/lighttpd
mkdir -p /usr/share/cgi-bin
cp /root/usr/share/cgi-bin/* /usr/share/cgi-bin
# since no immediate change, no need to restart network
# install WWW
mkdir /tmp/export
cp /root/export.tgz /tmp/export
cd /tmp/export
tar xzf export.tgz
rm -rf /www/*
mv export/* /www
cd /
rm -rf /tmp/export
# restart server
/etc/init.d/lighttpd restart
# setup configurations
echo "OurHardWorkByTheseWordsGuarded.PleaseDoNotSteal." /root/password
chmod 400 /root/password
mkdir /root/configurations
mkdir /root/configurations/custom
file=default.cgz /usr/share/cgi-bin/save_current_config.json > /dev/null 2>&1
mv /root/configurations/custom/default.cgz /root/configurations
echo TODO create factory configuration
find /bin/* -type f > /tmp/_factory.list
find /etc/* -type f >> /tmp/_factory.list
find /lib/* -type f >> /tmp/_factory.list
find /root/* -type f >> /tmp/_factory.list
find /sbin/* -type f >> /tmp/_factory.list
find /usr/* -type f >> /tmp/_factory.list
find /www/* -type f >> /tmp/_factory.list
tar czf /root/configurations/factory.cgz -T /tmp/_factory.list > /dev/null 2>&1
rm /tmp/_factory.list
# additional package and setup for AP + STA
opkg install iwinfo
uci set wireless.wan=wifi-iface
uci set wireless.wan.device=radio0
uci set wireless.wan.proto=dhcp
uci set wireless.wan.network=wan
uci set wireless.wan.mode=sta
uci set wireless.wan.disabled=1
uci commit
# no restart needed since sta will not be run at this moment

