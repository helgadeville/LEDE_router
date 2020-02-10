#!/bin/sh
VERSION=`uci get system.version`
if [ "$VERSION" != "1.5" -a "$VERSION" != "1.6" ];
 then
  logger "ERROR: System version must be 1.5, current: $VERSION"
  exit 1
fi
logger Performing upgrade from 1.5 to 1.6, GUI interface
