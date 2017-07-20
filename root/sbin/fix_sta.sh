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
     uci set network.wireless.wan.disabled=1
     uci commit
     wifi up
#    uncomment the following lines to try AP+STA after reboot
     sleep 3
     uci set network.wireless.wan.disabled=0
     uci commit
     break
   fi
 
   sleep $SLEEP
 
done
