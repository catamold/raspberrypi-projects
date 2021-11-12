---
title: Back Up Pi SD Card
parent: Raspberry Commands
has_children: false
---

## Back Up Pi SD Card

### Create an image on Windows

**1.** Download [Win32 Disk Imager](https://sourceforge.net/projects/win32diskimager/), which is used to create SD cards (or USB disk) from an image of an operating system downloaded on the Internet, but it is also used **to create an image from an SD card**.

**2.** Insert your **SD card from Pi** in your computer.

**3.** Open **Win 32 Disk Imager**.

**4.** Choose an **image location** and **name for your image**. Make sure to have enough free space on your disk where you want to store the image.

**5.** Then select the **device** you want to back up. You’ll typically only see the **“boot”** partition, but don’t worry, **Win32DiskImager** will create an entire image of all partitions on the device. Make sure that *Read Only Allocated Partitions* is **unchecked**.

**6.** You can now click on **“Read”** to start the copy. The process will start and it can take some time depending on your SD card size.

### Restoring the image to any SD card

**1.** Insert the **SD card** in your computer.

**2.** Choose the **image file**. Pick the **device letter** in the list, and then click on **“Write”** to start the copy.