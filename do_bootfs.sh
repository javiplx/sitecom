#!/bin/sh 

VERSION=
FS=
KERNEL=

if [ x${VERSION} = x ] ; then
   echo Set a proper version string
   exit
   fi

rm -f ${VERSION}.bin


dd if=/dev/zero of=initrd.img bs=1M count=3 
mke2fs -F -b 1024 -i 1024 initrd.img 
tune2fs -c 0 -i 0 initrd.img 

mkdir image 
mount -o loop -t auto initrd.img image 
tar cC bootfs . | tar xC image 
tar xC image -f bootfs-skel.tar
echo ${VERSION} > image/etc/sysconfig/config/version
echo 'ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100' >> image/etc/inittab
umount image 
rmdir image 
 
gzip -9 initrd.img 
mv initrd.img.gz bootfs.bin

file=bootfs.bin
md5sum ${file} > ${file}.md5sum
tar -uf ${VERSION}.bin --remove-files ${file} ${file}.md5sum


if [ x$FS = xYES ] ; then
# Create squashfs with the dropbear executables
# Flash is able to fit at least 5012.65 Kbytes (v2.3.33)
mksquashfs squashfs-root filesystem.bin -noI -no-fragments

file=filesystem.bin
md5sum ${file} > ${file}.md5sum
tar -uf ${VERSION}.bin --remove-files ${file} ${file}.md5sum
fi


if [ x$KERNEL = xYES ] ; then
file="uImage"
test -f ${file}.bin && tar -uf ${VERSION}.bin ${file}.bin ${file}.md5sum
fi

