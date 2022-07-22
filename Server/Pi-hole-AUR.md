# Pi-hole AUR

https://pi-hole.net/  
https://aur.archlinux.org/packages/pi-hole-server  
  
*Pi-hole is not officially supported on Arch Linux but it is still available through the AUR.*  
*If you are running Arch (as I do on my raspberry) and still want an officially supported Pi-hole installation, you should install Pi-hole in a docker container (https://github.com/pi-hole/docker-pi-hole).*   
*I did a procedure for that as well : https://github.com/Antiz96/Linux-Configuration/blob/main/Server/Pi-hole.md* 

## Open the port for Pihole and its component on the firwall

*I do not open the DHCPv6 port as I don't use ipv6.*  
Refer to this link for the full list of port you may need to open and how to open them depending on your firewall : https://docs.pi-hole.net/main/prerequisites/

```
sudo firewall-cmd --permanent --add-service=http --add-service=dns --add-service=dhcp #Opening port for web interface (80), DNS (50) and DHCP (67)
sudo firewall-cmd --permanent --new-zone=ftl #Creating a new zone dedicated to the FTL port (which has to be open only on the localhost interface)
sudo firewall-cmd --permanent --zone=ftl --add-interface=lo #Add the localhost interface to the new FTL zone
sudo firewall-cmd --permanent --zone=ftl --add-port=4711/tcp #Opening the FTL port on the dedicated zone with the localhost interface
sudo firewall-cmd --reload #Reload to apply changes
```

## Install and configure Pihole on Arch

I basically followed the Arch Wiki : https://wiki.archlinux.org/title/Pi-hole

### Install the AUR Package and enable the service

```
yay -S pi-hole-server
sudo systemctl status pihole-FTL #If it's in "Failed" state, you might need to reboot
```

### Install php-sqlite and uncomment needed php extension

```
sudo pacman -S php-sqlite 
sudo vi /etc/php/php.ini
```

> [...]  
> extension=pdo_sqlite  
> [...]  
> extension=sockets  
> [...]  
> extension=sqlite3  
> [...]

### Install lighttpd (front-end web server)

```
sudo pacman -S lighttpd php-cgi
sudo cp /usr/share/pihole/configs/lighttpd.example.conf /etc/lighttpd/lighttpd.conf
sudo systemctl enable --now lighttpd
```

### Add the pi-hole specific line in the hosts file

```
sudo vi /etc/hosts
```

> [...]  
> "ip.address.of.pihole"   pi.hole "hostname"

### Set up the password for the admin panel

```
pihole -a -p
```

## Edit config file for the PHP8 compatibility of the Web Interface

https://wiki.archlinux.org/title/Pi-hole#...but_I_need_to_stick_with_PHP_8_for_my_system

```
sudo vim /srv/http/pihole/admin/scripts/pi-hole/php/savesettings.php
```

**Before :**  
> [...]  
> foreach(["v4_1", "v4_2", *"v6_1", "v6_2"*] as $type)  
> [...]  
  
**After :**
> [...]  
> foreach(["v4_1", "v4_2"] as $type)  
> [...]  

## Enable DHCP service

I personally use my pi-hole as my DHCP in addition of being my DNS server.  
At that point, I enable the DHCP service through the pi-hole's web interface and disable the DHCP service of my router.

## Change the DNS of my server from my router IP to its own IP (So he is its own DNS)

https://nanxiao.me/en/configure-static-ip-address-on-arch-linux/

```
nmcli con show
sudo nmcli con modify 03994945-5119-3b3c-acbc-b599437851e8 ipv4.dns 192.168.1.1
reboot
```

## Tips and tricks

### Configure postfix to use gmail as a relay 

I use postfix to send email containing the result of tasks I automatize through various scripts (more information about those scripts in the next paragraph).  
  
https://www.howtoforge.com/tutorial/configure-postfix-to-use-gmail-as-a-mail-relay/  

```
sudo vi /etc/postfix/sasl_passwd
```

> [smtp.gmail.com]:587    "username"@gmail.com:"password"

```
sudo chmod 400 /etc/postfix/sasl_passwd
sudo vi /etc/postfix/main.cf
```

> [...]  
> #Personal configuration (for Pihole notification)  
> relayhost = [smtp.gmail.com]:587  
> smtp_use_tls = yes  
> smtp_sasl_auth_enable = yes  
> smtp_sasl_security_options =  
> smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd  
> smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt  

```
sudo postmap /etc/postfix/sasl_passwd
sudo systemctl restart postfix
```

Enable **Less Secure App** on your gmail account (postfix is categorized as so).

### Deploy scripts and crontab to automate some tasks for the "pihole" user

#### Automatic whitelist update script

https://github.com/anudeepND/whitelist

```
cd /home/pihole
sudo git clone https://github.com/anudeepND/whitelist.git
sudo vim /home/pihole/pihole_whitelist_update.sh
```

> #!/bin/bash  
>  
> python3 /home/pihole/whitelist/scripts/whitelist.py && echo -e "Subject:Pihole's whitelist updated\n\nHello,\n\nThe Pihole's whitelist has been succesfully updated." | /usr/sbin/sendmail yourmailexample@mail.com, yourmailexample2@mail.com || echo -e "Subject:Error during Pihole's whitelist update\n\nHello,\n\nThere was an error during the Pihole's whitelist update." | /usr/sbin/sendmail yourmailexample@mail.com, yourmailexample2@mail.com

#### Automatic blacklist update script

```
sudo vim /home/pihole/pihole_blacklist_update.sh
```

> #!/bin/bash  
>    
> pihole -g && echo -e "Subject:Pihole's blacklist updated\n\nHello,\n\nPihole's blacklist has been succesfully updated." | /usr/sbin/sendmail yourmailexample@mail.com, yourmailexample2@mail.com || echo -e "Subject:Error during Pihole's blacklist update\n\nHello,\n\nThere was an error during Pihole's blacklist update." | /usr/sbin/sendmail yourmailexample@mail.com, yourmailexample2@mail.com

#### Crontab for automatic executions of the scripts

```
sudo crontab -u pihole -e
```

> ##Pihole Crontab##  
>  
> #Updating Blacklist  
> 0 3 * * 0 sudo /home/pihole/pihole_blacklist_update.sh  
>  
> #Updating Whitelist  
> 0 4 * * 0 sudo /home/pihole/pihole_whitelist_update.sh

#### Giving secure permissions to all the scripts

```
sudo chown -R root:pihole /home/pihole
sudo chmod 750 /home/pihole/pihole_*.sh
sudo chmod 750 /home/pihole/whitelist/scripts/*.py
sudo chmod 750 /home/pihole/whitelist/scripts/*.sh
```

#### Add sudo permissions to execute the scripts to the "pihole" user

```
sudo vim /etc/sudoers.d/pihole_scripts
```

> pihole ALL=(ALL) NOPASSWD: /home/pihole/pihole_blacklist_update.sh, /home/pihole/pihole_whitelist_update.sh

#### Disable the abality to log in to the pihole user (for security reasons)

```
sudo vim /etc/passwd
```

> [...]  
> pihole:x:972:972:pihole daemon:/home/pihole:**/usr/bin/nologin**

### Create a symlink of the logs files in /var/log 

I personally prefer having all logs centralisez in /var/log.  

```
cd /var/log/
sudo ln -s /run/log/pihole pihole
sudo ln -s /run/log/pihole-ftl pihole-ftl
```

### Bind the Pihole-FTL DNS service to the actual Pihole IP address (instead of 0.0.0.0) 

https://discourse.pi-hole.net/t/make-pihole-ftl-bind-only-on-certain-ips-v4-0/11883/5  
https://discourse.pi-hole.net/t/solve-dns-resolution-in-other-containers-when-using-docker-pihole/31413  
https://wiki.archlinux.org/title/Talk:Pi-hole#Bind_the_Pihole-FTL_DNS_service_to_the_actual_IP_address_of_the_Pi-hole_%28instead_of_0.0.0.0%29_to_prevent_DNS_resolution_issues_for_other_virtual_hosts  
  
By default, the DNS service (pihole-FTL) will be bind to the 0.0.0.0 IP address (you can see this with "netstat -lntp | grep 53")  
This will prevent any other virtual hosts onto the same machine hosting your pihole instance to get DNS resolution (such as docker containers).  
    
In order to solve this, you need to uncomment the "bind-interfaces" line in the /etc/dnsmasq.conf file.  
This will tell the DNS service (pihole-FTL) to bind itself to each interface explicitely (and thus to the IP address of your pihole, and not "0.0.0.0").  

```
sudo vim /etc/dnsmasq.conf
```

> [...]  
> bind-interfaces  
> [...]  
  
Then, you need to restart the pihole-FTL service to apply changes :  

```
sudo systemctl restart pihole-FTL
```

**It is worth mentioning that, since I uncommented the line "bind-interfaces" in /etc/dnsmasq.conf, the pihole-FTL service often fails to start at boot/reboot saying that it couldn't bind the requested IP address.**  
I'm guessing the pihole-FTL service tries to start before the network service comes completely up, so it cannot bind the IP address as it is not available already.  
In order to solve that, I added the below line to the /usr/lib/systemd/system/pihole-FTL.service file, which tells the pihole-FTL service to wait 2 seconds before starting (in order to let the time to the network service to fully come up) :  

```
sudo vim /usr/lib/systemd/system/pihole-FTL.service
```

> [...]  
> ExecStartPre=/bin/sleep 2  
> [...]
  
**Be aware that the original service file will be restored each updates, so you'll need to redo the above step each time pi-hole gets an update.**

### Automatically check for system update(s)

*This has nothing to do with pi-hole itself but I do use the following script to get notified by email for any available updates on my Arch server. This is also a way to see if the pi-hole packages need to be updated, so I know that I'll need to redo the above step (adding a 2 seconds wait before the pihole-FTL service start).*

```
sudo pacman -S pacman-contrib
sudo vim ~/check_update.sh
```

> #!/bin/bash  
>   
>   
> PACKAGES=$(/usr/bin/checkupdates | awk '{print $1}' && /usr/bin/yay -Qua | awk '{print $1}')  
>   
> if [ -n "$PACKAGES" ]; then  
> > echo -e "Subject:Server's package list available for update\n\nHello,\n\nThe following packages can be updated on the server :\n$PACKAGES" | /usr/sbin/sendmail yourmail@example.com, yourmail2@example.com  
>  
> else
> > echo -e "Subject:No packages to update on Server\n\nHello,\n\nThere is no packages to update on Server.\nThe server is up to date" | /usr/sbin/sendmail yourmail@example.com, yourmail2@example.com  
>  
> fi 
  
```
chmod +x check_update.sh
contrab -e
```
  
> #Check update  
> 0 12 * * 0 /home/rcandau/check_update.sh  
