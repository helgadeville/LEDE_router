#!/bin/sh
MODEL=`cat /proc/cpuinfo | grep machine | sed 's/^[^:]*:[ ]*//'`
MODEL_SHORT=`cat /proc/cpuinfo | grep machine | sed 's/^[^:]*:[ ]*// ; s/TP-LINK[ ]*//' ; s/ .*//`
mkswap /dev/sda2
swapon /dev/sda2
# perform copy
# mount whichever device is appropriate /dev/sda1 or /dev/sda3
mount /dev/sda3 /mnt
mv /overlay/root.tgz /mnt
mv /overlay/export.tgz /mnt
cd /mnt
tar xzf root.tgz
mv root/* /root/
rmdir root
rm root.tgz
rm -rf lost+found
mv export.tgz /root
cd /root
# MUST HAVE INTERNET
echo INTERNET REQUIRED HERE !!!!!!
# Install some fancy packages for initial VPN setup
opkg update
opkg install openvpn-openssl nano sudo patch uhttpd coreutils-base64 openssl-util curl iwinfo swconfig
# Prepare files and setup buttons
cp -R /root/etc/openvpn/* /etc/openvpn
mkdir /etc/openvpn/configurations
chmod 755 /etc/openvpn/configurations
cp /root/sbin/* /sbin
cp /root/etc/rc.local /etc
mkdir /root/rc.button
mv /etc/rc.button/rfkill /etc/rc.button/rfkill_old
cp /root/etc/rc.button/* /etc/rc.button/
mkdir /etc/hotplug.d/button
cp /root/etc/hotplug.d/button/* /etc/hotplug.d/button/
cp /root/etc/config/dhcp /etc/config
cp /root/etc/init.d/netwait /etc/init.d
/etc/init.d/netwait enable
echo Change LAN address to 10.10.10.10
# change lan address to 10.10.10.10
uci set network.lan.ipaddr=10.10.10.10
# remove wan6 configuration
uci del network.wan6
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
# disable VPN autostart
/etc/init.d/openvpn disable
/etc/init.d/openvpn stop
# http server et al
echo Now preparing uhttpd
# patching some stuff
patch /etc/init.d/openvpn /root/patches/openvpn.patch
patch /lib/functions/procd.sh /root/patches/procd.sh.patch
# GUI
echo Now preparing GUI
rm /etc/sudoers.d 2> /dev/null
mkdir /etc/sudoers.d
cp /root/etc/sudoers.d/http /etc/sudoers.d
echo "A:*" > /etc/httpd.conf
echo "/:admin:\$p\$root" >> /etc/httpd.conf
uci del uhttpd.main.listen_https 2> /dev/null
mkdir -p /usr/share/cgi-bin
cp /root/usr/share/cgi-bin/* /usr/share/cgi-bin
chmod 555 /usr/share/cgi-bin/*
chmod 500 /usr/share/cgi-bin/_*
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
ln -s /usr/share/cgi-bin /www/cgi-bin
# restart server
/etc/init.d/uhttpd enable
# setup configurations and stations
mkdir /root/stations
echo "OurHardWorkByTheseWordsGuarded.PleaseDoNotSteal." /root/password
# enable radio
uci del wireless.radio0.disabled 2> /dev/null
# remove password from Wifi
uci set wireless.default_radio0.encryption=none
uci del wireless.default_radio0.key 2> /dev/null
uci del wireless.default_readio0.disabled 2> /dev/null
# additional setup for AP + STA
uci set wireless.wan=wifi-iface
uci set wireless.wan.device=radio1
uci set wireless.wan.proto=dhcp
uci set wireless.wan.network=wan
uci set wireless.wan.mode=sta
uci set wireless.wan.disabled=1
# FINAL TOUCH : setup WPS led
uci del system.led_wps 2> /dev/null
uci set system.led_wps=led
uci set system.led_wps.name='WPS'
uci set system.led_wps.sysfs='tp-link:green:wps'
uci set system.led_wps.default=0
# prepare SAMBA with default settings - if partition exists
if [ -b /dev/sda3 ];
 then
  opkg install samba36-server samba36-client vsftpd
  # prepare ftp
  cp /root/etc/vsftpd.conf /etc
  /etc/init.d/vsftpd enable
  # prepare samba
  uci set samba.@samba[0].name="$MODEL_SHORT"
  uci set samba.@samba[0].workgroup='ROUTERS'
  uci set samba.@samba[0].description='Router shared storage'
  uci set samba.@samba[0].charset='UTF-8'
  uci set samba.@samba[0].homes=0
  uci set samba.@samba[0].interface='lan'
  # share
  uci add samba sambashare
  uci set samba.@sambashare[-1].name='Storage'
  uci set samba.@sambashare[-1].path='/storage/Storage'
  uci set samba.@sambashare[-1].guest_ok=yes
  uci set samba.@sambashare[-1].create_mask=666
  uci set samba.@sambashare[-1].dir_mask=777
  uci set samba.@sambashare[-1].read_only=no
  # prepare storage
  mkdir /storage
  mount /dev/sda3 /storage
  mkdir /storage/Storage
  chmod 777 /storage/Storage
  umount /dev/sda3
  mkdir /home
  ln -s /storage /home/ftp
  chmod 777 /home/ftp
  chmod 755 /storage
  # enable samba
  /etc/init.d/samba enable
  # add storage to auto mount
  uci add fstab mount
  uci set fstab.@mount[-1].target='/storage'
  uci set fstab.@mount[-1].device='/dev/sda3'
  uci set fstab.@mount[-1].fstype='ext4'
  uci set fstab.@mount[-1].options='rw,noatime'
  uci set fstab.@mount[-1].enabled='1'
  uci set fstab.@mount[-1].enabled_fsck='0'
fi
# FINAL COMMIT FOR UCI CHANGES !!!
uci set system.version='1.4'
uci commit
# set registry
RD=`uci show wireless | grep 'wifi-device' | sed 's/wireless\.//' | sed 's/=wifi-device//'`
for radio in $RD
 do
  uci set wireless.$radio.country='00'
done
# CREATE configurations
chmod 400 /root/password
mkdir -p /root/configurations/custom 2> /dev/null
chmod 755 /root/configurations/custom
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
# CLEANUP ROOT
rm -rf /root/etc
rm /root/export.tgz
rm -rf /root/patches
rm -rf /root/sbin
rm -rf /root/usr
# REBOOT IS A GOOD IDEA NOW
reboot

