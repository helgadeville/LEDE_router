#!/bin/sh
/bin/opkg -V0 update
/bin/opkg -V0 list-upgradable | cut -f 1 -d ' ' 2>/dev/null | xargs
