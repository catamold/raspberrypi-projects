---
title: Minecraft Server
has_children: true
nav_order: 2
---

## Minecraft Server

### Install the java runtime environment
**1.** We need first to ensure that our current Raspbian operating system is entirely up to date.

We can update the package list and all our packages by running the following two commands:
```
sudo apt-get update
sudo apt-get upgrade
```

**2.** Once you’re ready to go, type this command into Terminal to install the Java runtime environment (JRE):

`sudo apt install openjdk-8-jre-headless`

We’ve chosen to install the “headless” version of the JRE because it’s a little more lightweight. The headless package is used when you don’t have to worry about graphics, which we don’t — all the graphics stuff will be happening on devices that you and your friends play on.

### Download Minecraft’s server software
**1.** There are a few different apps that can run Minecraft servers, but we’re going to keep things official and use the one that [Minecraft offers](http://www.mc-download.com/index.php?action=downloadfile&filename=minecraft_server.1.7.8.jar&directory=Minecraft%20Versions%20Official/Minecraft%20Server&) for free on its website. Head to Minecraft.net and download the latest and greatest version of server.jar.

**2.** That will land **server.jar** in your downloads folder, but let’s not leave it there. Go ahead and make a folder for your server within the home directory. You can do that in File Manager or just type this command into Terminal:

`mkdir Minecraft_Server`

The mkdir command means “make directory,” and that’s just what Raspbian will do for you. The new folder will be right where we want it: in your Raspberry Pi’s Home Folder, which is where you are by default when you are working in Terminal.

**3.** Now, grab the server.jar file that you downloaded and put it in the **Minecraft_Server** folder. It’s probably easiest to do that in File Explorer, though you can use the mv command in terminal if you’d prefer.

### Read and confirm Minecraft’s end-user license agreement

**1.** Let’s get back into Terminal. While in Terminal, we’re going to navigate to our Minecraft_Server folder and files.

`cd Minecraft_Server`

Now that we’re in the right folder, we can issue commands that impact the files within this folder. We’ll type a command that starts our server:

`java -Xms1G -Xmx1G -jar [server_name_downloaded.jar]`

**2.** And we will promptly get error messages. It turns out that we have to confirm that we’ve read Mineraft’s end-user license agreement before we can use our server.

Then, look in your **Minecraft_Server** folder for a text file named **eula.txt**. Open it up and change the line `eula=false` to `eula=true`.

You can do this in the file explorer or within the Terminal with our favorite text editor, nano, via the command `nano eula.txt`. With **"eula=true"** in there, go ahead and close the file (if you’re using nano, that’s **Ctrl+X**), making sure to save the file on your way out.

### Start the Raspberry Pi Minecraft server
**1.** With the red tape and fine print all taken care of, it’s time to start our server for real. As we do so, we’ll also allocate some RAM for server.jar to use when it runs.

`java -Xms1G -Xmx1G -jar [server_name_downloaded.jar]`

This command starts the server. The use of “java” lets our Raspberry Pi know that this is a Java program, so a Java interpreter should be used. The bit that says “server.jar” identifies the application we’re opening. In between is where we’re allocating RAM to our server. With **"-Xms1G"** and **"-Xmx1G"**, we set how much RAM we want server.jar to start with (1 GB) and how much it’s allowed to use at the absolute maximum (also 1 GB)

Whatever you choose to do, make sure that you don’t set the starting RAM **("-Xms")** higher than the maximum **("-Xmx")**.

**2.** If you’re using an older Raspberry Pi, you may want to tweak the amount of RAM that you allocate. Going below 1 GB isn’t necessarily great for your server’s performance, but you won’t have much of an option if you’re using a Pi that only has 1 GB of RAM total. You can check out RAM availability in the Terminal with the command `free -m`. If you need to use less than 1 GB of RAM, you can change the G in the command to M (for MB instead of GB, of course). 

### Adjust and connect to your Raspberry Pi Minecraft server
**1.** You don’t actually need the GUI, though. If you’d rather launch the server without it, you can append nogui to the end of the launch command, like so:

`java -Xms1G -Xmx1G -jar [server_name_downloaded.jar] nogui`

**2.** You can also mess with default settings on your server by accessing the server.properties file within your Minecraft_Server folder. With your server shut down, just open the file with your text editor of choice. We’ll use nano:

`sudo nano server.properties`

Within server.properties, you can change settings like the maximum number of players and the default view distance. You change these and other settings to whatever you like however you want, but keep in mind the Pi can’t handle too much processing.
```
view-distance=5
max-player=5
```

**3.** If I’m connecting to **MY OWN** Server, find the **server.properties** file in the server folder, then the `online-mode=true` line, and change it to `online-mode=false`. Now you can connect to the server.

### Boot on Startup
To have the server start on boot, we will need to do a few extra steps.

**1.** We will need to create a service for the Minecraft server so let’s start writing the service file by entering the command below.

`sudo nano /lib/systemd/system/minecraftserver.service`

**2.** In this file you will need to enter the following text.

This file defines the service, so the service manager knows how and what to run. Don’t forget to update the spigot version number whenever you upgrade.
```
[Unit]
Description=Minecraft Spigot Server

[Service]
User=pi
Group=pi
Restart=on-abort
WorkingDirectory=/home/pi/Minecraft_Server/
ExecStart=/usr/bin/java -Xms512M -Xmx1008M -jar /home/pi/Minecraft_Server/[server_name_downloaded.jar] nogui

[Install]
WantedBy=multi-user.target
```
Once done, save the file by pressing **CTRL + X** then **Y** followed by **ENTER**.

**3.** Now, we will need to enable the service. You can enable the service by running the command below:

`sudo systemctl enable minecraftserver.service`

**4.** You should now be able to start the Minecraft server by simply using the following command:

`sudo systemctl start minecraftserver.service`

**5.** Using a similar command, you can check on the status of the service. Checking the status is great for debugging.

`sudo systemctl status minecraftserver.service`

**6.** You can stop the server by using the following command:

`sudo systemctl stop minecraftserver.service`

**7.** To disable the boot on startup, use the following command:

`sudo systemctl disable minecraftserver.service`