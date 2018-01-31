#!/bin/sh
GW=`ip r | grep default | cut -d ' ' -f 3`
[ -n "$GW" ] && ping -q -w 1 -c 1 "$GW" > /dev/null 2>&1
[ -n "$GW" -a $? -eq 0 ] && echo online || echo offline
