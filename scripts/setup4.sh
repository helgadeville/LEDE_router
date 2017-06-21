#!/bin/sh
# Luci etc.
echo Now preparing lighttpd
opkg update
opkg install lighttpd
opkg install lighttpd-mod-access lighttpd-mod-alias lighttpd-mod-auth lighttpd-mod-authn_file lighttpd-mod-cgi lighttpd-mod-evasive
echo Now preparing GUI
echo TODO

