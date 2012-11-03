#!/bin/sh 

dd if=/dev/zero of=initrd.img bs=1M count=3 
mke2fs -F -b 1024 -i 1024 initrd.img 
tune2fs -c 0 -i 0 initrd.img 

echo 'ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100' >> bootfs/etc/inittab

mkdir image 
mount -o loop -t auto initrd.img image 
tar cC bootfs . | tar xC image 
tar xC image -f bootfs-skel.tar
umount image 
rmdir image 
 
sed -i -e '/^ttyS0/ d' bootfs/etc/inittab

gzip -9 initrd.img 
mv initrd.img.gz bootfs.bin

