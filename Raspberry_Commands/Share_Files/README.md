---
title: Share Files
parent: Raspberry Commands
has_children: false
---

## Share Files

### Access a Linux Share From Windows

To move data in the other direction, you'll need to install Samba on your Linux computer.

`sudo apt install samba`

Next, set a username for the samba share.

`smbpasswd -a username`

You'll be prompted for a password for the new account (don't call it "username"!). Next, create a directory to share the data from.

`mkdir /home/[username]/[folder_name]`

Next, edit the **smb.conf** file in your text editor:

`sudo nano /etc/samba/smb.conf`

Add the following to the end of the configuration file. Make the required changes to suit your own needs, then hit Ctrl + X to exit, tapping Y to save.
```
[Share]
path = /home/[username]/[folder_name]
available = yes
valid users = [username]
read only = no
browsable = yes
public = yes
writable = yes
```

Next, restart Samba:

`sudo service smbd restart`

You'll then be able to access the share from Windows. Open File Explorer or your browser and input the IP or hostname of the remote Linux device, followed by the folder name. In our example, this is

`\\192.168.1.233\[folder_name]`