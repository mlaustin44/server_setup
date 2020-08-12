zfs create rpool/media
zfs create rpool/config
apt-get install nfs-common nfs-kernel-server
/rpool/media 192.168.40.0/16(rw,sync,no_subtree_check,no_root_squash) 192.168.1.0/24(ro,no_subtree_check)
/rpool/config 192.168.40.0/24(ro,sync,no_subtree_check) 192.168.1.194(rw,no_subtree_check,no_root_squash)

exportfs -a
/etc/init.d/nfs-kernel-server reload
