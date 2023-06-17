---
title: Cloud Print
parent: Print Server
has_children: false
---

## Cloud Print

### Useful commands
Show available printers:

`lpstat -p | awk '{print $2}'`

Print a document on a custom printer:

`lp [document_name] -d [printer_name]`

Check the status of a custom printer (active):

`lpstat -d HP_LaserJet_1018 -t | grep 'idle'`

## Automate files print directly from ownCloud server using Cron
To automate the print directly from the cloud, we use crontab to run the [autoPrint_ownCloud.sh](https://github.com/catamold/raspberrypi-projects/releases/download/v1.0/autoPrint_ownCloud.sh) bash file every 1 minute (`* * * * * [FILE_LOCATION]/autoPrint_ownCloud.sh`) or 3 minutes (`*/3 * * * *`), etc. The script checks if files are stored in the **Print_HP** directory from ownCloud, then print all the documents and delete them from the cloud.

## Automate files print directly from nextCloud server
To automate the print directly from the cloud, we use crontab to run the change the bash file above with the following:

```
#!/bin/bash

## Check for files
refresh_request=false
while read -r dname; do
    if [ "$(sudo ls -A $dname)" ]; then
        refresh_request=true
    fi
done <<<$(sudo find /media/nextclouddrive/data/ -name "Print_HP")

## Print all files in Print_HP folder from all users
if [ "$refresh_request" = "true" ]; then
	
	## Check if printer is idle
	if lpstat -d HP_LaserJet_1020_raspberrypi -t | grep 'idle'; then
		sudo find /media/nextclouddrive/data/ -name "Print_HP"|while read dname; do
			sudo find "$dname" -type f|while read fname; do
				echo "printing file: " $dname
				sudo lpr -P HP_LaserJet_1020_raspberrypi "$fname"
			done
		done
	
		## Delete all files in Print_HP directory form all users
		sudo find /media/nextclouddrive/data/ -name "Print_HP"|while read dname; do
			sudo find "$dname" -type f -delete
		done

		## Refresh nextclouddrive database
		cd /var/www/html/nextcloud
		sudo -u www-data php occ files:scan --all &
		
		wait $!
		echo "nextcloud server updated!"
	fi
fi
```