#!/bin/sh
logger Setting DNS servers for dnsmasq
uci del dhcp.@dnsmasq[0].port 2> /dev/null
uci set dhcp.@dnsmasq[0].readethers='0'
dnss=`awk '/forwarders/,/}/' /etc/bind/named.conf | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0
-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"`
uci del network.wan.dns > /dev/null 2>&1
for dns in $dnss; do uci add_list network.wan.dns="$dns"; done
uci set network.wan.peerdns="0"
ipaddr=`uci get network.lan.ipaddr 2> /dev/null`
if [ -n "$ipaddr" ]
 then
  uci del dhcp.lan.dhcp_option > /dev/null 2>&1
  uci add_list dhcp.lan.dhcp_option="3,$ipaddr"
  uci add_list dhcp.lan.dhcp_option="6,$ipaddr"
fi
uci commit
logger Stopping bind
/etc/init.d/named stop
/etc/init.d/named disable
logger Uninstalling bind
opkg remove bind-server bind-libs
rm -rf /etc/bind
logger Restarting dnsmasq
/etc/init.d/dnsmasq restart
logger Fixing file privs
chmod 755 /usr/share/cgi-bin/*
chmod 500 /usr/share/cgi-bin/_*
logger Creating new default configuration
ln -s /usr/share/cgi-bin /www/cgi-bin
rm /root/configurations/custom/*
rm /root/configurations/default.cgz
file=default /usr/share/cgi-bin/_save_current_config.sh > /dev/null 2>&1
mv /root/configurations/custom/default.cgz /root/configurations
find /bin/* -type f > /tmp/_factory.list
find /etc/* -type f >> /tmp/_factory.list
find /lib/* -type f >> /tmp/_factory.list
find /root/* -type f >> /tmp/_factory.list
find /sbin/* -type f >> /tmp/_factory.list
find /usr/* -type f >> /tmp/_factory.list
find /www/* -type f >> /tmp/_factory.list
rm /root/configurations/factory.cgz
tar czf /root/configurations/factory.cgz -T /tmp/_factory.list > /dev/null 2>&1
rm /tmp/_factory.list
uci set system.version='1.4'
uci commit
logger Update to 1.4 finished
