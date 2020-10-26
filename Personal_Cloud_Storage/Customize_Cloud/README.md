---
title: Customize Cloud
parent: Personal Cloud Storage
has_children: false
---

## Customize Cloud

### Change the Default Background Image and logo of OwnCloud
Inside the core/img directory where ownCloud was installed, you will find the background image **background.jpg**. Rename it and upload your new image as **background.jpg**. You can also change **logo.png** and **logo.svg**.

### Replace Default Owncloud Text in Login Page
This page can be found under ownCloud’s installation directory in **/lib/private/legacy/defaults.php**. Use your preferred Linux text editor to change the text.
```
$this->defaultEntity = 'iCloud'; /* e.g. company name, used for footers and copyright notices */
$this->defaultName = 'iCloud'; /* short name, used when referring to the software */
$this->defaultTitle = 'iCloud'; /* can be a longer name, for titles */
$this->defaultBaseUrl = 'https://[your_address]/';
                
$this->defaultSlogan = $this->l->t('Private and Secure');
```