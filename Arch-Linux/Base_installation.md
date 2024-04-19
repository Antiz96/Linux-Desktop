# Arch Linux base installation

This is my personal routine to install Arch Linux

## Pre-configuration

```bash
loadkeys fr #Change Keyboard Layout
ping -c 4 archlinux.org #Check if I have access to the internet
timedatectl set-ntp true #Enable NTP to synchronize time within the live environment
timedatectl status #Check time status
```

## Prepare the disk

```bash
fdisk -l #Check the hard drives' name to select the one I want to install Arch Linux on
```

### Partition scheme

> EFI partition mounted on /boot/EFI --> 1G - FAT32  
> Swap partition --> 8G - SWAP  
> Root partition mounted on / --> Left free space - EXT4

### Partition the disk  

```bash
fdisk /dev/nvme0n1 #Partitioning the disk I want to install Arch on
```

> Delete current partitions ---> **o** (This deletes every partitions, use the "d" option instead if you only want to delete specific partitions)  
> Create a GPT partition table (cause I use EFI) ---> **g**
>
> Create a 1G EFI partition ---> **n** ---> **+1G** as last sector  
> Create a 8G Swap partition ---> **n** ---> **+8G** as last sector  
> Create a Root partition with the left space ---> **n**
>
> Change the first partition type to EFI ---> **t** ---> partition 1 ---> type 1  
> Change the second partition type to Linux swap ---> **t** ---> partition 2 ---> type 19  
> Change the third partition type to Linux filesystem ---> **t** ---> partition 3 ---> type 20 (this should already be done by default)
>
> Print the current partition table to review changes ---> **p**  
> Write the table to the disk ---> **w**

### Create the filesystems

```bash
mkfs.fat -F32 /dev/nvme0n1p1 #Create the filesystem for the EFI partition
mkswap /dev/nvme0n1p2 #Create the filesystem for the Swap partition
swapon /dev/nvme0n1p2 #Enable the Swap partition on the system
mkfs.ext4 /dev/nvme0n1p3 #Create the filesystem for the Root partition
```

### Mount the partitions and install the system's base

```bash
mount /dev/nvme0n1p3 /mnt #Mount the Root partition on /mnt to install the system's base on it
mkdir -p /mnt/boot/EFI #Create the /boot/EFI directories in /mnt
mount /dev/nvme0n1p1 /mnt/boot/EFI #Mount the EFI partition on /boot/EFI
pacstrap /mnt base linux linux-firmware #Install the system's base on the Root partition
genfstab -U /mnt >> /mnt/etc/fstab #Generate the system's fstab
```

## Configure the system

### Chroot into the system

```bash
arch-chroot /mnt #Chroot in the new installed system's base on the root partition
```

### Configure pacman

```bash
pacman -S vim #Install my favorite editor
vim /etc/pacman.conf #Enable the "color" and "parallel downloads" options in pacman
```

> [...]  
> Color  
> [...]  
> VerbosePkgLists  
> ParallelDownloads = 10  
> [...]

### Language/Region configuration

```bash
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime #Set up the Region/TimeZone
hwclock --systohc #Synchronize the Hardware Clock
vim /etc/locale.gen #Uncomment the local in that file (for me: en_US.UTF-8 UTF-8)
locale-gen #Apply the configuration
vim /etc/locale.conf #Set the LANG variable accordingly in this file (for me: LANG=en_US.UTF-8)
vim /etc/vconsole.conf #Set the Keymap in this file (for me: KEYMAP=fr)
```

### Host configuration

```bash
vim /etc/hostname #Create the hostname file and put the hostname in it
```

> Arch-Desktop

```bash
vim /etc/hosts #Edit the hosts file and add lines from the Arch Wiki ---> https://wiki.archlinux.org/index.php/Installation_guide#Network_configuration.
```

> 127.0.0.1        localhost  
> ::1              localhost  
> 127.0.1.1        Arch-Desktop.localdomain Arch-Desktop

### User configuration

