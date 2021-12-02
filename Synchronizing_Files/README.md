---
title: Synchronizing Files
has_children: false
---

## Synchronizing Files

### Installing Syncthing to Your Raspberry Pi
**1.** We update our Raspberry Pi by running the following two commands.

```
sudo apt update
sudo apt full-upgrade
```

**2.** Next, we need to make sure that we have the **apt-transport-https** package installed. This package allows the package manager to handle sources that operate over the HTTPS protocol. By default, this is not supported. We can install the required package by running the command below.

`sudo apt install apt-transport-https`

**3.** Finally, we can store the **Syncthing GPG keys** in our **keyrings directory**. These keys are designed to ensure that the packages we are installing have been correctly signed and aren’t coming from an unexpected source. Download and save the keys by using the following command on your Raspberry Pi.

`curl -s https://syncthing.net/release-key.txt | gpg --dearmor | sudo tee /usr/share/keyrings/syncthing-archive-keyring.gpg >/dev/null`

**4.** With the key added, we can now add the repository itself. We will be utilizing the stable branch of the **Syncthing** software. Add the repository to our sources list by using the command below.

`echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list`

**5.** Before we will install Syncthing from the repository, we need to update the package list. We need to update the list so that the package manager reads from our newly added source. Refresh the package list by running the following command on your device.

`sudo apt update`

**6.** Finally, let us install the **Syncthing** software to our Raspberry Pi. With the package repository now added, all we need to do to install the software is run the following command.

`sudo apt install syncthing`

### Allowing Outside Access to your Syncthing Web Interface

**1.** By default, we won’t be able to access the Syncthing web interface without being physically on the device, but we can modify the configuration to allow outside access. First we need to know our local Pi IP.

`hostname -I`

***Optional.*** Create a user and modify the user's home directory to read, write and execute only. Then login using the user credentials.

```
sudo adduser ftp-user-[username]
sudo chmod 700 /home/ftp-user-[username]
```

To add an existing user account to a group on your system, use the **usermod** command. For example, to add the user geek to the group geekgroup, use the following command:

`sudo usermod -a -G geekgroup geek`

List all members of a group using **/etc/group** file.

`grep synch-drive /etc/group`


**2.** Before we continue any further, we will need to run **Syncthing** once to generate **config** files in your user account.

`syncthing`

**3.** After the first run, Syncthing will create all the configuration files we need. This configuration file will only work as long as we run the Syncthing software with our pi user. Begin editing the required config file using the nano text editor by using the command below.

`nano ~/.config/syncthing/config.xml`

**4.** Within this file, you need to find the following line. We will need to replace the local IP defined on this line (`127.0.0.1`) with our Pi’s local IP address (e.g. `<address>192.168.0.193:8384</address>`). Using the local IP address, we are restricting access to the web interface only to users on the same local network. (Alternatively, if you want to allow access to any address, use the IP `0.0.0.0`).

`<address>127.0.0.1:8384</address>`

### Setting up Syncthing as a Service on the Raspberry Pi

**1.** We need to make use of nano again to create the file for our service. The service that we will be putting together is from the [official GitHub for Syncthing](https://github.com/syncthing/syncthing). Run the following command to begin writing the file within the **“/lib/systemd/system”** directory. Within this file, enter the following lines (Change the **User** with your user name). These lines dictate how the operating system will handle Syncthing on our Raspberry Pi.

`sudo nano /lib/systemd/system/syncthing.service`

```
[Unit]
Description=Syncthing - Open Source Continuous File Synchronization
Documentation=man:syncthing(1)
After=network.target

[Service]
User=pi
ExecStart=/usr/bin/syncthing -no-browser -no-restart -logflags=0
Restart=on-failure
RestartSec=5
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

# Hardening
ProtectSystem=full
PrivateTmp=true
SystemCallArchitectures=native
MemoryDenyWriteExecute=true
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
```

**2.** With our service created, we can now enable it to start at boot. All you need to do is run the following command.

`sudo systemctl enable syncthing`

**3.** Next, start the service so that we can begin accessing the Syncthing web interface.

`sudo systemctl start syncthing`

**4.** We should verify that our Syncthing service started on our Raspberry Pi.

`sudo systemctl status syncthing`

**5.** To access the web interface, you will need to know the Raspberry Pi’s IP address (e.g. **http://192.168.0.101:8384**).

### Securing the Syncthing Interface

**1.** By default, Syncthing comes with no username or password defined. What this means is that any user can access the interface and adjust your settings. To stop users from being able to do any unwanted damage, you can define login details. If you haven’t set the username and password before, you will see a message warning you of the dangers. To get to the **settings page** quickly, we can **click** the **“Settings”** button on this warning. (If this message isn’t displaying for you, you can also find the settings page by **clicking** the **“Actions” dropdown box** in the top right corner and selecting **“Settings”**.

**2.** Within the popup **settings page**, you will need to change to the **“GUI” tab**. On this page, you will need to enter both a **username** and a **password**. You should also check the **Use HTTPS for GUI**. Then **Save** the changes.

### Retrieving your Devices Syncthing ID

**1.** Syncthing works by generating a unique ID for every single device. To synchronize data between devices, each one must have the other device’s ID added. Finding the ID of your Raspberry Pi Syncthing setup is a straightforward process and can be found within the web interface. Back on the **web interface’s main page**, **click** the **“Actions”** toggle in the top right corner of the screen, then in the dropdown box, **click** the **“Show ID”** option.

**2.** On this page, you will see the **identification string** and the matching **QR code** for the ID. Then identification string should be 50-56 characters long and contain numbers, letters, and hyphens. The hyphens are ignored by the system but are there to make the ID easier to read. You will need to add your Raspberry Pi’s ID to the other devices you will be connecting to. Likewise, you will also need to add their ID. The ID works as part of Syncthing’s method for connecting multiple devices to the same pool.

### Adding a Device to your Raspberry Pi’s Syncthing Pool

**1.** First you have to install [Syncthing](https://syncthing.net/downloads/) to your PC, then retrieve the **Device ID**, the **identification string** of the device.

**2.** On the **Syncthing interface** of Pi, you need to click the **“Add Remote Device”** button located at the bottom right side. In the top textbox enter the **Device ID** for the device you want to connect to. As the ID is relatively long, it will likely be easier to copy and paste the ID over. Once done, you can click the **“Save” button** to add the device and begin the connection process.

**3.** In the **Syncthing interface** of your PC you should see something like this **Device "raspberrypi" (XXX at [XXX]:22000) wants to connect. Add new device?**. Press **Add Devide**. Once both Syncthing servers have each other’s IDs added, you should see that you’re successfully connected (**Connected (Unused)**).

### Synchronizing a Folder with your Connected Devices

**1.** With a device now connected to our Raspberry Pi Syncthing, we can try sharing a folder with the device. To begin editing an existing folder’s share settings, expand the **Default Folder** of Pi, then click the **“Edit” button** underneath that folder. Within the file settings dialog we will need to change to the **“Sharing” tab**. Using this dialog, you can select the devices you want to share the folder with, by **checking the box of the PC's name**.

**2.** In the **Syncthing interface** of your PC you should see something like this **raspberrypi wants to share folder "Default Folder" (default). Share this folder?**. Press **Share**.

**3.** You should now see that your folder has now begun synchronizing. Once it has finished synchronizing, you should see both the folder and the device marked as **“Up to date”**.