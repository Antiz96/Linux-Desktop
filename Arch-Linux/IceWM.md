# IceWM

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

## Install IceWM

IceWM with a few extra packages according to my personal preferences.  
Still a very minimal installation though.

- For regular computers:  

```
sudo pacman -S icewm xfce4-terminal polkit-gnome pulseaudio picom plank thunar thunar-archive-plugin file-roller gvfs xdg-user-dirs-gtk mousepad ristretto flameshot notification-daemon gnome-calculator network-manager-applet blueman redshift openssh xorg-xinit xorg-xrandr xautolock i3lock lxappearance numlockx playerctl gsimplecal
```

- For Raspberry Pi:  

```
sudo pacman -S icewm xfce4-terminal polkit-gnome pulseaudio mousepad ristretto thunar thunar-archive-plugin file-roller gvfs notification-daemon xdg-user-dirs-gtk network-manager-applet xorg-xinit xorg-xrandr i3lock numlockx xdotool playerctl
```

### Configuring startx for IceWM

I'm not using any display manager with IceWM.  
I'm using startx instead. I configure it this way:  

```
cp /etc/X11/xinit/xinitrc ~/.xinitrc
vim ~/.xinitrc #Delete the 5 last lines and add the following ones instead
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

## Reboot and log into IceWM

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

```
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
```

- arch-update (AUR) --> https://github.com/Antiz96/arch-update `systemctl --user enable --now arch-update.timer`
- ddgr
- discord
- docker --> `sudo systemctl enable --now docker`
- distrobox (AUR)
- glow
- gnome-keyring
- hexchat
- keepassxc
- vlc
- gparted
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
- pa-applet-git (AUR)
- mkinitcpio-numlock (AUR) **Then add the "numlock" hook in /etc/mkinitcpio.conf between "autodetect" and "modconf" and then** `sudo mkinitcpio -p linux`
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

- Shell: Orchis-dark-compact - https://www.gnome-look.org/p/1357889/
- Icon: Tela-Circle-Blue - https://www.gnome-look.org/p/1359276/
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

## Configuration

**Warning: "/home/rcandau" is hard-coded in the "~/.icewm/keys" file (Lock Screen Shortcut)**  
**Change it accordingly to your username**  

### IceWM configuration

- For regular computers:  

```
mkdir -p ~/.icewm && curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/IceWM/icewm.zip -O && unzip icewm.zip -d ~/.icewm/ && chmod +x ~/.icewm/startup && rm -f icewm.zip
```
**Remember to uncomment the correct "Display resolution" line in the "~/.icewm/startup" script depending on the machine (First Line = Desktop | Second Line = Laptop)**  

- For Raspberry Pi:  

```
mkdir -p ~/.icewm && curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/IceWM/icewm-rpi.zip -O && unzip icewm-rpi.zip -d ~/.icewm/ && chmod +x ~/.icewm/startup && rm -f icewm-rpi.zip
```

## Add touchpad click and navigation (Only for laptop)

```
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/General/90-touchpad.conf -o /etc/X11/xorg.conf.d/90-touchpad.conf
```

## Dock (plank)

```
sudo sed -i "s/Icon=org.xfce.screenshooter/Icon=applets-screenshooter/g" /usr/share/applications/xfce4-screenshooter.desktop
sudo sed -i "s/Icon=system-software-install/Icon=pamac/g" /usr/share/applications/org.manjaro.pamac.manager.desktop
```

- firefox
- terminal
- spotify
- mailspring
- thunar
- mousepad 
- onlyoffice 
- keepassxc
- steam
- discord
- hexchat
- virtualbox
- screenshot
- pamac
- Arch Update
- Power

## Autoconnect to bluetooth headphones

```
bluetoothctl trust 38:18:4C:E9:85:B4
sudo vi /etc/pulse/default.pa
```
> [...]  
> #Automatically switch to newly-connected devices  
> load-module module-switch-on-connect  

### Dotfiles

```
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/bashrc_Arch.txt -o ~/.bashrc
curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/General/tmux.conf -o ~/.tmux.conf
mkdir -p ~/.config/zathura/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/General/zathurarc -o ~/.config/zathura/zathurarc && xdg-mime default org.pwmt.zathura.desktop application/pdf
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
mkdir -p ~/.local/share/applications && curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/IceWM/power.desktop -o ~/.local/share/applications/power.desktop
mkdir -p ~/.config/xfce4/terminal && curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/IceWM/terminalrc -o ~/.config/xfce4/terminal/terminalrc
mkdir -p ~/.config/gsimplecal/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Customisation/main/Dotfiles/IceWM/config -o ~/.config/gsimplecal/config
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/IceWM/picom.conf -o /etc/xdg/picom.conf
source ~/.bashrc
```

## Keyboard Shortcuts

- Super = Open Application Menu
- Super + A = Open Dmenu App Finder/Launcher
- Super + F = Switch size of windows (Maximize/Minimize)
- Super + D = Close the window
- Super + E = Thunar
- Super + C = Calculator
- Super + M = Display the desktop
- Super + T = Terminal
- Super + L = Lock the screen
- Super + V = Tile opened windows vertically
- Super + H = Iconifie active window
- Super + Esc = Open the logout menu
- Super + F1 = Switch to workspace1
- Super + F2 = Switch to workspace2
- Super + F3 = Switch to workspace3
- Super + F4 = Switch to workspace4
- Super + TAB = Switch to next workspace
