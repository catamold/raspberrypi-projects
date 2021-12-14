---
title: Cast Camera To Chromecast
parent: Camera Server
has_children: false
---

## Cast Camera To Chromecast

**1.** Install PIP in otder to use **pip3** to install CATT.

```
sudo apt install python3-pip
sudo pip3 install catt
```

**2.** Now, try searching for Chromecast devices

`catt scan`

Example of output
```
Scanning Chromecasts...
192.168.xx.xx Kitchen Google Inc. Google Home Mini
192.168.xx.xx Living room Google Inc. Google Nest Hub
```

**3.** Display a website (or the local camera streaming) on Chromecast

`catt -d 192.168.xx.xx cast_site http://192.168.xx.xx`

**4.** You can also cast a Youtube video on Chromecast

`catt -d 192.168.xx.xx cast https://youtu.be/xxxxxxxxxx`
