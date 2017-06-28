#!/bin/sh
RADIOS=`uci show wireless | grep "wifi-device" | sed 's/wireless\.// ; s/=.*//'`
WIFI="["
for radio in $RADIOS
 do
  STATE=`uci show wireless.$radio.disabled | sed "s/.*disabled=// ; s/\'//g ; s/0$/enabled/ ; s/1$/disabled/"` ;
  WIFI="$WIFI{\"#\":\"$radio\",\"state\":\"$STATE\"}," ;
done
WIFI=`echo $WIFI | sed 's/,$/]/'`
echo "$WIFI"
