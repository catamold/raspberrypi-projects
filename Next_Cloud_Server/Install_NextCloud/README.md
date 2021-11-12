---
title: Install NextCloud
parent: Next Cloud Server
has_children: false
---

## Install NextCloud

### NextCloud prerequisites
**1.** NextCloud needs a web server with **Apache**, **MySQL (MariaDB)** and **PHP**, and it also needs a few **PHP modules**. Use the following commands to install everything:

```
sudo apt install apache2 mariadb-server libapache2-mod-php
sudo apt install php-gd php-json php-mysql php-curl php-mbstring php-intl php-imagick php-xml php-zip
```

### NextCloud installation
You now need to download and extract the **NextCloud archive**:

**1.** Go to the **Apache web** folder.

`cd /var/www/html`

**2.** Get the latest NextCloud from [here](https://download.nextcloud.com/server/releases/) (i.e. **nextcloud-15.0.8.zip** or **.tar.bz2 archive**).

`sudo wget https://download.nextcloud.com/server/releases/nextcloud-15.0.8.zip`

**3.** Extract the file with unzip.

`sudo unzip nextcloud-15.0.8.zip`

**4.** As we use root to extract files, we need to change the folder permissions to allow Apache to access it:

```
sudo chmod 750 nextcloud -R
sudo chown www-data:www-data nextcloud -R
```

### MySQL configuration
After the **MariaDB server** installation, it creates a root user you can use only from the command line.

**1.** We will create a new user and a dedicated database for NextCloud. Connect to **MySQL** with **root**.

`sudo mysql`

**2.** Create the new user. Replace **“password”** by a strong password.

`CREATE USER 'nextcloud' IDENTIFIED BY 'password';`

**3.** Create the new database

`CREATE DATABASE nextcloud;`

**4.** Give all permissions to the new user on this database. Same thing here, just replace **“password”** with the previous password.

`GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@localhost IDENTIFIED BY ‘password’;`

**5.** Save and exit.

```
FLUSH PRIVILEGES;
quit
```

### NextCloud configuration

**1.** Open the following URL in your browser: **https://[IP]/nextcloud**. Replace the **“IP”** with the Raspberry Pi IP address.

**2.** A form will show up. Choose a **username** and **password** for NextCloud.

**3.** Enter the credentials we just created in MySQL:

– **User**: nextcloud
– **Password**: “password” *(your password)*
– **Database**: nextcloud
– **Host**: localhost

**4.** Then click **“Finish setup”** and wait a few minutes to be redirected to the **NextCloud home page**.

### Allow local users to access NextCloud Server

**1.** Edit the configuration file of the NextCloud server.

`sudo nano /var/www/html/nextcloud/config/config.php`

**2.** Add the local domain of Pi in **trusted_domains** (e.g. **192.168.0.101**).

```
...
'trusted_domains' =>
array (
	0 => '192.168.0.101',
),
...
```