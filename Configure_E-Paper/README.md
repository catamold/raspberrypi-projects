---
title: Configure E-Paper
has_children: false
---

## Configure Electronic Paper for 2.13 inch E-paper(BRW)

**1.** Connect the Hat board of the e-paper to the GPIO pins of the Raspberry Pi. Then configure the basic environment:

```
sudo apt-get update
sudo apt-get -y install libpng-dev
sudo apt-get -y purge wiringpi
sudo hash -r
cd /tmp
wget https://project-downloads.drogon.net/wiringpi-latest.deb
sudo dpkg -i wiringpi-latest.deb
gpio -v
```

**2.** Enable **SPI interface** via `sudo raspi-config` tool.

**3.** Install `spidev`, `RPi.GPIO` and `PIL(Pillow)` libraries in **Python**:

```
pip3 install pillow
pip3 install RPi.GPIO
pip3 install spidev
```

**3.** Try the **2.13 inch E-paper(BRW)** with this [**demo code**](). The display will flash red, black, white and finally a picture. The **demo.png** in the code is just a sample picture and can be generated according to your needs. The format of the picture is recommended to use the **PNG format** and the size of the picture: **122x250 pixels**. The specifications of the **2.13 inch E-paper(BRW)** can be found [here]().

```
python3 eink2.13_demo.py
```

## Understanding the code