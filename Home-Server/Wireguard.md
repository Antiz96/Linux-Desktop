# Wireguard

https://www.wireguard.com/

## Create a dynamic DNS domain with a dynamic DNS provider

There's plenty of them that are free, such as NO IP, DtDNS, ChangeIP, Free DNS, DuckDNS, DyNS, etc...  
If you already have your own DNS, you can use it as well.  

## Configure your DynDNS domain

...either on your router (recommended) or directly on the machine that will host the Wireguard server (if your routeur cannot handle DynDNS).

### On your router

If your router has a DynDNS service, you should use it instead of configuring it directly on the server that will host the Wireguard service.  
Indeed, although the selection of services may be limited, it will be easier to set up, will require little to no maintenance, and will have no downtime (if the router is down you will not have Internet anyway).  
To configure the DynDNS in your router, just go to the "DynDNS" service via the administration panel and enter the information according to the domain you've just created (Service, account, Domain, etc...).

### Directly on the server (if your router cannot handle DynDNS)

If your router cannot handle DynDNS, you'll have to configure it directly on the server that will host the wireguard service using "ddclient".  
More on that here :
https://www.youtube.com/watch?v=rtUl7BfCNMY (from 10m47)
https://wiki.archlinux.org/title/Dynamic_DNS

## Enable port forwarding on your router for the wireguard port (in order to access your vpn from internet)

Go to your router administration panel and add a new rule in the port forwarding service (NAT/PAT).  
Give the rule a name, select the UDP protocol, select "51820" as external and internal port and select the server that will host the Wireguard service as the destination device.  
You can also filter the external source IP but, unless you want your VPN to only be accessible from a specific network/location, it is not recommended (as you're IP will differ depending on where you are).  
  
The rule should look like this :  
`Protocol : UDP | Source IP : * | Source Port : 51820 | Destination IP : "IP of your wireguard server" | Destination Port : 51820`

## Installing Wireguard on Docker

https://hub.docker.com/r/linuxserver/wireguard

### Install docker on my server (if not done already)

https://github.com/Antiz96/Linux-Configuration/blob/main/Server/Docker.md

### Create a local folder to store the clients configuration and make data persistent for update/upgrade

```
sudo mkdir /opt/wireguard
```

### Run the container

To run it, modify the parameters of the following command according to your needs/environment :  

```
sudo docker run -d \
  --name=wireguard \ #Name of your wireguard container.
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \ #Your timezone.
  -e SERVERURL=wireguard.domain.com \ #The DynDNS domain you've created earlier.
  -e SERVERPORT=51820 \ #The port on which the Wiregaurd server will listen to (make sure it matches the port forwarding rule you've created earlier), 51820 by default.
  -e PEERS=1 \ #The number of client configuration you want to generate. It can either be a number or a list of strings separated by comma (if you want to name them).
  -e PEERDNS=auto \ #The IP address of the DNS you want your client to use while connected to the VPN, auto option by default.
  -e INTERNAL_SUBNET=10.10.10.0 \ #The IP subnet to use for the VPN tunnel.
  -e ALLOWEDIPS=0.0.0.0/0 \ #The IP subnet you want to allow to connect to your VPN (0.0.0.0/0 = "Allow all" which is recommended, unless you want your VPN to only be accessible from a specific network/location).
  -p 51820:51820/udp \ #Expose the port of the container to the host port (make sure it fits the SERVERPORT variable and the port forwarding rule you've set on your router).
  -v /path/to/appdata/config:/config \ #Mapping the local directory you've created earlier to the /config directory on the container.
  -v /lib/modules:/lib/modules \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --restart unless-stopped \ #Always restart the container unless you stopped it manually
  linuxserver/wireguard
```

This is my personal docker run command for wireguard (I masked the SERVERURL for obvious privacy and security reasons) :  

```
sudo docker run -d \
  --name=wireguard \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e TZ=Europe/Paris \
  -e SERVERURL=XXXX \
  -e SERVERPORT=51820 \
  -e PEERS=ArchLinux,ArchLaptop,RPhone \
  -e PEERDNS=192.168.1.1 \
  -e INTERNAL_SUBNET=10.10.10.0 \
  -e ALLOWEDIPS=0.0.0.0/0 \
  -p 51820:51820/udp \
  -v /opt/wireguard:/config \
  -v /lib/modules:/lib/modules \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --restart unless-stopped \
  linuxserver/wireguard
```

## Connect your clients to the VPN

You can retrieve the configuration files for the client you've created with the docker run command in the directory you mapped (/opt/wireguard in my case).  
They are available in two formats : Text file or PNG file (QR Code - Those are also chown in the docker log output of the container).  
Copy the configuration files to their associated clients. 

### Phone

Install the Wireguard application. Check the following link to see how to install it, depending on your OS :  
https://www.wireguard.com/install/  
  
Launch the application and either scan the QR Code with it or import the configuration file in order to connect to the VPN.  

### PC

Install the wireguard client. Check the following link to see how to install it, depending on your OS :  
https://www.wireguard.com/install/  
  
On Arch :  

```
sudo pacman -S wireguard-tools #Install the Wireguard package
sudo wg-quick up /path/to/the/file.conf #Connect the VPN
sudo wg-quick down /path/to/the/file.conf #Disconnect the VPN
```

If you have an error saying "/usr/bin/wg-quick: line XX: resolvconf: command not found", you may need to install the `openresolv` package as well.  

```
sudo pacman -S openresolv
```

## Update/Upgrade procedure

```
sudo docker pull linuxserver/wireguard
sudo docker stop wireguard
sudo docker rm wireguard
sudo docker run -d \
  --name=wireguard \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e TZ=Europe/Paris \
  -e SERVERURL=XXXX \
  -e SERVERPORT=51820 \
  -e PEERS=ArchLinux,ArchLaptop,RPhone \
  -e PEERDNS=192.168.1.1 \
  -e INTERNAL_SUBNET=10.10.10.0 \
  -e ALLOWEDIPS=0.0.0.0/0 \
  -p 51820:51820/udp \
  -v /opt/wireguard:/config \
  -v /lib/modules:/lib/modules \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --restart unless-stopped \
  linuxserver/wireguard
```
  
### After any update
After an update, you can clean old dangling docker images (to regain spaces and clean up your local stored Docker images) :  

```
sudo docker image prune
```

Alternatively, you can clean all unused Docker component (stopped containers, network not use by any containers, dangling images and build cache) :  
**If you choose to do that, make sure all your containers are running ! Otherwise, they will be deleted.**  

```
sudo docker system prune
```
