#!/bin/sh
echo TO PROCEED, YOU NEED TO HAVE EXT4 USB PENDRIVE IN USB PORT
mount /dev/sda1 /mnt
tar -C /overlay/ -c . -f - | tar -C /mnt/ -xf -
sync && umount /dev/sda1
cp /root/etc/config/fstab /etc/config
chmod 444 /etc/config/fstab
dd if=/dev/zero of=/swapfile bs=1024 count=65536
mkswap /swapfile
swapon /swapfile
service fstab enable
readlink -f /etc/rc.d/*fstab
echo REBOOT NOW

