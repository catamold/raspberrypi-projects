---
title: Personal Cloud Storage
has_children: true
nav_order: 2
---

## Personal Cloud Storage

### Preparing Raspbian Stretch for Buster
**1.** We need first to ensure that our current Raspbian operating system is entirely up to date.

Upgrading all the currently installed packages ensures that we will have a cleaner upgrade path to Raspbian Buster.

Let’s first update all the currently installed packages by running the following command:
```
sudo apt update
sudo apt dist-upgrade -y
```

We utilize **"dist-upgrade"** instead of the plain **"upgrade"** command to force Raspbian to upgrade to the latest available versions of all packages regardless of whether they need to update.

**2.** Next, let’s go ahead and also update the Raspberry Pi’s firmware.

We can do that by running the command below on our Raspbian installation:

`sudo rpi-update`

Once all the update processes have completed, we can now proceed to upgrade the Raspbian installation from Stretch to Raspbian Buster.

### Updating Raspbian Stretch to Raspbian Buster
**1.** Now that we have prepared our Raspbian Stretch installation, we can now start the process of moving to Buster.

To do this, we will need to modify the **"/etc/apt/sources.list"** file.

Begin modifying the sources file by running the following command.

`sudo nano /etc/apt/sources.list`

**2.** Within this file, find the following line and change **"Stretch"** to **"Buster"**.

This change will allow the package manager to search the Raspberry Pi package repository under the **"Buster"** distribution instead of the **"Stretch"** distribution.

**Find**

`deb http://raspbian.raspberrypi.org/raspbian/ stretch main contrib non-free rpi`

**Replace With**

`deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi`

Once you have replaced all occurrences of **"stretch"** within the file you can save it by pressing **CTRL + X** then **Y** followed by **ENTER**.

**3.** Next we also need to modify the **"/etc/apt/sources.list.d/raspi.list"** file by running the following command:

`sudo nano /etc/apt/sources.list.d/raspi.list`

**4.** In this file, you need to go ahead and find the following text and change **"Stretch"** to **"Buster"**.

**Find**

`deb http://archive.raspberrypi.org/debian/ stretch main`

**Replace With**

`deb http://archive.raspberrypi.org/debian/ buster main`

Once you have again finished switching **"Stretch"** to **"Buster"**, you can save the file by pressing **CTRL + X** then **Y** and then **ENTER**.

**5.** Now before we do the final push to Raspbian Buster, we will first remove the **"apt-listchanges"** package.

The reason for removing this package is to give us a faster and smoother upgrading process. Without removing this package, the Raspbian operating system will have to load a fairly large changelog file which will slow down your upgrade process considerably.

Feel free to re-install this package after the upgrade process has completed.

Run the command below to uninstall the **"apt-listchanges"** package.

`sudo apt-get remove apt-listchanges`

**6.** Finally, with the source files now modified to mention the **"Buster"** build instead of **"Stretch"** we are now ready to begin the upgrade process.

The first command will update the package lists stored on the Raspberry Pi. The second command will then update all the packages to their Raspbian Buster versions.

```
sudo apt update
sudo apt dist-upgrade
```

Please note that this process can take considerable time as there are a fair few packages that will need to be updated.

Additionally, you may be required to answer prompts, so don’t stray too far from your Raspberry Pi.

**7.** Once the Buster upgrade process has completed, we will need to get rid of some new applications that will automatically be installed.

These packages are not supported by the Raspberry Pi foundation and are recommended to be removed.

We can remove these packages by running the following command on your Raspberry Pi:

```
sudo apt purge timidity lxmusic gnome-disk-utility deluge-gtk evince wicd wicd-gtk clipit usermode gucharmap gnome-system-tools pavucontrol
```

**8.** Next, we need to run a few more commands to ensure we have cleaned up everything leftover from the upgrade.

The first command that we will be running is the package managers **"autoremove"** command. This command will remove any packages that have been marked as no longer needed due to changed dependencies.

Run the following command to remove these no longer required packages.

`sudo apt autoremove -y`

**9.** Now we need to run the apt package managers **"autoclean"**.

This **autoclean** command will clear out the package cache. It automatically removes any package files that are no longer available for download and thus are largely useless.

Use the command below to begin the cleaning process.

`sudo apt autoclean`

