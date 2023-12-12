# XFCE

## Install Xorg and graphical drivers (optional)

- For regular computers:

```bash
sudo pacman -S xorg-server nvidia
```

- For Raspberry Pi:

```bash
sudo pacman -S xorg-server xf86-video-fbdev
sudoedit /boot/config.txt
```

> [...]  
> gpu_mem=256 #Increasing the reserved memory for the GPU

## Install XFCE (minimal installation)

Minimal installation according to my personal preferences.  
Check <https://archlinux.org/groups/x86_64/xfce4/> & <https://archlinux.org/groups/x86_64/xfce4-goodies/> to see what you want to install or not.  
If you want a complete XFCE installation, just install the "xfce4" and the "xfce4-goodies" packages (additionally you may need a display manager).

```bash
sudo pacman -S xfce4 mousepad ristretto thunar-archive-plugin xfce4-notifyd xfce4-screenshooter xfce4-screensaver xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin numlockx plank gvfs speedcrunch network-manager-applet blueman redshift engrampa picom xdg-user-dirs-gtk pulseaudio openssh lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm
sudo localectl --no-convert set-x11-keymap fr #Configure Keyboard layout for x11
```

## Reboot and log into XFCE

```bash
sudo reboot
```

## Install the paru AUR Helper

```bash
sudo pacman -S git
cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

## Enable multilib repo in pacman.conf

```bash
sudo vim /etc/pacman.conf
```

> [multilib]  
> Include = /etc/pacman.d/mirrorlist

```bash
sudo pacman -Syy
```

## Install bluetooth support

```bash
sudo pacman -S bluez bluez-utils pulseaudio-bluetooth
sudo systemctl enable --now bluetooth
```

## Mount secondary disk in fstab

```bash
sudo blkid #Show and copy the UUID of my secondary disk
sudo vim /etc/fstab
```

> #Data  
> UUID=107b1979-e8ed-466d-bb10-15e72f7dd2ae       /run/media/antiz/data         ext4          defaults 0 2

## Install packages

- Main packages:

```bash
sudo pacman -S ccid discord distrobox docker fastfetch firefox glow hexchat htop keepassxc mlocate mpv noto-fonts-emoji ntfs-3g powerline-fonts steam systray-x thunderbird timeshift tmux ttf-font-awesome virt-viewer xclip xorg-xhost zathura zathura-pdf-poppler #Main packages from Arch repos
paru -S arch-update lightdm-webkit2-theme-glorious mugshot onlyoffice-bin pa-applet-git protonmail-bridge-bin ventoy-bin yubico-piv-tool ykcs11-p11-kit-module zaman #Main packages from the AUR
sudo pacman -S --asdeps gnome-keyring gnu-free-fonts rofi ttf-dejavu xdg-utils #Optional dependencies that I need for the above packages
systemctl --user enable --now arch-update.timer ssh-agent.service #Start and enable timers and services
sudo systemctl enable --now docker cronie pcscd #Start and enable services
```

- Laptop only packages:

```bash
sudo pacman -S openresolv wireguard-tools tlp
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket && sudo systemctl enable --now tlp.service
```

## Theme

- Applications: Kimi-Dark - <https://www.gnome-look.org/p/1326889/>
- Icon: Tela-Circle-Blue - <https://www.gnome-look.org/p/1359276/>
- Shell: Orchis-dark-compact - <https://www.gnome-look.org/p/1357889/>
- Cursor: McMojave cursors - <https://www.opendesktop.org/s/Gnome/p/1355701/>

## Bash Theme

<https://github.com/speedenator/agnoster-bash>

```bash
cd $HOME
mkdir -p .bash/themes/agnoster-bash
git clone https://github.com/speedenator/agnoster-bash.git .bash/themes/agnoster-bash
```

## Dock (plank)

- firefox
- terminal
- thunderbird
- thunar
- mousepad
- onlyoffice
- keepass
- steam
- discord
- hexchat
- virtualbox
- screenshot
- settings

## Disable XFCE compositor

I use picom instead, for window animations and transparency support (see the "Autostart APP" section for the picom autolaunch"):

- XFCE Settings -> "Window Manager Tweaks" -> "Compositor" -> uncheck "Enable display compositing"

## Autostart APP

- PolicyKit
- Applet Blueman
- Screensaver
- Power Management
- Picom compositor --> picom --xrender-sync-fence #(This xrender argument is needed for some people that has nvidia card: <https://superuser.com/questions/1601366/picom-failed-to-trigger-fence>)
- Plank Dock --> plank
- Redshift Nightmode --> redshift-gtk -l 49.443232:1.099971
- Network
- Settings
- Snapshot detect
- PulseAudio
- xapp-sn-watcher
- Xfce Notification Daemon

## Top panel configuration

Needs to be done manually:

- Launcher Lock Screen --> `dm-tool switch-to-greeter`
- WhiskerMenu Configuration --> Appearance: Tree display mode --> 80% opacity --> Dashboard Button: Icon + text and Arch Linux logo --> Behavior: All apps --> Categories menu --> Commands: Modify App --> Modify Profil
- Notification Greffon --> Mask the confirmation for "Delete the journal"
- Power Management Greffon --> Show the "presentation mode" indicator

## Make bluetooth autoconnect to trusted devices

```bash
sudo vi /etc/pulse/default.pa
```

> [...]  
> #Automatically switch to newly-connected devices  
> load-module module-switch-on-connect

## Dotfiles

```bash
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Bashrc/Arch -o ~/.bashrc
mkdir -p ~/.config/tmux/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/tmux.conf -o ~/.config/tmux/tmux.conf
mkdir -p ~/.config/zathura/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/zathurarc -o ~/.config/zathura/zathurarc && xdg-mime default org.pwmt.zathura.desktop application/pdf
mkdir -p ~/.gnupg/ && chmod 700 ~/.gnupg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/scdaemon.conf -o ~/.gnupg/scdaemon.conf
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/picom.conf -o /etc/xdg/picom.conf
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/xfce4-terminalrc -o ~/.config/xfce4/terminal/terminalrc
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/XFCE/xfce4-panel.xml -o ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/XFCE/xfce4-keyboard-shortcuts.xml -o ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/XFCE/lightdm.conf -o /etc/lightdm/lightdm.conf
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/XFCE/lightdm-webkit2-greeter.conf -o /etc/lightdm/lightdm-webkit2-greeter.conf
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/XFCE/authenticate.js -o /usr/share/lightdm-webkit/themes/glorious/js/authenticate.js
mkdir -p ~/.config/rofi/ && curl https://raw.githubusercontent.com/newmanls/rofi-themes-collection/master/themes/spotlight-dark.rasi -o ~/.config/rofi/spotlight-dark.rasi && sed -i s/border-radius:\ \ 8/border-radius:\ \ 0/ ~/.config/rofi/spotlight-dark.rasi && sed -i "/\bplaceholder\b/d" ~/.config/rofi/spotlight-dark.rasi && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/rofi-config -o ~/.config/rofi/config.rasi
sudo mkdir -p /usr/local/lib/systemd/user/ && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/mpris-proxy.service -o /usr/local/lib/systemd/user/mpris-proxy.service && systemctl --user daemon-reload && systemctl --user enable --now mpris-proxy.service
source ~/.bashrc
```

## Keyboard Shortcuts

- Super + A = Open Whisker Menu --> xfce4-popup-whiskermenu
- Super + F = Switch size of windows (Maximize/Minimize)
- Super + D = Close the window
- Super + E = thunar
- Super + C = calculator --> speedcrunch
- Super + M = Display the desktop
- Super + T = Terminal
- Super + L = Lock the screen --> dm-tool switch-to-greeter
