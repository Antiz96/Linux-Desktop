# Nextcloud

https://nextcloud.com/

## Install Docker on my Server (if not done already)

https://github.com/Antiz96/Linux-Configuration/blob/main/Server/Docker.md

## Installing Nextcloud on Docker

https://github.com/nextcloud/docker

### Create the Nextcloud directory

Create the directory in which the configuration and the data will be stored :

```  
sudo mkdir /data/Nextcloud
```

### Pull and run the container

This run command contains the mapping to /data/Nextcloud (previously created) to get persistent data for upgrades and backups.  
It also contains the Docker "unless-stopped" restart policy (https://docs.docker.com/config/containers/start-containers-automatically/).  
It will make nextcloud listen to the "8080" port. Make sure you don't have anything already listening to that port.  
*If you do have anything already listening to the 8080, use another one in the below command*

```
sudo docker run --name nextcloud -v /data/Nextcloud:/var/www/html -d --restart unless-stopped -p 8080:80 nextcloud
```

### Access

You can access your nextcloud instance with the following URL :  
`http://[HOSTNAME]:8080/`

### Nextcloud administration guide

https://docs.nextcloud.com/server/23/admin_manual/index.html

## Apps

### Disable the following default apps

Usage survey  
User status  
Weather status

### Enable the following default apps

Auditing/Logging  
External storage support *(only if you plan to use external storage support such a FTP, S3, etc...)*  
Default encryption module *(only if you use remote storage(s). If not, you'd better use full disk encryption instead)*

### Only Office integration

https://nextcloud.com/blog/how-to-install-onlyoffice-in-nextcloud-hub-and-new-integration-feature/  
Install the **Community Document Server** and the **OnlyOffice** app.  

### Disk space monitoring

Install the **Quota warning** app.

### Trello like integration (for enterprise purpose)

Install the **Deck** app.

### 2FA Authentication Support (for enterprise purpose)

Install the **Two-Factor TOTP Provider** app.  
Install the **Two-Factor Admin Support** app.

## Update/Upgrade and reinstall procedure

Since we use Docker, the update and upgrade procedure is actually the same as it does not rely directly on our server.  
Also, if you did a mapping between a volume stored on a local disk (like I did), all you need to do to reinstall your Nextcloud server is to re-download Docker (if you reinstalled your OS completly) and do the following steps.

### Pull the docker image

*(... to check if there's an available update)*

```
sudo docker pull nextcloud
```

### Apply the update

Stop, delete and re-run the container in order to apply the update :

```
sudo docker stop nextcloud
sudo docker rm nextcloud
sudo docker run --name nextcloud -v /data/Nextcloud:/var/www/html -d --restart unless-stopped -p 8080:80 nextcloud
```

### After an update

After an update, you can clean old dangling docker images (to regain spaces and clean up your local stored Docker images) :

```
sudo docker image prune
```
  
Alternatively, you can clean all unused Docker component (stopped containers, network not use by any containers, dangling images and build cache) :  
**If you choose to do that, make sure all your containers are running ! Otherwise, stopped ones will be deleted.**

```
sudo docker system prune
```
