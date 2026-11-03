# How to start 
## 1.Download any HyperVisor from an official site. e.g (VM Oracle,KVM (Kernel-based Virtual Machine), Microsoft Hyper-V.

For my work i would use VM Oracle.

<img width="1920" height="1100" alt="chrome_KSiVD6hy8K" src="https://github.com/user-attachments/assets/b5716572-cc42-4fff-998d-0e12136602e1" />

Open the installed file

<img width="418" height="548" alt="s5vlSSzx6m" src="https://github.com/user-attachments/assets/23e84b7b-d655-41c1-ae1a-7adb608ac906" />


 ## 2.Download the two operating system images
 You need two ISO files:

Ubuntu Server
Download the latest LTS version from:
https://ubuntu.com/download/server

Windows 10 Enterprise Evaluation
Go to the Microsoft Evaluation Center, fill in the short form, and download the 32-bit ISO:
https://www.microsoft.com/en-us/evalcenter/download-windows-10-enterprise

Save both files in your Downloads folder. Do not put them inside any project folder.

## 3.Create the Ubuntu virtual machine

1.Open VirtualBox and click New.
2.Name: lab01-ubuntu
3.Type: Linux → Ubuntu (64-bit)
4.Memory: 4096 MB
5.Processors: 2
6.Hard disk: Create a virtual hard disk now → 25 GB, dynamically allocated
7.Click Finish.

<img width="1018" height="468" alt="01-new-vm-wizard" src="https://github.com/user-attachments/assets/4cd0abe0-2e4a-47dd-ab7e-d20579ee2f86" />

## 4.Create the Windows virtual machine

1.Click New again.

2.Name: lab02-windows

3.Type: Microsoft Windows → Windows 11 (64-bit)

4.Tick Skip Unattended Installation

5.Memory: 4096 MB

6.Processors: 2

7.Hard disk: 64 GB, dynamically allocated (do not tick “Pre-allocate Full Size”)

8.Click Finish.

After creation, open Settings → System and check that:

` Enable EFI is ticked `
` TPM is set to v2.0 `
` Secure Boot is enabled `

## 5. Put both machines on the same network
1.In VirtualBox go to File → Tools → Network Manager.

2.Open the NAT Networks tab.

3.Create a new network (name it NatNetwork if it does not exist). Make sure DHCP is enabled.

4.For each virtual machine:

5.Open Settings → Network

6.Adapter 1 → Attached to: NAT Network

7.Name: NatNetwork



! [] (https://github.com/evylit/osarch-baimagambet/blob/main/tickets/ticket1-vm-build-doc/evidence/03-network-adapter.png.png)

Install Ubuntu Server

1.Start lab01-ubuntu.

2.When asked, select the Ubuntu Server ISO.

3.Choose language → English.

4.On the “Keyboard configuration” screen, press Enter.

5.On the network screen, leave the defaults (DHCP) and continue.

6.On the “Guided storage configuration” screen, leave the defaults and continue.

7.Confirm the destructive action (this is a virtual disk, it is safe).

8.Set a username and password (remember them).

9.When asked about SSH, tick Install OpenSSH server.

10.Skip any additional snaps.

11.Wait for installation to finish, then select Reboot Now.

12.After reboot, log in with the credentials you created.

Verify the system:

` uname -a
lsb_release -a `

Step 7. Install Windows 11

1.Start lab02-windows.[cite: 1]

2.Immediately press any key when you see “Press any key to boot from CD or DVD…”.[cite: 1]

3.Choose language and keyboard → Next.[cite: 1]

4.Click I don't have a product key.[cite: 1]

5.Select Windows 11 Enterprise Evaluation.[cite: 1]

6.Accept the licence terms.[cite: 1]

7.Choose Custom: Install Windows only.[cite: 1]

8.Select the virtual disk and click Next.[cite: 1]

9.Wait for installation and several reboots.[cite: 1]

10.When asked to sign in with a Microsoft account, choose Domain join instead (or “Offline account”).[cite: 1]

11.Create a local username and password.[cite: 1]

12.Skip privacy options as much as possible.[cite: 1]

13.After the desktop appears, install Guest Additions:[cite: 1]

* In the VirtualBox menu: Devices → Insert Guest Additions CD image[cite: 1] *
* Run the installer inside Windows and reboot when finished.[cite: 1] *


