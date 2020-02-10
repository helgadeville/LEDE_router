#!/bin/sh
VERSION=`uci get system.version`
if [ "$VERSION" != "1.6" ];
 then
  logger "ERROR: System version must be 1.6, current: $VERSION"
  exit 1
fi
logger Performing upgrade from 1.6 to 1.7, GUI interface
