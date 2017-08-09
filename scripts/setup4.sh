#!/bin/sh
# Install some fancy packages for initial VPN setup
opkg update
opkg install bind-server openvpn-openssl nano sudo patch lighttpd lighttpd-mod-alias lighttpd-mod-auth lighttpd-mod-authn_file lighttpd-mod-cgi lighttpd-mod-evasive coreutils-base64 openssl-util curl iwinfo
# Prepare files and setup buttons
cp -R /root/etc/openvpn/* /etc/openvpn
cp /root/sbin/* /sbin
cp /root/etc/rc.local /etc
mkdir /root/rc.button
mv /etc/rc.button/rfkill /etc/rc.button/rfkill_old
cp /root/etc/rc.button/wps /etc/rc.button
# setup bind/named
cp /root/etc/bind/named.conf /etc/bind
cp /root/etc/config/dhcp /etc/config
cp /root/etc/init.d/netwait /etc/init.d
service netwait enable
service dnsmasq restart
service named restart
# setup VPN
echo Removing shitty examples
uci del openvpn.sample_server
uci del openvpn.sample_client
uci del openvpn.custom_config
echo New OpenVPN instance
# a new OpenVPN instance:
uci set openvpn.vpn=openvpn
uci set openvpn.vpn.enabled=1
uci set openvpn.vpn.config=/etc/openvpn/vpn.conf
echo New network interface
# a new network interface for tun:
uci set network.vpn=interface
uci set network.vpn.proto=none
uci set network.vpn.ifname=tun0
echo New Firewall zone
# a new firewall zone (for VPN):
uci add firewall zone
uci set firewall.@zone[-1].name=vpn
uci set firewall.@zone[-1].input=REJECT
uci set firewall.@zone[-1].output=ACCEPT
uci set firewall.@zone[-1].forward=REJECT
uci set firewall.@zone[-1].masq=1
uci set firewall.@zone[-1].mtu_fix=1
uci add_list firewall.@zone[-1].network=vpn
echo Enable forwarding
# enable forwarding from LAN to VPN:
uci add firewall forwarding
uci set firewall.@forwarding[-1].src=lan
uci set firewall.@forwarding[-1].dest=vpn
# some defaults
uci set wireless.default_radio0.encryption=psk2
uci set wireless.default_radio0.key=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 12`
# disable wan access to router
uci set dropbear.@dropbear[0].Interface=lan
echo Commiting changes
# Finally, you should commit UCI changes:
uci commit
/etc/init.d/openvpn disable
/etc/init.d/openvpn stop
# http server et al
echo Now preparing lighttpd
# patching some stuff
patch /etc/init.d/openvpn /root/patches/openvpn.patch
patch /lib/functions/procd.sh /root/patches/procd.sh.patch
# GUI
echo Now preparing GUI
rmdir /etc/lighttpd/conf.d
rm /etc/sudoers.d 2> /dev/null
mkdir /etc/sudoers.d
cp /root/etc/sudoers.d/http /etc/sudoers.d
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
# setup configurations and stations
mkdir /root/stations
echo "OurHardWorkByTheseWordsGuarded.PleaseDoNotSteal." /root/password
# additional setup for AP + STA
uci set wireless.wan=wifi-iface
uci set wireless.wan.device=radio0
uci set wireless.wan.proto=dhcp
uci set wireless.wan.network=wan
uci set wireless.wan.mode=sta
uci set wireless.wan.disabled=1
uci commit
# configurations
chmod 400 /root/password
mkdir -p /root/configurations/custom 2> /dev/null
file=default /usr/share/cgi-bin/_save_current_config.sh > /dev/null 2>&1
mv /root/configurations/custom/default.cgz /root/configurations
echo create factory configuration
find /bin/* -type f > /tmp/_factory.list
find /etc/* -type f >> /tmp/_factory.list
find /lib/* -type f >> /tmp/_factory.list
find /root/* -type f >> /tmp/_factory.list
find /sbin/* -type f >> /tmp/_factory.list
find /usr/* -type f >> /tmp/_factory.list
find /www/* -type f >> /tmp/_factory.list
tar czf /root/configurations/factory.cgz -T /tmp/_factory.list > /dev/null 2>&1
rm /tmp/_factory.list
# no restart needed 

