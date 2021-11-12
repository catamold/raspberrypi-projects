---
title: Update NextCloud
parent: Next Cloud Server
has_children: false
---

## Update NextCloud

**1.** Before updating the NextCloud, put your server into **maintenance mode**, by setting it to *true*. Edit the configuration file of the NextCloud server.

`sudo nano /var/www/html/nextcloud/config/config.php`

```
"maintenance" => true,
```

**2.** Update Nextcloud using the **Setting panel** of the **Admin user**.


**3.** After update, change back the **maintenance mode**, by setting it to *false*. Edit the configuration file of the NextCloud server.

`sudo nano /var/www/html/nextcloud/config/config.php`

```
"maintenance" => false,
```

### Stuck on Update Process (Step 5 is currently in process)

**1.** Go into the file **/var/www/nextcloud/updater/index.php** and comment the lines:

```
if($stepState === 'start') {
		die(
		sprintf(
				'Step %s is currently in process. Please reload this page later.',
				$stepNumber
				)
		);
}
```

**2.** Continue with the update using the **Setting panel** of the **Admin user**.