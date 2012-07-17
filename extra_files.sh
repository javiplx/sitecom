#!/bin/sh

tar -cf bootfs-skel.tar -C bootfs --exclude dev/root dev \
	etc/sysconfig/config/smb/folders \
	etc/sysconfig/config/smb/private \
	etc/sysconfig/config/smb/shares \
	home mnt proc root sys tmp \
	usr/local usr/share/system var/spool/system

