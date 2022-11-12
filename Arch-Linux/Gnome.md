# Gnome

## Install Xorg and graphical drivers (optional)

*As I have a Nvidia GPU, I'm still using Xorg over Wayland.*  
  
- For regular computers:  
  
```
sudo pacman -S xorg-server nvidia
sudo localectl --no-convert set-x11-keymap fr #Configure Keyboard layout for x11
```

- For Raspberry Pi:  
  
```
sudo pacman -S xorg-server xf86-video-fbdev
sudo localectl --no-convert set-x11-keymap fr #Configure Keyboard layout for x11
sudoedit /boot/config.txt
```

> [...]  
> gpu_mem=256 #Increasing the reserved memory for the GPU

## Install Gnome (minimal installation)

Minimal installation according to my personal preferences.  
Check https://archlinux.org/groups/x86_64/gnome/ & https://archlinux.org/groups/x86_64/gnome-extra/ to see what you want to install or not.  
If you want a complete Gnome installation, just install the "gnome" package (and the "gnome-extra" package if you want to).  

```
sudo pacman -S gnome-shell gnome-control-center gnome-terminal gnome-calculator gnome-screenshot gnome-menus gnome-shell-extensions gnome-tweaks nautilus gedit file-roller eog xdg-user-dirs-gtk gdm 
sudo systemctl enable gdm
```

## Reboot and log into Gnome

```
sudo reboot
```

## Install an AUR Helper and a graphical package installer

```
sudo pacman -S git
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S pamac-aur
```

## Installing bluetooth support

```
sudo pacman -S bluez pulseaudio-bluetooth
yay -S bluez-utils-compat #That package contains deprecated tools that I need to make my USB-Dongle work. If you don't need them, just install **bluez-utils** via pacman
sudo systemctl enable --now bluetooth
```

## Mount secondary disk in fstab

```
sudo blkid #Show and copy the UUID of my secondary disk
sudo vim /etc/fstab
```
> #Data  
> UUID=107b1979-e8ed-466d-bb10-15e72f7dd2ae       /run/media/rcandau/data         ext4          defaults 0 2  

## Packages to install

- arch-update (AUR) --> https://github.com/Antiz96/arch-update `systemctl --user enable --now arch-update.timer` 
- gnome-browser-connector (AUR) 
- ddgr (AUR) 
- discord  
- docker --> `sudo systemctl enable --now docker`
- distrobox (AUR)
- glow
- gnome-keyring
- gnome-terminal-transparency (AUR)  
- gparted  
- hexchat  
- keepassxc 
- mailspring (AUR) 
- vlc  
- onlyoffice-bin (AUR)  
- openresolv **Only for my Laptop in order to connect to my VPN**  
- firefox  
- pacman-contrib
- protonmail-bridge (AUR)
- spotify (AUR)
- steam
- virtualbox
- virt-viewer
- imagewriter (AUR)
- timeshift (AUR) --> `sudo systemctl enable --now cronie`
- mkinitcpio-numlock (AUR) **Then add the "numlock" hook in /etc/mkinitcpio.conf between "autodetect" and "modconf" and then** `sudo mkinitcpio -p linux`
- touchegg (AUR) **Only for my Laptop to enable trackpad gestures. After install:** `sudo systemctl enable --now touchegg`
- tmux
- dmenu
- zathura
- zathura-pdf-poppler
- mlocate
- htop
- neofetch
- wireguard-tools **Only for Laptop in order to connect to my VPN**
- zaman (AUR) --> https://github.com/Antiz96/zaman

## Theme

- Applications: Kimi-Dark (V40) - https://www.gnome-look.org/p/1326889/
- Icon: Tela-Circle-Blue - https://www.gnome-look.org/p/1359276/
- Shell: Orchis-dark-compact - https://www.gnome-look.org/p/1357889/
- Cursor: McMojave cursors - https://www.opendesktop.org/s/Gnome/p/1355701/

## Bash Theme

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

## Gnome extensions

- Caffeine
- Dash to dock
- Native window placement
- Tray Icons: Reloaded
- User themes
- Workspace indicator
- X11 Gestures **Only for laptop, enables trackpad gesture on Gnome 40+, requires touchégg (AUR) started and enable**

## Dock

- firefox
- terminal
- spotify
- mailspring
- nautilus
- gedit 
- onlyoffice
- keepass
- steam
- discord
- hexchat
- virtualbox
- screenshot
- pamac
- extensions
- gnome tweaks
- settings

## Gnome Terminal Settings

- Preferences --> Dark Theme  
- Profile --> Colors ---> Gnome Dark --> Solarized  
- Transparent Background ---> Cursor between the two color squares above  

## Dotfiles

```
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/bashrc_Arch.txt -o ~/.bashrc
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/tmux.conf -o ~/.tmux.conf
mkdir -p ~/.config/zathura/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/General/zathurarc -o ~/.config/zathura/zathurarc && xdg-mime default org.pwmt.zathura.desktop application/pdf
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/Gnome/ArcMenu-Settings -o ~/Documents/ArcMenu-Settings
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/Gnome/ArcMenu-Theme -o ~/Documents/ArcMenu-Theme
source ~/.bashrc
```

## Keyboard Shortcuts

- Super + F = Switch size of windows (Maximize/Minimize)
- Super + D = Close the window
- Super + E = Nautilus
- Super + C = Calculator
- Super + M = Display the desktop
- Super + A = Overview
- Super + L = Lock the screen
- Super + T = gnome-terminal
