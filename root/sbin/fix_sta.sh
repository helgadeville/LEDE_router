#!/bin/sh
#
# Fix loss of AP when STA (Client) mode fails by reverting to default
# AP only configuration. Default AP configuration is assumed to be in
# /etc/config/wireless.ap-only
#
 
 
TIMEOUT=30
SLEEP=3
 
sta_err=0
 
while [ $(iwinfo | grep -c "ESSID: unknown") -ge 1 ]; do
   let sta_err=$sta_err+1
   if [ $((sta_err * SLEEP)) -ge $TIMEOUT ]; then
     logger Reverting configuration to normal AP - wireless client can not be started - 
     uci set wireless.wan.disabled=1
     uci commit
     /etc/init.d/network restart
     /etc/init.d/netwait start
     /etc/init.d/firewall reload
     /etc/init.d/dnsmasq reload
     /etc/init.d/named restart
     /etc/init.d/dropbear restart
#    uncomment the following lines to try AP+STA after reboot
     sleep 3
     uci del wireless.wan.disabled 2> /dev/null
     uci commit
     break
   fi
 
   sleep $SLEEP
 
done
