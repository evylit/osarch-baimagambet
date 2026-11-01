|Student|Baimagambet|
|Pair|Working alone|
|Machine|Laptop, Windows 10 host, Inter core i5  (8 cores / 16 threads), 16 GB RAM|
|Guest|Ubuntu server 26.04 + Windows 10|
|Date|01.11.2026|
|Hyperbisor|Oreacle Virtual Box|

# What i did
1.Downloaded windows 10 32bit Enterprise Evaluation ISO definetely not from offcial Microsoft Evaluation Center.
2.Created VM 'lab02-windows'
- 2 vCPU
- 4 GB RAM
- 64 GB thin (dynamically allocated) disk
- UEFI + Secure Boot + virtual TPM 2.0\
3. Imstalled windows 10 and guest additions
4.Created a NAT Network (NatNetwork, 10.0.2.0/24) and attached both guests to it
5.Obtained IP addresses
  - Ubuntu:10.0.2.3
  - Windows:10.0.2.4
6.Ping from Ubuntu to Windows timed out because Windows Defender Firewall blocks incoming ICMP Echo Requests by default. Fixed with the proper rule (firewall was not disabled)

              Internet
                 |
      Host laptop 192.168.56.1 (Mobile Hotspot)
                 |
     [VMware NAT · VMnet8 · 192.168.80.0/24]
          /                        \
lab01-ubuntu                  lab02-windows
 10.0.2.3                  10.0.2.4
##Why NAT Network?
- NAT in VBox gives its own isolated network.
- Bridged network places a device directly on your physical (LAN)

## Result — Overcommitment experiment 
| |Before (both VMs off)|After (both Vms 10gb)|
|Host RAM in use|5.5 GB|15 GB|
|Availaible|9.9 GB|0.30|
|Commited|12 GB|30|
|Noticable changes|   | Stutteering mouse, freezing for a few seconds. |



