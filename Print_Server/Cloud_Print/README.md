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
To automate the print directly from the cloud, we use crontab to run the autoPrint_ownCloud.sh bash file every 1 minute. The script checks if files are stored in the **Print_HP** directory from ownCloud, then print all the documents and delete them from cloud.