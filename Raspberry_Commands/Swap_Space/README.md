---
title: Swap Space
parent: Raspberry Commands
has_children: false
---

## Swap Space
This is a tip for improving the performance of especially web browsers on the Raspberry Pi. Web browsers, like Chromium (the open source parts of Google’s Chrome browser) are notoriously hungry for memory. While swap is not as fast as RAM, and also somewhat taxing on your microSD card, it will allow certain things to work which would have crashed or frozen before. **The default swap size is 100 MB.**

**Keep in mind that swap is using your microSD card – since a lot of data gets written and read from the SD card that way, the tear & wear on it is higher. This is a price you pay for extending your RAM. Another price you pay is that the applications will work slower once the real RAM on your Pi has been saturated, as accessing RAM is much faster than accessing the microSD card.**

1. Before we can increase our Raspberry Pi’s swap file, we must first temporarily stop it. The swap file cannot be in use while we increase it.

`sudo dphys-swapfile swapoff`

2. Next, we need to modify the swap file configuration file. We can open this file using **nano** by using the command below. Within this config file, find the following line of text `CONF_SWAPSIZE=100` and increase or decrease the swap file (e.g. `CONF_SWAPSIZE=1024`).

`sudo nano /etc/dphys-swapfile`

3. We can now re-initialize the Raspberry Pi’s swap file by running the command below. Running this command will delete the original swap file and recreate it to fit the newly defined size.

`sudo dphys-swapfile setup`

4. With the swap now recreated to the newly defined size, we can now turn the swap back on. To start the operating systems swap system, run the following command.

`sudo dphys-swapfile swapon`

5. While the new swapfile is now switched on, programs will not know that this new memory exists until they restart.  If you want all programs to be reloaded with access to the new memory pool, then the easiest way is to restart your device. To restart your Raspberry Pi, all you need to do is run the command below.

`sudo reboot`