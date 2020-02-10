#!/bin/sh
VERSION=`uci get system.version`
if [ "$VERSION" != "1.3" ];
 then
  logger "ERROR: System version must be 1.3, current: $VERSION"
  exit 1
fi
logger Performing upgrade from 1.3 to 1.4, GUI interface
