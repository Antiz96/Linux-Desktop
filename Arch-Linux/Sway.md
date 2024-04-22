# Sway

## Graphical drivers (optional)

Also install `nvidia` if you have an Nvidia GPU.

```bash
sudo pacman -S mesa
```

## Install sway

Sway with a few extra packages according to my personal preferences.  
Still a very minimal installation though.

- For regular computers:

```bash
sudo pacman -S sway xfce4-terminal polkit-gnome pipewire thunar thunar-archive-plugin engrampa gvfs xdg-user-dirs mousepad ristretto rofi-wayland flameshot swaync nwg-look speedcrunch network-manager-applet nwg-panel blueman gammastep openssh swaybg swayidle swaylock playerctl xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk grim
```

### Auto start Sway

```bash
vim ~/.bash_profile
```

> [...]  
> #Autostart Sway  
> ``if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then``  
> > export XDG_SESSION_DESKTOP=sway  
> > export XDG_CURRENT_DESKTOP=sway  
> > export XDG_SESSION_TYPE=wayland  
> > export QT_QPA_PLATFORM=wayland  
> > export SDL_VIDEODRIVER=wayland  
> > export MOZ_ENABLE_WAYLAND=1  
> > exec sway  
>
> fi

### Set default keymap and terminal

```bash
sudo vim /etc/sway/config
```

```text
[...]
set $term xfce4-terminal
[...]
input * {
        xkb_layout "fr"
        xkb_variant "azerty"
}
```

## Reboot and log into Sway

```bash
sudo reboot
```

## Install the paru AUR Helper

```bash
sudo pacman -S git
cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
pkgctl build
sudo pacman -U paru-!(*debug*).pkg.tar.zst
mkdir -p ~/.config/paru/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/paru.conf -o ~/.config/paru/paru.conf
```

## Enable multilib repo in pacman.conf

```bash
sudo vim /etc/pacman.conf
```

> [multilib]  
> Include = /etc/pacman.d/mirrorlist

```bash
sudo pacman -Syyu
```

## Install bluetooth support

```bash
sudo pacman -S bluez bluez-utils
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
sudo pacman -S ccid discord distrobox docker fastfetch firefox firejail htop keepassxc mlocate mpv noto-fonts-emoji ntfs-3g powerline-fonts rsync steam systray-x thunderbird tmux ttf-font-awesome virt-viewer wl-clipboard xorg-xwayland yubico-piv-tool zathura zathura-pdf-poppler #Main packages from Arch repos
paru -S arch-update firefox-pwa onlyoffice-bin protonmail-bridge-bin ventoy-bin zaman #Main packages from the AUR
sudo pacman -S --asdeps gnome-keyring gnu-free-fonts ttf-dejavu xdg-utils wofi #Optional dependencies that I need for the above packages
systemctl --user enable --now arch-update.timer ssh-agent.service #Start and enable timers and services
sudo systemctl enable --now docker pcscd #Start and enable services
```

- Laptop only packages:

```bash
sudo pacman -S kanshi openresolv wireguard-tools tlp
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket && sudo systemctl enable --now tlp.service
```

## Theme

- Shell: Orchis-dark-compact - <https://www.gnome-look.org/p/1357889/>
- Icon: Tela-Circle-Blue - <https://www.gnome-look.org/p/1359276/>
- Cursor: McMojave cursors - <https://www.opendesktop.org/s/Gnome/p/1355701/>

## Bash Theme

<https://github.com/speedenator/agnoster-bash>

```bash
cd $HOME
mkdir -p .bash/themes/agnoster-bash
git clone https://github.com/speedenator/agnoster-bash.git .bash/themes/agnoster-bash
```

## Dotfiles

