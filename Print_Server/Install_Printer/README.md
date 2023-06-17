---
title: Install Printer
parent: Print Server
has_children: false
---

## Install Printer

### HP Linux Imaging and Printing

#### Installation

First, fearch for HPLIP software:

`apt-cache search hplip`

Then, install the latest version of HPLIP:

`sudo apt-get update && sudo apt-get install hplip`

Install the `hplip-gui` package:

`sudo apt-get install hplip-gui`

Some HP printers, *like HP_LaserJet_1020*, require proprietary software technologies to allow full access to printer features and performance. For this we have to install the *HPLIP Binary Plug-In*.

`sudo hp-plugin -i`

**The plugin will automatically fownload the firmware of the printer connected via USB.**

```
------------------------
| DOWNLOADING FIRMWARE |
------------------------

Downloading firmware to device hp:/usb/HP_LaserJet_1020?serial=JL59GCF...
Firmware download successful.
```

#### Setup printer

Next, configure your printer using `hp-setup`. Use interactive mode `-i` instead of graphical UI, if not using a display.

`$ sudo hp-setup -i`

Follow the setup process for the printer connected via **USB**. Make sure that the printer is connected to Raspberry Pi:

```
--------------------------------
| SELECT CONNECTION (I/O) TYPE |
--------------------------------

  Num       Connection  Description
            Type
  --------  ----------  ----------------------------------------------------------
  0*        usb         Universal Serial Bus (USB)
  1         net         Network/Ethernet/Wireless (direct connection or JetDirect)
  
Enter number 0...1 for connection type (q=quit, enter=usb*) ? 0

Using connection type: usb

Setting up device: hp:/usb/HP_LaserJet_1020?serial=JL59GCF
```

For more information about the functions of `hp-setup`, here is a list of options:

```
Usage: hp-setup [MODE] [OPTIONS]

[MODE]
  Run in graphical UI mode: -u or --gui (Default)
  Run in interactive mode:  -i or --interactive

[OPTIONS]
  Automatic mode:	                              -a or --auto (-i mode only)
  To specify the port on a multi-port JetDirect:  --port=<port> (Valid values are 1*, 2, and 3. *default)
  No testpage in automatic mode:                  -x (-i mode only)
  To specify a CUPS printer queue name:           -p<printer> or --printer=<printer> (-i mode only)
  To specify a CUPS fax queue name:               -f<fax> or --fax=<fax> (-i mode only)
  Type of queue(s) to install:                    -t<typelist> or --type=<typelist>. <typelist>: print*, fax* (*default) (-i mode only)
  To specify the device URI to install:           -d<device> or --device=<device> (--qt4 mode only)
  Remove printers or faxes instead of setting-up: -r or --rm or --remove (-u only)
  Set the language:                               -q <lang> or --lang=<lang>. Use -q? or --lang=? to see a list of available language codes.
  Set the logging level:                          -l<level> or --logging=<level>, where <level>: none, info*, error, warn, debug (*default)
  Run in debug mode:                              -g (same as option: -ldebug)
  Help information:                               -h or --help
```

As an example, for removing a printer configured with `hp-setup`, use the following:

`sudo hp-setup -i -r`

It will automatically remove the existing printer, or you can choose a printer to remove from the list:

```
----------------------------
| REMOVING PRINT/FAX QUEUE |
----------------------------

------------------
| SELECT PRINTER |
------------------

  Num       CUPS Printer
  --------  ----------------------------
  0         HP_LaserJet_1020
  1         HP_LaserJet_1020_raspberrypi
---
```

#### Print a document

To print a document with the newly printer configured, use the `hp-print` command:

`sudo hp-print --printer="HP_LaserJet_1020" -u [FILE]`

For more information about the functions of `hp-print`, here is a list of options:

```
Usage: hp-print [DEVICE_URI|PRINTER_NAME] [MODE] [OPTIONS] [FILES]

[PRINTER|DEVICE-URI]
  To specify a device-URI  :  -d<device-uri> or --device=<device-uri>
  To specify a CUPS printer:  -p<printer> or --printer=<printer>

[MODE]
  Run in graphical UI mode:  -u or --gui (Default)

[OPTIONS]
  Use Qt5:                   --qt5 (Default)
  Set the logging level:     -l<level> or --logging=<level>
                             <level>: none, info*, error, warn, debug (*default)
  Run in debug mode:         -g (same as option: -ldebug)
  This help information:     -h or --help
```

#### Check for errors

In case of errors, or if the printer is not correctly configured, run the following commands to check for permissions and missing/optional dependencies:

```
sudo hp-check
sudo hp-doctor
```

#### Uninstall hplip

To remove hplip completely use the following commands:

```
sudo apt remove hplip
sudo apt purge hplip
```

#### Useful commands

The following commands shows if the printer is connected:

`lsusb`