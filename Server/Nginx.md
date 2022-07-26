# Nginx

https://www.nginx.com/

I use nginx as a reverse proxy to access all my self hosted services.  
It allows me to easily manage headers and various settings of my self hosted services as well as easily securing them with SSL and extra security settings.  

## Installation

**Arch :** 

```
sudo pacman -S nginx
```
  
**Debian :**

```
sudo apt install nginx
```

## Configuration

```
sudo mkdir -p /etc/nginx/conf.d && sudo mkdir /opt/ssl #Create directories for URL configuration files and ssl related files
sudo vim /etc/nginx/nginx.conf
```

> [...]  
> worker_processes 4; #Change worker_processes from 1 to the number of CPU cores  
> [...]  
> types_hash_max_size 4096; #Add this to the http context to get rid of the warning "could not build optimal types_hash" --> https://bugzilla.redhat.com/show_bug.cgi?id=1564878  
> [...]  
> server_tokens off; #Add this to the http context to hide the nginx version  
> [...]  
> include /etc/nginx/conf.d/\*.conf; #Add this to the http context to use configuration files from the conf.d directory previously created  
> [...]  
> #server { #Comment the WHOLE default server block  
> > #listen       80;  
> > #server_name  localhost;  
> > [...]

```
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl enable --now nginx
```

## Creation of a self signed wildcard SSL certificate (on one server and then copy them on the second node)

```
cd /opt/ssl/
sudo openssl genrsa -out xxx.key 4096
sudo openssl req -key xxx.key -new -sha256 -out xxx.csr -addext "subjectAltName = DNS:CN_OF_CERTIFICATE"
sudo openssl x509 -signkey xxx.key -in xxx.csr -req -days 365 -out xxx.crt
```

## URL Configuration Template

```
sudo vim "URL".conf
```

> server {  
> > listen “HOSTNAME or IP”:443 ssl http2;  
> > server_name “URL”;  
> >    
> > #Log Path  
> > access_log /var/log/nginx/”URL”\_access.log;  
> > error_log /var/log/nginx/”URL”\_error.log;  
> >  
> > #SSL  
> > ssl_protocols TLSv1.2 TLSv1.3;  
> > #Protocols needed for Portainer  
> > #proxy_ssl_protocols TLSv1.2 TLSv1.3;  
> > ssl_certificate /opt/ssl/”Filename”.crt;  
> > ssl_certificate_key /opt/ssl/”Filename”.key;  
> >    
> > location / {  
> > > proxy_pass “URL_to_redirect_to”;
> > >   
> > > #Header needed for Pihole  
> > > #proxy_set_header Host $host;  
> > >  
> > > #Extra configuration needed for FileBrowser (disable the max size check for file upload)  
> > > #client_max_body_size 0;  
> > >  
> > > #Extra configuration needed for Portainer (websocket for container consoles)  
> > > #proxy_http_version 1.1;  
> > > #proxy_set_header Upgrade $http_upgrade;  
> > > #proxy_set_header Connection "Upgrade";  
> > > #proxy_set_header Host $host;  
> > >  
> > > #Extra configuration needed for Proxmox (websocket for VM consoles and disable the max size check for ISO upload)  
> > > #proxy_http_version 1.1;  
> > > #proxy_set_header Upgrade $http_upgrade;  
> > > #proxy_set_header Connection "upgrade";  
> > > #client_max_body_size 0;  
> > >  
> > > #HSTS Vulnerability  
> > > add_header Strict-Transport-Security 'max-age=63072000; includeSubDomains; preload';  
> > >  
> > > #Nosniff & XSS Protection  
> > > add_header X-Content-Type-Options nosniff;  
> > > add_header X-XSS-Protection "1; mode=block";  
> > > add_header X-Frame-Options SAMEORIGIN always;  
> > > add_header Content-Security-Policy "frame-ancestors 'self';base-uri 'self';";  
> >
> > }  
>
> }

## Validate and apply new configuration(s)

```
sudo nginx -t
```

> nginx: the configuration file /etc/nginx/nginx.conf syntax is ok  
> nginx: configuration file /etc/nginx/nginx.conf test is successful
    
```
sudo nginx -s reload
```

## Specific extra configurations for the Proxmox Spice Proxy 

```
sudo vim /etc/nginx/nginx.conf
```

> [...]  
> stream {  
> > include /etc/nginx/conf.d/proxmox-spice.stream;  
>  
> }

```
sudo vim /etc/nginx/conf.d/proxmox-spice.stream
```

> server {  
> > listen "HOSTNAME or IP":3128;  
> > proxy_pass "PROXMOX_SERVER":3128;  
>  
> }

```
sudo firewall-cmd --add-port=3128/tcp --permanent
sudo firewall-cmd --reload
sudo nginx -t
sudo nginx -s reload
```
