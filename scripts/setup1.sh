#!/bin/sh
echo Change LAN address to 10.10.10.10
# change lan address to 10.10.10.10
uci set network.lan.ipaddr=10.10.10.10
# remove wan6 configuration
uci del network.wan6
uci commit
# reload network
echo *** YOU NEED TO RECONNECT NOW ***
/etc/init.d/network reload

