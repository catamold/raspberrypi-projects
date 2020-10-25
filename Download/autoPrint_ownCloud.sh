#!/bin/bash

## Check for files
refresh_request=false
while read -r dname; do
    if [ "$(sudo ls -A $dname)" ]; then
        refresh_request=true
    fi
done <<<$(sudo find /media/ownclouddrive/data/ -name "Print_HP")

## Print all files in Print_HP folder from all users
if [ "$refresh_request" = "true" ]; then
	sudo find /media/ownclouddrive/data/ -name "Print_HP"|while read dname; do
		sudo find "$dname" -type f|while read fname; do
			sudo lp "$fname" -d HP_LaserJet_1018
		done
	done
	
	##if lpstat -d HP_LaserJet_1018 -t | grep 'idle'; then ## Check if printer is idle
	
	## Delete all files in Print_HP directory form all users
	sudo find /media/ownclouddrive/data/ -name "Print_HP"|while read dname; do
		sudo find "$dname" -type f -delete
	done

	## Refresh ownCloud database
	cd /var/www/owncloud
	sudo -u www-data php occ files:scan --all &
	
	wait $!
	echo "onwCloud server updated!"
fi