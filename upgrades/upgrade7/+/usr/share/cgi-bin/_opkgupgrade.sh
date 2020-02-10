#!/bin/sh
[ -z "$packages" ] && exit 1
cmd="/bin/opkg upgrade $packages"
eval $cmd
