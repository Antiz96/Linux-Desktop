# Arch Linux base installation

This is my personal installation routine for Arch Linux.

## Pre-configuration

```bash
loadkeys fr # Change Keyboard Layout
ping -c 4 archlinux.org # Check if I have access to the internet
timedatectl set-ntp true # Enable NTP to synchronize time within the live environment
timedatectl status # Check time status
```

## Disk partitioning

I personally use the following very simple partition scheme:

> ESP mounted on /efi --> 1G - FAT32  
> Root partition mounted on / --> Left free space - EXT4

### Create partitions

```bash
fdisk -l # Check the hard drive names to select the one I want to install Arch Linux on
fdisk /dev/nvme0n1 # Partitioning the disk I want to install Arch on
```

> Delete current partitions ---> **o** (This deletes every partitions, use the "d" option instead if you only want to delete specific partitions)  
> Create a GPT partition table ---> **g**  
>
> Create a 1G ESP ---> **n** ---> **+1G** as last sector  
> Create a Root partition with the left space ---> **n**  
>
> Change the first partition type to EFI ---> **t** ---> partition 1 ---> type 1  
> Change the third partition type to Linux filesystem ---> **t** ---> partition 2 ---> type 20 (this should already be the case by default)  
>
> Print the current partition table to review changes ---> **p**  
> Write the table to the disk ---> **w**

### Create filesystems

- With disk encryption:

```bash
mkfs.fat -F32 /dev/nvme0n1p1 # Create the filesystem for the ESP
cryptsetup -y -v luksFormat /dev/nvme0n1p2 # Setup the luks encryption for the Root partition and choose the passphrase
cryptsetup open /dev/nvme0n1p2 root # Open the luks encrypted container on the Root partition and give it a name that will be used by the mapper. In my case, the name is "root"
mkfs.ext4 /dev/mapper/root # Create the filesystem for the root mapper
```

- Without disk encryption:

```bash
mkfs.fat -F32 /dev/nvme0n1p1 # Create the filesystem for the ESP
mkfs.ext4 /dev/nvme0n1p2 # Create the filesystem for the root partition
```

### Mount partitions and install the base system

- With disk encryption:

```bash
mount /dev/mapper/root /mnt # Mount the root mapper on /mnt
mkdir /mnt/efi # Create the ESP directory
mount /dev/nvme0n1p1 /mnt/efi # Mount ESP
mkswap -U clear --size 4G --file /mnt/swapfile # Create a swapfile
swapon /mnt/swapfile # Activate the swapfile
pacstrap /mnt base linux linux-firmware # Install the base system on the root partition
genfstab -U /mnt >> /mnt/etc/fstab # Generate the fstab
```

- Without disk encryption:

```bash
mount /dev/nvme0n1p2 /mnt # Mount the root partition on /mnt
mkdir /mnt/efi # Create the ESP directory
mount /dev/nvme0n1p1 /mnt/efi # Mount ESP
mkswap -U clear --size 4G --file /mnt/swapfile # Create a swapfile
swapon /mnt/swapfile # Activate the swapfile
pacstrap /mnt base linux linux-firmware # Install the base system on the root partition
genfstab -U /mnt >> /mnt/etc/fstab # Generate the fstab
```

### Chroot into the new system

```bash
arch-chroot /mnt # Chroot in the newly installed system on the root partition
```

## System configuration

### Configure pacman

```bash
pacman -S vim # Install an editor
vim /etc/pacman.conf # Enable the "Color", "VerbosePkgLists" and "ParallelDownloads" options in pacman
```

> [...]  
> Color  
> [...]  
> VerbosePkgLists  
> ParallelDownloads = 10  
> [...]

### Language/Region configuration

```bash
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime # Set up the Region/TimeZone
hwclock --systohc # Synchronize the Hardware Clock
vim /etc/locale.gen # Uncomment the locale (for me: en_US.UTF-8 UTF-8)
locale-gen # Generate the locale
vim /etc/locale.conf # Set the LANG variable accordingly in this file (for me: LANG=en_US.UTF-8)
vim /etc/vconsole.conf # Set the Keymap in this file (for me: KEYMAP=fr)
```

