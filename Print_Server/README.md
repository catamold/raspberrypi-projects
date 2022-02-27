---
title: Print Server
has_children: true
nav_order: 2
---

## Print Server

### Installing the Raspberry Pi Print Server Software
**1.** To get started we should first update the Raspberry Pi to ensure we are running the latest software. You can do this by entering the following commands into the terminal:
```
sudo apt-get update
sudo apt-get upgrade
```

**2.** Once the Raspberry Pi has been updated, we can now start installing the print server software. In this case, we will be installing CUPS, this software manages printers connected via USB or over the network, and it has the bonus of providing a management interface that you can view over the internet.

Install this software by typing the following command into the terminal:

`sudo apt-get install cups`

**3.** When CUPS has finished installing there are a few extra things that we will need to do.

The first thing to do is add the **pi** user to the **lpadmin** group. This group will allow the pi user to access the administrative functions of CUPS without needing to use the superuser:

`sudo usermod -a -G lpadmin pi`

**4.** There is one other thing that we will need to do to CUPS to ensure that it runs well on the home network and that is to make CUPS accessible across your whole network, at the moment it will block any non-localhost traffic.

We can get it to accept all traffic by running the following two commands:
```
sudo cupsctl --remote-any
sudo systemctl restart cups
```

**5.** Now we should be able to access the Raspberry Pi print server from any computer within the network. If you are unsure on what your Raspberry Pi’s local IP Address is then you can make use of the following command:

`hostname -I`

**6.** Once you have your Raspberry Pi’s IP Address, go to the following web address in your favorite web browser, make sure to swap out my IP address (192.168.1.105) with your own, or instead you can replace it with **localhost**:

`http://192.168.1.105:631`

Below we look at setting up SAMBA correctly to ensure Windows can properly identify the print server running on the Raspberry Pi. We will also show you how to add a printer using the CUPS interface.

### Setting up SAMBA for the Pi Print Server
If you intend on using your print server with Windows, then setting up SAMBA correctly is necessary. We will need to install SAMBA and make a few changes to its configuration to ensure that it runs correctly and utilizes the CUPS print drivers.

**1.** Now firstly, we should make sure we have SAMBA installed, the easiest way to do this is simply run the install command in the terminal. We can do that by entering the following command in the terminal:

`sudo apt-get install samba`

**2.** With SAMBA now installed to our Raspberry Pi, we will need to open its configuration file and make several edits, and we can open the file with the following command:

`sudo nano /etc/samba/smb.conf`

**3.** Now with the file open, we will need to scroll to the bottom of the file. The quickest way to do this is to use **Ctrl+V**.
```
# CUPS printing.  
[printers]
comment = All Printers
browseable = no
path = /var/spool/samba
printable = yes
guest ok = yes
read only = yes
create mask = 0700

# Windows clients look for this share name as a source of downloadable
# printer drivers
[print$]
comment = Printer Drivers
path = /var/lib/samba/printers
browseable = yes
read only = no
guest ok = no
```
Save the file by pressing **Ctrl+X** and then pressing **Y** and then **Enter**.

**4.** We can now restart SAMBA to get it to load in our new configuration, to do that, all we need to do is type the following command into the terminal:

`sudo systemctl restart smbd`

### Adding a printer to CUPS
**1.** Adding a printer to CUPS is a rather simple process, but first, we need to load up the CUPS web interface. If you’re unsure what your Raspberry Pi’s IP address is, then run the following command in the terminal:

`hostname -I`

**2.** Once you have your Raspberry Pi’s IP address, go to the following web address in your favorite web browser, make sure to swap out my IP address (192.168.1.105) with your own:

`https://192.168.1.105:631`

Or you can simply type:

`https://localhost:631`

**3.** You should be greeted with the following screen, on here we need to click **"Administration"**.

**4.** Now that we are on the administration screen, we need to click on the **"Add Printer"** button.

**5.** With the **"Add Printer"** screen now loaded, we can select the printer we want to set up. In our case, that is the HP LaserJet 1018 printer. Once selected, press the **"Continue"** button.

If your printer is not showing up on this screen, ensure that you have plugged it into one of the USB ports on the Raspberry Pi and that it is turned on.

You may need to restart your Raspberry Pi if it is still refusing to show up, ensure the printer is turned on and plugged in when you restart.

**6.** On this screen, you need to select the model of your printer. CUPS will try and automatically detect the model and pick the correct driver.

