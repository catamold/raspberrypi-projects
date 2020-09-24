---
title: Server Monitor
parent: Minecraft Server
has_children: false
---

## Server Monitor

### Raspberry Pi Monitor CPU and RAM usage
Let start by installing htop:

`apt-get install htop -y`

Then just type `htop` on the **Terminal**.

Or you can check your system free memory and update the results of the free command every two seconds:

`watch free -m`

### Minecraft Server log file
The first time you start the service, it will generate several configuration files and directories, including the Minecraft world. Use the tail command to monitor the server log file:

`tail -f /home/pi/Minecraft_Server/logs/latest.log`

### Minecraft Manually Save Server

`cp -r /home/pi/Minecraft_Server/world /home/pi/Minecraft_Server/Saves/world_[date]`

### Minecraft Server admin commands
User must also install Screen in a bid to keep the servers running in the background even after closing the console. To do so, type the following command:

`sudo apt-get install screen`

Create two screens:
```
screen -S terminal
screen -S minecraft
```

View all active screens:
```
screen -ls
```

Start Minecraft server on Raspberry Pi 3B:
```
cd /home/pi/Minecraft_Server
java -Xmx512M -Xmx700M -jar minecraft_server.1.7.10.jar nogui
Ctrl + A + D
```

Come back to your session:
```
screen -rx <id-session>
Ctrl + A + D
```

Remove screen:
```
screen -X -S [id-session] quit
```