**10.** The final thing we should do is restart our Raspberry Pi. Restarting ensures that the Raspberry Pi will load in all the new Buster packages and clear out any old data sitting in memory.

Run the following command to reboot the Raspberry Pi:

`sudo reboot`

At this point, you should now have successfully updated your Raspberry Pi from Raspbian Stretch to Raspbian Buster. 

### Setting up The Raspberry Pi Owncloud Server
The first thing we need to do is install both NGINX and PHP to our Raspberry Pi. We will need both of these pieces of software to run the Owncloud software.

**1.** Firstly, in either The Pi’s command line or via SSH, we will need to update the Raspberry Pi and its packages, do this by entering:
```
sudo apt-get update
sudo apt-get upgrade
```

**2.** Next, we need to add the www-data user to the www-data group.

`sudo usermod -a -G www-data www-data`

These instructions have been updated to work with Raspbian Buster. If you’re on an earlier version, then I highly recommend you upgrade to Raspbian Buster.

**3.** Once you are running Raspbian Buster, you can safely continue with this tutorial.

In this step, we will be installing all the packages that we require to run Owncloud. This includes php7.3 and its numerous modules that OwnCloud relies upon.

Run the following command to install everything we need:
```
sudo apt-get install nginx openssl ssl-cert php7.3-xml php7.3-dev php7.3-curl php7.3-gd php7.3-fpm php7.3-zip php7.3-intl php7.3-mbstring php7.3-cli php7.3-mysql php7.3-common php7.3-cgi php7.3-apcu php7.3-redis redis-server php-pear curl libapr1 libtool libcurl4-openssl-dev
```

### Setting up NGINX for Owncloud and HTTPS
Our next step is to now set up and configure NGINX for it to work with the Owncloud software. We will also be setting NGINX up so that it can support HTTPS connections as well.

**1.** Now we need to create an SSL certificate you can do this by running the following command:

```
sudo openssl req $@ -new -x509 -days 730 -nodes -out /etc/nginx/cert.pem -keyout /etc/nginx/cert.key
```

Just enter the relevant data for each of the questions it asks you.

**2.** In addition to the SSL certificate, we also need to generate a custom dhparam file. This file helps ensure that our SSL connections are kept secure. By default, this would use a default one that isn’t nearly as secure.

To generate a 2048 byte long dhparam file, run the following command on your Raspberry Pi. This process will take quite a long time, up to 2 hours.

Adding the **dhparam** flag to the command will help speed up the process, but arguably is less secure.

`sudo openssl dhparam -out /etc/nginx/dh2048.pem 2048`

**3.** Now we need to chmod the three cert files we just generated.
```
sudo chmod 600 /etc/nginx/cert.pem
sudo chmod 600 /etc/nginx/cert.key
sudo chmod 600 /etc/nginx/dh2048.pem
```

**4.** Let’s clear the server config file since we will be copying and pasting our own version in it.

`sudo sh -c "echo '' > /etc/nginx/sites-available/default"`

**5.** Now let’s configure the web server configuration so that it runs Owncloud correctly.

`sudo nano /etc/nginx/sites-available/default`

