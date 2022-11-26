# XFCE

## Install Xorg and graphical drivers (optional)

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

## Install XFCE (minimal installation) 

Minimal installation according to my personal preferences.  
Check https://archlinux.org/groups/x86_64/xfce4/ & https://archlinux.org/groups/x86_64/xfce4-goodies/ to see what you want to install or not.  
If you want a complete XFCE installation, just install the "xfce4" and the "xfce4-goodies" packages (additionnaly you may need a display manager).  

```
sudo pacman -S xfce4 mousepad ristretto thunar-archive-plugin xfce4-notifyd xfce4-screenshooter xfce4-screensaver xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin numlockx plank gvfs gnome-calculator network-manager-applet blueman redshift file-roller picom xdg-user-dirs-gtk pulseaudio openssh lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm
```

## Reboot and log into XFCE

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

## Application
- arch-update (AUR) --> https://github.com/Antiz96/arch-update `systemctl --user enable --now arch-update.timer`
- discord
- docker --> `sudo systemctl enable --now docker`
- distrobox (AUR)
- glow
- gnome-keyring
- gparted
- hexchat
- keepassxc
- vlc
- onlyoffice-bin (AUR)
- openresolv **Only for my Laptop in order to connect to my VPN**
- firefox
- mailspring (AUR)
- pacman-contrib
- protonmail-bridge (AUR)
- spotify (AUR)
- steam
- virtualbox
- virt-viewer
- imagewriter (AUR)
- timeshift (AUR) --> `sudo systemctl enable --now cronie`
- mkinitcpio-numlock (AUR) **Then add the "numlock" hook in /etc/mkinitcpio.conf between "autodetect" and "modconf" and then** `sudo mkinitcpio -p linux`
- lightdm-webkit2-theme-glorious (AUR) --> https://github.com/manilarome/lightdm-webkit2-theme-glorious & https://github.com/manilarome/lightdm-webkit2-theme-glorious/issues/33
- mugshot (AUR)
- tmux
- dmenu
- zathura
- zathura-pdf-poppler
- mlocate
- htop
- neofetch
- wireguard-tools **Only for my Laptop in order to connect to my VPN**
- zaman (AUR) --> https://github.com/Antiz96/zaman

## Theme

- Applications: Kimi-Dark - https://www.gnome-look.org/p/1326889/
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

## Dock (plank)

- firefox
- terminal
- spotify
- mailspring
- thunar
- mousepad 
- onlyoffice
- keepass
- steam
- discord
- hexchat
- virtualbox
- screenshot
- pamac
- settings

## Disable XFCE compositor 

I use picom instead, for window animations and transparency support (see the "Autostart APP" section for the picom autolaunch"):   
  
- XFCE Settings -> "Window Manager Tweaks" -> "Compositor" -> uncheck "Enable display compositing"

## Autostart APP

- PolicyKit
- Applet Blueman
- Screensaver
- Power Management
- Picom compositor --> picom --xrender-sync-fence #(This xrender argument is needed for some people that has nvidia card: https://superuser.com/questions/1601366/picom-failed-to-trigger-fence) 
- Plank Dock --> plank
- Redshift Nightmode --> redshift-gtk -l 49.443232:1.099971
- Network
- Settings
- Snapshot detect
- PulseAudio
- xapp-sn-watcher
- Xfce Notification Daemon

## Autoconnect to bluetooth headphones

```
bluetoothctl trust 38:18:4C:E9:85:B4
sudo vi /etc/pulse/default.pa
```
> [...]  
> #Automatically switch to newly-connected devices  
> load-module module-switch-on-connect  

## Top panel configuration (See Dotfiles part)

https://github.com/Antiz96/Linux-Customisation/blob/main/Dotfiles/XFCE/xfce4-panel.xml  
  
Needs to be done manually:  
   
- Launcher Lock Screen --> `dm-tool switch-to-greeter`
- WhiskerMenu Configuration --> Apparance: Tree display mode | 80% opacity --> Dashboard Button: Icon + text and Arch Linux logo --> Behavior: All apps | Categories menu --> Commands: Modify App | Modify Profil
- Notification Greffon --> Mask the confirmation for "Delete the journal"
- Power Management Greffon --> Show the "presentation mode" indicator

## Dotfiles

```
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/bashrc_Arch.txt -o ~/.bashrc
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/tmux.conf -o ~/.tmux.conf
mkdir -p ~/.config/zathura/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/General/zathurarc -o ~/.config/zathura/zathurarc && xdg-mime default org.pwmt.zathura.desktop application/pdf
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/XFCE/terminalrc -o ~/.config/xfce4/terminal/terminalrc
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/XFCE/xfce4-panel.xml -o ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/XFCE/xfce4-keyboard-shortcuts.xml -o ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/XFCE/lightdm.conf -o /etc/lightdm/lightdm.conf
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/XFCE/lightdm-webkit2-greeter.conf -o /etc/lightdm/lightdm-webkit2-greeter.conf
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/XFCE/authenticate.js -o /usr/share/lightdm-webkit/themes/glorious/js/authenticate.js
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/XFCE/picom.conf -o /etc/xdg/picom.conf
source ~/.bashrc
```

## Keyboard Shortcuts (see Dotfiles part)

https://github.com/Antiz96/Linux-Customisation/blob/main/Dotfiles/XFCE/xfce4-keyboard-shortcuts.xml  
  
- Super + A = Open Whisker Menu --> xfce4-popup-whiskermenu
- Super + F = Switch size of windows (Maximize/Minimize)
- Super + D = Close the window
- Super + E = thunar
- Super + C = calculator --> gnome-calculator
- Super + M = Display the desktop
- Super + T = Terminal
- Super + L = Lock the screen --> dm-tool switch-to-greeter 
