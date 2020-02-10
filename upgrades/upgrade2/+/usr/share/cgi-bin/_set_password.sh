#!/bin/sh
# gets old and new passwords (cleartext) and old and new users

# check variables
[ -z "$old" -o -z "$new" -o -z "$oldUser" -o -z "$newUser" ] && exit 1

# check user
FOUND=$( grep '^/:.*:\$p\$' /etc/httpd.conf | cut -f 2 -d ':' )
[ "$oldUser" != "$FOUND" ] && exit 1
logger three
# extract old password
current=`grep '^root:' /etc/shadow | cut -f 2 -d ':'`
salt=`echo "$current" | cut -f 3 -d '$'`
oldHash=`echo "$old" | openssl passwd -1 -salt "$salt" -stdin`
logger four
# check password
[ "$oldHash" != "$current" ] && exit 1
logger five
# change password
printf "$new\n$new\n" | passwd root > /dev/null 2>&1
# and check result
[ $? -gt 0 ] && exit 1
logger six
# rewrite file /etc/httpd.conf
echo "A:*" > /etc/httpd.conf
echo "/:$newUser:\$p\$root" >> /etc/httpd.conf

# restart uhttpd
/etc/init.d/uhttpd reload
