#!/bin/sh
# upload root.tgz to /root
#!/bin/sh
dd if=/dev/zero of=/swapfile bs=1024 count=65536
mkswap /swapfile
swapon /swapfile
service fstab enable
readlink -f /etc/rc.d/*fstab
# NEED TO REBOOT
echo REBOOT NOW



