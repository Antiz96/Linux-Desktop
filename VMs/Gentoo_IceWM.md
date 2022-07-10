# Gentoo IceWM

Just a quick reminder on how I install a minimal Gentoo environnement to work with.

## Base Install

https://wiki.gentoo.org/wiki/Handbook:AMD64

### Boot on the ISO, change keymap, set a root password and launch ssh service

```
loadkeys fr
passwd
rc-service sshd start
```

### Partitioning the disk, create filesystem and mount the root partition (pretty similar to Arch Install)

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
mkdir --parents /mnt/gentoo
mount /dev/sda3 /mnt/gentoo
```

### Set the date and time

```
ntpd -q -g
```
OR MANUALLY WITH :  
```
date -s HH:MM:SS
```

### Download the desktop systemd stage tarball and unpack it

```
cd /mnt/gentoo/
wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20220220T170542Z/stage3-amd64-desktop-systemd-20220220T170542Z.tar.xz
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
```

### Setup parallel compilations ("A good choice is the smaller of: the number of threads the CPU has, or the total system RAM divided by 2 GiB.")

```
vi /mnt/gentoo/etc/portage/make.conf
```
> [...]  
> #Parallel Compilations  
> MAKEOPTS="-j4"  

### Select fastest mirrors

```
mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
mkdir --parents /mnt/gentoo/etc/portage/repos.conf
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

### Mount the boot partition

```
mount /dev/sda1 /boot
```

### Update the repository list

```
emerge-webrsync #For slow connections or behind a restrictive firewall
```
OR
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
eselect profile set "number" #To select another profile (mine is : "/desktop/systemd (stable)")
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
> USE="bash-completion -a52 -cdda -cdr curl -dvd -dvdr ffmpeg -fortran imap man networkmanager pulseaudio -qt5 -wayland zip gtk3 minizip postproc script"  

### Configuring the ACCEPT LICENSE variable

[link](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Optional:_Configuring_the_ACCEPT_LICENSE_variable)
  
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

### Install Linux Firmware (for hardware firmware, nvidia card, etc...) and intel microcode

```
emerge --ask sys-kernel/linux-firmware
emerge --ask sys-firmware/intel-microcode
```

## Configuring your OWN kernel part

### Installing, the kernel sources and tools to get information about the system

https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel  

```
emerge --ask sys-kernel/gentoo-sources #Download the default gentoo kernel sources
eselect kernel list #List the available kernels
eselect kernel set 1 #Select a kernel to use
ls -l /usr/src/linux #Check the symlink to the kernel
emerge --ask sys-apps/pciutils #Install the pciutils packages in order to get information about the system in order to configure the kernel properly
lspci && echo "" && lsmod #Get information about the system
```

### Configuring the kernel

```
cd /usr/src/linux 
make menuconfig #Generate a menu-driver kernel configuration screen. Below are all the things I had to manually select, the rest was already selected by default
```
> [\*] Virtualization  
> > [\*] Kernel-based Virtual Machine (KVM) support  
> > [\*] KVM for Intel (and compatible) processor support  
>  
> -\*- Enable the block layer  
> > Partition Types  
> > > [\*] Advancer partition selection  
> > > [\*] EFI GUID Partition support  

### Compiling and installing the kernel

```
make && make modules_install
make install
```

### Building an initramfs

```
emerge --ask sys-kernel/dracut
dracut --kver=5.15.23-gentoo #"uname -r" to see which kernel you're using, minus the architecture part (-x86_64)
ls /boot/initramfs* #Check that the initramfs has been successfully built
```

## Installing default Gentoo Kernel

### Installing the "installkernel" package

```
emerge --ask sys-kernel/installkernel-gentoo
```

### Install the actual Kernel

```
emerge --ask sys-kernel/gentoo-kernel
```

### Delete potential old kernel version

```
emerge --depclean
```

### Generate the kernel module

```
emerge --ask @module-rebuild
```

### Adding specific kernel module if needed

https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel#Kernel_modules  

## Additonial configuration

### Creating the fstab

```
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
hostnamectl hostname Gentoo
```
OR
```
vim /etc/hostname
```
> Gentoo

### Install dhcpcd for automatic network configuration (needs the "networkmanager" USE flag)

```
emerge --ask net-misc/networkmanager
systemctl enable NetworkManager
```

### Configure host file

```
vim /etc/hosts
```
> 127.0.0.1       localhost  
> ::1             localhost  
> 127.0.1.1       Gentoo.localdomain Gentoo  

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
grub-install --target=x86_64-efi --efi-directory=/boot
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

## Install qemu-guest-agent (if needed)

```
sudo emerge qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

## Install Spice Agent (if needed - Don't forget to put it to the startup script)

```
sudo emerge --ask spice-vdagent
```

## Install useful packages

```
sudo emerge --ask app-shells/bash-completion x11-base/xorg-server x11-drivers/nvidia-drivers 
```

## Install eselect-repository to add the elementary repo

```
sudo emerge --ask app-eselect/eselect-repository
eselect repository list | grep elementary
sudo eselect repository enable elementary
sudo emerge dev-vcs/git
sudo emerge --sync
```

## Install my complete IceWM environment 

```
sudo emerge --ask x11-wm/icewm x11-terms/xfce4-terminal media-sound/pulseaudio x11-misc/picom x11-misc/plank xfce-base/thunar xfce-extra/thunar-archive-plugin app-arch/file-roller gnome-base/gvfs x11-misc/xdg-user-dirs-gtk app-editors/mousepad media-gfx/ristretto xfce-extra/xfce4-screenshooter xfce-extra/xfce4-notifyd gnome-extra/gnome-calculator gnome-extra/nm-applet net-wireless/blueman x11-misc/redshift x11-apps/xinit x11-apps/xrandr x11-misc/xautolock x11-misc/i3lock lxde-base/lxappearance x11-misc/numlockx x11-misc/xdotool media-sound/playerctl       
```

## Copy and configure xinitrc

```
cp /etc/X11/xinit/xinitrc ~/.xinitrc
```

## Edit the xinitrc file (delete the complete last "if" block)

```
vim ~/.xinitrc #(Delete the 5 last lines and add the following ones instead)
```
> [...]  
> #Start IceWM  
> export XDG_SESSION_TYPE=X11  
> numlockx &  
> exec icewm-session  

```
vim ~/.bash_profile
```
> [...]  
> #Autostart IceWM  
> ``if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then``   
> > exec startx  
>  
> fi  

## Set Keyboard to fr in X

```
localectl --no-convert set-x11-keymap fr
```

## Update Grub

```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Reboot

```
reboot
```
