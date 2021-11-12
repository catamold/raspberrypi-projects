---
title: Web-Based SSH Terminal
parent: Browser Based Server
has_children: false
---

## Web-Based SSH Terminal

### Installing Shellinabox on Debian
**1.** Make sure that your repository enabled and available to install Shellinabox from the that repository. To check, do a search for Shellinabox with the “apt-cache” command and then install it using **“apt-get”** command.

```
sudo apt-cache search shellinabox
sudo apt-get install openssl shellinabox
```

**2.** By default, **shellinaboxd** listens on **TCP** port **4200** on **localhost**. For security reason, you can change this default port to a random one (i.e. **6175**) to make it difficult for anyone to reach your **SSH** box. Also, during installation a new self-signed SSL certificate automatically created under **“/var/lib/shellinabox”** to use **HTTPS** protocol.

`sudo nano /etc/default/shellinabox`

**3.** Change the **SHELLINABOX_PORT** with the one you want to access the **Web-browser SSH Terminal** and also add the **SHELLINABOX_ARGS** in order to allow access to the local server only with the custom domain. Instead of **[Your-IP-Adress]** type your domain adress (i.e. **192.168.0.101**).

```
# TCP port that shellinboxd's webserver listens on
SHELLINABOX_PORT=6175

# specify the IP address of a destination SSH server
SHELLINABOX_ARGS="--o-beep -s /:SSH:[Your-IP-Adress]"

# if you want to restrict access to shellinaboxd from localhost only
SHELLINABOX_ARGS="--o-beep -s /:SSH:[Your-IP-Adress] --localhost-only"
```

**4.** At the end of the file you can also add additional custom options to the **Web-browser SSH Terminal page**.

```
# Additional examples with custom options:

# Fancy configuration with right-click menu choice for black-on-white:
OPTS="--user-css Normal:+white-on-black.css,Reverse:-black-on-white.css --disable-ssl-menu -s /:LOGIN"
```

**5.** Start the **Shellinabox** service. The **Shellinabox** service will automatically start whenever you restart the Raspberry Pi.

```
sudo service shellinaboxd start
sudo /etc/init.d/shellinabox restart
```

**6.** Now let’s verify whether **Shellinabox** is running on port **6175** using **“netstat”** command.

`/etc/init.d/shellinabox status`

**7.** Now open up your web browser, and navigate to **https://[Your-IP-Adress]:6175**. You should be able to see a web-based **SSH terminal**. Login using your **username** and **password** and you should be presented with your shell prompt. You can **right-click** to use several features and actions, including changing the look and feel of your shell.

**8.** To stop the **Shelinabox** server type the following:

`sudo service shellinaboxd stop`