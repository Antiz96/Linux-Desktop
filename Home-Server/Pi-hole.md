# Pihole

https://pi-hole.net/  

## Install Docker on my Server (if not done already)

https://github.com/Antiz96/Linux-Configuration/blob/main/Server/Docker.md

## Installing Pi-hole on Docker

https://github.com/pi-hole/docker-pi-hole 

### Create the Pi-hole base directory

```
sudo mkdir /opt/pihole
```

### Launch the container

#### Without DHCP

If you don't plan to use Pi-hole as your DHCP (i.e. you still want to use your router's DHCP), you can run the container normally, exposing ports for DNS and the web interface :  

*"ServerIP" should be replaced with your external IP.* 
  
```
sudo docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 80:80 \
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

#### With DHCP

If you plan to use Pi-hole as your DHCP as well, you'll need to use some tricks.  
There are multiple different ways to run DHCP from within the Docker Pi-hole container.  
All of that is well explained [here](https://docs.pi-hole.net/docker/dhcp/)

I personally use the simple and easy method which consists of running the container with the "host" network mode.  
*Be aware that this will make the container run on your LAN Network (just like a regular pihole) instead of being bridged and isolated from the host like it would normally be*  
  
As the container will run directly on the host's network, we need to manually open the necessary port on the firewall :   
  
```
sudo firewall-cmd --add-port=53/tcp --permanent # Open the DNS port
sudo firewall-cmd --add-port=53/udp --permanent # Open the DNS port udp
sudo firewall-cmd --add-port=80/tcp --permanent # Open the HTTP port for the web interface
sudo firewall-cmd --add-port=67/udp --permanent # Open the DHCP port
sudo firewall-cmd --reload
```

Now we can run the container with the "host" network mode (and also add the `--cap-add=NET_ADMIN` which is necessary to run the DHCP service) :  
*"ServerIP" should be replaced with your external IP.*

```
sudo docker run -d \
    --name pihole \
    --cap-add=NET_ADMIN \
    --net=host \
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

Finally, you'll need to select "Permit all origins" in the "interface settings" in the DNS settings panel via the web interface, in order to get the DHCP to work.

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
    --cap-add=NET_ADMIN \
    --net=host \
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
