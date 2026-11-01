# Lab Report: VirtualBox Networking & Memory Overcommitment

| Field | Value |
|-------|-------|
| **Student** | Baimagambet |
| **Pair** | Working alone |
| **Host Machine** | Laptop, Windows 10 |
| **CPU** | Intel Core i5 (8 cores / 16 threads) |
| **RAM** | 16 GB |
| **Guests** | Ubuntu Server 26.04 + Windows 10 |
| **Date** | 01.11.2026 |
| **Hypervisor** | Oracle VirtualBox |

---

## What I Did

1. Downloaded **Windows 10 32-bit Enterprise Evaluation** ISO (not from the official Microsoft Evaluation Center).
2. Created VM `lab02-windows` with the following configuration:
   - 2 vCPU
   - 4 GB RAM
   - 64 GB thin (dynamically allocated) disk
   - UEFI + Secure Boot + virtual TPM 2.0
3. Installed Windows 10 and Guest Additions.
4. Created a **NAT Network** (`NatNetwork`, `10.0.2.0/24`) and attached both guests to it.
5. Obtained IP addresses:
   - Ubuntu: `10.0.2.3`
   - Windows: `10.0.2.4`
6. Ping from Ubuntu to Windows timed out because Windows Defender Firewall blocks incoming ICMP Echo Requests by default. Fixed by adding a proper inbound rule (firewall was **not** disabled).

---

## Network Topology
Internet
|
Host laptop 192.168.56.1 (Mobile Hotspot)
|
[VirtualBox NAT Network · 10.0.2.0/24]
/                        \lab01-ubuntu                  lab02-windows
10.0.2.3                      10.0.2.4


### Why NAT Network?

- **NAT Network** in VirtualBox creates its own isolated network.
- A **Bridged** network would place the VMs directly on the physical (LAN) network.

---

## Result — Overcommitment Experiment

| Metric | Before (both VMs off) | After (both VMs with 10 GB) |
|--------|-----------------------|-----------------------------|
| Host RAM in use | 5.5 GB | 15 GB |
| Available | 9.9 GB | 0.30 GB |
| Committed | 12 GB | 30 GB |
| Noticeable changes | — | Stuttering mouse, freezing for a few seconds |

---

## What Did Not Work the First Time

Ping from Ubuntu to Windows timed out.  
Windows Defender Firewall blocks incoming ICMP Echo Requests by default.

**Solution:** Added a specific inbound rule for ICMPv4 Type 8 (instead of disabling the firewall).

---

## Evidence

| File | Description |
|------|-------------|
| `evidence/ipconfig-windows.txt` | Windows IP configuration |
| `evidence/ip-addr-linux.txt` | Ubuntu IP configuration |
| `evidence/ping-both-ways.txt` | Ping both directions + internet connectivity from both guests |
| `evidence/host-memory-before.png` | Host memory with both guests powered off |
| `evidence/host-memory-after.png` | Host memory under overcommitment (both guests allocated 10 GB) |
