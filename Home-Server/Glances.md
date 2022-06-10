# Glances

https://nicolargo.github.io/glances/

## Install Docker on my Debian Server (if not done already)

https://github.com/Antiz96/Linux-Configuration/blob/main/Home-Server/Docker.md

## Installing Glances on Docker

https://github.com/nicolargo/glances#docker-the-fun-way

### Pull and run the container

```
sudo docker pull nicolargo/glances:latest-full 
sudo docker run -d --restart="always" -p 61208-61209:61208-61209 -e GLANCES_OPT="-w" -v /var/run/docker.sock:/var/run/docker.sock:ro --pid host --name glances nicolargo/glances:latest-full
```

### Set a username and password for the web interface (optionnal but recommended)

```
sudo mkdir /opt/glances
sudo docker exec -it glances bash
glances -s --username --password
```

> Define the Glances server username: your_username #Replace **your_username** by the username you want to use  
> Define the Glances server password (your_username username):  
> Password (confirm):  
> Do you want to save the password? [Yes/No]: **Yes**  
> Glances XML-RPC server is running on 0.0.0.0:61209  
> Announce the Glances server on the LAN (using 172.17.0.5 IP address)  
  
Then press "ctrl+\" to interupt the proccess and `exit` the container.    
Finally, copy the password file locally and re-run the container mapping it (replace **your_username** by the username you've set earlier).    

```
sudo docker cp glances:/root/.config/glances/your_username.pwd /opt/glances/your_username.pwd
sudo docker stop glances
sudo docker rm glances
sudo docker run -d --restart="always" -p 61208-61209:61208-61209 -e GLANCES_OPT="-w -u your_username --password" -v /opt/glances/your_username.pwd:/root/.config/glances/your_username.pwd -v /var/run/docker.sock:/var/run/docker.sock:ro --pid host --name glances nicolargo/glances:latest-full
```

### Access

You can now access it on this URL (admin:admin) :  
`http://[HOSTNAME]:61208/`

## Update/Upgrade and reinstall procedure

Since we use Docker, the update and upgrade procedure is actually the same as it does not rely directly on our server.  

### Pull the docker image 

*(... to check if there's available updates)*  

```
sudo docker pull nicolargo/glances:latest-full
```

### Apply the update

```
sudo docker stop glances
sudo docker rm glances
sudo docker run -d --restart="always" -p 61208-61209:61208-61209 -e GLANCES_OPT="-w" -v /var/run/docker.sock:/var/run/docker.sock:ro --pid host --name glances nicolargo/glances:latest-full
```

Or, if you set a username and password (Replace **your_username** by the username you've set earlier) :

```
sudo docker run -d --restart="always" -p 61208-61209:61208-61209 -e GLANCES_OPT="-w -u your_username --password" -v /opt/glances/your_username.pwd:/root/.config/glances/your_username.pwd -v /var/run/docker.sock:/var/run/docker.sock:ro --pid host --name glances nicolargo/glances:latest-full
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