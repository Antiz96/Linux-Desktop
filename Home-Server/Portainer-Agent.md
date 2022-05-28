# Portainer

https://www.portainer.io/

## Install Docker on my Debian Server (if not done already)

https://github.com/Antiz96/Linux-Configuration/blob/main/Home-Server/Docker.md

## Installing Portainer agent on Docker

https://docs.portainer.io/v/ce-2.11/start/install/agent/docker/linux

### Pull and run the container

```
sudo docker run -d -p 9001:9001 --name portainer-agent --hostname portainer-agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent:latest
```

### Add the agent to the Portainer Server

Add the following URL to the environment tab in your portainer server's web interface (you don't have to specify the "https://")  
`[HOSTNAME]:9001`

## Update/Upgrade procedure

```
sudo docker pull portainer/agent:latest
sudo docker stop portainer-agent
sudo docker rm portainer-agent
sudo docker run -d -p 9001:9001 --name portainer-agent --hostname portainer-agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent:latest
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
