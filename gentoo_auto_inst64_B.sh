#!/bin/bash
# This script is writen by YuanzhenZHOU <szrednick@gmail.com> for gentoo easy installation.

NEW_HOSTNAME="amddt"
NEW_IPADDR="192.168.1.7 netmask 255.255.255.0 "
NEW_GATEWAY="192.168.1.9"
NEW_DNS="61.177.7.1"
GENTOO_MIRRORS="http://mirrors.163.com/gentoo"
GENTOO_RSYNC="rsync://192.168.3.61/gentoo-portage"

echo 
echo "************************************************************************"
echo "  Yuanzhen' s gentoo easy install script ----- PART B"
echo
echo "Now You should finish all the following issue:"
echo " 1. chroot to /mnt/gentoo/ "
echo " 2. Confirm to install gentoo"
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

export PS1="(zyz_chroot) $PS1"

echo "Stage: Rebuild" 
cat >/etc/make.conf <<EOF
CHOST="x86_64-pc-linux-gnu"
CFLAGS="-march=native -O2 -pipe"
CXXFLAGS="${CFLAGS}"
MAKEOPTS="-j5"
USE="bash-completion java6 cjk threads"
ACCEPT_LICENSE="*"
#SYNC="$GENTOO_RSYNC"
GENTOO_MIRRORS="$GENTOO_MIRRORS"
EOF

emerge --sync
emerge -uD system

echo "Stage: Locale"
cat >/etc/locale.gen <<EOF
en_US ISO-8859-1
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
EOF
locale-gen

echo "Stage: Timezone"
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone

echo "Stage: Mounts"
cat >/etc/fstab <<EOF
/dev/sda1         /             ext4       noatime               0  1
#/dev/sda2         none          swap       sw                    0  0
 
# Logical volumes
#/dev/vg/data      /data         ext4       noatime,nodiratime    0  2
 
/dev/cdrom        /mnt/cdrom    auto       noauto,ro             0  0

proc              /proc         proc       defaults              0  0
shm               /dev/shm      tmpfs      nodev,nosuid,noexec   0  0
EOF

echo "Stage: emerge kernel..."
emerge gentoo-sources
emerge genkernel 
echo "YOU NEED CONFIG the KERNEL!!!"
genkernel --lvm --disklabel --menuconfig all
echo "Stage: emerge kernel done."


echo "Stage: Network"
cat >/etc/conf.d/net <<EOF
config_eth0="$NEW_IPADDR"
routes_eth0="default via $NEW_GATEWAY"
dns_servers_eth0=("$NEW_DNS")
EOF

cd /etc/init.d
ln -s net.lo net.eth0
rc-update add net.eth0 default
rc-update add sshd default

emerge grub

cat >/boot/grub/grub.conf <<EOF
default 0
timeout 5
splashimage=(hd0,0)/boot/grub/splash.xpm.gz
 
title Gentoo Linux 3.x.x
root (hd0,0)
kernel /boot/kernel-genkernel-x86_64-3.5.7-gentoo real_root=/dev/sda3 panic=60
initrd /boot/initramfs-genkernel-x86_64-3.5.7-gentoo
EOF

echo "NOTICE: NOW please:"
echo "1. Change root password"
echo "2. Install GRUB to MBR"
echo ""
