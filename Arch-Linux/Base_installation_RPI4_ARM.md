# Arch Linux ARM base installation for RPI 4

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

### Update the machine

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

### Disable ssh connexion for the root account

```
sudo vi /etc/ssh/sshd_config
```
> [...]  
> PermitRootLogin no  
> [...]  

## Post Install preferences

Then I Configure Arch Linux according to my preferences, without the things that has already been done during the Arch Linux ARM installation and the above steps (partitiong/filesystem, mount + pacstrap + genfstab, creating my user, grub bootloader, exit and umount /mnt, etc...) :  

https://github.com/Antiz96/Linux-Configuration/blob/main/Arch-Linux/Base_installation.md

## Disable systemd-resolved

Systemd-resolved is enabled by default on Arch-Linux ARM.  
It causes interferences with NetworkManager :  

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

## Post base installation procedure for IceWM

I use IceWM on my RPI as it is very light :  
  
https://github.com/Antiz96/Linux-Customisation/blob/main/Arch-Linux/Post_base_installation-IceWM.md
