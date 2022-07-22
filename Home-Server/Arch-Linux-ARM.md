# Arch Linux ARM

https://archlinuxarm.org/

## Installation

https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4

## Configuration

### Install sudo and give sudo privileges to the regular user

As root (**only for this part**) :

```
pacman -S sudo
visudo
```

Uncomment the following line :  
> %wheel ALL=(ALL:ALL) ALL

### Update the server

#### Enable color & parallel downloads in pacman

```
sudo vi /etc/pacman.conf
```
> [...]  
> Color  
> [...]  
> ParallelDownloads = 10  
> [...]

#### Update

```
sudo pacman -Syy
sudo pacman -Syu
```

### Set up the swap partition

*(... previously created during the installation)*

```
sudo mkswap /dev/mmcblk0p3
sudo swapon /dev/mmcblk0p3
sudo vi /etc/fstab
```
> [...]  
> /dev/mmcblk0p3  none    swap    defaults        0       0

### Rename the default "alarm" user

#### Temporarely enable ssh connexion for the root user

```
sudo vi /etc/ssh/sshd_config
```
> [...]  
> PermitRootLogin yes  
> [...]  

```
sudo systemctl restart sshd
```

#### Rename the alarm user and set a new password

Connect directly as **root** via ssh (only for this part) :  

```
usermod -l rcandau alarm
groupmod -n rcandau alarm
usermod -d /home/rcandau -m rcandau
passwd rcandau
```

## Secure SSH connexions

### Change the default SSH port

```
sudo vi /etc/ssh/sshd_config
```
> [...]  
> Port **"X"** *#Where "X" is the port you want to set*  
> [...]

### Disable ssh connexion for the root account

```
sudo vi /etc/ssh/sshd_config
```
> [...]  
> PermitRootLogin no  
> [...]  

### Creating a SSH key on the client, copying the public key to the server and restrict SSH connexions method to public key authentication

**On the client :**

```
ssh-keygen -t rsa -b 4096 #Choose a relevant name to remember on which server/service/entity you use this key. Also, set a strong passphrase for encryption.
ssh-copy-id -i ~/.ssh/"keyfile_name".pub "user"@"server" #Change "keyfile_name", "user" and "server" according to your environment
```
  
**On the Server :**

```
sudo vi /etc/ssh/sshd_config
```
> [...]  
> PasswordAuthentication no  
> AuthenticationMethods publickey

### Restart the SSH service to apply changes

**If you already have a firewall service running, be sure you opened the port you've set earlier for SSH before restarting the service, otherwise you won't be able to log back to your server.**  
At that point, I do not have a firewall service running, but I'll take care of that in the next step.

```
sudo systemctl restart sshd
```

Also, be aware that, from now, you'll need to specify the port and the private key to connect to ssh, like so : `ssh -p "port" -i "/path/to/privatekey" "user"@"server"`.  
However, you can create a config file in "~/.ssh" to avoid having to specify the port, the user and/or the ssh key each time :

```
vi ~/.ssh/config
```
> Host **"Host alias"**  
> > User **"Username"**  
> > Port **"SSH port"**  
> > IdentityFile **"Path to the keyfile"**  
> > Hostname **"Hostname of the server"**

## Post Install preferences

Then I Configure Arch Linux according to my preferences, without the things that has already been done during the Arch Linux ARM installation and the above steps (partitiong/filesystem, mount + pacstrap + genfstab, creating my user, grub bootloader, exit and umount /mnt, etc...) :  

https://github.com/Antiz96/Linux-Configuration/blob/main/Arch-Linux/Base_installation.md

## Disable systemd-resolved

Systemd-resolved is enabled by default on Arch-Linux ARM.  
It causes interferences with NetworkManager (and Pihole-FTL as well) :  

```
sudo vim /etc/systemd/resolved.conf
```
> [...]  
> [Resolve]  
> DNSStubListener=no  
> [...]

```
sudo systemctl disable --now systemd-resolved
sudo rm /etc/resolv.conf
sudo touch /etc/resolv.conf
sudo reboot
```

## Install useful packages and starting/configuring the firewall

```
sudo pacman -S base-devel linux-headers man bash-completion openssh inetutils dnsutils postfix firewalld traceroute rsync zip unzip cronie diffutils git mlocate htop pacman-contrib
sudo systemctl enable --now sshd cronie postfix firewalld
sudo updatedb
sudo mandb
sudo firewall-cmd --add-port=X/tcp --permanent #Open the port we've set for SSH (replace "X" by the port)
sudo firewall-cmd --remove-service="ssh" --permanent #Close the default SSH port
sudo firewall-cmd --remove-service="dhcpv6-client" --permanent #Close the dhcpv6-client port as I do not use it
sudo firewall-cmd --reload
```

## Install wakeonlan

*(... so I can power on my server remotly via ssh on this server)*  

### Install yay

```
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Install wakeonlan

```
yay -S wakeonlan
```

## Download my .bashrc

```
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/bashrc_Arch-Server.txt -o ~/.bashrc
source ~/.bashrc
```

## Setup a static IP address

https://nanxiao.me/en/configure-static-ip-address-on-arch-linux/  

```
nmcli con show
sudo nmcli con modify 03994945-5119-3b3c-acbc-b599437851e8 ipv4.addresses 192.168.1.1/24
sudo nmcli con modify 03994945-5119-3b3c-acbc-b599437851e8 ipv4.gateway 192.168.1.254
sudo nmcli con modify 03994945-5119-3b3c-acbc-b599437851e8 ipv4.dns 192.168.1.254
sudo nmcli con modify 03994945-5119-3b3c-acbc-b599437851e8 ipv4.method manual
sudo nmcli con up 03994945-5119-3b3c-acbc-b599437851e8
```