However, in some cases this will not function correctly, so you will have to go through the list yourself and find the most relevant driver.

If the printer is not listed here (HP LaserJet 1018), execute the following series of terminal commands, then disconnect the USB cable of the printer, count to five and reconnect it:
```
sudo apt-get update

sudo apt-get remove hplip cups-filters cups hplip-data system-config-printer-udev

sudo rm -v -rf /usr/share/hplip

sudo apt-get install printer-driver-foo2zjs printer-driver-foo2zjs-common

sudo apt-get install tix groff dc cups cups-filters

sudo getweb 1018

```

Once you are satisfied everything is correct, click the **"Add Printer"** button.

**7.** Now, this is the last screen you need to deal with before the printer is successfully added, you can set the name and description to whatever you want. It is handy setting the location if you have multiple printers in your house that you need to deal with.

Also, make sure you enable **"Share This Printer"**, otherwise other computers will not be able to access it.

Once you are happy with the settings, feel free to press **"Continue"**.

**8.** The final screen that you will be presented with after setting up your printer is pictured right below. This screen allows you to change a few of the printer’s specific settings. Such as the page print size, the print quality, and various other options.

Now we will go over how to add our newly setup Raspberry Pi print server to Windows. It should be a relatively easy process thanks to setting up SAMBA earlier in the tutorial.

**9.** In case the Model of the printer ends with **hpcups 3.21.2, requires proprietary plugin**, then open the terminal in **sudo su** mode and type the following command and follow the intructions on client:

`hp-setup -i`

### Adding a Raspberry Pi Print Server to Windows
**1.** Adding a CUPS printer to Windows can be a bit of work, mainly because you need to select the driver for Windows to be able to connect to and understand the printer.

To get started, first go to the network page in Windows, one of the fastest ways to get to this is to load up **"My Computer"** or **"This PC"** and click on **"Network"** in the sidebar. Once there you should have a screen that looks like the one below with your Raspberry Pi’s hostname there, in my case it is **RASPBERRYPI**.

If you can no longer access network files, chances are your device is still using the SMB version 1 protocol, which is no longer supported on Windows 10. Here's a workaround to regain access to your files.

1. Open **Control Panel**.

2. Click on **Programs**.

3. Click on **Turn Windows features on or off** link.

4. Expand the **SMB 1.0/CIFS File Sharing Support** option.

5. Check the **SMB 1.0/CIFS Client** option.

6. Click the **OK** button.

7. Click the **Restart now** button.

After completing these steps, you'll once again be able to see and connect to network devices running the old protocol on your local network from your Windows 10 computer.

Of course, you should only use these steps as a temporary solution to regain access to your files stored on the network. Ideally, if you're saving your data on a drive connected to a router with file sharing capabilities or NAS, you should contact the device manufacturer for specific instructions to update the device to a version that supports SMBv2.02 or later.

If you can't access the shared folder because your organization's security policies block, then open **Run** from windows and type `gpedit.msc`. Then on the left side of the **"Local Group Policy Editor"** window, expand **Administrative Templates->Network->Lanman Workstation**, then double click on **"Enable insecure guest logons"** and set it to **"Enabled"**. 

**2.** Double click on your Raspberry Pi’s share, it may ask for a username and password. If just pressing enter doesn’t work, try entering pi as the username.

You should now be greeted with a screen displaying the printers available on your Raspberry Pi print server. Right click the printer and press **"Connect..."** or double click on the printer you want to have connected to your computer.

**3.** Upon double clicking this, you will likely be greeted with the warning message below, just click the **"OK"** button.

**4.** Now you will need to find your printer within this list, on the left is a list of all the brands, and on the right, is a list of all the printers for that brand that Windows has drivers for. If you don’t find your printer on here, then try looking up your printer’s model online and download the appropriate drivers for it.

In my case, I had to look for the HP LaserJet 1018. If it's not listed, you have first to [download the printer package](https://github.com/catamold/raspberrypi-projects/releases/download/v1.0/hp-laserjet-1018-basic-driver.zip), unzip it, then click the **"Have Disk..."**, then **"Browse"** and select the **HPLJ1018.INF** file inside unziped folder.

Once you have selected your printer, press the **"Ok"** button.

**6.** The printer should now be successfully added to your computer and be available for any program to use. You can ensure the printer is correctly set up by printing a file.