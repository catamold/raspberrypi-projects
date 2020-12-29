---
title: Install Application
parent: Personal Cloud Storage
has_children: false
---

## Install Application

### Applications Status
See all applications and versions:

`sudo -u www-data php occ app:list`

### Install passman
Upload file on [bashupload](https://bashupload.com), then retrive it on Linux using the following command:

`wget -P /path/to/directory <download-url>`

Untar the file:

`sudo tar -xvf file.tar.bz2`

**1.** Delete or move the _signature.json_ out of `/var/www/owncloud/apps/passman/appinfo`

**2.** Modify `/var/www/owncloud/apps/passman/appinfo/info.xml` file by changing the line **43**: Max=10.0 to max=11.0

**3.** Restart apache:

`sudo service apache2 restart`

**4.** Archive the file with **.tar.gz**:

`sudo tar -czvf passman.tar.gz passman`

**5.** Install the application in the `/var/www/owncloud` director

`sudo -u www-data php occ market:install -l /var/www/passman.tar.gz`

### Debugging
If exporting the passwords to csv doesn't finish, upload a file on one of your password and check if it works now.