## Windows

I created a disk partition as follows:

1. Opened Disk Management.
2. Created a simple volume in the unallocated space.
3. Formatted it as NTFS.
4. Assigned the drive letter Z:.

Disk style:   MBR
Reason: I checked it from a command stroke using diskpart, listdisk.


## Linux

What I did

1.Layout - lsblk

2. Partition two disks
sudo parted /dev/sdb --script mklabel gpt mkpart primary 1MiB 100% set 1 raid on
sudo parted /dev/sdc --script mklabel gpt mkpart primary 1MiB 100% set 1 raid on

3. Build the mirror
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
cat /proc/mdstat
sudo mdadm --detail /dev/md0

4. Format and mount
sudo mkfs.ext4 /dev/md0
sudo mkdir /mnt/mirror
sudo mount /dev/md0 /mnt/mirror
5. Write a recognisable file and checksum it
 echo "Lab 4 test data - Nurlanov" | sudo tee /mnt/mirror/testfile.txt
sha256sum /mnt/mirror/testfile.txt
6. Fail one disk
sudo mdadm /dev/md0 --fail /dev/sdc1
sudo mdadm /dev/md0 --remove /dev/sdc1
cat /proc/mdstat
sudo mdadm --detail /dev/md0
sha256sum /mnt/mirror/testfile.txt
7. Add the third disk and rebuild
sudo parted /dev/sdd --script mklabel gpt mkpart primary 1MiB 100% set 1 raid on
sudo mdadm /dev/md0 --add /dev/sdd1
watch cat /proc/mdstat
sudo mdadm --detail /dev/md0

> Your colleague deleted the wrong file from the mirror an hour ago. Does RAID 1 help? Why?
>
> Nope, its not gonna. RAID1 is only defends from protects against disk failure, not against the accidental deletion of files.