```bash
mkdir -p ~/.config/sway && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Sway/sway-config -o ~/.config/sway/config && mkdir -p ~/Pictures/Sway && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/lock.png -o ~/Pictures/Sway/lock.png && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/shutdown.svg -o ~/Pictures/Sway/shutdown.svg && mkdir -p ~/Documents/Scripts && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/power-menu.sh -o ~/Documents/Scripts/power-menu.sh && chmod +x ~/Documents/Scripts/power-menu.sh
mkdir -p ~/Pictures/wallpapers && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/island-morning.jpg -o ~/Pictures/wallpapers/island-morning.jpg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/island-day.jpg -o ~/Pictures/wallpapers/island-day.jpg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/island-evening.jpg -o ~/Pictures/wallpapers/island-evening.jpg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/island-night.jpg -o ~/Pictures/wallpapers/island-night.jpg && mkdir -p ~/Documents/Scripts && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/dynamic-wallpaper.sh -o ~/Documents/Scripts/dynamic-wallpaper.sh && chmod +x ~/Documents/Scripts/dynamic-wallpaper.sh && mkdir -p ~/.config/systemd/user && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/dynamic-wallpaper.service -o ~/.config/systemd/user/dynamic-wallpaper.service && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/dynamic-wallpaper.timer -o ~/.config/systemd/user/dynamic-wallpaper.timer && systemctl --user enable --now dynamic-wallpaper.timer
mkdir -p ~/.config/nwg-panel && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Sway/nwg-panel-config -o ~/.config/nwg-panel/config && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Sway/nwg-panel-style.css -o ~/.config/nwg-panel/style.css && mkdir -p ~/Pictures/nwg-panel && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/Arch_Panel.svg -o ~/Pictures/nwg-panel/Arch_Panel.svg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/caffeine-cup-empty.svg -o ~/Pictures/nwg-panel/caffeine-cup-empty.svg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/caffeine-cup-full.svg -o ~/Pictures/nwg-panel/caffeine-cup-full.svg && cp -f ~/Pictures/nwg-panel/caffeine-cup-empty.svg ~/Pictures/nwg-panel/autolock.svg
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Bashrc/Arch -o ~/.bashrc
mkdir -p ~/.config/tmux/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/tmux.conf -o ~/.config/tmux/tmux.conf
mkdir -p ~/.config/mpv/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/mpv.conf -o ~/.config/mpv/mpv.conf
mkdir -p ~/.config/zathura/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/zathurarc -o ~/.config/zathura/zathurarc && xdg-mime default org.pwmt.zathura.desktop application/pdf
mkdir -p ~/.gnupg/ && chmod 700 ~/.gnupg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/scdaemon.conf -o ~/.gnupg/scdaemon.conf
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/xfce4-terminal.xml -o ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
mkdir -p ~/.config/rofi/ && curl https://raw.githubusercontent.com/newmanls/rofi-themes-collection/master/themes/spotlight-dark.rasi -o ~/.config/rofi/spotlight-dark.rasi && sed -i s/border-radius:\ \ 8/border-radius:\ \ 0/ ~/.config/rofi/spotlight-dark.rasi && sed -i "/\bplaceholder\b/d" ~/.config/rofi/spotlight-dark.rasi && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/rofi-config -o ~/.config/rofi/config.rasi
sudo mkdir -p /usr/local/lib/systemd/user/ && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/mpris-proxy.service -o /usr/local/lib/systemd/user/mpris-proxy.service && systemctl --user daemon-reload && systemctl --user enable --now mpris-proxy.service
sudo mkdir -p /etc/pacman.d/hooks && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/firejail.hook -o /etc/pacman.d/hooks/firejail.hook && mkdir -p ~/.config/firejail && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/man.local -o ~/.config/firejail/man.local && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/mpv.profile -o ~/.config/firejail/mpv.profile && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/ristretto.local -o ~/.config/firejail/ristretto.local && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/ssh.profile -o ~/.config/firejail/ssh.profile
sudo mkdir -p /usr/local/bin && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/system-backup.sh -o /usr/local/bin/system-backup && sudo chmod +x /usr/local/bin/system-backup && sudo mkdir -p /usr/local/lib/systemd/system && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/system-backup.service -o /usr/local/lib/systemd/system/system-backup.service && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/system-backup.timer -o /usr/local/lib/systemd/system/system-backup.timer && sudo systemctl enable --now system-backup.timer
source ~/.bashrc
```

## Keyboard Shortcuts

- Super + A = Open app finder/launcher
- Super + F = Toggle tabbed layout
- Super + D = Close focused window
- Super + E = Thunar
- Super + M = Mousepad
- Super + C = Calculator
- Super + T = Terminal
- Super + B = Firefox
- Super + L = Lockscreen
- Super + H = Split horizontally (default mode)
- Super + V = Split vertically
- Super + G = Switch tiling layout of opened windows (vertical/horizontal)
- Super + S = Toggle sticky window
- Super + R = Resize window
- Super + Space = Toggle floating window
- Super + Right = Switch focused window to the right one
- Super + Left = Switch focused window to the left one
- Super + Up = Switch focused window to the up one
- Super + Down = Switch focused window to the down one
- Super + Shift + Right = Move focused window to the right (when reaching the edge of the screen, makes the window move to the right screen if there's one)
- Super + Shift + Left = Move focused window to the left (when reaching the edge of the screen, makes the window move to the left screen if there's one)
- Super + Shift + Up = Move focused window up (when reaching the edge of the screen, makes the window move to the up screen if there's one)
- Super + Shift + Down = Move focused window down (when reaching the edge of the screen, makes the window move to the down screen if there's one)
- Super + Shift + F1 = Move window to workspace 1
- Super + Shift + F2 = Move window to workspace 2
- Super + Shift + F3 = Move window to workspace 3
- Super + Shift + F4 = Move window to workspace 4
- Super + Shift + F5 = Move window to workspace 5
- Super + Shift + F6 = Move window to workspace 6
- Super + F1 = Switch to workspace1
- Super + F2 = Switch to workspace2
- Super + F3 = Switch to workspace3
- Super + F4 = Switch to workspace4
- Super + F5 = Switch to workspace5
- Super + F6 = Switch to workspace6
- Super + Tab = Switch to next workspace
- Alt + Tab = Open the window switcher
- Super + Esc = Open the power menu
