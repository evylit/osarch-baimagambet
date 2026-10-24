Lab 1 — Your first virtual machine
## Summary
| What                        | Value                                              | Details |
|-----------------------------|----------------------------------------------------|----------------|
|Hypervisor                   |Oracle VirtualBox |Licence: https://www.virtualbox.org/wiki/Licensing_FAQ
|Guest OS | Ubuntu Server 26.04.1 LTS (Resolute)|evidence/guest-release.txt
|VM name|lab01-ubuntu |-
|vCPU|2|Host has 8 cores / 12 logical processors (Lab 0)|
|RAM|2 GB (2048 MB)| Host has 16 GB |
|Disk|25 GB|-|
|Network|NAT|-|
|Snapshot|clean-install(default snapshot)|Taken while powered off|
|Break method|Option A - deleted /etc/hostname|evidence/broken.png|
|Rollback|Restored to clean-install |evidence/snapshot-list.png|

## Resource Justification
Host (from Lab 0):

## Evidence
All files are in the evidence/ folder:

- vm-settings.png — CPU, memory and disk as configured
- guest-release.txt — output of lsb_release -a
- broken.png — guest after deleting /etc/hostname
- snapshot-list.png — snapshot list after rollback

## Commands used (inside the guest)

# Check system
lsb_release -a
hostname
nproc
free -h
df -h /
ip -br a

# Break (Option A)
cat /etc/hostname
sudo rm /etc/hostname
cat /etc/hostname
sudo reboot

# After rollback
cat /etc/hostname
hostname
