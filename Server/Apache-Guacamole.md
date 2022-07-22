# Apache Guacamole

https://guacamole.apache.org/

## Install Docker on my Server (if not done already)

https://github.com/Antiz96/Linux-Configuration/blob/main/Server/Docker.md

## Installing Apache Guacamole on Docker

https://www.linode.com/docs/guides/installing-apache-guacamole-through-docker/  
https://guacamole.apache.org/doc/gug/guacamole-docker.html  

### Pull the docker images

```
sudo docker pull guacamole/guacamole #Provides the Guacamole web application running within Tomcat with support for WebSocket
sudo docker pull guacamole/guacd #Provides the needed packages and lib for the various connection protocols available : VNC, RDP, SSH, telnet, and Kubernetes
sudo docker pull mysql/mysql-server #Needed for authentication and storage of configuration
```

### Generate the database's table creation script

```
sudo docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > /tmp/initdb.sql
```

### Create a directory on my secondary disk to store the database 

```
sudo mkdir -p /storage/Guacamole/Database
```

### Launch the MYSQL container, map it to the volume created in the above command and generate a "one time" password for the MYSQL Root account

```
sudo docker run --name mysql -e MYSQL_RANDOM_ROOT_PASSWORD=yes -e MYSQL_ONETIME_PASSWORD=yes -v /storage/Guacamole/Database:/var/lib/mysql -d mysql/mysql-server
sudo docker logs mysql #To retrieve the password in the following line
```

> [Entrypoint] GENERATED ROOT PASSWORD: "password"

### Copy the "initdb.sql" script into the mysql container

```
sudo docker cp /tmp/initdb.sql mysql:/tmp/guac_db.sql
```

### Configure the mysql instance

#### log in the mysql container

```
sudo docker exec -it mysql bash
mysql -u root -p #The password is the one generated above
```

#### Change the mysql root password, create a regular mysql user and a database for Guacamole 

*Change 'password', 'guacamole_user' or the database's name to your liking.*

```  
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';  
CREATE DATABASE guacamole_db;  
CREATE USER 'guacamole_user'@'%' IDENTIFIED BY 'password';  
GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole_db.\* TO 'guacamole_user'@'%';  
FLUSH PRIVILEGES;  
quit
```

#### Execute the database's table creation script generated earlier

```
cat /tmp/guac_db.sql | mysql -u root -p guacamole_db
```
  
If you wish, you can verify that the tables have been created, like so :

```
mysql -u guacamole_user -p
USE guacamole_db;
SHOW TABLES;
quit
```

#### Exit the container to get back to the server
```
exit
```

### Start the guacd container

```
sudo docker run --name guacd -d guacamole/guacd
```

### Start the guacamole container and link it to the guacd and mysql containers 

*Change "MYSQL_DATABASE", "MYSQL_USER" and "MYSQL_PASSWORD" to what you configured.*  

```
sudo docker run --name guacamole --link guacd:guacd --link mysql:mysql -e MYSQL_DATABASE=guacamole_db -e MYSQL_USER=guacamole_user -e MYSQL_PASSWORD=guacamole_user_password -d -p 8080:8080 guacamole/guacamole
```

### Access

You can now access and configure guacamole on this URL (Default Login/Pass = guacadmin/guacadmin) :  
`http://[HOSTNAME]:8080/guacamole`

## Configuration

https://www.youtube.com/watch?v=LWdxhZyHT_8

### Modify the default user's password (for security reasons) and changing the timezone

guacadmin (top right coner) --> Settings --> Preferences  
From here you can set/change the timezone if needed and change the password for the current (guacadmin) user.

### Create your own new administrator account 

*We will delete the default user in the next step for security reasons*  
  
guacadmin (top right coner) --> Settings --> User --> guacadmin  
From here you can clone the guacadmin user (with the "clone" button at the bottom center of the page) to create a new user with the same permissions.    
Then change the username, password, profil and various settings to your liking and click "Save" at the bottom center.  

### Delete the default user (for security reasons)

Log into your new user (created in the previous step) and get back to the user settings.  
Click on "guacadmin" and click on "Delete" (at the bottom center of the page).

### Create new groups, connections or users (if needed)

You can now set up your various groups, connections to your machines or create other users with particular permissions if needed.  
There are some great explanations on how to do all of that in this video :  
https://www.youtube.com/watch?v=LWdxhZyHT_8

## Make the Guacamole's containers autostart at boot

https://www.techrepublic.com/article/how-to-ensure-your-docker-containers-automatically-start-upon-a-server-reboot/  
  
Docker containers will not automatically launch at startup by default, you'll need to launch them yourself each time the server boot/reboot with "sudo docker start mysql guacd guacamole" unless you do the following.  
To make guacamole containers automatically launch at startup, we'll use "Docker Restart Policies".  
There are different Docker restart policies available, I let you refer to the link above to choose the right one for you.
I'll personally use the "unless-stopped" Docker restart policy.  
  
Update the Docker restart policy of each containers :  

```
sudo docker update --restart unless-stopped mysql
sudo docker update --restart unless-stopped guacd
sudo docker update --restart unless-stopped guacamole
```

## Update/Upgrade and reinstall procedure

Since we use Docker, the update and upgrade procedure is actually the same as it does not rely directly on our server.  
Also, if you did a mapping between a volume stored on a secondary disk and your mysql container to store the database (like I did), all you need to do to reinstall your Guacamole server is to re-download Docker (if you reinstalled your OS completly) and do the following steps :  

### Pull the different docker images 

*(... to check if there's available updates).*

```
sudo docker pull guacamole/guacamole
sudo docker pull guacamole/guacd
sudo docker pull mysql/mysql-server
```

### Apply Update

#### For Mysql

```
sudo docker stop mysql
sudo docker rm mysql
sudo docker run --name mysql -v /storage/Guacamole/Database:/var/lib/mysql -d --restart unless-stopped mysql/mysql-server
```

#### For guacd

```
sudo docker stop guacd
sudo docker rm guacd
sudo docker run --name guacd -d --restart unless-stopped guacamole/guacd 
```

#### For guacamole 

*Change "MYSQL_DATABASE", "MYSQL_USER" and "MYSQL_PASSWORD" to what you configured)*  

```
sudo docker stop guacamole
sudo docker rm guacamole
sudo docker run --name guacamole --link guacd:guacd --link mysql:mysql -e MYSQL_DATABASE=guacamole_db -e MYSQL_USER=guacamole_user -e MYSQL_PASSWORD=guacamole_user_password -d --restart unless-stopped -p 8080:8080 guacamole/guacamole 
```

### After an update

After an update, you can clean old dangling docker images (to regain spaces and clean up your local stored Docker images) :  

```
sudo docker image prune
```
  
Alternatively, you can clean all unused Docker component (stopped containers, network not use by any containers, dangling images and build cache) :  
**If you choose to do that, make sure all your containers (guacamole, guacd and mysql) are running ! Otherwise, they will be deleted.**

```
sudo docker system prune
```
