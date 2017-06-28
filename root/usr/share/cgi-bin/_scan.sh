#!/bin/sh
DEV="wlan0"
SCAN=`iw $DEV scan | grep 'BSS\|SSID\|signal\|Privacy\|WPA\|RSN'`
echo "$SCAN" | sed 's/BSS/MAC:/g ; s/(on.*//g ; s/^[ \t]*//g ; s/RSN:.*/WPA2/g'
