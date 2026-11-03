# Ticket 1 — New developer starts Monday, needs a test machine

## 1. What was asked
Hi, we have someone starting on Monday and he needs a test computer
set up. Nothing special, just so he can try things without breaking
anything. Can you write down how to do it so I can do the next one
myself? Thanks


## 2. What was actually needed
1.Operation system
2.How much RAM and CPU comnputer has
3.Whether a snapshot / rollback point is required

## 3. What I did
1.Chose VirtualBox as the hypervisor
2.Created two virtual machines
ubunt67 - Ubuntu Server 26.04.1 LTS, 2 vCPU, 4 GB RAM, 25 GB dynamic disk
winbro - Windows 11 Enterprise Evaluation, 2 vCPU, 4 GB RAM, 64 GB dynamic disk, UEFI + Secure Boot + TPM
3.Put both machines on the same NAT Network so they can talk to each other and still reach the internet.
4.Added a Windows Firewall rule that allows ICMP (ping) without disabling the firewall.
5.Verified connectivity in both directions and to the internet.
6.Took a clean snapshot of the Ubuntu guest named clean-install.
7.Wrote a detailed BUILD.md that a non-technical person can follow.


## 4. Evidence
- `evidence/01-new-vm-wizard.png` — shows the initial setting for the correct work
- `evidence/02-disk-settings.png` — disk is 64 GB
- `evidence/03-network-adapter.png` - Both guests are attached to the same NAT Network
- `evidence/04-guest-uname.txt` - Ubuntu is running (uname -a + lsb_release -a)
- `evidence/05-ping-between-guests.txt` — Evidence that guests can see each other
- `evidence/06-snapshot-list.png` - Snapshot clean-install exists and can be restored

## 5. What I would do differently

I would prepare a one-page “cheat sheet” with only the five most important clicks and the exact numbers (RAM, CPU, disk size). The full BUILD.md is correct, but for a person who is in a hurry it is still long. A one-page version would reduce the chance of skipping a critical step.