### Host configuration

```bash
vim /etc/hostname # Create the hostname file and put the hostname in it
```

> Arch-Desktop

```bash
vim /etc/hosts # Edit the hosts file
```

> 127.0.0.1        localhost  
> ::1              localhost  
> 127.0.1.1        Arch-Desktop.localdomain Arch-Desktop

### User configuration

```bash
passwd # Setup a password for the root account
useradd -m antiz # Create a "regular" user
passwd antiz # Setup a password for the user
usermod -aG wheel antiz # Add the user to the wheel group (for sudo usage)
```

### Install and configure sudo

```bash
pacman -S sudo # Install sudo
visudo # Uncomment the line that allows the wheel group members to use sudo on any command
```

> [...]  
> %wheel ALL=(ALL) ALL  
> [...]

### Enable Splash Screen in mkinitcpio

This allows to show an Arch Linux logo during the loading of the initramfs by the kernel.  
This is purely aesthetic.

```bash
vim /etc/mkinitcpio.d/linux.preset
```

> [...]  
> default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp" # Uncomment that line  
> [...]

### Setup Unified Kernel Image (UKI)

A [UKI](https://wiki.archlinux.org/title/Unified_kernel_image) is the combination of the UEFI boot stub, the kernel & kernel cmdline, the initramfs and other resources into a single executable file which can be booted from boot loaders. It allows for a simpler systemd-boot setup (as it [automatically looks for UKIs without requiring additional configuration](https://wiki.archlinux.org/title/Unified_kernel_image#systemd-boot)) and a simpler bootchain overall. I also allows to include the initramfs into the Secure Boot verification (which would otherwise be unverified as it the initramfs intervenes later in the boot process) by booting, signing and verify the UKI (which itself contains the initramfs).

#### Set the kernel cmdline

```bash
vim /etc/kernel/cmdline # Add our encrypted root partition to the kernel cmdline
```

- With disk encryption:

> rd.luks.name=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx=root rd.luks.options=password-echo=no root=/dev/mapper/root rw # Run 'blkid' to get the UID of your root partition

- Without disk encryption:

> root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw # Run 'blkid' to get the UID of your root partition

#### Configure mkinitcpio to generate UKIs

```bash
vim /etc/mkinitcpio.d/linux.preset # Enable UKI options in mkinitcpio preset for your kernel
```

```text
[...]
#default_image="/boot/initramfs-linux.img" # Comment the "regular" image line
default_uki="/efi/EFI/Linux/arch-linux.efi" # Uncomment the "uki" line, make sure the root directory is pointing to /efi (should be the case by default) as this is where the ESP is mounted
[...]
```

```bash
mkdir -p /efi/EFI/Linux # Make sure the directory for the UKIs exists
pacman -S --asdeps systemd-ukify # Install systemd-ukify to build / assemble the UKI
```

### Add the sd-encrypt hook in mkinitcpio (if using disk encryption)

Required to handle the encrypted root partition at boot.

```bash
vim /etc/mkinitcpio.conf # Add the "sd-encrypt" kernel hook into the mkinitcpio configuration for the disk encryption
```

> [...]  
> HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole **sd-encrypt** block filesystems fsck)  
> [...]

### Setup AppArmor

```bash
pacman -S apparmor
systemctl enable apparmor
vim /etc/kernel/cmdline
```

- With disk encryption:

> rd.luks.name=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX=root rd.luks.options=password-echo=no root=/dev/mapper/root rw **lsm=landlock,lockdown,yama,integrity,apparmor,bpf**

- Without disk encryption:

> root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw **lsm=landlock,lockdown,yama,integrity,apparmor,bpf**

### Build the UKI

```bash
mkinitcpio -P # Build the UKI
rm /boot/initramfs-*.img # Remove initramfs leftover images
```

### Use a secure default umask for the ESP partition

This is to avoid warning with `bootctl install` in the next step.

```bash
vim /etc/fstab
```

> [...],fmask=**0077**,dmask=**0077**[...]

