# Docker

https://www.docker.com/

## Install Docker on Arch

```
sudo pacman -S docker
sudo systemctl enable --now docker containerd
```

## Install Docker on Debian

https://www.linode.com/docs/guides/installing-and-using-docker-on-ubuntu-and-debian/

### Make sure docker is not already installed via the regular Debian repos

```
sudo apt remove docker docker-engine docker.io
```

### Install docker dependencies

```
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
```

### Add docker GPG Key and repo

```
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Update repo list and install docker

```
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io
```

### Start and enable the docker service

```
sudo systemctl start docker
sudo systemctl enable docker containerd
```
