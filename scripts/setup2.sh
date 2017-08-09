#!/bin/sh
echo TO PROCEED, YOU NEED TO HAVE EXT4 USB PENDRIVE IN USB PORT
echo ALSO YOU NEED ROOT.TGZ AND EXPORT.TGZ ON THE PENDRIVE
mount /dev/sda1 /mnt
mv /mnt/root.tgz /tmp
cd /tmp
tar xzf root.tgz
mv root/* /root
rmdir root
rm root.tgz
cd /root
mv /mnt/export.tgz /root
cp /root/etc/config/fstab /etc/config
chmod 444 /etc/config/fstab
service fstab enable
readlink -f /etc/rc.d/*fstab
tar -C /overlay/ -c . -f - | tar -C /mnt/ -xf -
sync && umount /dev/sda1
# NEED TO REBOOT
echo REBOOT NOW !