**6.** Now simply copy and paste the following code into the file:
```
upstream php-handler {
    server unix:/var/run/php/php7.3-fpm.sock;
}

server {
    listen 80;
    server_name _;

    #Allow letsencrypt through
    location /.well-known/acme-challenge/ {
        root /var/www/owncloud;
    }

    # enforce https
    location / {
        return 301 https://$host$request_uri;
    }
}
  
server {
    listen 443 ssl http2;
    server_name _;
  
    ssl_certificate /etc/nginx/cert.pem;
    ssl_certificate_key /etc/nginx/cert.key;

    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:AES256+EDH';
    ssl_dhparam /etc/nginx/dh2048.pem;
    ssl_prefer_server_ciphers on;
    keepalive_timeout    70;
    ssl_stapling on;
    ssl_stapling_verify on;
  
    add_header Strict-Transport-Security "max-age=15552000; includeSubDomains; preload" always;
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header X-Download-Options noopen;
    add_header X-Permitted-Cross-Domain-Policies none;
  
    root /var/www/owncloud/;
  
    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }
  
    # The following 2 rules are only needed for the user_webfinger app.
    # Uncomment it if you're planning to use this app.
    #rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
    #rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;
  
    location = /.well-known/carddav {
        return 301 $scheme://$host/remote.php/dav;
    }
    location = /.well-known/caldav {
        return 301 $scheme://$host/remote.php/dav;
    }
  
    # set max upload size
    client_max_body_size 512M;
    fastcgi_buffers 8 4K;
    fastcgi_ignore_headers X-Accel-Buffering;
  
    gzip off;
  
    error_page 403 /core/templates/403.php;
    error_page 404 /core/templates/404.php;
  
    location / {
        rewrite ^ /index.php$uri;
    }
  
    location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
        return 404;
    }

    location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) {
        return 404;
    }
  
    location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+|core/templates/40[34])\.php(?:$|/) {
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param HTTPS on;
        fastcgi_param modHeadersAvailable true;
        fastcgi_param front_controller_active true;
        fastcgi_read_timeout 180;
        fastcgi_pass php-handler;
        fastcgi_intercept_errors on;
        fastcgi_request_buffering off; #Available since NGINX 1.7.11
    }
  
    location ~ ^/(?:updater|ocs-provider)(?:$|/) {
        try_files $uri $uri/ =404;
        index index.php;
    }
  
    location ~ \.(?:css|js)$ {
        try_files $uri /index.php$uri$is_args$args;
        add_header Cache-Control "max-age=15778463";
        add_header Strict-Transport-Security "max-age=15552000; includeSubDomains";
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Robots-Tag none;
        add_header X-Download-Options noopen;
        add_header X-Permitted-Cross-Domain-Policies none;
        access_log off;
    }

    location ~ \.(?:svg|gif|png|html|ttf|woff|ico|jpg|jpeg|map)$ {
        add_header Cache-Control "public, max-age=7200";
        try_files $uri /index.php$uri$is_args$args;
        access_log off;
    }
}
```

**7.** Now save and exit out of the file by pressing **CTRL + X**, then **Y**, followed by **ENTER**.

**8.** As we have made changes to NGINX’s configuration we need to restart it’s service by running the following command:

`sudo systemctl restart nginx`

### Tweaking PHP for Owncloud
With NGINX now set up, we can now go ahead and prepare PHP to work with our Owncloud installation. As we use php-fpm, there are a few additional things we need to do.

**1.** Now that is done, there are a few more configurations we will need to update, first open up the PHP config file by entering.

`sudo nano /etc/php/7.3/fpm/php.ini`

**2.** In this file, we want to find and update the following lines. (**CTRL + W** allows you to search)

**Find**

`upload_max_filesize = 2M`

**Replace With**

`upload_max_filesize = 2000M`

**Find**

`post_max_size = 8M`

**Replace With**

`post_max_size = 2000M`

**3.** Once done, save and then exit by pressing **CTRL + X**, followed by **Y**, then **ENTER**.

**4.** Our next step is to make some changes to the php-fpm pool configuration. The reason for this is that php-fpm can’t access environment variables.

Run the following command to begin modifying the configuration file.

`sudo nano /etc/php/7.3/fpm/pool.d/www.conf`

**5.** Within this file, find the following block of code and replace it with what we have below.

You can use **CTRL + W** to find this block of code faster. Typically its located near the bottom of the file.

**Find**
```
;env[HOSTNAME] = $HOSTNAME
;env[PATH] = /usr/local/bin:/usr/bin:/bin
;env[TMP] = /tmp
;env[TMPDIR] = /tmp
;env[TEMP] = /tmp
```

**Replace With**
```
env[HOSTNAME] = $HOSTNAME
env[PATH] = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp
```

**6.** With these changes made, go ahead and save the file by pressing **CTRL + X**, followed by **Y**, then **ENTER**.

### Adding Swap Memory
Our next step is to add some swap memory to our system.

Adding swap memory allows the Raspberry Pi to work further beyond its memory by making use of space on the storage device. While a lot slower then RAM it is better then the program crashing

**1.** To increase the amount of swap memory, we need to modify a file called **dphys-swapfile**.

To modify this file, make use of the following command:

`sudo nano /etc/dphys-swapfile`

**2.** Within this file, find the following line and change it to what we have below.

**Find**

`CONF_SWAPSIZE=100`

**Replace With**

