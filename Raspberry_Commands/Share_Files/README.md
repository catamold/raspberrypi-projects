---
title: Share Files
parent: Raspberry Commands
has_children: false
---

## Share Files

### Access a Linux Share From Windows

**1.** To move data in the other direction, you'll need to install Samba on your Linux computer.

`sudo apt install samba`

**2.** Next, set a username for the samba share.

`smbpasswd -a username`

**3.** You'll be prompted for a password for the new account (don't call it "username"!). Next, create a directory to share the data from.

`mkdir /home/[username]/[folder_name]`

**4.** Next, edit the **smb.conf** file in your text editor:

`sudo nano /etc/samba/smb.conf`

**5.** Add the following to the end of the configuration file. Make the required changes to suit your own needs, then hit Ctrl + X to exit, tapping Y to save.

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

**6.** Next, restart Samba:

`sudo service smbd restart`

**7.** You'll then be able to access the share from Windows. Open File Explorer or your browser and input the IP or hostname of the remote Linux device, followed by the folder name. In our example, this is

`\\192.168.1.233\[folder_name]`