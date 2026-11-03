# How to start 
1. ## Download any HyperVisor from an official site. e.g (VM Oracle,KVM (Kernel-based Virtual Machine), Microsoft Hyper-V.

For my work i would use VM Oracle.

<img width="1920" height="1100" alt="chrome_KSiVD6hy8K" src="https://github.com/user-attachments/assets/b5716572-cc42-4fff-998d-0e12136602e1" />

Open the installed file

<img width="418" height="548" alt="s5vlSSzx6m" src="https://github.com/user-attachments/assets/23e84b7b-d655-41c1-ae1a-7adb608ac906" />


2. ## Download the two operating system images
 You need two ISO files:

Ubuntu Server
Download the latest LTS version from:
https://ubuntu.com/download/server

Windows 11 Enterprise Evaluation
Go to the Microsoft Evaluation Center, fill in the short form, and download the 64-bit ISO:
https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise

Save both files in your Downloads folder. Do not put them inside any project folder.

3. ## Create the Ubuntu virtual machine

1.Open VirtualBox and click New.
2.Name: lab01-ubuntu
3.Type: Linux → Ubuntu (64-bit)
4.Memory: 4096 MB
5.Processors: 2
6.Hard disk: Create a virtual hard disk now → 25 GB, dynamically allocated
7.Click Finish.

<img width="1018" height="468" alt="01-new-vm-wizard" src="https://github.com/user-attachments/assets/4cd0abe0-2e4a-47dd-ab7e-d20579ee2f86" />