`CONF_SWAPSIZE = 512`

**3.** Once done, save and then quit by pressing **CTRL + X**, followed by **Y**, then **ENTER**.

**4.** For our changes to take effect, we will need to now restart the Raspberry Pi by running the command below.

`sudo reboot`

### Setting up MYSQL on a Raspberry Pi
**1.** We have to install the MySQL server software to your Raspberry Pi.

Installing MySQL to the Raspberry Pi is a simple process and can be done with the following command:

`sudo apt install mariadb-server`

**3.** With the MySQL server software installed to the Raspberry Pi, we will now need to secure it by setting a password for the **"root"** user.

By default, MySQL is installed without any password set up meaning you can access the MySQL server without any authentication.

Run the following command to begin the MySQL securing process:

`sudo mysql_secure_installation`

Just follow the prompts to set a password for the root user and to secure your MySQL installation.

For a more secure installation, you should answer **"Y"** to all prompts when asked to answer **"Y"** or **"N"**.

These prompts will remove features that allows someone to gain access to the server easier.

Make sure you write down the password you set during this process as we will need to use it to access the MySQL server and create databases and users for software such as WordPress or PHPMyAdmin.

**4.** Now let's test the access to your Raspberry Pi’s MySQL server, you can enter the following command:

`sudo mysql -u root -p`

**5.** There are two different ways you can quit out of the MYSQL command line, the first of those is to type **"quit;"** into the MySQL interface.

The other way of quitting out of the MYSQL command line is to press **CTRL + D**.

### Setting up a MySQL Database & User for Owncloud
**1.** To be able to create our database, we will need to make use of the MySQL command-line interface.

We can load up the tool by running the following command:

`sudo mysql -u root -p`

**2.** Once logged in, you can begin interacting with your MySQL server.

The database we will be creating is called **ownclouddb**. We can create this database by running the following command:

`CREATE DATABASE ownclouddb;`

**3.** With the database created, let’s now create a user that can interact with it.

We can create a user called **ownclouduser** by running the command below. Make sure that you replace **[PASSWORD]** with a secure password and make a note of it for later.

`CREATE USER 'ownclouduser'@'localhost' IDENTIFIED BY '[PASSWORD]';`

**4.** Our next step is to give access permissions to our new user.

We can grant these privileges by running the following command:

`GRANT ALL PRIVILEGES ON ownclouddb.* TO 'ownclouduser'@'localhost';`

**5.** The final task is to flush the privileges. If we don’t do this, then our changes won’t be utilized by the server.

To flush the privileges, all we need to do is run the following command:

`FLUSH PRIVILEGES;`

**6.** Once the privilege table has been flushed, we can proceed to install and set up the Owncloud software.

To quit out of the MYSQL command line, the first of those is to type **"quit;"** into the MySQL interface or by pressing press **CTRL + D**.

### Downloading & Extracting Owncloud
Now in this section, we will be installing the actual Owncloud software on to our Raspberry Pi. Installing Owncloud requires a couple of straightforward steps.

**1.** Once the Pi has restarted, you will need to install Owncloud onto the Raspberry Pi.

Let us change in to the directory where we will be running the script from.

`cd /var/www/`

**2.** Now that we are in the right directory we can now download the latest version of Owncloud.

To do this we will make use of **wget** by running the command below:

`sudo wget https://download.owncloud.org/community/owncloud-latest.tar.bz2`

**3.** Now extract the archive we downloaded by using **tar**.

`sudo tar -xvf owncloud-latest.tar.bz2`

**4.** With everything extracted we need to make sure that the **www-data** owns the files.

We can recursively modify the permissions of the file by using the chown command.

`sudo chown -R www-data:www-data /var/www`

**5.** Now we need to open up the **.user.ini** file to enforce some of the changes we made earlier in the tutorial

`sudo nano /var/www/owncloud/.user.ini`

**6.** In here update the following values, so they are 2000M:
```
upload_max_filesize=2000M
post_max_size=2000M
memory_limit=2000M
```

**7.** Now that is done, we should be able to connect to Owncloud at your PI’s IP address, or **localhost**.

`hostname -I`

Before you set up the admin account, you might want to mount an external drive, so you have lots of disk space for your Raspberry Pi Owncloud server. Just follow the instructions in the next section.

