# Dashy

https://github.com/lissy93/dashy

## Install docker on my Server (if not done already)

https://github.com/Antiz96/Linux-Configuration/blob/main/Server/Docker.md

## Create a dedicated dashy directory

```
sudo mkdir /opt/dashy
```

## Download my dashy config file 

(Remember to fill in the "username" and "password" fields for the monitoring sections)

```
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Server/Dashy-conf.yml -o /opt/dashy/conf.yml
```

## Pull and run the container 

```
sudo docker run -d -p 8080:80 -v /opt/dashy/conf.yml:/app/public/conf.yml --name dashy --restart=unless-stopped lissy93/dashy:latest
```

## Update procedure

```
sudo docker pull lissy93/dashy:latest
sudo docker stop dashy
sudo docker rm dashy
sudo docker run -d -p 8080:80 -v /opt/dashy/conf.yml:/app/public/conf.yml --name dashy --restart=unless-stopped lissy93/dashy:latest
```

# After an update

After an update, you can clean old dangling docker images (to regain spaces and clean up your local stored Docker images) :  

```
sudo docker image prune
```

Alternatively, you can clean all unused Docker component (stopped containers, network not use by any containers, dangling images and build cache) :  
**If you choose to do that, make sure all your containers are running ! Otherwise, they will be deleted.**  

```
sudo docker system prune
```

## Tips and tricks

### Re-read configuration file

If you modified your configuration file or if dashy did not load it correctly for some reason, you can make dashy re-read it without having to restart the container  

```
sudo docker exec -it dashy yarn build
```
