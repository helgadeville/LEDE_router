#!/bin/sh
VERSION=`uci get system.version`
if [ -n "$VERSION" -a "$VERSION" != "1.2" -a "$VERSION" != "1.3" ];
 then
  logger "ERROR: System version must be 1.2, 1.3 or not set, current: $VERSION"
  exit 1
fi
