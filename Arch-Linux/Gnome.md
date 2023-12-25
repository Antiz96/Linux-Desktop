# Gnome

## Install Xorg and graphical drivers (optional)

*As I have a Nvidia GPU, I'm still using Xorg over Wayland.*

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

## Install Gnome (minimal installation)

Minimal installation according to my personal preferences.  
Check <https://archlinux.org/groups/x86_64/gnome/> & <https://archlinux.org/groups/x86_64/gnome-extra/> to see what you want to install or not.  
If you want a complete Gnome installation, just install the `gnome` package (and the `gnome-extra` package if you want to).

```bash
sudo pacman -S gnome-shell gnome-control-center gnome-terminal gnome-calculator gnome-screenshot gnome-menus gnome-shell-extensions gnome-tweaks nautilus gedit file-roller eog xdg-user-dirs-gtk gdm
sudo systemctl enable gdm
sudo localectl --no-convert set-x11-keymap fr #Configure Keyboard layout for x11
```

## Reboot and log into Gnome

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
sudo pacman -S ccid discord distrobox docker fastfetch firefox firejail glow hexchat htop keepassxc mlocate mpv noto-fonts-emoji ntfs-3g powerline-fonts steam systray-x thunderbird timeshift tmux ttf-font-awesome virt-viewer xclip xorg-xhost zathura zathura-pdf-poppler #Main packages from Arch repos
paru -S arch-update gnome-browser-connector gnome-terminal-transparency onlyoffice-bin pa-applet-git protonmail-bridge-bin ventoy-bin yubico-piv-tool ykcs11-p11-kit-module zaman #Main packages from the AUR
sudo pacman -S --asdeps gnome-keyring gnu-free-fonts rofi ttf-dejavu xdg-utils #Optional dependencies that I need for the above packages
systemctl --user enable --now arch-update.timer ssh-agent.service #Start and enable user timers and services
sudo systemctl enable --now docker cronie pcscd #Start and enable services
```

- Laptop only packages:

```bash
sudo pacman -S openresolv wireguard-tools power-profiles-daemon
paru -S touchegg
sudo systemctl enable --now touchegg
```

## Theme

- Applications: Kimi-Dark (V40) - <https://www.gnome-look.org/p/1326889/>
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
- Profile --> Colors --> Gnome Dark --> Solarized
- Transparent Background --> Cursor between the two color squares above

## Make bluetooth autoswitch sound source to connected device

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