### Mounting & Setting up a Drive
Setting up an external drive while should be relatively straightforward but sometimes things don’t work as correctly as they should.

These instructions are for mounting and allowing Owncloud to store files onto an external hard drive.

**1.** Firstly if you have an NTFS drive we will need to install an NTFS package by entering the following:

`sudo apt-get install ntfs-3g`

**2.** Now let’s make a directory we can mount.

```
sudo mkdir /media/ownclouddrive
sudo mount /dev/sda1 /media/ownclouddrive
```

If this error below occur, type `sudo umount /media/ownclouddrive`.

```
Mount is denied because the NTFS volume is already exclusively opened. 
The volume may be already mounted, or another software may use it which
could be identified for example by the help of the 'fuser' command.
```

**3.** Lets make a data directory where the data is stored:
```
cd /media/ownclouddrive
sudo mkdir data
```

**4.** Now lets make sure the drive is mounted at boot.

`sudo nano /etc/fstab`

**5.** Now we need to get the **GID**, **UID**, and the **UUID** as we will need to use these soon.

Enter the following command for the **GID**:

`id -g www-data`

**6.** Now for the **UID** enter the following command:

`id -u www-data`

**7.** Also if we get the **UUID** of the hard drive, the Pi will remember this drive even if you plug it into a different USB port.

`ls -l /dev/disk/by-uuid`

Copy the light blue letters and numbers of the last entry (Should have something like -> **../../sda1** at the end of it).

**8.** Now let’s add your drive into the fstab file so that it will boot with the correct permissions.

`sudo nano /etc/fstab`

**9.** Now add the following line to the bottom of the file, updating UID, GUID and the UUID with the values we got above. (The following should all be on a single line)
```
UUID=[UUID] /media/ownclouddrive auto nofail,uid=[UID],gid=[GID],umask=0027,dmask=0027,noatime 0 0
```

**10.** Lets make sure ownCloud can write to the disk

`sudo chown -R www-data:www-data /media/ownclouddrive/data`

**11.** Reboot the Raspberry Pi, and the drives should automatically be mounted. If they are mounted, we’re all good to go.

Note: If you get an error stating the Pi is in emergency mode at boot up then this likely means a problem with the fstab entry. Just edit the fstab file (`sudo nano /etc/fstab`) and remove the added line or look for a mistake and fix it.

### Setting up Owncloud
**1.** In your favorite web browser, you need to go to your Raspberry Pi’s IP address.

If you don’t know your Pi’s local IP, you can run the following command:

`hostname -I`

**2.** Once you go to the IP you’re like to get a certificate error, add this to your exception list as it will be safe to proceed.

On **Chrome**, you click the **Show advanced button**, then click **"Proceed to [YOURPISIPADDRESS] (unsafe)"**.

**3.** When you first open up Owncloud, you will need to do some initial setup steps.

1. The first thing you need to do is specify a **username** and **password** for your Owncloud admin account.

2. Next, we need to bring up the storage and database settings. You can do this by clicking the **"Storage & database"** dropdown. If you want to use the internal Raspberry Pi usage, specify **/var/www/owncloud/data**. If you want to use the external usage, remove the current location and add **/media/ownclouddrive/data**.

3. We then need to bring up the MySQL database options. You can find these by clicking the **MySQL/MariaDB** toggle.

4. Next, we need to fill out three bits of information, the database user, the password for that user, and the database name.

4.1. First, you need to specify the **"Database user"**. If you are following this guide, this should be `ownclouduser`.

4.2. The second option you will need to specify the password you set for the above user.

4.3. Finally, we need to set the database name. If you have used the ones from this tutorial, you should set this to **ownclouddb**.

5. Once you have finished with all the settings, click the **Finish** setup button.

### Setting up Memory Caching for Owncloud
In this section, we will be showing you how to configure Owncloud to make use of APCu and Redis. APCu is used as an object memory cache, and Redis is used to deal with transactional file locking.

Using both of these will help improve the performance of Owncloud on your Raspberry Pi.

**1.** To be able to enable these, we ill need to make a change to the Owncloud configuration file.

Begin editing this file by running the following command:

`sudo nano /var/www/owncloud/config/config.php`

**2.** Within this file, find the following line and add the block of text below it.

**Find**

