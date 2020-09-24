---
title: Server Commands
parent: Minecraft Server
has_children: false
---

## Server Commands

### Raspberry Pi Monitor CPU and RAM usage
Let start by installing htop:

`apt-get install htop -y`

Then just type `htop` on the **Terminal**.

### Minecraft Server log file
The first time you start the service, it will generate several configuration files and directories, including the Minecraft world. Use the tail command to monitor the server log file:

`tail -f /opt/minecraft/server/logs/latest.log`

### Accessing Minecraft Console
To access the Minecraft Console use the mcrcon utility. You need to specify the host, rcon port, rcon password and use the -t switch which enables the mcrcon terminal mode:

/opt/minecraft/tools/mcrcon/mcrcon -H [hostname_ip] -P 25565 -t

### Sending private messages to other players
`/tell  [player] [message]`
