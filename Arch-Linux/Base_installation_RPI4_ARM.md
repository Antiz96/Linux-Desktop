# Arch Linux ARM base installation for RPI 4

## Installation

<https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4>

I also create a third 4G partition for Swap.

## Configuration

### Install sudo and give sudo privileges to the regular user

As root (**only for this part**):

```bash
pacman -Syy
pacman -S sudo
visudo
```

Uncomment the following line:  
> %wheel ALL=(ALL:ALL) ALL

### Update the machine

#### Enable color & parallel downloads in pacman

```bash
sudo vi /etc/pacman.conf
```

> [...]  
> Color  
> [...]  
> ParallelDownloads = 10  
> [...]

#### Update

```bash
sudo pacman -Syy
sudo pacman -Syu
```

### Set up the swap partition (previously created during installation)

```bash
sudo mkswap /dev/mmcblk1p3
sudo swapon /dev/mmcblk1p3
sudo vi /etc/fstab
```

> [...]  
> /dev/mmcblk1p3  none    swap    defaults        0       0

### Rename the default "alarm" user

#### Temporarily enable ssh connection for the root user

```bash
sudo vi /etc/ssh/sshd_config
```

> [...]  
> PermitRootLogin yes  
> [...]

```bash
sudo systemctl restart sshd
```

#### Rename the alarm user and set a new password

Connect directly as **root** via ssh (only for this part):

```bash
usermod -l antiz alarm
groupmod -n antiz alarm
usermod -d /home/antiz -m antiz
passwd antiz
```

### Disable ssh connection for the root account

```bash
sudo vi /etc/ssh/sshd_config
```

> [...]  
> PermitRootLogin no  
> [...]

```bash
sudo systemctl restart sshd
```

## Post Install preferences

Then I configure Arch Linux according to my preferences, without the things that has already been done during the Arch Linux ARM installation and the above steps (partitiong/filesystem, mount + pacstrap + genfstab, creating my user, grub bootloader, exit and umount /mnt, etc...):

<https://github.com/Antiz96/Linux-Desktop/blob/main/Arch-Linux/Base_installation.md>

## Disable systemd-resolved

Systemd-resolved is enabled by default on Arch-Linux ARM.  
It causes interferences with NetworkManager so I disable it:

```bash
sudo vim /etc/systemd/resolved.conf
```

> [...]  
> [Resolve]  
> DNSStubListener=no  
> [...]

```bash
sudo systemctl disable --now systemd-resolved
sudo rm /etc/resolv.conf
sudo touch /etc/resolv.conf
```

## Switch to the Linux RPI Kernel

By default, Arch Linux ARM **aarch64** comes with the mainline Linux kernel.  
I personally advise switching to the Linux RPI kernel for a better hardware support:

```bash
sudo pacman -S linux-rpi linux-rpi-headers #Accept to replace conflicting packages
sudo sed -i 's/mmcblk1/mmcblk0/' /etc/fstab
sudo reboot
```

## Desktop environment/Window manager (optional)

- [Gnome](https://github.com/Antiz96/Linux-Desktop/blob/main/Arch-Linux/Gnome.md)
- [XFCE](https://github.com/Antiz96/Linux-Desktop/blob/main/Arch-Linux/XFCE.md)
- [IceWM](https://github.com/Antiz96/Linux-Desktop/blob/main/Arch-Linux/IceWM.md)
- [i3](https://github.com/Antiz96/Linux-Desktop/blob/main/Arch-Linux/i3.md)