```bash
passwd #Setup a password for the root account
useradd -m antiz #Create a "regular" user
passwd antiz #Setup a password for the user
usermod -aG wheel,audio,video,optical,storage,games antiz #Add the user to some useful groups
```

### Install and configure sudo

```bash
pacman -S sudo #Install sudo
visudo #Uncomment the line that allows the wheel group members to use sudo on any command
```

> [...]  
> %wheel ALL=(ALL) ALL  
> [...]

### Install and configure grub

```bash
pacman -S grub efibootmgr dosfstools mtools #Install the Grub bootloader and dependencies for EFI. Also install "os-prober" if you wish to do a dual boot with another distro/OS.
grub-install --target=x86_64-efi --bootloader-id=arch-linux --recheck #Install Grub on the EFI partition
grub-mkconfig -o /boot/grub/grub.cfg #Generating the Grub configuration file
mkdir -p /etc/pacman.d/hooks && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/grub-update.hook -o /etc/pacman.d/hooks/grub-update.hook #Download custom pacman hook to run grub-install [...] & grub-mkconfig [...] on grub update
```

### Install and enable Network Manager

```bash
pacman -S networkmanager #Install "networkmanager" to manage my network connection
systemctl enable NetworkManager #Autostart NetworkManager at boot
```

## Exit the system and reboot the computer

```bash
exit #Get out of the chroot
umount -l /mnt #Umount the /mnt mounted point
reboot #Reboot the computer to boot into the fresh Arch install
```

## Log in with the "regular" user previously created and install additional useful packages

```bash
sudo pacman -S devtools man bash-completion amd-ucode pacman-contrib #Additional useful packages and drivers. Install "intel-ucode" instead of "amd-ucode" if you have an Intel CPU
sudo grub-mkconfig -o /boot/grub/grub.cfg #Re-generate Grub configuration to include CPU microcode
```

### Install a firewall (optional)

Installing a firewall may be optional for a fresh and simple **desktop** install as Arch doesn't expose any service/ports by default.  
However, it is a supplementary security layer you might consider (even tho there's a little chance you ever need it).  
Check this link for more info/reasons to install a firewall: <https://unix.stackexchange.com/questions/30583/why-do-we-need-a-firewall-if-no-programs-are-running-on-your-ports>

*For a server, you probably **should** install a firewall.*

```bash
sudo pacman -S firewalld #Install firewalld
sudo systemctl enable --now firewalld #Autostart firewalld at boot
```

FirewallD authorises the "ssh" and "dhcpv6-client" services by default, to make sure you won't loose access to your machine if you need those.  
But I usually prefer removing them and accept what needs to be accepted myself for a finner control.

```bash
sudo firewall-cmd --remove-service="ssh" --permanent #Remove the default authorised ssh service
sudo firewall-cmd --remove-service="dhcpv6-client" --permanent #Remove the default authorised DHCPV6-client service
sudo firewall-cmd --reload #Apply changes
```

## Enable paccache (automatic cleaning of pacman cache)

The `pacman-contrib` package provides the `paccache` script which cleans the `pacman` cache by deleting all cached versions of installed and uninstalled packages, except for the most recent three.  
You can launch it manually by running `paccache -r`.

To launch `paccache` automatically on a weekly basis, enable the associated systemd timer:

```bash
sudo systemctl enable --now paccache.timer
```

## Enable fstrim (for SSDs only - optional)

If you use SSDs, you can use `fstrim` to discard all unused blocks in the filesystem in order to improve performances.  
You can launch it manually by running `sudo fstrim -av`, but keep in mind that it is not recommended to launch it too frequently. It is commonly approved that running it once a week is a sufficient frequency for most desktop and server systems.

To launch `fstrim` automatically on a weekly basis, enable the associated systemd timer:

```bash
sudo systemctl enable --now fstrim.timer
```

## Enable NTP for automatic time sync

```bash
sudo timedatectl set-ntp true
```

## Base installation complete

Link to the installation and configuration procedure for i3 on Arch according to my preferences below (if needed):

- [i3](https://github.com/Antiz96/Linux-Desktop/blob/main/Arch-Linux/i3.md)
