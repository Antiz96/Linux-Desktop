# Keepalived

https://github.com/acassen/keepalived

https://www.redhat.com/sysadmin/keepalived-basics
https://tobru.ch/keepalived-check-and-notify-scripts/
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/load_balancer_administration/s1-lvs-connect-vsa
I use Keepalived to manage a VIP (Virtual IP Address) between both of my servers for the NGINX service.
I configured it to check for the NGINX service state and to use a Master/Backup model for the VIP, with the master being my home-server (but I'll show how you to configure as a active/passive model).


## Installation

**Home-Server :**    

```
sudo apt install keepalived
```

**Rasp-Server :**

```
sudo pacman -S keepalived
```

## Open the necessary ports on the firewall

```
sudo firewall-cmd --add-rich-rule='rule protocol value="vrrp" accept' --permanent
sudo firewall-cmd --reload
```

## Configuration

### Create a directory to store the check and the notify script on both of my servers 

*(respectively aimed to trigger the changing state and the changing state action(s))*

```sudo mkdir /opt/keepalived/
sudo vim /opt/keepalived/keepalived_check.sh
```

> #!/bin/bash  
>    
> MASTER=$(ip a | grep -w "192.168.1.20")  
>    
> if [ -n "$MASTER" ]; then  
> > pidof nginx || exit 1  
> else  
> > nginx -t 2>&1 | grep -w "syntax is ok" || exit 1  
> 
> fi
  
```
sudo vim /opt/keepalived/keepalived_notify.sh
```

> #!/bin/bash  
>    
> TYPE=$1  
> NAME=$2  
> STATE=$3  
>  
> case $STATE in  
> > "MASTER")  
> > > systemctl start nginx  
> > > exit 0  
> > ;;  
> > "BACKUP")  
> > > systemctl stop nginx  
> > > exit 0  
> > ;;  
> > "FAULT")  
> > > systemctl stop nginx  
> > > exit 0  
> > ;;  
> > \*)  
> > > echo "Unknown state $STATE for VRRP $TYPE $NAME"  
> > > exit 1  
> > ;;
> esac

```
sudo chmod 774 /opt/keepalived/*.sh
```

### Create the configuration file on both of my servers

**Home-Server (The Master node) :**

```
sudo vim /etc/keepalived/keepalived.conf
```

> global_defs {  
> > enable_script_security  
> > script_user root  
> }
>  
> vrrp_script check_script {  
> > script "/opt/keepalived/keepalived_check.sh"  
> > interval 2 #Check every 2 seconds  
> > fall 2 #Require 2 consecutive failures to enter FAULT state  
> > rise 2 #Require 2 consecutive successes to exit FAULT state  
> > #timeout 1 #Wait 1 second before assuming a failure  
> > #weight 10 #Reduce priority by 10 on complete fall  
> }  
>  
> vrrp_instance VIP_Nginx {  
> > state MASTER  
> > interface vmbr0  
> > virtual_router_id 1  
> > priority 150  
> > advert_int 1  
> > authentication {  
> > > auth_type PASS  
> > > auth_pass 1234  
> > }  
> >   
> > virtual_ipaddress {  
> > > 192.168.1.20/24  
> > }  
> > notify "/opt/keepalived/keepalived_notify.sh"  
> > track_script {  
> > > check_script  
> > }  
> }  
  
**Rasp-Server (The Backup node) :**  

```
sudo vim /etc/keepalived/keepalived.conf
```

> global_defs {  
> > enable_script_security  
> > script_user root  
> }
>  
> vrrp_script check_script {  
> > script "/opt/keepalived/keepalived_check.sh"  
> > interval 2 #Check every 2 seconds  
> > fall 2 #Require 2 consecutive failures to enter FAULT state  
> > rise 2 #Require 2 consecutive successes to exit FAULT state  
> > #timeout 1 #Wait 1 second before assuming a failure  
> > #weight 10 #Reduce priority by 10 on complete fall  
> }  
>  
> vrrp_instance VIP_Nginx {  
> > state BACKUP  
> > interface wlan0  
> > virtual_router_id 1  
> > priority 100  
> > advert_int 1  
> > authentication {  
> > > auth_type PASS  
> > > auth_pass 1234  
> > }  
> >   
> > virtual_ipaddress {  
> > > 192.168.1.20/24  
> > }  
> > notify "/opt/keepalived/keepalived_notify.sh"  
> > track_script {  
> > > check_script  
> > }  
> } 

## Start/Enable the keepalived service

```
sudo systemctl enable --now keepalived
```

##  Active/Passive mode

If you want to use an Active/Passive mode rather then a Master/Backup mode, modify state as "BACKUP" and add the "nopreempt" option for **both** nodes in the config file, like so :  

**Home-Server (The First node) :**

```
sudo vim /etc/keepalived/keepalived.conf
```

> global_defs {  
> > enable_script_security  
> > script_user root  
> }
>  
> vrrp_script check_script {  
> > script "/opt/keepalived/keepalived_check.sh"  
> > interval 2 #Check every 2 seconds  
> > fall 2 #Require 2 consecutive failures to enter FAULT state  
> > rise 2 #Require 2 consecutive successes to exit FAULT state  
> > #timeout 1 #Wait 1 second before assuming a failure  
> > #weight 10 #Reduce priority by 10 on complete fall  
> }  
>  
> vrrp_instance VIP_Nginx {  
> > state BACKUP  
> > interface vmbr0  
> > virtual_router_id 1  
> > priority 150 
> > nopreempt 
> > advert_int 1  
> > authentication {  
> > > auth_type PASS  
> > > auth_pass 1234  
> > }  
> >   
> > virtual_ipaddress {  
> > > 192.168.1.20/24  
> > }  
> > notify "/opt/keepalived/keepalived_notify.sh"  
> > track_script {  
> > > check_script  
> > }  
> }  
  
**Rasp-Server (The second node) :**  

```
sudo vim /etc/keepalived/keepalived.conf
```

> global_defs {  
> > enable_script_security  
> > script_user root  
> }
>  
> vrrp_script check_script {  
> > script "/opt/keepalived/keepalived_check.sh"  
> > interval 2 #Check every 2 seconds  
> > fall 2 #Require 2 consecutive failures to enter FAULT state  
> > rise 2 #Require 2 consecutive successes to exit FAULT state  
> > #timeout 1 #Wait 1 second before assuming a failure  
> > #weight 10 #Reduce priority by 10 on complete fall  
> }  
>  
> vrrp_instance VIP_Nginx {  
> > state BACKUP  
> > interface wlan0  
> > virtual_router_id 1  
> > priority 100 
> > nopreemt 
> > advert_int 1  
> > authentication {  
> > > auth_type PASS  
> > > auth_pass 1234  
> > }  
> >   
> > virtual_ipaddress {  
> > > 192.168.1.20/24  
> > }  
> > notify "/opt/keepalived/keepalived_notify.sh"  
> > track_script {  
> > > check_script  
> > }  
> } 
