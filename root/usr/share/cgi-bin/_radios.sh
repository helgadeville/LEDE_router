#!/bin/sh
RADIOS=`uci show wireless | grep "wifi-device" | sed 's/wireless\.// ; s/=.*//'`
WIFI="["
for radio in $RADIOS
 do
  STATE=`uci show wireless.$radio.disabled 2> /dev/null | sed "s/.*disabled=// ; s/\'//g ; s/0$/enabled/ ; s/1$/disabled/"` ;
  [ -z "$STATE" ] && STATE=enabled
  WIFI="$WIFI{\"#\":\"$radio\",\"state\":\"$STATE\"}," ;
done
WIFI=`echo $WIFI | sed 's/,$/]/'`
echo "$WIFI"
