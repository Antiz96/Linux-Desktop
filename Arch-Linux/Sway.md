# Sway

## Install graphical drivers

```bash
sudo pacman -S mesa # install nvidia instead of mesa if you have an Nvidia GPU.
```

## Install Sway

Sway with a few additional packages for a base system according to my personal preferences.

```bash
sudo pacman -S sway xfce4-terminal polkit-gnome pipewire pipewire-audio pipewire-pulse thunar thunar-archive-plugin engrampa gvfs xdg-user-dirs mousepad ristretto rofi-wayland flameshot swaync nwg-look network-manager-applet nwg-panel blueman gammastep openssh swaybg swayidle swaylock playerctl wl-clipboard xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk grim
```

### Auto start Sway when logging on TTY1

```bash
vim ~/.bash_profile
```

> [...]  
> #Autostart Sway  
> ``if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then``  
> > export XDG_CURRENT_DESKTOP=sway  
> > export XDG_SESSION_DESKTOP=sway  
> > export XDG_SESSION_TYPE=wayland  
> > export QT_QPA_PLATFORM=wayland  
> > export SDL_VIDEODRIVER=wayland  
> > exec sway  
>
> fi

### Set default keymap and terminal in Sway config

```bash
sudo vim /etc/sway/config
```

```text
[...]
set $term xfce4-terminal
[...]
input type:keyboard {
        xkb_layout "fr"
        xkb_variant "azerty"
        xkb_numlock "enabled"
}
```

## Reboot (should start Sway automatically after logging)

```bash
sudo reboot
```

## Install the paru AUR Helper

```bash
sudo pacman -S --asexplicit git
cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
pkgctl build
sudo pacman -U paru-!(*debug*).pkg.tar.zst
mkdir -p ~/.config/paru/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/paru.conf -o ~/.config/paru/paru.conf
```

## Enable multilib repo in pacman.conf (needed for Steam)

```bash
sudo vim /etc/pacman.conf
```

> [multilib]  
> Include = /etc/pacman.d/mirrorlist

```bash
sudo pacman -Syyu
```

## Install and setup Bluetooth support

```bash
sudo pacman -S --asexplicit bluez bluez-utils
sudo systemctl enable --now bluetooth
systemctl --user enable --now mpris-proxy.service
```

### Auto-switch sound source to connected Bluetooth device

```bash
mkdir -p ~/.config/pipewire/pipewire-pulse.conf.d/
vim ~/.config/pipewire/pipewire-pulse.conf.d/switch-on-connect.conf
```

```text
pulse.cmd = [
    { cmd = "load-module" args = "module-always-sink" flags = [ ] }
    { cmd = "load-module" args = "module-switch-on-connect" }
]
```

### Disable PipeWire HSP/HFP profile (optional)

Since wireplumber 0.5, some applications are triggering an audio profile switch for bluetooth headsets from A2DP profile to HSP/HFP profile, which results in a bad audio quality.  
Most of the time, the audio profile is switched back to A2DP automatically after a few seconds but that's not always the case.

As I don't intend to ever use the built-in microphone of my headset (since I have a separate one), I just disable the HSP/HFP profile altogether as a workaround (be aware that the HSP profile is required to make headsets' built-in microphones working):

```bash
mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
vim ~/.config/wireplumber/wireplumber.conf.d/disable-hsp-hfp-profile.conf
```

```text
wireplumber.settings = {
  bluetooth.autoswitch-to-headset-profile = false
}

monitor.bluez.properties = {
  bluez5.roles = [ a2dp_sink a2dp_source ]
}
```

See <https://gitlab.freedesktop.org/pipewire/wireplumber/-/issues/634> & <https://wiki.archlinux.org/title/Bluetooth_headset#Disable_PipeWire_HSP/HFP_profile> for more details.

## Mount secondary disk in fstab

```bash
sudo blkid # Check the UUID of my secondary disk
sudo vim /etc/fstab
```

> #Data  
> UUID=107b1979-e8ed-466d-bb10-15e72f7dd2ae       /run/media/antiz/data         ext4          defaults 0 2

