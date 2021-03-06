#!/bin/sh
logger Fixing file privs
chmod 755 /usr/share/cgi-bin/*
chmod 500 /usr/share/cgi-bin/_*
logger Setting country privs
RD=`uci show wireless | grep 'wifi-device' | sed 's/wireless\.//' | sed 's/=wifi-device//'`
for radio in $RD
 do
  uci set wireless.$radio.country='00'
done
uci commit
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
uci set system.version='1.6'
uci commit
logger Update to 1.6 finished
