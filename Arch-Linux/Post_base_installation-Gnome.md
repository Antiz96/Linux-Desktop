# Gnome

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
> # Data  
> UUID=107b1979-e8ed-466d-bb10-15e72f7dd2ae       /run/media/rcandau/data         ext4          defaults 0 2  

## Packages to install

- arch-update (AUR) --> https://github.com/Antiz96/arch-update  
- bluemail (AUR)  
- ckb-next (AUR) **Only for my Desktop PC to configure my Corsair Keyboard. Settings --> (Last blue : 26, 95, 180)**
- chrome-gnome-shell (AUR) 
- ddgr (AUR) 
- discord  
- glow
- gnome-terminal-transparency (AUR)  
- gparted  
- hexchat  
- keepassxc  
- vlc  
- onlyoffice-bin (AUR)  
- openresolv **Only for my Laptop in order to connect to my VPN**  
- firefox  
- pacman-contrib
- spotify (AUR)
- steam
- virtualbox
- virt-viewer
- imagewriter (AUR)
- timeshift (AUR)
- mkinitcpio-numlock (AUR) **Then add the "numlock" hook in /etc/mkinitcpio.conf between "autodetect" and "modconf" and then** `sudo mkinitcpio -p linux`
- touchegg (AUR) **Only for my Laptop to enable trackpad gestures. After install :** `sudo systemctl enable --now touchegg`
- tmux
- dmenu
- zathura
- zathura-pdf-poppler
- mlocate
- htop
- neofetch
- wakeonlan (AUR)
- wireguard-tools **Only for Laptop in order to connect to my VPN**

## Theme

- Applications : Kimi-Dark (V40) - https://www.gnome-look.org/p/1326889/
- Icon : Tela-Circle-blue - https://www.gnome-look.org/p/1359276/
- Shell : Orchis-dark-compact - https://www.gnome-look.org/p/1357889/
- Cursor : McMojave cursors - https://www.opendesktop.org/s/Gnome/p/1355701/

## Gnome extensions

- Arch Linux Updates Indicator
- Arcmenu
- Coverflow alt+tab
- Dash to dock
- Frippery move clock
- Native window placement
- Panel osd
- Transparent Shell
- Tray Icons: Reloaded
- User themes
- Workspace indicator
- X11 Gestures **Only for laptop, enables trackpad gesture on Gnome 40+, requires touchégg (AUR) started and enable**

## Dock

- firefox
- terminal
- spotify
- bluemail
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
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/tmux.conf -o ~/.tmux/conf
mkdir -p ~/.config/zathura/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/General/zathurarc -o ~/.config/zathura/zathurarc && xdg-mime default org.pwmt.zathura.desktop application/pdf
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/Gnome/ArcMenu-Settings -o ~/Documents
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/Gnome/ArcMenu-Theme -o ~/Documents
source ~/.bashrc
```

## Keyboard Shortcuts

- Super = Open ArcMenu
- Super + F = Switch size of windows (Maximize/Minimize)
- Super + D = Close the window
- Super + E = Nautilus
- Super + C = Calculator
- Super + M = Display the desktop
- Super + A = Overview
- Super + L = Lock the screen
- Super + T = gnome-terminal
- CTRL + ALT + DEL = htop
