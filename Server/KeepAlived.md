# KeepAlived

https://github.com/acassen/keepalived  
  
https://www.redhat.com/sysadmin/keepalived-basics  
https://tobru.ch/keepalived-check-and-notify-scripts/  
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/load_balancer_administration/s1-lvs-connect-vsa  
I use Keepalived to manage a VIP (Virtual IP Address) between both of my servers for the NGINX service.  
I configured it to check for the NGINX service state and to use a Master/Backup model for the VIP, but I'll show how to configure it as a active/passive model as well.  

## Installation

**Debian :**    

```
sudo apt install keepalived
```

**Arch :**

```
sudo pacman -S keepalived
```

## Open the necessary ports on the firewall

```
sudo firewall-cmd --add-rich-rule='rule protocol value="vrrp" accept' --permanent
sudo firewall-cmd --reload
```

## Configuration

### Configure the hosts file on all cluster nodes

I configure the hosts file of all nodes so they can still "talk" to each user in case there's a DNS issue (it's always DNS).

```
sudo vim /etc/hosts
```
> [...]  
> #Cluster  
> IP_OF_NODE1        Hostname.domain Hostname  
> IP_OF_NODE2        Hostname.domain Hostname  
> IP_OF_NODE3        Hostname.domain Hostname  
> IP_OF_VIP          Hostname.domain Hostname  

### Create a directory to store the check and the notify script on both of my servers 

*(respectively aimed to trigger the changing state and the changing state action(s))*

```
sudo mkdir /opt/keepalived/
sudo vim /opt/keepalived/keepalived_check.sh
```

> #!/bin/bash  
>    
> MASTER=$(ip a | grep -w "192.168.1.20")  
>    
> if [ -n "$MASTER" ]; then  
> > pidof nginx || exit 1  
>
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
> echo "$STATE" > /opt/keepalived/state.txt  
>  
> case $STATE in  
> > "MASTER")  
> > > systemctl start nginx  
> > > exit 0  
> >
> > ;;  
> > "BACKUP")  
> > > systemctl stop nginx  
> > > exit 0  
> >
> > ;;  
> > "FAULT")  
> > > systemctl stop nginx  
> > > exit 0  
> >
> > ;;  
> > \*)  
> > > echo "Unknown state : $STATE" > /opt/keepalived/state.txt  
> > > exit 1  
> >
> > ;;
> 
> esac

```
sudo chmod 774 /opt/keepalived/*.sh
```

### Create the state file

This is a basic txt file I create to collect the current state of my nodes (see the keepalived_notify.sh script above).   
That's really useful to monitor their current state for instance.   

```
sudo touch /opt/keepalived/state.txt && sudo chmod 644 /opt/keepalived/state.txt
```

### Create the configuration file on all of my servers

**Server1 (The Master node) :**

```
sudo vim /etc/keepalived/keepalived.conf
```

> global_defs {  
> > enable_script_security  
> > script_user root  
> 
> }
>  
> vrrp_script check_script {  
> > script "/opt/keepalived/keepalived_check.sh"  
> > interval 2 #Check every 2 seconds  
> > fall 2 #Require 2 consecutive failures to enter FAULT state  
> > rise 2 #Require 2 consecutive successes to exit FAULT state  
> > #timeout 1 #Wait 1 second before assuming a failure  
> > #weight 10 #Reduce priority by 10 on complete fall  
> 
> }  
>  
> vrrp_instance VIP_HOSTNAME {  
> > state MASTER  
> > interface eth0  
> > virtual_router_id 1  
> > priority 150  
> > advert_int 1  
> > authentication {  
> > > auth_type PASS  
> > > auth_pass 1234  
> >
> > }  
> >   
> > virtual_ipaddress {  
> > > 192.168.1.20/24  
> >
> > }  
> > notify "/opt/keepalived/keepalived_notify.sh"  
> > track_script {  
> > > check_script  
> >
> > }  
>
> }  
  
