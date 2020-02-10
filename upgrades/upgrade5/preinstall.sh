#!/bin/sh
VERSION=`uci get system.version`
if [ "$VERSION" != "1.4" ];
 then
  logger "ERROR: System version must be 1.4, current: $VERSION"
  exit 1
fi
logger Performing upgrade from 1.4 to 1.5, GUI interface
