# FileBrowser

https://filebrowser.org/

## Install Docker on my Server (if not done already)

https://github.com/Antiz96/Linux-Configuration/blob/main/Server/Docker.md

## Installing FileBrowser on Docker

https://github.com/filebrowser/filebrowser

### Create the FileBrowser directory and the database file (with the right permission)

```
sudo mkdir -p /data/FileBrowser/data && sudo chown rcandau: /data/FileBrowser/data && chmod 700 /data/FileBrowser/data
sudo touch /data/FileBrowser/database.db && sudo chown rcandau: /data/FileBrowser/database.db && chmod 600 /data/FileBrowser/database.db
```

### Pull and run the container

```
sudo docker run -v /data/FileBrowser/data:/srv -v /data/FileBrowser/database.db:/database.db -u $(id -u):$(id -g) -p 8080:80 --name filebrowser -d --restart="unless-stopped" filebrowser/filebrowser
```

### Access

You can now access and configure it on this URL (admin:admin) :  
`http://[HOSTNAME]:8080/`


## Configuration

Global Settings --> Dark Mode  
User Management --> Change default username and password

## Update/Upgrade and reinstall procedure

Since we use Docker, the update and upgrade procedure is actually the same as it does not rely directly on our server.  
Also, if you did a mapping between a volume stored on a local disk (like I did), all you need to do to reinstall your FileBrowser server is to re-download Docker (if you reinstalled your OS completly) and do the following steps.

### Pull the docker image

*(... to check if there's an available update)*

```
sudo docker pull filebrowser/filebrowser
```

### Apply the update

```
sudo docker stop filebrowser
sudo docker rm filebrowser
sudo docker run -v /data/FileBrowser/data:/srv -v /data/FileBrowser/database.db:/database.db -u $(id -u):$(id -g) -p 8080:80 --name filebrowser -d --restart="unless-stopped" filebrowser/filebrowser
```

### After an update

After an update, you can clean old dangling docker images (to regain spaces and clean up your local stored Docker images) :  

```
sudo docker image prune
```

Alternatively, you can clean all unused Docker component (stopped containers, network not use by any containers, dangling images and build cache) :  
**If you choose to do that, make sure all your containers are running ! Otherwise, they will be deleted.**  

```
sudo docker system prune
```
