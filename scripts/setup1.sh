#!/bin/sh
echo TO PROCEED, YOU NEED TO HAVE EXT4 USB PENDRIVE IN USB PORT
echo ALSO YOU NEED ROOT.TGZ AND EXPORT.TGZ ON THE PENDRIVE
mount /dev/sda1 /mnt
cd /mnt
tar xzf root.tgz
cp /mnt/root/etc/config/fstab /etc/config
chmod 444 /etc/config/fstab
service fstab enable
readlink -f /etc/rc.d/*fstab
tar -C /overlay/ -c . -f - | tar -C /mnt/ -xf -
sync && cd / && umount /dev/sda1
# NEED TO REBOOT
echo REBOOT NOW ! AFTER REBOOT MAKE SURE TO HAVE INTERNET CONNECTION !!!