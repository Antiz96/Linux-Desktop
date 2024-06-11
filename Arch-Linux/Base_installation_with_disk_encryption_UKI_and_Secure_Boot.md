# Arch Linux base installation with Disk Encryption, Unified Kernel Image (UKI) and Secure Boot

This is my personal routine to install Arch Linux with Disk Encryption, Unified Kernel Image (UKI) and Secure Boot.

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

> EFI partition mounted on /boot --> 1G - FAT32  
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
cryptsetup -y -v luksFormat /dev/nvme0n1p3 #Setup the encryption for the Root partition and choose the passphrase
cryptsetup open /dev/nvme0n1p3 root #Open the encryption container on the Root partition and give it a name that will be used by the mapper. In my case, the name is "root"
mkfs.ext4 /dev/mapper/root #Make the filesystem for the root partition
```

### Mount the partitions and install the system's base

```bash
mount /dev/mapper/root /mnt #Mount the Root partition on /mnt to install the system's base on it
mkdir /mnt/boot #Create the /boot directory in /mnt
mount /dev/nvme0n1p1 /mnt/boot #Mount my EFI partition on it
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

### Configure the encrypt hook in mkinitcpio

```bash
vim /etc/mkinitcpio.conf #Add the "encrypt" kernel hook into the mkinitcpio configuration for the encryption
```

> [...]  
> HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block **encrypt** filesystems fsck)  
> [...]

### Setup Unified Kernel Image (UKI)

```bash
vim /etc/kernel/cmdline # Add our encrypted root partition to the kernel cmdline
```

> cryptdevice=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx:root root=/dev/mapper/root rw # Run 'blkid' to get the UID of your root partition

```bash
vim /etc/mkinitcpio.d/linux.preset # Enable UKI options in mkinitcpio preset for your kernel
```

```text
# mkinitcpio preset file for the 'linux' package

#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
#default_image="/boot/initramfs-linux.img" # Comment the "regular" image line for initramfs
default_uki="/boot/EFI/Linux/arch-linux.efi" # Uncomment the "uki" line for the initramfs and change the path from /efi to /boot (as we mounted our boot partition to /boot)
#default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
#fallback_image="/boot/initramfs-linux-fallback.img" # Comment the "regular" image line for fallback initramfs
fallback_uki="/boot/EFI/Linux/arch-linux-fallback.efi" # Uncomment the "uki" line for the fallback initramfs and change the path from /efi to /boot (as we mounted our boot partition to /boot)
fallback_options="-S autodetect"
```

```bash
mkdir -p /boot/EFI/Linux # Make sure the directory for the UKIs exists
mkinitcpio -P # Build the UKIs
rm /boot/initramfs-*.img # Remove initramfs leftover image
```

### Use a more secure umask for the boot partition

This is to avoid warning with `bootctl install` in the next step.

```bash
vim /etc/fstab
```

> [...],fmask=**0077**,dmask=**0077**[...]

```bash
umount /boot
mount /boot
```

### Install and configure systemd-boot

```bash
pacman -S efibootmgr dosfstools mtools #Install the Grub bootloader and dependencies for EFI. Also install "os-prober" if you wish to do a dual boot with another distro/OS.
bootctl install
vim /boot/loader/loader.conf
```

> default arch-linux.efi
> timeout 0  
> console-mode max  
> editor no

```bash
systemctl enable systemd-boot-update.service
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

I personally modify the associated `paccache` systemd service to also delete uninstalled packages from cache:

```bash
sudo systemctl edit paccache.service
```

> [Service]  
> ExecStart=  
> ExecStart=/bin/bash -c 'paccache -ruk0 && paccache -r'

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

## Set up Secure Boot

Secure Boot adds an additional layer of security by maintaining a cryptographically signed list of binaries authorized or forbidden to run at boot. It basically helps in improving the confidence that the machine core boot components such as boot manager, kernel and initramfs have not been tampered with (more info in the related [Arch Wiki page](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#)).

### Putting firmware in "Setup Mode" and set an Admin password for the UEFI/Firmware menu

Secure Boot is in Setup Mode when the Platform Key is removed. To do so, use the option to delete/clear certificate from the UEFI/Firmware setup menu.  
If you want to backup the current keys and variables before deleting/clearing them, see <https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Backing_up_current_variables>.

It is also advised to set an Admin password for the UEFI/Firmware menu access (via the Security tab) to prevent anyone from being able to disable Secure Boot from there.

### Install and configure sbctl

```bash
sudo pacman -S sbctl # Install the sbctl package
sbctl status # Verify that Setup Mode is enabled
sudo sbctl create-keys # Generate our own signing keys
sudo sbctl enroll-keys -m # Enroll our keys to the UEFI, including Microsoft's keys (`-m`). See the warning in the following URL for more details: https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Creating_and_enrolling_keys
sudo sbctl sign -s /boot/EFI/Linux/arch-linux.efi # Sign the UKI
sudo sbctl sign -s /boot/EFI/Linux/arch-linux-fallback.efi # Sign the fallback UKI
sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI # Sign the boot loader
sudo sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi # Sign systemd-boot boot loader
sudo sbctl verify # Verify that the above files have been correctly sign
sbctl status # Verify that sbctl is correctly installed and that Setup Mode is now disabled
```

### Enable Secure Boot

You can now reboot your system and enable Secure Boot from the UEFI/Firmware setup menu.

You can check that Secure Boot is correctly set up and enabled by running:

```bash
sbctl status
```

## Base installation complete

Link to the installation and configuration procedure for i3 on Arch according to my preferences below (if needed):

- [i3](https://github.com/Antiz96/Linux-Desktop/blob/main/Arch-Linux/i3.md)
- [Sway](https://github.com/Antiz96/Linux-Desktop/blob/main/Arch-Linux/Sway.md)
