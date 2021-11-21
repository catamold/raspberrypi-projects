---
title: Server Security
parent: FTP Server
has_children: false
---

# Server Security

## Server Monitoring Logs

**1.** Enable logs in the **vsftpd session** by uncommenting or adding the following lines:

`sudo nano /etc/vsftpd.conf`

```
xferlog_enable=YES
xferlog_file=/var/log/vsftpd.log
log_ftp_protocol=YES
xferlog_std_format=NO 
```

**2.** You can check the **vsftpd session logs** to see a history of connections made to your **FTP server**.

`sudo cat /var/log/vsftpd.log`

## Deny hosts from accessing the FTP server

**1.** Add hosts in the **ftphosts** file. Save and crete the file.

`sudo nano /etc/ftphosts`

**2.** Then add a line to **/etc/pam.d/vsftpd** file to deny the hosts listed in **ftphosts** file after the line with **ftpusers**.

`sudo nano /etc/pam.d/vsftpd`

```
auth     required       pam_listfile.so item=user sense=deny file=/etc/ftpusers onerr=succeed
auth     required       pam_listfile.so item=host sense=deny file=/etc/ftphosts onerr=succeed
```

## Install fail2bam

**1.** To install the **fail2ban** package for your Linux distribution type the following command:

`sudo apt-get install fail2ban`

**2.** After you install fail2ban, you are ready to configure it. To do this, follow these steps. The **jail.conf** file contains a basic configuration that you can use as a starting point, but it may be overwritten during updates. **Fail2ban** uses the separate **jail.local** file to actually read your configuration settings.

`sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local`

**3.** Open the **jail.local** file in a text editor and edit the following lines how you want.

`sudo nano /etc/fail2ban/jail.local`

- **ignoreip**: This option enables you to specify IP addresses or hostnames that fail2ban will ignore. 
- **bantime**: This option defines in seconds how long an IP address or host is banned. The default is 600 seconds (10 minutes). If you want the bantime to be permanent, type **-1**.
- **maxretry**: This option defines the number of failures a host is allowed before it is banned.
- **findtime**: This option is used together with the maxretry option. If a host exceeds the maxretry setting within the time period specified by the findtime option, it is banned for the length of time specified by the bantime option.

**4.** Search for **[vsftpd}** in  **/etc/fail2ban/jail.local** file and make sure that it looks like this:

```
[vsftpd]
enabled = true
port = ftp,ftp-data,ftps,ftps-data
logpath = %(vsftpd_log)s
```

**5.** Open the **filter** file and make sure that it looks like this:

`sudo nano /etc/fail2ban/filter.d/vsftpd.conf`

```
[INCLUDES]

before = common.conf

[Definition]

__pam_re=\(?%(__pam_auth)s(?:\(\S+\))?\)?:?
_daemon = vsftpd

failregex = ^%(__prefix_line)s%(__pam_re)s\s+authentication failure; logname=\S* uid=\S* euid=\S* tty=(ftp)? ruser=\S* rhost=<HOST>(?:\s+user=.*)?\s*$
^ \[pid \d+\] \[[^\]]+\] FAIL LOGIN: Client "<HOST>"(?:\s*$|,)
^ \[pid \d+\] \[root\] FAIL LOGIN: Client "<HOST>"(?:\s*$|,)

ignoreregex =
```


**6.** Restart the **fail2ban** service and load the new configuration, by typing the following command:

`sudo systemctl restart fail2ban`


**7.** Check the status of the new **Jail**, and make one fail to attempt to log in to see if it captures the event.

`sudo fail2ban-client status vsftpd`

```
Status for the jail: vsftpd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     3
|  `- File list:        /var/log/vsftpd.log
`- Actions
   |- Currently banned: 1
   |- Total banned:     1
   `- Banned IP list:   192.168.0.101
```

**8.** To display a list of IP addresses currently banned by fail2ban, type the following command:

`sudo iptables -S`

**Example in this case the user with the ip address 192.168.0.101/32 is banned for accessing the FTP (21) and SFTP (22) server**

```
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-N f2b-sshd
-N f2b-vsftpd
-A INPUT -p tcp -m multiport --dports 21,20,990,989 -j f2b-vsftpd
-A INPUT -p tcp -m multiport --dports 22 -j f2b-sshd
-A f2b-sshd -j RETURN
-A f2b-vsftpd -s 192.168.0.101/32 -j REJECT --reject-with icmp-port-unreachable
-A f2b-vsftpd -j RETURN
```

**9.** To unban a user that was banned, type the following command followed by his **ip address**:

`sudo fail2ban-client unban 192.168.0.101`

## Port forwarding

**1.** Create an account on [NO-IP](https://my.noip.com/).

**2.** Port forwarding on all routers.

