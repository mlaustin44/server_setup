zfs create rpool/media
zfs create rpool/config
apt-get install nfs-common nfs-kernel-server
/rpool/media 192.168.40.0/16(rw,sync,no_subtree_check,no_root_squash) 192.168.1.0/24(ro,no_subtree_check)
/rpool/config 192.168.40.0/24(ro,sync,no_subtree_check) 192.168.1.194(rw,no_subtree_check,no_root_squash)

exportfs -a
/etc/init.d/nfs-kernel-server reload

---

Rebuild on disk failure:
zpool status
ls -1 /dev/disk/by-id/ (to find new disk)

zpool replace -f <pool> <old disk in zpool> /dev/disk/by-id/<new disk> (to replace with an entirely new drive)

-f needed for: use '-f' to override the following errors:
/dev/disk/by-id/scsi-35000c50042509acf contains a filesystem of type 'ext4'


root@proxmox:~# zpool status
  pool: rpool
 state: DEGRADED
status: One or more devices could not be used because the label is missing or
	invalid.  Sufficient replicas exist for the pool to continue
	functioning in a degraded state.
action: Replace the device using 'zpool replace'.
   see: http://zfsonlinux.org/msg/ZFS-8000-4J
  scan: scrub repaired 0B in 0 days 00:03:02 with 0 errors on Sun Aug  9 00:27:04 2020
config:

	NAME                              STATE     READ WRITE CKSUM
	rpool                             DEGRADED     0     0     0
	  raidz1-0                        DEGRADED     0     0     0
	    scsi-35000c500573c0633-part3  ONLINE       0     0     0
	    11374149915071450551          UNAVAIL      0     0     0  was /dev/disk/by-id/scsi-35000c50056f79d47-part3
	    scsi-35000c50056f2a1c7-part3  ONLINE       0     0     0
	    scsi-35000c50056a77683-part3  ONLINE       0     0     0


root@proxmox:~# ls -1 /dev/disk/by-id/ 
scsi-35000c50042509acf
scsi-35000c50056a77683
scsi-35000c50056a77683-part1
scsi-35000c50056a77683-part2
scsi-35000c50056a77683-part3
scsi-35000c50056f2a1c7
scsi-35000c50056f2a1c7-part1
scsi-35000c50056f2a1c7-part2
scsi-35000c50056f2a1c7-part3
scsi-35000c500573c0633
scsi-35000c500573c0633-part1
scsi-35000c500573c0633-part2
scsi-35000c500573c0633-part3

root@proxmox:~# zpool replace -f rpool 11374149915071450551 scsi-35000c50042509acf

----
root@proxmox:/dev/disk# zpool offline rpool scsi-35000c50042509acf


1) Make new disk bootable:
    root@proxmox:/dev# sgdisk /dev/disk/by-id/scsi-35000c50056a77683 -R /dev/disk/by-id/scsi-35000c50042509acf

2) 
    root@proxmox:/dev# sgdisk -G /dev/disk/by-id/scsi-35000c50042509acf

root@proxmox:/dev# smartctl -i /dev/sda <- to get the IDs for matching to zpool