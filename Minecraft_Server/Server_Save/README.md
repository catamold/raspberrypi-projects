---
title: Server Save
parent: Minecraft Server
has_children: false
---

## Minecraft Save Server

### Manually Save using Terminal:
`cp -r /home/pi/Minecraft_Server/world /home/pi/Minecraft_Server/Saves/world_[date]`

### Automate Save using Cron:
Cron is a tool for configuring scheduled tasks on Unix systems. It is used to schedule commands or scripts to run periodically and at fixed intervals. First, we access crontab bypassing command below:

`sudo crontab -e`

The layout for a cron entry is made up of six components: minute, hour, day of month, month of year, day of week, and the command to be executed.
```
# * * * * *  command to execute
# ┬ ┬ ┬ ┬ ┬
# │ │ │ │ │
# │ │ │ │ │
# │ │ │ │ └───── day of week (0 - 7) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
# │ │ │ └────────── month (1 - 12)
# │ │ └─────────────── day of month (1 - 31)
# │ └──────────────────── hour (0 - 23)
# └───────────────────────── min (0 - 59)
```

The bash file can be downloaded [here](https://github.com/catamold/raspberrypi-projects/releases/download/v2.0/minecraft_autosave.sh). Everyday at _6:45_ in the morning, the system runs this shell script containing sudo in cron, which save the server's current state on ownCloud files location:

`45 6 * * * /home/pi/Scripts/minecraft_autosave.sh`

View your currently saved scheduled tasks with:

`sudo crontab -l`