`'installed' => true,`

**Add Below**
```
  'memcache.local' => '\OC\Memcache\APCu',
  'memcache.locking' => '\OC\Memcache\Redis',
  'redis' => [
    'host' => 'localhost',
    'port' => 6379,
  ],
```

**3.** Once done, save the file by pressing **CTRL + X**, then **Y**, followed by **ENTER**.

### Using System Cron with Owncloud
The Owncloud team recommends that you should set it up so that the operating system runs the scripts cron jobs instead of Ajax.

**1.** To be able to set up a cron job for Owncloud, we will need to make use of the **www-data** user’s crontab.

Begin modifying the user’s cron by running the following command:

`sudo crontab -u www-data -e`

If you are asked what editor you should use to modify the crontab, we highly recommend that you use **nano**.

**2.** Add the following line to the bottom of this file.

`*  *  *  *  * /usr/bin/php /var/www/owncloud/occ system:cron`

This line will run Owncloud’s cron job every minute.

**3.** Once done, save the file by pressing **CTRL + X**, followed by **Y**, then **ENTER**.

You should now have Owncloud set up correctly on your Raspberry Pi.

### Port Forwarding & External Access
If you want to have access to your cloud drive outside your local network, then you will need to setup port forwarding and make a few changes to our config files.

Firstly, we need to go back to the default file and change the server_name values (There is 2 of them). Update these to your external IP address. You can get your IP at **what is my IP**, searched on google.

If you have a dynamic IP you may want to set up a dynamic DNS and use that as your address. You can find information on this in my guide to port forwarding.

**1.** Enter the following to bring up our default server file:

`sudo nano /etc/nginx/sites-available/default`

**2.** Once you have updated the IP’s in the server file, you will need to add the external IP to your trusted IP list and make sure Owncloud doesn’t overwrite it. To do this open up the Owncloud config file and enter:

`sudo nano /var/www/owncloud/config/config.php`

**3.** In here add a new item to the trusted domains **array** (This will be your external IP address). Your new entry should look something like this (x are just placeholders).

`1 => 'xxx.xxx.xxx.xxx',`

**4.** Finally update the URL of the overwrite.cli.url line to your IP Address. It should look something like this.

`'overwrite.cli.url' => 'https://xxx.xxx.xxx.xxx',`

**5.** Once done, restart the Nginx service by entering the following:

`sudo service nginx restart`

### Setting Up Raspberry Pi Port Forwarding
Raspberry Pi port forwarding is a method where can allow external access to the Pi. To do this, we will need to change some settings on the router.

All routers are different but I will try and make this as generic as possible however there could still be a lot of differences between these instructions and your router. The router I am using for this tutorial is the **TP-Link** or **Telekom** wireless dual band gigabit router.

**1.** On a computer that is connected to the local network, connect to the router admin page via a web browser.

A router IP typically is `192.168.1.1` or `192.168.1.254`

Once you go to the IP you’re might like to get a certificate error, add this to your exception list as it will be safe to proceed.

On **Chrome**, you click the **Show advanced button**, then click **"Proceed to [YOURPISIPADDRESS] (unsafe)"**.

**2.** Enter the **username** and **password** for the router.

**TP-Link**

In the router admin page head to **forwarding->virtual server**.

On this page enter the following:

- **Service Port**: This is the external port. (**80**)
- **IP Address**: This is the IP of the Pi. (use `hostname -I`)
- **Internal Port**: Set this to Pi’s application port. (A web server runs on port **80** for example)
- **Protocol**: Set this to **ALL** unless specified or **TCP - UDP**.
- **Status**: Set this to **Enabled**.

**Telekom**

In the router admin page head to **Access Control->Port Forwarding->Add Rule**.

On this page enter the following:

- **Custom service name**: What name do you want (**Raspberry**)
- **Service**: Other
- **External host**: You don't have to type nothing (*)
- **Internal host**: This is the IP of the Pi. (use `hostname -I`)
- **Protocol**: TCP - UDP
- **External Port**: 80
- **Internal Port**: 80

**3.** These settings will route traffic destined for the port specified to the port on the Raspberry Pi.

**4.** You should now be able to connect to the application on the Raspberry Pi outside your network. Connect from other PCs on lan using the `hostname -I`**:80** address.