#!/bin/bash
# This script is writen by YuanzhenZHOU <szrednick@gmail.com> for gentoo easy installation.

echo 
echo "************************************************************************"
echo "  Yuanzhen' s gentoo easy install script ----- PART A"
echo
echo "Now You should finish all the following issue:"
echo " 1. Make os / partition and mounted to /mnt/gentoo/ "
echo " 2. Download stage3-amd64-xxxxxx.tar.bz2 and extracted to /mnt/gentoo"
echo "   e.g.  tar xf stage3-amd64-*.tar.bz2 -C /mnt/gentoo/ "
echo " 3. Download portage-latest.tar.xz  and extracted to /mnt/gentoo/usr/"
echo "   e.g.  tar xf portage-*.tar.xz -C /mnt/gentoo/usr/ "
echo "************************************************************************"
echo 
echo "Are you ready to continue ? [y/n]"

read Keypress
#echo $Keypress

if [ "$Keypress" == "y" ]; then 
  echo "You choose yes" 
else
  if [ $Keypress != "n" ]; then
    echo "Bad choose option!"
    exit 9
  fi
  echo "You choose no"
  exit 1
fi

#echo "COMMENT here to install"
# To prevent damage, we just exit with 0, comment the following line 
# to start installation. 
#exit 0

echo "Stage: Start setup, mount filesystems"
cp /etc/resolv.conf /mnt/gentoo/etc/
cat /proc/mounts >/mnt/gentoo/etc/mtab

mount -o rbind /proc /mnt/gentoo/proc
mount -o rbind /dev /mnt/gentoo/dev
mount -o rbind /sys /mnt/gentoo/sys

cp /etc/resolv.conf /mnt/gentoo/etc/

echo "Stage: Chroot"
chroot /mnt/gentoo /bin/bash; env-update; source /etc/profile; 
