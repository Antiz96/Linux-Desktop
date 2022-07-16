# Proxmox

https://www.proxmox.com

## Pre-Installation

### Open the port used by Proxmox (and its component) on the firewall

I only open the port for proxmox service's that I use.  
For a full list of port use by the different proxmox services, refer to this link : https://pve.proxmox.com/wiki/Firewall  

```
sudo firewall-cmd --zone=public --add-port=8006/tcp --permanent #Web Interface port
sudo firewall-cmd --zone=public --add-port=3128/tcp --permanent #Spice proxy port
sudo firewall-cmd --reload
```

### Create the Proxmox main directory and the Proxmox data directory

*(...to store the VMs, backups, etc...)*

```
sudo mkdir /storage/Proxmox
sudo mkdir /data/Proxmox
```

## Installation 

### Install Proxmox on Debian

**Official Guide :**  
https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_11_Bullseye  
  
If you're facing a dependency problem during this installation (**dpkg deb error subprocess paste was killed by signal broken pipe**), then :  

```
sudo dpkg -P qemu-system-data && sudo apt install -f
```

*User Management Part : Create regular user in Datacenter --> Permissions --> User (PVE Realm) and then, add PVEAdmin role in the main "Permission tab"*   
*Linux Bridge Part : In Proxmox --> System --> Network, edit the actual network card and delete IP/Netmask and Gateway. Once done, create a new "Linux Bridge" card, add the IP/Netmask and Gateway and add the actual network card as the bridge port.*

### Install additionnal useful packages

```
sudo apt install ksmtuned ssh-askpass
```

*ksmtuned --> Allows the use of ballooning (https://pve.proxmox.com/wiki/Dynamic_Memory_Management).*  
*ssh-askpass --> Allows the possibility to use sudo password remotely (That I sometimes use to upload mutiple ISOs at once to the server).*

### Configure ssh-askpass

```
sudo vim /etc/sudo.conf
```

> [...]  
> #Sudo askpass:  
> **Path askpass /usr/bin/ssh-askpass**  
> [...]

## Access

You can now access the Proxmox's web interface on the following URL :  
`https://[HOSTNAME]:8006/`

## Configuration

### Add storages for VMs, Backups and ISO via the Proxmox Web interface

Datacenter --> Storage  
   
ADD - Type : directory | ID : Backup | Directory : /storage/Proxmox/Backup | Content : VZDump Backup File  
ADD - Type : directory | ID : ISO | Directory : /storage/Proxmox/ISO | Content : ISO Image  
ADD - Type : directory | ID : VMs | Directory : /storage/Proxmox/VMs | Content : Disk Image  
ADD - Type : directory | ID : Data | Directory : /data/Proxmox | Content : Disk Image  
EDIT local directory --> uncheck "enabled" checkbox

### Disable the root account on the Web Interface (for security reasons)

Log in to your regular PVEAdmin account  
   
Datacenter --> Permissions --> User  
EDIT root account --> uncheck "enabled" checkbox  
(you can reactivate it the same way if you need it for some reasons)

### Modify proxmox repo from "enterprise" to "no-subscription" 

*(...as I do not use a subscription for my personal needs, I do not have a subscription key. Therefore, I cannot authenticate to the enterprise repo and use it, leading to an error "401 unauthorized" when performing "apt update").*   

```
sudo vim /etc/apt/sources.list.d/pve-enterprise.list
```

> **#** deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise

```
sudo vim /etc/apt/sources.list.d/pve-no-subscription.list
```

> deb http://download.proxmox.com/debian bullseye pve-no-subscription

### Get rid of the "No valid subscription key found" message when loggin in to the web interface

```
sudo cp -p /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js-bck
sudo vim /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
```

--> Change "Ext.Msg.show" to "void"  
> [...]  
> **void**({  
> >  title: gettext('No valid subscription'),  
> > [...]

```
sudo systemctl restart pveproxy
```

## Update/Upgrade procedure

Proxmox and its components are no more than regular packages installed on the Debian server.
So the update/upgrade procedure is basically just update/upgrade your system.

### Update Proxmox

```
sudo apt update && sudo apt full-upgrade
```

### Upgrade Proxmox

Proxmox upgrades usually follow Debian upgrade.  
You have to fully update the system, change Debian and Proxmox repos to the new Debian version (for instance, from "buster" to "bullseye") and perform an update + dist-upgrade.  
Usually, Proxmox write a wiki page/tutorial on how to upgrade from a major release to another, both for Debian and Proxmox at the same time.  
  
For instance, upgrade from "buster" to "bullseye" and from Proxmox v6 to Proxmox v7 :  
https://pve.proxmox.com/wiki/Upgrade_from_6.x_to_7.0  
  
If you prefer, you'll find video tutorial all over youtube :  
https://www.youtube.com/watch?v=NLoY4vuTI6g& (French)  
https://www.youtube.com/watch?v=RCSp6gT7LWs& (English)
