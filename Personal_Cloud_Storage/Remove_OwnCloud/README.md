---
title: Remove OwnCloud
parent: Personal Cloud Storage
has_children: false
---

## Remove OwnCloud
```
sudo rm -r /etc/nginx

sudo rm -r /var/www/

sudo apt-get remove nginx openssl ssl-cert php7.3-xml php7.3-dev php7.3-curl php7.3-gd php7.3-fpm php7.3-zip php7.3-intl php7.3-mbstring php7.3-cli php7.3-mysql php7.3-common php7.3-cgi php7.3-apcu php7.3-redis redis-server php-pear curl libapr1 libtool libcurl4-openssl-dev

sudo apt-get --purge remove nginx-*

sudo apt-get install nginx
```