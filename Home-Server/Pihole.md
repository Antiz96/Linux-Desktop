# Pihole

https://pi-hole.net/  
  
This server is a VM running on my Proxmox instance that has been cloned from my Arch-Linux Server Template.  
  
In that sense, the base installation and configuration of the VM is not covered here (see the link above).

## Install Docker on my Arch Server (if not done already)

https://github.com/Antiz96/Linux-Configuration/blob/main/Rasp-Server/Docker.md

## Installing Pi-hole on Docker

https://github.com/pi-hole/docker-pi-hole 

### Create the Pi-hole base directory

```
sudo mkdir /opt/pihole
```

### Launch the container

The 67 port, the `--cap-add=NET_ADMIN` and the `--net=host` arguments are only needed if you are using Pi-hole as your DHCP server.  
ServerIP should be replaced with your external ip.  

```
sudo docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 80:80 \
    -p 67:67 \
    --cap-add=NET_ADMIN \
    --net=host
    -e TZ="Europe/Paris" \
    -v "/opt/pihole/etc-pihole:/etc/pihole" \
    -v "/opt/pihole/etc-dnsmasq.d:/etc/dnsmasq.d" \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    --hostname pi.hole \
    -e VIRTUAL_HOST="pi.hole" \
    -e PROXY_LOCATION="pi.hole" \
    -e ServerIP="192.168.1.1" \
    pihole/pihole:latest
```

### Set a password for the web interface

A random password is automatically generated the first time you run the pihole container.  
You can retrieve it like so : `sudo docker logs pihole | grep random`  
  
To set up your own password :  
  
```
sudo docker exec -it pihole pihole -a -p
```

## Access and configuration

You can access the pihole web interface here :
`http://HOSTNAME/admin/"`

## Update/Upgrade and reinstall procedure

Since we use Docker, the update and upgrade procedure is actually the same as it does not rely directly on our server.

### Pull the docker image

*(... to check if there's available updates)*

```
sudo docker pull pihole/pihole:latest
```

### Apply the update

```
sudo docker stop pihole
sudo docker rm pihole
sudo docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 80:80 \
    -p 67:67 \
    --cap-add=NET_ADMIN \
    --net=host
    -e TZ="Europe/Paris" \
    -v "/opt/pihole/etc-pihole:/etc/pihole" \
    -v "/opt/pihole/etc-dnsmasq.d:/etc/dnsmasq.d" \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    --hostname pi.hole \
    -e VIRTUAL_HOST="pi.hole" \
    -e PROXY_LOCATION="pi.hole" \
    -e ServerIP="192.168.1.1" \
    pihole/pihole:latest
```

### After an update

After an update, you can clean old dangling docker images (to regain spaces and clean up your local stored Docker images) :

```
sudo docker image prune
```

Alternatively, you can clean all unused Docker component (stopped containers, network not use by any containers, dangling images and build cache) :
**If you choose to do that, make sure all your containers are running ! Otherwise, they will be deleted**

```
sudo docker system prune
```
