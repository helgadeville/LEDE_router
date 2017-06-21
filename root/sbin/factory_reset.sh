#!/bin/sh
OVERLAY="$( grep ' /overlay ' /proc/mounts )"
if [ -n "$OVERLAY" ]; then
 echo "FACTORY RESET" > /dev/console
 jffs2reset -y && reboot &
fi

