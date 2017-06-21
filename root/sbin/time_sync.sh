#!/bin/bash
ubus -t 10 wait_for network.interface.wan
NTP=`nslookup time.google.com 8.8.8.8 | sed -n "/Address 1:/s/^.*:.//p"`
[ -n "$NTP" ] && ntpd -q -p "$NTP"
