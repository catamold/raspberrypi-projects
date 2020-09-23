---
title: NAS Storage
has_children: false
---

## NAS Storage

### Setting up Samba on your Raspberry Pi
**1.** The first thing that we must do before we setup a SMB/CIFS share on our Raspberry Pi is to make sure everything is up to date.

We can update the package list and all our packages by running the following two commands:
```
sudo apt-get update
sudo apt-get upgrade
```

**2.** Now that we have our Raspbian operating system entirely up to date, we can now proceed on to installing the Samba software to our Raspberry Pi.

We can install the packages that we require to setup Samba by running the following command:

`sudo apt-get install samba samba-common-bin`

**3.** Before we set up our network storage on our Pi, we need to first create a folder that we will share.

This folder can be located anywhere, including on a mounted external hard drive. For this tutorial, we will be creating the directory within the “pi” users home directory.

Create this folder by running the following command:

`mkdir /home/pi/shared`

**4.** Now we can share this folder using the Samba software. To do this, we need to modify the samba config file.

The **"smb.conf"** configuration file is where you will store all your settings for your shares.

We can begin modifying the config file by running the command below:

`sudo nano /etc/samba/smb.conf`

5. Within this file, add the following to the bottom. This text defines various details of our share.

```
[pimylifeupshare]
path = /home/pi/shared
writeable=Yes
create mask=0777
directory mask=0777
public=no
```

**"[pimylifeupshare]"** – This defines the share itself, the text between the brackets is the point at which you will access the share. For example, ours will be at the following address: **//raspberrypi/pimylifeupshare**

**"path"** – This option is the path to the directory on your Raspberry Pi that you want to be shared.

**"writeable"** – When this option is set to **"Yes"**, it will allow the folder to be writable.

**"create mask"** and **"directory mask"** – This option defines the maximum permissions for both files and folders. Setting this to 0777 allows users to read, write, and execute.

**"public"** – If this is set to **"no"** the Pi will require a valid user to grant access to the shared folders.

**6.** With the changes made to the file, you can now go ahead and save it by pressing **CTRL + X** then **Y** followed by **ENTER**.

**7.** Next, we need to set up a user for our Samba share on the Raspberry Pi. Without it, we won’t be able to make a connection to the shared network drive.

In this example, we will be creating a Samba user called **"pi"** with the password set to **"raspberry"**.

Run the following command to create the user. You will be prompted afterward to enter the password:

`sudo smbpasswd -a pi`

To change the current password type:

`sudo smbpasswd pi`

**8.** Finally, before we connect to our Raspberry Pi Samba share, we need to restart the samba service so that it loads in our configuration changes.

`sudo systemctl restart smbd`

**9.** The last thing we should do before we try connecting to our Samba share is to retrieve our Raspberry Pi’s local IP address.

First, make sure you’re connected to a network by either connecting Ethernet cable or setup WiFi.

While you can connect using the Pi’s network name, we will grab the IP address just in case that option fails to work on your home network.

Run the command below to print out the Pi’s local IP Address:

`hostname -I`

### Connecting to your Samba Server on Windows
**1.** To connect to your Samba on Windows, begin by opening up the **"My PC"**, then click **"Map network drive"**.

**2.** You will now be greeted by the dialog shown below asking you to enter some details.

Within the **"Folder"** textbox you will want to enter the following **"\\raspberrypi\pimylifeupshare"**.

Make sure that you replace **"pimylifeupshare"** with the name that you defined for your Samba share.

Check the **"Connect using different credentials"** box. Once done, click the **"Finish"** button to finalize the connection.

**3.** Finally, you will be asked to enter your login details to be able to finish the connection.

Enter the username and password you set using the **"smbpasswd"** tool earlier on in the tutorial. Once done, press the **"OK"** button to continue.