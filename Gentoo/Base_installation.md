# Gentoo base installation

This is my personal routine to install Gentoo  

## Base Install

https://wiki.gentoo.org/wiki/Handbook:AMD64

### Boot on the ISO, change keymap, set a root password and launch ssh service

```
loadkeys fr
passwd
rc-service sshd start #And then connect from another computer via ssh
```

### Partitioning the disk, create filesystem and mount the root and boot partitions

```
fdisk /dev/sda
```

> 550M --> EFI  
> 4G --> SWAP  
> Left --> ROOT  

```
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2 && swapon /dev/sda2
mkfs.ext4 /dev/sda3
mkdir -p /mnt/gentoo
mount /dev/sda3 /mnt/gentoo
mkdir -p /mnt/gentoo/boot/EFI
mount /dev/sda1 /mnt/gentoo/boot/EFI
```

### Set the date and time

```
ntpd -q -g
```

*or set it manually:*  

```
date -s HH:MM:SS
```

### Download the stage 3 tarball and unpack it

Head over to [this web page](https://www.gentoo.org/downloads/) and copy/paste the download link of the stage 3 tarball you want in the wget command, depending on the init system you chose and if the machine you're installing is a Server or a Desktop.  
  
*Example below with a **systemd desktop** machine*

```
cd /mnt/gentoo/
wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20221016T170545Z/stage3-amd64-desktop-systemd-20221016T170545Z.tar.xz
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
```

### Setup parallel compilations

According to Gentoo documentation, a good choice is the smaller of the number of threads the CPU has, or the total system RAM divided by 2 GiB.
  
```
vi /mnt/gentoo/etc/portage/make.conf
```

> [...]  
> #Parallel Compilations  
> MAKEOPTS="-j4"  

### Select fastest mirrors

```
mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
mkdir -p /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
```

### Copy the resolv.conf file into the Gentoo environment (to ensure it has DNS resolution)

```
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
```

### Mount the necessary filesystems

```
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run
```

### chroot into the new gentoo environment

```
chroot /mnt/gentoo /bin/bash 
source /etc/profile
export PS1="(chroot) ${PS1}"
```

### Update the repository list

```
emerge --sync
```

### To read new items in emerge (gives you changes, warning, rebuild, etc... Kinda like the Arch News)

```
eselect news list #List items
eselect news read #Read items. You can specify the one news to read with eselect news read "number_of_the_news"
eselect news purge #Remove read items
```

### To select a profile

```
eselect profile list #List available profiles. The one currently being used is taggued with "*"
eselect profile set "number" #To select another profile (mine is: "/desktop/systemd (stable)")
```

### Update the @world set (updating the system)

```
emerge --ask --verbose --update --deep --newuse @world
```

### The USE variable

https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Configuring_the_USE_variable  
  
```
emerge vim
vim /etc/portage/make.conf
```

> #USE Flags  
> USE="X bash-completion -a52 -cdda -cdr curl -dvd -dvdr ffmpeg -fortran imap man networkmanager pulseaudio -qt5 -wayland zip gtk3 gtk4 minizip postproc script dist-kernel"  

### Configuring the ACCEPT LICENSE variable

https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Optional:_Configuring_the_ACCEPT_LICENSE_variable

```
vim /etc/portage/make.conf
```

> [...]  
> #Accept License  
> ACCEPT_LICENSE="\*"  

### Configure timezone and locale for the Gentoo environment

```
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
vim /etc/locale.gen
```

> fr_FR.UTF-8 UTF-8  
  
```
locale-gen
```

### Configure locale for the system

```
eselect locale list #To get the list
eselect locale set 4 #To select the desired language
```

### Reload the Gentoo environment

```
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
```

### Install Linux Firmware and intel microcode

Install "amd-microcode" instead of "intel-microcode" for AMD CPU  
  
```
emerge --ask sys-kernel/linux-firmware sys-firmware/intel-microcode
```

## Installing a kernel

I usually install the "default" Gentoo kernel *binary* for speed and convience, but you can actually configure/compile your owm kernel if you want to.  
See https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel for more information.

### Install the Gentoo kernel

```
emerge --ask sys-kernel/gentoo-kernel-bin
```

### Delete potential old kernel versions

```
emerge --depclean
```

### Generate the kernel module

```
emerge --ask @module-rebuild
```

### Adding specific kernel module if needed

https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel#Kernel_modules  

## Additional configuration

### Creating the fstab

```
blkid
vim /etc/fstab
```

> #Boot  
> UUID=0C07-E57F                                  /boot           vfat            defaults,noatime       0 2  
> #Root  
> UUID=8ae3b953-d6a7-41ac-8a9e-e7674eda153f       /               ext4            rw,relatime   0 1  
> #Swap  
> UUID=43eba25f-5c9b-4d6e-a5b7-982c115ed4ff       none            swap            defaults      0 0  

### Configure hostname

```
vim /etc/hostname
```

> Gentoo

### Configure host file

```
vim /etc/hosts
```

> 127.0.0.1       localhost  
> ::1             localhost  
> 127.0.1.1       Gentoo.localdomain Gentoo  

### Install networkmanager to manage my network connection (needs the "networkmanager" USE flag)

```
emerge --ask net-misc/networkmanager
systemctl enable NetworkManager
```

### Configure root password

```
passwd
```

### Setup the boot configuration

```
systemd-firstboot --prompt --setup-machine-id
```

### Install and configure the GRUB Bootloader

```
vim /etc/portage/make.conf
```

> [...]  
> #GRUB UEFI  
> GRUB_PLATFORMS="efi-64"  

```
emerge --ask --verbose sys-boot/grub
grub-install --target=x86_64-efi --efi-directory=/boot/EFI
grub-mkconfig -o /boot/grub/grub.cfg
```

## Exit chroot and reboot the system

```
exit
cd
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo
reboot
```

## Create a regular user

```
useradd -m rcandau
passwd rcandau
usermod -aG wheel,audio,video rcandau
```

## Remove the stage tarball

```
rm /stage3-*.tar.*
```

## Install and configure sudo

```
emerge sudo
export EDITOR=vim
visudo
```

## Reboot the system and log to the regular user

```
reboot
```

## Install additional useful packages

```
sudo emerge --ask bash-completion 
```

### Install a firewall (optional)

Installing a firewall may be optionnal for a fresh and simple **desktop** install as Arch doesn't expose any service/ports by default.  
However, it is a supplementary security layer you might consider (even tho there's a little chance you ever need it).  
Check this link for more info/reasons to install a firewall: https://unix.stackexchange.com/questions/30583/why-do-we-need-a-firewall-if-no-programs-are-running-on-your-ports  
  
*For a server, you probably **should** install a firewall.*  
  
```
sudo env USE="minimal -pulseaudio" emerge --ask firewalld #The env USE variable allows you to add or remove CFlags directly in the emerge command. Those flags will not be remembered (unlike the ones set in /etc/portage/make.conf). It's useful to set some CFlags for a specific package that requires them, like FirewallD.
sudo systemctl enable --now firewalld #Autostart firewalld at boot
```

FirewallD authorises the "ssh" and "dhcpv6-client" services by default, to make sure you won't loose access to your machine if you need those.  
But I usually prefer removing them and accept what needs to be accepted myself for a finner control.   
 
```
sudo firewall-cmd --remove-service="ssh" --permanent #Remove the default authorised ssh service
sudo firewall-cmd --remove-service="dhcpv6-client" --permanent #Remove the default authorised DHCPV6-client service
sudo firewall-cmd --reload #Apply changes
```

## Base installation complete!

Link to the installation and configuration procedure for i3 on Gentoo according to my preferences below (if needed):  
  
- [i3](https://github.com/Antiz96/Linux-Customisation/blob/main/Gentoo/i3.md)
