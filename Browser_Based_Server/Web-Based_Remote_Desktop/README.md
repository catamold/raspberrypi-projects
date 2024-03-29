---
title: Web-Based Remote Desktop
parent: Browser Based Server
has_children: false
---

## Web-Based Remote Desktop

### Installing Guacamole
**1.** Install the following dependencies.

```
sudo apt-get install libcairo2-dev libjpeg62-turbo-dev libpng12-dev libossp-uuid-dev
sudo apt-get install libfreerdp-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libpulse-dev libssl-dev libvorbis-dev libwebp-dev
```

In case you receive this error: **Package libpng12-dev has no installation candidate**, the package *libpng12-dev* was dropped after 16.04. It's been gone a long time. Try **'libpng-dev'** instead.

In case you receive this error: **Unable to locate package libfreerdp-dev**, the package is obsolete, you should install **'freerdp2-dev'** instead.

**2.** Check the name of the latest version of [Guacamole source code server](https://sourceforge.net/projects/guacamole/files/current/source/) (i.e. **guacamole-server-0.9.14.tar.gz**, then download it, uncompress it and then change into the new directory.

```
wget http://downloads.sourceforge.net/project/guacamole/current/source/guacamole-server-0.9.14.tar.gz
tar -zxvf guacamole-server-0.9.14.tar.gz
cd guacamole-server-0.9.14
```

**3.** Now we will compile Guacamole and set it up so that it starts when the pi starts.

```
sudo ./configure -with-init-dir=/etc/init.d
sudo make
sudo make install
```

In case you receive this error:

```        
typescript.c: In function ‘guac_terminal_typescript_alloc’:                                 
typescript.c:133:46: error: ‘%s’ directive writing 6 bytes into a region of size between 0 and 2047 [-Werror=format-overflow=]
  133 |     sprintf(typescript->timing_filename, "%s.%s", typescript->data_filename,
```

Then paste the following:

```
sudo apt-get remove gcc g++

sudo apt-get update && \
sudo apt-get install build-essential software-properties-common -y && \
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
sudo apt-get update && \
sudo apt-get install gcc-snapshot -y && \
sudo apt-get update && \
sudo apt-get install gcc-6 g++-6 -y && \
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6
```

**4.** When finished, change out of the guacamole directory, back to home directory, download and uncompress the [Guacamole Client Source Code](https://sourceforge.net/projects/guacamole/files/current/source/) with the same version as the server.

```
cd
wget http://sourceforge.net/projects/guacamole/files/current/source/guacamole-client-0.9.14.tar.gz
tar -zxvf guacamole-client-0.9.14.tar.gz
cd guacamole-client-0.9.14
```
**5.** Install some extra tools needed to compile the client, like **Maven**.

`sudo apt-get install maven`

**6.** Install **Apache Tomcat**. This makes your pi zero into a powerful dynamic java servlet web server and allows it to broadcast desktops visually with **HTML5** over the network into client web browsers.

`sudo apt-get install tomcat7 tomcat7-admin tomcat7-docs`

**7.** Compile the Guacamole client.

`mvn package`

**8.** Now we will copy the compiled .war file to the Tomcat directory.

`sudo cp guacamole/target/guacamole-0.9.9.war /var/lib/tomcat7/webapps/guacamole.war`

**9.** Create a location for Guacamole configuration files.

`sudo mkdir /etc/guacamole`

**10.** Edit **/etc/guacamole/guacamole.properties**.

`sudo nano /etc/guacamole/guacamole.properties`

```
# Hostname and port of guacamole proxy
guacd-hostname: localhost
guacd-port: 4822
```

**11.** Now create a connection config file. Edit **/etc/guacamole/user-mapping.xml**.

`sudo nano /etc/guacamole/user-mapping.xml`

```
<user-mapping>

<!-- Per-user authentication and config information -->
<authorize username="username" password="password">
<protocol>rdp</protocol>
<param name="hostname">localhost</param>
<param name="port">3389</param>
</authorize>
</user-mapping>
```

**12.** Create a directory in tomcat7 for the connection file to go into.

`sudo mkdir /usr/share/tomcat7/.guacamole`

**13.** Link this to the files you just created.

```
sudo ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat7/.guacamole
sudo ln -s /etc/guacamole/user-mapping.xml /usr/share/tomcat7/.guacamole
```

**14.** Install RDP client to allow remote desktop broadcasting.

`sudo apt-get install rdesktop  freerdp-x11 xrdp`

**15.** Restart guacamole and tomcat

```
sudo service guacd restart
sudo service tomcat7 restart
```

**16.** Connect to your **pi's remote desktop** by opening up your web browser, and navigate to **https://[Your-IP-Adress]:8080/guacamole**
