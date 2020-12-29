---
title: Backup
parent: Personal Cloud Storage
has_children: false
---

## Backup

**1.** Backup the Database
`mysqldump -u<username> -p<password> <databasename> > <ownCloud-Version-Dump.sql>`

**2.** Backup owncloud
`sudo tar -czvf <filename>.tar.gz <your_file>`