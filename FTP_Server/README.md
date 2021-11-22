---
title: FTP Server
has_children: true
nav_order: 1
---

## FTP Server

### Create a user for FTP server connection
**1.** Create a new user, used only for FTP connections. You will be prompted for a password. Make sure it is a good one. The other details can be left blank or populated as you see fit (To delete a user type `sudo deluser ftp-user-[username]`).

`sudo adduser ftp-user-[username]`

### Mount USB HDD/SSD into Raspberry Pi

**1.** Mount the USB HDD/SSD to the Raspberry Pi, and make sure that it is formatted as **NTFS**. Check the partition name of the USB HDD/SSD drive (e.g. **/dev/sda2**:

```
sudo blkid
sudo fdisk -l
```

**2.** Make a file in **home** to access quickly the USB HDD/SSD.

`sudo mkdir /usb-ssd-storage`

**3.** Now we know where our drive is, we need to mount it to a folder **/usb-ssd-storage** in **home** directory. Change **[NO.]** with the partition number name from the previous step (If you need to **unmount** the drive, run `sudo umount /usb-ssd-storage`).

`sudo mount /dev/sda[NO.] /usb-ssd-storage`

**4.** You’ll also have to set permissions to ensure the drive can be accessed properly:

`sudo chmod 775 /usb-ssd-storage`

**5.** Make the USB HDD/SSD mount permanently, by editing the **‘fstab’** file. Add the following line to the bottom of the file:

`sudo nano /etc/fstab`

```
/dev/sda[NO.] /usb-ssd-storage ntfs defaults 0 0
```

**6.** Apply changes, by rebooting the operating system.

`sudo shutdown -r now`

**7.** Create a folder in the USB HDD/SSD storage, that will be accessed only by the **ftp-user-[username]**.

`sudo mkdir -p /usb-ssd-storage/ftp-user-[username]/files`

**8.** Create a folder in the **‘ftp-user-[username]’** home directory, this will be used in the next step to **bind** to the folder we created in **/root/usb-ssd-storage**.

`sudo mkdir /home/ftp-user-[username]/ssd-storage`

**9.** Perform a bind to where the USB HDD/SSD is mounted. Edit the **‘fstab’** file so this bind is permanent. Add the following line to the bottom of the file, it should be below the line which was added in the previous step.

`sudo nano /etc/fstab`

```
/usb-ssd-storage/ftp-user-[username]/files /home/ftp-user-[username]/ssd-storage none bind 0 0
```

**10.** Now change the ownership of this folder to the **‘ftp-user-[username]’** user:

`sudo chown ftp-user-[username]:ftp-user-[username] /home/ftp-user-[username]/ssd-storage`

### Setting up an FTP Server on the Raspberry Pi
**1.** Install **vsftpd (Very Secure FTP Daemon)** to your Raspberry Pi by using the command below.

`sudo apt install vsftpd`

**2.** Before we can connect to our new Raspberry Pi FTP server we need to modify some settings. Let us begin modifying the **vsftpd configuration file** by using the nano text editor with the following command.

`sudo nano /etc/vsftpd.conf`

Within this file you will need **uncomment** (Remove the **#**) the following lines:

```
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
chroot_local_user=YES
chroot_list_enable=NO
```

Also you will need **add** the following lines (**“local_root”** option means that the user will be locked to their home directory).

```
user_sub_token=$USER
local_root=/home/$USER
```

**3.** For our new settings to take effect we need to restart the **vsftpd** daemon on the Raspberry Pi.

`sudo service vsftpd restart`

**4.** Modify the user's home directory to read only.

`sudo chmod a-w /home/ftp-user-[username]`

**5.** You can now reboot the operating system and test the connection in a FTP program.

`sudo shutdown -r now`

**6.** Check the open ports on Raspberry Pi by typing the following command:

`netstat -vatn`

### Connect to the FTP server using FileZilla
Connect using the following credentials:

- **Host**: Adress of the raspberry pi network domain (e.g. **192.168.0.101**).
- **Username**: This is the username of the created user (e.g. **ftp-user-[username]**).
- **Password**: The password used for creating the user.
- **Port**: Using a **FTP** connection requires port no. **21**.

### Connect to the FTP using Windows 10 network location
Connect using the following credentials:

- **Internet or network address**: The ftp server followed by the adress of the raspberry pi network domain (e.g. **ftp://192.168.0.101**).
- **User name**: This is the username of the created user (e.g. **ftp-user-[username]**).
- **Password**: The password used for creating the user.