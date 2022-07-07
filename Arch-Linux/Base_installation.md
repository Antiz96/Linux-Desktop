# Arch Linux base installation 

This is my personal routine to install Arch Linux

## Pre-configuration

```
loadkeys fr #Change Keyboard Layout
ping -c 4 archlinux.org #Check if I have access to the internet
timedatectl set-ntp true #Enable NTP
timedatectl status #Check the NTP Status
```

## Preparing the disk

```
fdisk -l #Check the hard drives name to select the one I want to install Arch Linux on
```

### Partition scheme

> EFI partition mounted on /boot --> 550M  
> Swap partition --> 4G (https://itsfoss.com/swap-size)  
> Root partition mounted on / --> Left free space

### Partitioning the disk  

```
fdisk /dev/nvme0n1 #Partitioning the disk I want to install Arch on
```
> Delete current partitions ---> o option (This deletes every partitions, use the "d" option instead if you want to delete specific partitions)  
> Create a GPT partition table (cause I use EFI) ---> g option  
>   
> Create a 550M EFI partition ---> n option  
> Create a 4G Swap partition ---> n option  
> Create a Root partition with the left space ---> n option  
>   
> Change the first partition type to EFI ---> t option, type 1  
> Change the second partition type to Linux swap ---> t option, type 19  
> Change the third partition type to Linux filesystem ---> t option, type 20  
>    
> Print the current partition table ---> p option  
> Write the table to the disk ---> w option  

### Create the filesystems

```
mkfs.fat -F32 /dev/nvme0n1p1 #Create the filesystem for the EFI partition
mkswap /dev/nvme0n1p2 #Create the filesystem for the Swap partition
swapon /dev/nvme0n1p2 #Activate swap on the system
mkfs.ext4 /dev/nvme0n1p3 #Create the filesystem for the Root partition
```

## Mounting the partitions and install the system's base 

```
mount /dev/nvme0n1p3 /mnt #Mount the Root partition on /tmp to install my system's base on it
mkdir -p /mnt/boot/EFI #Create the /boot/EFI directory in /tmp
mount /dev/nvme0n1p1 /mnt/boot/EFI #Mount my EFI partition on it
pacstrap /mnt base linux linux-firmware #Install my system's base on the root partition
genfstab -U /mnt >> /mnt/etc/fstab #Generate the fstab
```

## Configuring the system

### Entering the system

```
arch-chroot /mnt #Chroot in my new system's base on the root partition
```

### Configuring pacman

```
pacman -S vim #Install my favorite editor
vim /etc/pacman.conf #Enable the color and parallel downloads options 
```
> [...]   
> Color   
> [...]   
> ParallelDownloads = 10   
> [...]  

### Language configuration

```
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime #Set up my Region
hwclock --systohc #Synchronize the Hardware Clock
vim /etc/locale.gen #Uncomment my local in that file (for me : fr_FR.UTF-8 UTF-8)
locale-gen #Apply the configuration
vim /etc/locale.conf #Set the LANG variable accordingly in this file (for me : LANG=fr_FR.UTF-8
vim /etc/vconsole.conf #Set my Keymap in this file (for me : KEYMAP=fr)
```

### Host configuration

```
vim /etc/hostname #Create the hostname file and put my hostname in it (for me : Arch-Linux)
```
> Arch-Linux  

```
vim /etc/hosts #Edit the hosts file and add lines from the Arch Wiki ---> https://wiki.archlinux.org/index.php/Installation_guide#Network_configuration.
```
> 127.0.0.1	localhost  
> ::1		localhost  
> 127.0.1.1	Arch-Linux.localdomain Arch-Linux  

### User configuration

```
passwd #Setup a password for the root account
useradd -m rcandau #Create my user
passwd rcandau #Setup a password for my user
usermod -aG wheel,audio,video,optical,storage,games rcandau #Add my user to some useful groups
```

### Install and configure sudo

```
pacman -S sudo #Install sudo
visudo #Uncomment the line that allows wheel group members to use sudo on any command 
```
> %wheel ALL=(ALL) ALL  

### Install and configure grub

```
pacman -S grub efibootmgr dosfstools mtools #Install the grub bootloader and dependencies for EFI. Also install "os-prober" if you wish to do a dual boot with another distro/OS.
grub-install --target=x86_64-efi --bootloader-id=arch-linux --recheck #Install grub on my EFI partition
grub-mkconfig -o /boot/grub/grub.cfg #Generating the Grub configuration file
```

### Install and enable Network Manager

```
pacman -S networkmanager #Install networkmanager (needed to get and manage my internet connexion)
systemctl enable NetworkManager #Autostart NetworkManager at boot
```

### Configure and install the firewall

Installing a firewall may be optionnal for a fresh and simple desktop install as Arch doesn't expose any service/ports by default.  
However, it is a supplementary security layer you might consider (even tho there's a little chance you ever need it).  
Check this link for more info/reasons to install a firewall : https://unix.stackexchange.com/questions/30583/why-do-we-need-a-firewall-if-no-programs-are-running-on-your-ports  

```
pacman -S firewalld #Install the firewall
systemctl enable firewalld #Autostart the firewall at boot
firewall-cmd --remove-service="ssh" --permanent #Remove the opened ssh port by default as my PC doesn't run a ssh server
firewall-cmd --remove-service="dhcpv6-client" --permanent #Remove the opened DHCPV6-client port by default as I don't use it
firewall-cmd --reload #Apply changes
```

## Exit the system and reboot the computer

```
exit #Get out of the chroot
umount -l /mnt #Umount my /mnt mounted point
reboot #Reboot the computer to boot into my fresh Arch Install
```

## Log in with my user (rcandau) and install other useful packages

```
sudo pacman -S base-devel linux-headers man bash-completion xorg-server intel-ucode nvidia #Installing additional useful packages and drivers for my system
```

## Install a Desktop Environment/Standalone Window Manager

I've used GNOME and XFCE in the past (doing minimal installations) but I switched to IceWM since then.  
Here's my installation routine for the three of them.  

### GNOME (Minimal installation)

Minimal installation according to my personal preferences.  
Check https://archlinux.org/groups/x86_64/gnome/ & https://archlinux.org/groups/x86_64/gnome-extra/ to see what you want to install or not.  
If you want a complete GNOME installation, just install the "gnome" package (and the "gnome-extra" package if you want to).  

```
sudo pacman -S gnome-shell gnome-control-center gnome-terminal gnome-calculator gnome-screenshot gnome-menus gnome-shell-extensions gnome-tweaks nautilus gedit file-roller eog xdg-user-dirs-gtk gdm 
sudo systemctl enable gdm
```

### XFCE (Minimal installation) 

Minimal installation according to my personal preferences.  
Check https://archlinux.org/groups/x86_64/xfce4/ & https://archlinux.org/groups/x86_64/xfce4-goodies/ to see what you want to install or not.  
If you want a complete XFCE installation, just install the "xfce4" and the "xfce4-goodies" packages.  

```
sudo pacman -S xfce4 mousepad ristretto thunar-archive-plugin xfce4-notifyd xfce4-screenshooter xfce4-screensaver xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin numlockx plank gvfs gnome-calculator network-manager-applet blueman redshift file-roller picom xdg-user-dirs-gtk pulseaudio openssh lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm
```

### IceWM

IceWM with a few extra packages according to my personal preferences.  
Still a very minimal installation though, the most minimal of the three.  

```
sudo pacman -S icewm xfce4-terminal polkit-gnome pulseaudio picom plank thunar thunar-archive-plugin file-roller gvfs xdg-user-dirs-gtk mousepad ristretto xfce4-screenshooter notification-daemon gnome-calculator network-manager-applet blueman redshift openssh xorg-xinit xorg-xrandr xautolock i3lock lxappearance numlockx xdotool playerctl gsimplecal
```

#### Configurin startx for IceWM

I'm not using any display manager with IceWM.  
I'm using startx instead. I configure it this way :  

```
cp /etc/X11/xinit/xinitrc ~/.xinitrc
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
> if [ -z "${DISPLAY}" ] \\&& [ "${XDG_VTNR}" -eq 1 ]; then    
> > exec startx  
>  
> fi  

## Final various little configurations and reboot

```
sudo localectl --no-convert set-x11-keymap fr #Configure Keyboard layout for x11
sudo grub-mkconfig -o /boot/grub/grub.cfg #Re-generate grub configuration for CPU microcode
reboot #Reboot my system (then select GNOME on XORG in GDM if I installed GNOME)
```

**Base installation complete !**  
**Post base install :**
- GNOME : https://github.com/Antiz96/Linux-Customisation/blob/main/Arch-Linux/Arch%20Linux%20Post%20Base%20Install%20-%20Gnome.txt
- XFCE : https://github.com/Antiz96/Linux-Customisation/blob/main/Arch-Linux/Arch%20Linux%20Post%20Base%20Install%20-%20XFCE.txt
- ICEWM : https://github.com/Antiz96/Linux-Customisation/blob/main/Arch-Linux/Arch%20Linux%20Post%20Base%20Install%20-%20IceWM.txt
