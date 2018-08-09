#!/bin/sh
[ -z "$name" ] && exit 1
uci set system.@system[0].hostname="$name"
uci set uhttpd.defaults.commonname="$name"
if [ -d /storage/Storage ];
 then
  uci set samba.@samba[0].name="$name"
fi
uci commit
# restart network
sudo -b /usr/share/cgi-bin/_restart.sh
