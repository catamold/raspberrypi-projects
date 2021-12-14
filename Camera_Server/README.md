---
title: Camera Server
has_children: true
nav_order: 1
---

## Camera Server

### Install Motion

**1.** Install some **motion** dependencies:

```
sudo apt install autoconf automake build-essential pkgconf libtool git libzip-dev libjpeg-dev gettext libmicrohttpd-dev libavformat-dev libavcodec-dev libavutil-dev libswscale-dev libavdevice-dev default-libmysqlclient-dev libpq-dev libsqlite3-dev libwebp-dev
```

**2.** Install **ffmpeg** and other **motion** dependencies:

```
sudo apt-get install ffmpeg libmariadb3 libpq5 libmicrohttpd12 -y
```

**3.** Install **motion**. You can also install the latest version of **motion** from [Mition-Project](https://github.com/Motion-Project/motion/releases):

```
wget https://github.com/Motion-Project/motion/releases/download/release-4.3.2/pi_buster_motion_4.3.2-1_armhf.deb 
sudo dpkg -i pi_buster_motion_4.3.2-1_armhf.deb 
```

### Install on Raspbian Bullseye (Optional)

**1.** Disable motion service, motionEye controls motion:

```
sudo systemctl stop motion
sudo systemctl disable motion 
```

**2.** Install the dependencies from the repositories:

```
sudo apt-get install python2 python-dev-is-python2 -y
sudo curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
sudo apt-get install libssl-dev libcurl4-openssl-dev libjpeg-dev zlib1g-dev -y
```

**3.** Install **motioneye**, which will automatically pull Python dependencies (`tornado`, `jinja2`, `pillow` and `pycurl`):

`sudo pip install motioneye`

**4.** Prepare the configuration directory:

```
sudo mkdir -p /etc/motioneye
sudo cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
```

**5.** Prepare the media directory:

`sudo mkdir -p /var/lib/motioneye`

**6.** Add an init script, configure it to run at startup and start the **motionEye** server:

```
sudo cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
sudo systemctl daemon-reload
sudo systemctl enable motioneye
sudo systemctl start motioneye
```

### Upgrade motionEye (Optional)

**1.** To upgrade to the newest version of **motionEye**, just issue:

```
sudo pip install motioneye --upgrade
sudo systemctl restart motioneye
```

**2.** To upgrade to a specific version (**say 0.27.1**), use:

`pip install --upgrade motioneye==0.27.1`

### Configure Motion

**1.** Configure the **motion.conf** file with the following lines.

`sudo nano /etc/motion/motion.conf`

Change the following:
```
daemon on
webcontrol_port 8080
webcontrol_localhost off
stream_port 8081
stream_localhost off
```

You can also change some of the camera configuration:
```
width 640
height 480
framerate 30
movie_quality 45
```

**2.** To enable the **motion daemon**, change the status of the `start_motion_daemon` in the **motion** file:

`sudo nano /etc/default/motion`

```
start_motion_daemon=yes
```

**3.** Reboot Pi, then access the localhost page on the **stream port** 8081 (**http://192.168.xx.xx:8081**):

`sudo reboot`

**4.** To *stop/start* or *check* the **motion** server, type the following:

```
sudo service motion stop
sudo service motion start
sudo service motion status
```