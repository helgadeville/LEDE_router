#!/bin/sh
if [ -n $1 ];
 then
  echo $1 > /etc/lighttpd/.htdigest
fi
