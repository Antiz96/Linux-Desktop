# Install Docker on my Debian Server (if not done already)

https://github.com/Antiz96/Linux-Customisation/blob/main/Home-Server/Docker-Install.md


# Installing Nextcloud on Docker

https://github.com/nextcloud/docker

## Create the Nextcloud directory

Create the directory in which the configuration and the data will be stored :
<br>
`sudo mkdir /data/Nextcloud`

## Pull and run the container

This run command contains the mapping to /data/Nextcloud (previously created) to get persistent data for upgrades and backups.
<br>
It also contains the Docker "always" restart policy (https://docs.docker.com/config/containers/start-containers-automatically/).
<br>
It will make nextcloud listen to the "8080" port. Make sure you don't have anything already listening to that port.
<br>
*If you do have anything already listening to the 8080, use another one in the below command*
<br>
`sudo docker run --name nextcloud -v /data/Nextcloud:/var/www/html -d --restart always -p 8080:80 nextcloud`

## Access

You can access your nextcloud instance with the following URL :
<br>
http://[HOSTNAME]:8080/

## Nextcloud administration guide

https://docs.nextcloud.com/server/23/admin_manual/index.html


# Apps

## Disable the following default apps

Usage survey
<br>
User status
<br>
Weather status

## Enable the following default apps

Auditing/Logging
<br>
External storage support *(only if you plan to use external storage support such a FTP, S3, etc...)*
<br>
Default encryption module *(only if you use remote storage(s). If not, you'd better use full disk encryption instead)*

## Only Office integration

https://nextcloud.com/blog/how-to-install-onlyoffice-in-nextcloud-hub-and-new-integration-feature/
<br>
Install the **Community Document Server** and the **OnlyOffice** app.

## Disk space monitoring

Install the **Quota warning** app.

## Trello like integration (for enterprise purpose)

Install the **Deck** app.

## 2FA Authentication Support (for enterprise purpose)

Install the **Two-Factor TOTP Provider** app.
Install the **Two-Factor Admin Support** app.


# Update/Upgrade and reinstall procedure

Since we use Docker, the update and upgrade procedure is actually the same as it does not rely directly on our server.
<br>
Also, if you did a mapping between a volume stored on a local disk (like I did), all you need to do to reinstall your Nextcloud server is to re-download Docker (if you reinstalled your OS completly) and do the following steps.

## Pull the docker image

*(... to check if there's an available update)*
<br>
`sudo docker pull nextcloud`

## Apply the update

Stop, delete and re-run the container in order to apply the update :
```
sudo docker stop nextcloud
sudo docker rm nextcloud
sudo docker run --name nextcloud -v /data/Nextcloud:/var/www/html -d --restart always -p 8080:80 nextcloud
```

## After an update

After an update, you can clean old dangling docker images (to regain spaces and clean up your local stored Docker images) :
<br>
`sudo docker image prune`
<br>
<br>
Alternatively, you can clean all unused Docker component (stopped containers, network not use by any containers, dangling images and build cache) :
<br>
**If you choose to do that, make sure all your containers are running ! Otherwise, stopped ones will be deleted.**
<br>
`sudo docker system prune`


Hello
<br>
World
<br>
<br>
Salut  Monde
