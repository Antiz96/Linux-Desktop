# IceWM

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

## Install IceWM

IceWM with a few extra packages according to my personal preferences.  
Still a very minimal installation though.

- For regular computers:

```bash
sudo pacman -S icewm xfce4-terminal polkit-gnome pulseaudio picom plank thunar thunar-archive-plugin engrampa gvfs xdg-user-dirs-gtk mousepad ristretto flameshot notification-daemon speedcrunch network-manager-applet blueman redshift openssh xorg-xinit xorg-xrandr xautolock i3lock lxappearance numlockx playerctl gsimplecal
sudo localectl --no-convert set-x11-keymap fr #Configure Keyboard layout for x11
```

- For Raspberry Pi:

```bash
sudo pacman -S icewm xfce4-terminal polkit-gnome pulseaudio mousepad ristretto thunar thunar-archive-plugin engrampa gvfs notification-daemon xdg-user-dirs-gtk network-manager-applet xorg-xinit xorg-xrandr i3lock numlockx xdotool playerctl
sudo localectl --no-convert set-x11-keymap fr #Configure Keyboard layout for x11
```

### Configuring startx for IceWM

I'm not using any display manager with IceWM.  
I'm using startx instead. I configure it this way:

```bash
cp /etc/X11/xinit/xinitrc ~/.xinitrc
vim ~/.xinitrc #Delete the 5 last lines and add the following ones instead
```

> [...]  
> #Start IceWM  
> export XDG_SESSION_TYPE=X11  
> xrandr --output DP-0 --primary --mode 1920x1080 --rate 165 --output HDMI-0 --mode 1920x1080 --rate 165 --left-of DP-0  
> exec icewm-session

Modify the `xrandr` command in the above snippet according to your monitor configuration.

For me:

- Desktop: `xrandr --output DP-0 --primary --mode 1920x1080 --rate 165 --output HDMI-0 --mode 1920x1080 --rate 165 --left-of DP-0`
- Laptop: `xrandr --output eDP-1 --primary --mode 1920x1080 --rate 60`

```bash
vim ~/.bash_profile
```

> [...]  
> #Autostart IceWM  
> ``if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then``  
> > exec startx  
>
> fi

## Reboot and log into IceWM

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
sudo pacman -S ccid discord distrobox docker fastfetch firefox glow hexchat htop keepassxc mlocate noto-fonts-emoji ntfs-3g powerline-fonts rofi steam systray-x thunderbird timeshift tmux ttf-font-awesome virt-viewer vlc xclip xorg-xhost zathura zathura-pdf-poppler #Main packages from Arch repos
paru -S arch-update onlyoffice-bin pa-applet-git protonmail-bridge-bin ventoy-bin yubico-piv-tool ykcs11-p11-kit-module zaman #Main packages from the AUR
sudo pacman -S --asdeps gnome-keyring gnu-free-fonts ttf-dejavu xdg-utils #Optional dependencies that I need for the above packages
systemctl --user enable --now arch-update.timer ssh-agent.service #Start and enable timers and services
sudo systemctl enable --now docker cronie pcscd #Start and enable services
```

- Laptop only packages:

```bash
sudo pacman -S autorandr openresolv wireguard-tools tlp
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

## Configuration

**Warning: "/home/antiz" is hard-coded in the "~/.icewm/keys" file (Lock Screen Shortcut)**  
**Change it according to your username**

### IceWM configuration

- For regular computers:

```bash
mkdir -p ~/.icewm && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/IceWM/icewm.zip -O && unzip icewm.zip -d ~/.icewm/ && chmod +x ~/.icewm/startup && rm -f icewm.zip
```

- For Raspberry Pi:

```bash
mkdir -p ~/.icewm && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/IceWM/icewm-rpi.zip -O && unzip icewm-rpi.zip -d ~/.icewm/ && chmod +x ~/.icewm/startup && rm -f icewm-rpi.zip
```

## Add touchpad click and navigation (Only for laptop)

```bash
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/90-touchpad.conf -o /etc/X11/xorg.conf.d/90-touchpad.conf
```

## Dock (plank)

```bash
sudo sed -i "s/Icon=org.xfce.screenshooter/Icon=applets-screenshooter/g" /usr/share/applications/xfce4-screenshooter.desktop
```

- firefox
- terminal
- thunderbird
- thunar
- mousepad
- onlyoffice
- keepassxc
- steam
- discord
- hexchat
- virtualbox
- screenshot
- Arch Update
- Power

## Make bluetooth autoconnect to trusted devices

```bash
sudo vi /etc/pulse/default.pa
```

> [...]  
> #Automatically switch to newly-connected devices  
> load-module module-switch-on-connect

### Dotfiles

```bash
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Bashrc/Arch -o ~/.bashrc
mkdir -p ~/.config/tmux/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/tmux.conf -o ~/.config/tmux/tmux.conf
mkdir -p ~/.config/zathura/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/zathurarc -o ~/.config/zathura/zathurarc && xdg-mime default org.pwmt.zathura.desktop application/pdf
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
mkdir -p ~/.local/share/applications && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/IceWM/power.desktop -o ~/.local/share/applications/power.desktop
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/picom.conf -o /etc/xdg/picom.conf
mkdir -p ~/.config/xfce4/terminal && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/xfce4-terminalrc -o ~/.config/xfce4/terminal/terminalrc
mkdir -p ~/.config/gsimplecal/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/gsimplecal-config -o ~/.config/gsimplecal/config
mkdir -p ~/.config/rofi/ && curl https://raw.githubusercontent.com/newmanls/rofi-themes-collection/master/themes/spotlight-dark.rasi -o ~/.config/rofi/spotlight-dark.rasi && sed -i s/border-radius:\ \ 8/border-radius:\ \ 0/ ~/.config/rofi/spotlight-dark.rasi && sed -i "/\bplaceholder\b/d" ~/.config/rofi/spotlight-dark.rasi && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/rofi-config -o ~/.config/rofi/config.rasi
sudo mkdir -p /usr/local/lib/systemd/user/ && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/mpris-proxy.service -o /usr/local/lib/systemd/user/mpris-proxy.service && systemctl --user daemon-reload && systemctl --user enable --now mpris-proxy.service
source ~/.bashrc
```

## Keyboard Shortcuts

- Super = Open Application Menu
- Super + A = Open App Finder/Launcher
- Super + F = Switch size of windows (Maximize/Minimize)
- Super + D = Close the window
- Super + E = Thunar
- Super + C = Calculator
- Super + M = Display the desktop
- Super + T = Terminal
- Super + L = Lock the screen
- Super + V = Tile opened windows vertically
- Super + H = Iconify active window
- Super + Esc = Open the logout menu
- Super + F1 = Switch to workspace1
- Super + F2 = Switch to workspace2
- Super + F3 = Switch to workspace3
- Super + F4 = Switch to workspace4
- Super + TAB = Switch to next workspace
