# Arch Linux WSL

## Downloand and installation procedure

https://github.com/yuk7/ArchWSL

## Configuration

### Creating and configuring my user

```
passwd #Change Root password
useradd -m rcandau #Create our user
passwd rcandau #Change its password
usermod -aG wheel rcandau #Put it in the wheel group so it can use sudo
export EDITOR=/usr/bin/vim #Make vim our default editor to edit the sudo configuration file
visudo #Uncomment line that allows wheel group members to use sudo on any command
```
  
### Set the default user as my regular user (instead of the root user)

The two following commands has to be launch in the windows cmd :  

```
cd Documents\Arch\ #Change directory to the directory that contains Arch Linux WSL
Arch.exe config --default-user rcandau #Make Arch log into our regular user at launch instead of root
```

### Enable systemd support

```
sudo vi /etc/wsl.conf
```

> [boot]  
> systemd=true

### Configuring pacman

```
sudo vi /etc/pacman.conf
```
> [...]  
> Color  
> [...]  
> ParallelDownloads = 10  
> [...]  

### Install my needed packages

```
sudo pacman -Syu #Update our system
sudo pacman -S base-devel linux-headers man bash-completion openssh inetutils dnsutils traceroute rsync zip unzip diffutils git tmux mlocate htop neofetch glow docker distrobox pacman-contrib codespell #Install my needed packages. DO NOT INSTALL "fakeroot" (https://github.com/yuk7/ArchWSL/issues/3)
cd /tmp #Change directory to tmp to download and install AUR support
git clone https://aur.archlinux.org/yay.git #Download "yay" install sources
cd yay #Change directory to "yay" install sources directory
makepkg -si #Install "yay"
yay -S certificate-ripper-bin arch-update #Install AUR packages
sudo systemctl enable --now docker paccache.timer #Enable systemd services
```
  
### Bash Theme

https://github.com/speedenator/agnoster-bash  
  
```
cd /tmp
git clone https://github.com/powerline/fonts.git fonts
cd fonts
sh install.sh
cd $HOME
mkdir -p .bash/themes/agnoster-bash
git clone https://github.com/speedenator/agnoster-bash.git .bash/themes/agnoster-bash
```

### Download my config files
  
```
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Bashrc/Arch-WSL -o ~/.bashrc
mkdir -p ~/.config/tmux/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/tmux.conf -o ~/.config/tmux/tmux.conf
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
source ~/.bashrc
```

**Uncomment the copy/paste option for WSL and comment the one for Linux in ~/.config/tmux/tmux.conf**
  
### Setup my DNS config for VPN
  
https://github.com/Antiz96/Linux-Desktop/blob/main/WSL/Resolve_DNS_Using_VPN.md
  
### Setup Openssh to accept rsa keys

The newest version of openssh included in Arch Linux (from openssh 8.8p1-1) doesn't accept some type of ssh keys judged too old/insecured.  
To correct that, you can either specify the type of key in your command like so : `ssh -oHostKeyAlgorithms=+ssh-rsa user@host` or add the following snippet in your ssh config file:

```
vi ~/.ssh/config
```
> Host *
> >  HostKeyAlgorithms +ssh-rsa