## Install additional packages

- Main packages:

```bash
sudo pacman -S capitaine-cursors ccid discord distrobox docker fastfetch firefox firejail htop keepassxc mpv noto-fonts-emoji orchis-theme plocate powerline-fonts protonmail-bridge rsync speedcrunch steam systray-x tela-circle-icon-theme-blue thunderbird tmux ttf-font-awesome ttf-nerd-fonts-symbols-mono vim-auto-pairs vim-devicons vim-nerdtree virt-viewer wl-clip-persist xorg-xwayland yubico-piv-tool zathura zathura-pdf-poppler
paru -S arch-update firefox-pwa nerdtree-git-plugin-git onlyoffice-bin ventoy-bin zaman
sudo pacman -S --asdeps gnome-keyring gnu-free-fonts qt6-wayland ttf-dejavu xdg-utils wofi # Optional dependencies I need for the above packages
systemctl --user enable --now arch-update.timer ssh-agent.service
sudo systemctl enable --now apparmor docker pcscd
```

- Laptop only packages:

```bash
sudo pacman -S nwg-displays wireguard-tools tlp
sudo pacman -S --asdeps openresolv # Needed for DNS resolution with Wireguard VPN
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket && sudo systemctl enable --now tlp.service
```

## Setup AppArmor and Firejail profile

### Add the required kernel parameters to enable AppArmor as default security model on every boot

- Without disk encryption / UKI / Secure Boot:

```bash
sudo vim /boot/loader/entries/arch.conf
```

> [...]  
> options root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw **lsm=landlock,lockdown,yama,integrity,apparmor,bpf**

```bash
sudo vim /boot/loader/entries/arch-fallback.conf
```

> [...]  
> options root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw **lsm=landlock,lockdown,yama,integrity,apparmor,bpf**

- With disk encryption / UKI / Secure Boot:

```bash
sudo vim /etc/kernel/cmdline
```

> cryptdevice=UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX:root root=/dev/mapper/root rw **lsm=landlock,lockdown,yama,integrity,apparmor,bpf**

### Regenerate initramfs / UKI and reboot to apply

```bash
sudo mkinitcpio -P
reboot
```

### Load Firejail's AppArmor profile into the kernel

