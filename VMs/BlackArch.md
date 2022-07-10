# BlackArch

Just a quick reminder on how I install BlackArch to practice security stuff.  

## Install BlackArch Slim (XFCE)

https://www.blackarch.org/downloads.html#install-iso

### Partition scheme

> 550M EFI  
> 4G Swap  
> Left ext4 root  

## Configuration

### Change user's shell to bash

```
sudo vim /etc/passwd #(change /bin/zsh to /bin/bash)
```

### Update the system and reboot

```
sudo pacman-key --refresh-keys
sudo pacman -Syu && yay -Syu 
reboot
```

### Install dependencies and various stuff

```
sudo pacman -S bash-completion traceroute neofetch dmenu zathura zathura-pdf-poppler numlockx
```

#### Install virtualbox addons (if needed)

Insert the addon disk and execute the run file with sudo privileges

#### Install qemu-agent for Proxmox (if needeed)

```
sudo pacman -S qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

#### Install Spice agent (if needed)

```
sudo pacman -S spice-vdagent
sudo systemctl start spice-vdagentd
```

### Start and enable the SSH Daemon

```
sudo systemctl enable --now sshd
```

### Reboot to apply changes

```
reboot
```

## Generate my ssh key

```
ssh-keygen
```

## Install my personal config files

```
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/bashrc_BlackArch.txt -o ~/.bashrc
mkdir -p ~/.config/zathura/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/General/zathurarc -o ~/.config/zathura/zathurarc && xdg-mime default org.pwmt.zathura.desktop application/pdf
```

## Create my export IP script

```
mkdir ~/Documents/scripts
vim ~/Documents/scripts/export_ip.sh
```

> #!/bin/bash  
> export ip="$1" && source ~/.bashrc && env | grep "$1"  && alias | grep "$1"  

```
chmod +x ~/Documents/scripts/export_ip.sh
```

## Put my openvpn files (tryhackme and hackthebox) in ~/Documents/Other

```
mkdir ~/Documents/Other
```

## Put my cheatsheet in /opt

```
sudo vim /opt/cheatsheet.txt
sudo chown rcandau: /opt/cheatsheet.txt
```

## Create my wordlist directory

```
sudo mkdir /opt/wordlist
sudo cp /usr/share/dirbuster/directory-list-2.3-medium.txt /opt/wordlist/
sudo cp /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz /opt/wordlist/
sudo tar xvzf /opt/wordlist/rockyou.txt.tar.gz -C /opt/wordlist/ && sudo rm /opt/wordlist/rockyou.txt.tar.gz
sudo chown -R rcandau: /opt/wordlist/
```

## Create my busybox directory

```
sudo mkdir /opt/busybox
sudo chown rcandau: /opt/busybox
```

## Create my revshell directory

```
sudo mkdir /opt/revshell
sudo chown rcandau: /opt/revshell
```

## Install various tools

```
sudo pacman -S sqlitebrowser && yay -S stegseek
```

## Firefox Bookmark

- https://gtfobins.github.io/
- https://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet
- https://github.com/swisskyrepo/PayloadsAllTheThings/blob/main/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md
- https://busybox.net/downloads/binaries/1.31.0-i686-uclibc/

## Settings

- Desktop Shortcut : Firefox, Terminal, File Manager, Trash
- Modify the logout widget in the panel settings --> Action Button - Shutdown, Reboot
- Startup App : Polkit, Numlockx (custom), Network, Settings Daemon, Spice Agent, Pulseaudio, Notification Daemon, xiccd, ssh keys agent, Folder update, Certificate Storage

## Static IP address, if needed

```
nmcli con show 
sudo nmcli con modify 03994945-5119-3b3c-acbc-b599437851e8 ipv4.addresses 192.168.1.101/24
sudo nmcli con modify 03994945-5119-3b3c-acbc-b599437851e8 ipv4.gateway 192.168.1.254
sudo nmcli con modify 03994945-5119-3b3c-acbc-b599437851e8 ipv4.dns 192.168.1.1
sudo nmcli con modify 03994945-5119-3b3c-acbc-b599437851e8 ipv4.method manual
sudo nmcli con up 03994945-5119-3b3c-acbc-b599437851e8 
```