**Server2 (The Backup node) :**  

```
sudo vim /etc/keepalived/keepalived.conf
```

> global_defs {  
> > enable_script_security  
> > script_user root  
> 
> }
>  
> vrrp_script check_script {  
> > script "/opt/keepalived/keepalived_check.sh"  
> > interval 2 #Check every 2 seconds  
> > fall 2 #Require 2 consecutive failures to enter FAULT state  
> > rise 2 #Require 2 consecutive successes to exit FAULT state  
> > #timeout 1 #Wait 1 second before assuming a failure  
> > #weight 10 #Reduce priority by 10 on complete fall  
>
> }  
>  
> vrrp_instance VIP_HOSTNAME {  
> > state BACKUP  
> > interface eth0  
> > virtual_router_id 1  
> > priority 100  
> > advert_int 1  
> > authentication {  
> > > auth_type PASS  
> > > auth_pass 1234  
> >
> > }  
> >   
> > virtual_ipaddress {  
> > > 192.168.1.20/24  
> >
> > }  
> > notify "/opt/keepalived/keepalived_notify.sh"  
> > track_script {  
> > > check_script  
> >
> > }  
>
> } 

## Start/Enable the keepalived service

```
sudo systemctl enable --now keepalived
```

##  Active/Passive mode

If you want to use an Active/Passive mode rather then a Master/Backup mode, modify state as "BACKUP" and add the "nopreempt" option for **both** nodes in the config file, like so :  

**Server1 (The First node) :**

```
sudo vim /etc/keepalived/keepalived.conf
```

> global_defs {  
> > enable_script_security  
> > script_user root  
>
> }
>  
> vrrp_script check_script {  
> > script "/opt/keepalived/keepalived_check.sh"  
> > interval 2 #Check every 2 seconds  
> > fall 2 #Require 2 consecutive failures to enter FAULT state  
> > rise 2 #Require 2 consecutive successes to exit FAULT state  
> > #timeout 1 #Wait 1 second before assuming a failure  
> > #weight 10 #Reduce priority by 10 on complete fall  
>
> }  
>  
> vrrp_instance VIP_HOSTNAME {  
> > state BACKUP  
> > interface eth0  
> > virtual_router_id 1  
> > priority 150  
> > nopreempt   
> > advert_int 1  
> > authentication {  
> > > auth_type PASS  
> > > auth_pass 1234  
> >
> > }  
> >   
> > virtual_ipaddress {  
> > > 192.168.1.20/24  
> >
> > }  
> > notify "/opt/keepalived/keepalived_notify.sh"  
> > track_script {  
> > > check_script  
> >
> > }  
>
> }  
  
**Server2 (The second node) :**  

```
sudo vim /etc/keepalived/keepalived.conf
```

> global_defs {  
> > enable_script_security  
> > script_user root  
>
> }
>  
> vrrp_script check_script {  
> > script "/opt/keepalived/keepalived_check.sh"  
> > interval 2 #Check every 2 seconds  
> > fall 2 #Require 2 consecutive failures to enter FAULT state  
> > rise 2 #Require 2 consecutive successes to exit FAULT state  
> > #timeout 1 #Wait 1 second before assuming a failure  
> > #weight 10 #Reduce priority by 10 on complete fall  
>
> }  
>  
> vrrp_instance VIP_HOSTNAME {  
> > state BACKUP  
> > interface eth0  
> > virtual_router_id 1  
> > priority 100  
> > nopreemt  
> > advert_int 1  
> > authentication {  
> > > auth_type PASS  
> > > auth_pass 1234  
> >
> > }  
> >   
> > virtual_ipaddress {  
> > > 192.168.1.20/24  
> >
> > }  
> > notify "/opt/keepalived/keepalived_notify.sh"  
> > track_script {  
> > > check_script  
> >
> > }  
>
> } 
