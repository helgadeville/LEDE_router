#!/bin/sh
echo TO PROCEED, YOU NEED TO HAVE EXT4 USB PENDRIVE IN USB PORT
echo ON USB DRIVE, FIRST PARTITION EXT3 IS TO BE 3GB, THEN SWAP 100MB AND OPTIONAL STORAGE EXT4
echo ALSO YOU NEED ROOT.TGZ AND EXPORT.TGZ ON THE PENDRIVE - on dev 1
mount /dev/sda1 /mnt
cd /mnt
tar xzf root.tgz
cp /mnt/root/etc/config/fstab /etc/config
chmod 444 /etc/config/fstab
service fstab enable
readlink -f /etc/rc.d/*fstab
tar -C /overlay/ -c . -f - | tar -C /mnt/ -xf -
sync && cd / && umount /dev/sda1
# NEED TO REBOOT
echo REBOOT NOW ! AFTER REBOOT MAKE SURE TO HAVE INTERNET CONNECTION !!! AFTER REBOOT !!!

hint: setup wireless internet connection like this:

uci set dhcp.@dnsmasq[0].rebind_protection=0
uci del network.wan6 2> /dev/null
uci del network.wan.ifname 2> /dev/null
uci del network.wan.disabled 2> /dev/null
uci set wireless.wan=wifi-iface
uci set wireless.wan.device=radio1
uci set wireless.wan.proto=dhcp
uci set wireless.wan.network=wan
uci set wireless.wan.mode=sta
uci set wireless.wan.proto=dhcp
uci del wireless.radio0.disabled 2> /dev/null
uci del wireless.radio1.disabled 2> /dev/null
uci set network.wan=interface
uci set network.wan.proto=dhcp
uci del wireless.wan.ipaddr 2> /dev/null
uci del wireless.wan.netmask 2> /dev/null
uci del network.wan.ipaddr 2> /dev/null
uci del network.wan.netmask 2> /dev/null
uci set network.lan.ifname=eth0
# set whatever SID and KEY is here
uci set wireless.wan.ssid='...'
uci set wireless.wan.encryption='...'
uci set wireless.wan.key='...'
uci del wireless.wan.disabled 2> /dev/null
#optional - otherwise you will have open network LEDE
uci set wireless.default_radio0.disabled=1
# or setup LEDE parameters
uci set wireless.default_radio0.encryption='psk2'
uci set wireless.default_radio0.key='...'
uci set wireless.default_radio0.ssid='LEDE 5Ghz'
uci del wireless.default_radio0.disabled 2> /dev/null
uci set wireless.default_radio1.encryption='psk2'
uci set wireless.default_radio1.key='LedePassw0rd'
uci set wireless.default_radio1.ssid='LEDE 2.4GHz'
uci del wireless.default_radio1.disabled 2> /dev/null
uci commit