```bash
sudo apparmor_parser -r /etc/apparmor.d/firejail-default
```

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
mkdir -p ~/.config/nwg-panel && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Sway/nwg-panel-config -o ~/.config/nwg-panel/config && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Sway/nwg-panel-style.css -o ~/.config/nwg-panel/style.css && mkdir -p ~/Pictures/nwg-panel && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/Arch_Panel.svg -o ~/Pictures/nwg-panel/Arch_Panel.svg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/restart-panel.svg -o ~/Pictures/nwg-panel/restart-panel.svg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/caffeine-cup-empty.svg -o ~/Pictures/nwg-panel/caffeine-cup-empty.svg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/caffeine-cup-full.svg -o ~/Pictures/nwg-panel/caffeine-cup-full.svg && cp -f ~/Pictures/nwg-panel/caffeine-cup-empty.svg ~/Pictures/nwg-panel/autolock.svg
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Bashrc/Arch -o ~/.bashrc
mkdir -p ~/.config/tmux/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/tmux.conf -o ~/.config/tmux/tmux.conf
mkdir -p ~/.config/fastfetch/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/fastfetch-config -o ~/.config/fastfetch/config.jsonc
mkdir -p ~/.config/mpv/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/mpv.conf -o ~/.config/mpv/mpv.conf
mkdir -p ~/.config/zathura/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/zathurarc -o ~/.config/zathura/zathurarc && xdg-mime default org.pwmt.zathura.desktop application/pdf
mkdir -p ~/.gnupg/ && chmod 700 ~/.gnupg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/scdaemon.conf -o ~/.gnupg/scdaemon.conf
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/gitconfig -o ~/.gitconfig
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/xfce4-terminal.xml -o ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
mkdir -p ~/.config/rofi/ && curl https://raw.githubusercontent.com/newmanls/rofi-themes-collection/master/themes/spotlight-dark.rasi -o ~/.config/rofi/spotlight-dark.rasi && sed -i s/border-radius:\ \ 8/border-radius:\ \ 0/ ~/.config/rofi/spotlight-dark.rasi && sed -i "/\bplaceholder\b/d" ~/.config/rofi/spotlight-dark.rasi && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/rofi-config -o ~/.config/rofi/config.rasi
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/pacman-mirrorlist -o /etc/pacman.d/mirrorlist
sudo mkdir -p /etc/pacman.d/hooks && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/firejail.hook -o /etc/pacman.d/hooks/firejail.hook && mkdir -p ~/.config/firejail && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/man.local -o ~/.config/firejail/man.local && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/mpv.profile -o ~/.config/firejail/mpv.profile && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/ristretto.local -o ~/.config/firejail/ristretto.local && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/ssh.profile -o ~/.config/firejail/ssh.profile && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/flameshot.local -o ~/.config/firejail/flameshot.local && sudo sed -i "s/#\ browser-allow-drm\ no/browser-allow-drm\ yes/g" /etc/firejail/firejail.config
sudo mkdir -p /usr/local/bin && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/system-backup.sh -o /usr/local/bin/system-backup && sudo chmod +x /usr/local/bin/system-backup && sudo mkdir -p /usr/local/lib/systemd/system && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/system-backup.service -o /usr/local/lib/systemd/system/system-backup.service && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/system-backup.timer -o /usr/local/lib/systemd/system/system-backup.timer && sudo systemctl enable --now system-backup.timer
source ~/.bashrc
```

## Keyboard Shortcuts

- Super + A = Open app finder/launcher
- Super + F = Toggle tabbed layout
- Super + D = Close focused window
- Super + E = File Manager
- Super + M = Notepad
- Super + C = Calculator
- Super + T = Terminal
- Super + B = Web Browser
- Super + L = Lockscreen
- Super + H = Split horizontally (default mode)
- Super + V = Split vertically
- Super + G = Switch tiling layout of opened windows (vertical / horizontal)
- Super + S = Toggle sticky window
- Super + R = Resize window
- Super + F11 = Switch Window to fullscreen mode
- Super + Space = Toggle floating window
- Super + Right = Switch focused window to the right one
- Super + Left = Switch focused window to the left one
- Super + Up = Switch focused window to the up one
- Super + Down = Switch focused window to the down one
- Super + Shift + Right = Move focused window to the right (when reaching the edge of the screen, makes the window move to the right screen if there's one)
- Super + Shift + Left = Move focused window to the left (when reaching the edge of the screen, makes the window move to the left screen if there's one)
- Super + Shift + Up = Move focused window up (when reaching the edge of the screen, makes the window move to the up screen if there's one)
- Super + Shift + Down = Move focused window down (when reaching the edge of the screen, makes the window move to the down screen if there's one)
- Super + F1 = Switch to workspace 1
- Super + F2 = Switch to workspace 2
- Super + F3 = Switch to workspace 3
- Super + F4 = Switch to workspace 4
- Super + F5 = Switch to workspace 5
- Super + F6 = Switch to workspace 6
- Super + F7 = Switch to workspace 7
- Super + F8 = Switch to workspace 8
- Super + F9 = Switch to workspace 9
- Super + F10 = Switch to workspace 10
- Super + Shift + F1 = Move window to workspace 1
- Super + Shift + F2 = Move window to workspace 2
- Super + Shift + F3 = Move window to workspace 3
- Super + Shift + F4 = Move window to workspace 4
- Super + Shift + F5 = Move window to workspace 5
- Super + Shift + F6 = Move window to workspace 6
- Super + Shift + F7 = Move window to workspace 7
- Super + Shift + F8 = Move window to workspace 8
- Super + Shift + F9 = Move window to workspace 9
- Super + Shift + F10 = Move window to workspace 10
- Super + Tab = Switch to next workspace
- Alt + Tab = Open the window switcher
- Super + Esc = Open the power menu
