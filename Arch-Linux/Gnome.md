# Gnome

## Install Xorg and graphical drivers (optional)

*As I have a Nvidia GPU, I'm still using Xorg over Wayland.*  
  
- For regular computers:  
  
```
sudo pacman -S xorg-server nvidia
```

- For Raspberry Pi:  
  
```
sudo pacman -S xorg-server xf86-video-fbdev
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
sudo localectl --no-convert set-x11-keymap fr #Configure Keyboard layout for x11
```

## Reboot and log into Gnome

```
sudo reboot
```

## Install the yay AUR Helper

```
sudo pacman -S git
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Enable multilib repo in pacman.conf

```
sudo vim /etc/pacman.conf
```
> [multilib]  
> Include = /etc/pacman.d/mirrorlist  
  
```
sudo pacman -Syy
```

## Install bluetooth support

```
sudo pacman -S bluez bluez-utils pulseaudio-bluetooth
sudo systemctl enable --now bluetooth
```

## Mount secondary disk in fstab

```
sudo blkid #Show and copy the UUID of my secondary disk
sudo vim /etc/fstab
```
> #Data  
> UUID=107b1979-e8ed-466d-bb10-15e72f7dd2ae       /run/media/rcandau/data         ext4          defaults 0 2  

## Install packages

- Main packages:
```
sudo pacman -S discord distrobox docker firefox glow hexchat htop hugo keepassxc mlocate neofetch ntfs-3g steam thunderbird tmux virt-viewer vlc zathura zathura-pdf-poppler #Main packages from Arch repos
yay -S arch-update gnome-browser-connector gnome-terminal-transparency onlyoffice-bin pa-applet-git protonmail-bridge-bin spotify systray-x-git timeshift ventoy-bin zaman #Main packages from the AUR
sudo pacman -S --asdeps gnome-keyring gnu-free-fonts rofi ttf-dejavu xclip xdg-utils #Optional dependencies that I need for the above packages
systemctl --user enable --now arch-update.timer #Start and enable associated timers
sudo systemctl enable --now docker cronie #Start and enable associated services
```

- Laptop only packages:
```
sudo pacman -S openresolv wireguard-tools power-profiles-daemon
yay -S touchegg
sudo systemctl enable --now touchegg
```

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
- Dash to panel
- Native window placement
- Tray Icons: Reloaded
- User themes
- Workspace indicator
- X11 Gestures **Only for laptop, enables trackpad gesture on Gnome 40+, requires touchégg (AUR) started and enable**

## Dock

- firefox
- terminal
- spotify
- thunderbird
- nautilus
- gedit 
- onlyoffice
- keepass
- steam
- discord
- hexchat
- virtualbox
- screenshot
- extensions
- gnome tweaks
- settings

## Gnome Terminal Settings

- Preferences --> Dark Theme  
- Profile --> Colors ---> Gnome Dark --> Solarized  
- Transparent Background ---> Cursor between the two color squares above  

## Make bluetooth autoconnect to trusted devices

```
sudo vi /etc/pulse/default.pa
```
> [...]  
> #Automatically switch to newly-connected devices  
> load-module module-switch-on-connect  

## Dotfiles

```
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/bashrc_Arch.txt -o ~/.bashrc
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/tmux.conf -o ~/.tmux.conf
mkdir -p ~/.config/zathura/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/zathurarc -o ~/.config/zathura/zathurarc && xdg-mime default org.pwmt.zathura.desktop application/pdf
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
mkdir -p ~/.config/rofi/ && curl https://raw.githubusercontent.com/newmanls/rofi-themes-collection/master/themes/spotlight-dark.rasi -o ~/.config/rofi/spotlight-dark.rasi && sed -i s/border-radius:\ \ 8/border-radius:\ \ 0/ ~/.config/rofi/spotlight-dark.rasi && sed -i "/\bplaceholder\b/d" ~/.config/rofi/spotlight-dark.rasi && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/rofi-config -o ~/.config/rofi/config.rasi
sudo mkdir -p /usr/local/lib/systemd/user/ && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/mpris-proxy.service -o /usr/local/lib/systemd/user/mpris-proxy.service && systemctl --user daemon-reload && systemctl --user enable --now mpris-proxy.service
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