```bash
umount /efi
mount /efi
```

### Install and configure systemd-boot

```bash
bootctl install
vim /efi/loader/loader.conf
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
pacman -S networkmanager # Install NetworkManager to manage my network connection
systemctl enable NetworkManager systemd-resolved # Autostart NetworkManager and systemd-resolved at boot
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf # Symlink /etc/resolv.conf to systemd-resolved stub
```

## Exit the chroot and reboot into the installed system

```bash
exit # Get out of the chroot
umount -l /mnt # Umount the /mnt mounted point
reboot # Reboot the computer to boot into the fresh Arch install
```

## Log in with the "regular" user previously created and install additional useful packages

```bash
sudo pacman -S devtools man bash-completion amd-ucode pacman-contrib # Additional useful packages and drivers. Install "intel-ucode" instead of "amd-ucode" if you have an Intel CPU
```

## Install and configure firewalld

```bash
sudo pacman -S firewalld # Install firewalld
sudo systemctl enable --now firewalld # Autostart firewalld at boot
```

Firewalld authorises the "ssh" and "dhcpv6-client" services by default, but I personally don't need those (my machines with a SSH server running are using a custom port and I don't use IPv6).

```bash
sudo firewall-cmd --remove-service="ssh" --permanent # Remove the default authorised ssh service
sudo firewall-cmd --remove-service="dhcpv6-client" --permanent # Remove the default authorised DHCPV6-client service
sudo firewall-cmd --reload # Apply changes
```

## Disable IPv6

I personally don't use IPv6 so I disable it altogether via NetworkManager:

```bash
sudo nmcli connection modify Wired\ connection\ 1 ipv6.method "disabled" # Adapt the connection name if needed
sudo nmcli connection up Wired\ connection\ 1 # Adapt the connection name if needed
```

## Enable paccache (automatic cleaning of pacman cache)

The `pacman-contrib` package provides the `paccache` script which cleans the `pacman` cache by deleting old cached packages versions.  
To run `paccache` automatically on a weekly basis, enable the associated systemd timer:

```bash
sudo systemctl enable --now paccache.timer
```

I personally modify the associated `paccache` systemd service to also delete uninstalled packages from cache:

```bash
sudo systemctl edit paccache.service
```

> [Service]  
> ExecStart=  
> ExecStart=/bin/bash -c 'paccache -r && paccache -ruk0'

## Enable fstrim (for SSDs only)

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

Secure Boot adds an additional layer of security by maintaining a cryptographically signed list of binaries authorized to be booted. It basically helps in improving the confidence that the machine core boot components such as the boot-loader, kernel / kernel cmdline and initramfs (when using UKI) have not been tampered with (more info in the related [Arch Wiki page](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot)).

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
sudo sbctl sign -s /efi/EFI/Linux/arch-linux.efi # Sign the UKI
sudo sbctl sign -s /efi/EFI/systemd/systemd-bootx64.efi # Sign systemd-boot boot loader
sudo sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi # Sign systemd-boot boot loader under /usr/lib (required when using the `systemd-boot-update.service`. See the "Tip" at https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Automatic_signing_with_the_pacman_hook)
sudo sbctl sign -s /efi/EFI/BOOT/BOOTX64.EFI # Sign the fallback boot loader
sudo sbctl sign -s /boot/vmlinuz-linux # Sign the kernel file. This is not necessary as we boot the UKI instead, but it also doesn't hurt.
sudo sbctl verify # Verify that the above files have been correctly signed
sbctl status # Verify that sbctl is correctly installed and that Setup Mode is now disabled
sudo bootctl update # Force the update of the boot loader, just in case
```

### Enable Secure Boot

You can now reboot your system and enable Secure Boot from the UEFI/Firmware setup menu.

You can check that Secure Boot is correctly set up and enabled by running:

```bash
sbctl status
```

## Base installation complete

Link to the installation and configuration procedure for Niri on Arch according to my preferences below (if needed):

- [Niri](https://github.com/Antiz96/Linux-Desktop/blob/main/Arch-Linux/Niri.md)
