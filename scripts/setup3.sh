#!/bin/sh
# Install some fancy packages for initial VPN setup
opkg update
opkg install bind-server openvpn-openssl nano
# Prepare files and setup buttons
cp /root/etc/openvpn/* /etc/openvpn
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
echo Exiting, REBOOT NOW

