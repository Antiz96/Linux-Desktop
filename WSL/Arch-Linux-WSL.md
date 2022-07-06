# Installation

https://github.com/yuk7/ArchWSL

# Configuration

```
passwd #Change Root password
useradd -m rcandau #Create our user
passwd rcandau #Change its password
usermod -aG wheel rcandau #Put it in the wheel group so it can use sudo
export EDITOR=/usr/bin/vim #Make vim our default editor to edit the sudo configuration file
visudo #Uncomment line that allows wheel group members to use sudo on any command
```
  
The two following commands has to be launch in the windows cmd :  

```
cd Documents\Arch\ #Change directory to the directory that contains Arch Linux WSL
Arch.exe config --default-user rcandau #Make Arch log into our regular user at launch instead of root
```

Back to Arch :

```
sudo pacman -Syu #Update our system
sudo pacman -S base-devel linux-headers man bash-completion openssh sshpass inetutils dnsutils traceroute rsync zip unzip cronie diffutils git tmux mlocate htop neofetch glow #Install my needed packages. DO NOT INSTALL "fakeroot" (https://github.com/yuk7/ArchWSL/issues/3)
cd /tmp #Change directory to tmp to download and install AUR support
git clone https://aur.archlinux.org/yay.git #Download "yay" install sources
cd yay #Change directory to "yay" install sources directory
makepkg -si #Install "yay"
yay -S ddgr #Install "ddgr"
```
  
Install my config files :  
  
```
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/bashrc_Arch-WSL.txt -o ~/.bashrc
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/tmux.conf -o ~/.tmux.conf
```
  
Setup my DNS config for VPN :
  
https://github.com/Antiz96/Linux-Configuration/blob/main/WSL/Resolve_DNS_Using_VPN.md
  
Setup Openssh to accept rsa keys :

The newest version of openssh included in Arch Linux (from openssl 8.8p1-1) doesn't accept some type of ssh keys judged too old/insecured.  
To correct that, you can either specify the type of key in your command like so : `ssh -oHostKeyAlgorithms=+ssh-rsa user@host` or create the following file :

```
vi .ssh/config
```
> Host *
> >  HostKeyAlgorithms +ssh-rsa


 




