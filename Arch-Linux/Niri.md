# Niri

## Install graphical drivers

```bash
sudo pacman -S mesa # install `nvidia` instead of `mesa` if you have an Nvidia GPU.
```

## Install Niri

Niri with a few additional packages for a base system according to my personal preferences.

```bash
sudo pacman -S niri xfce4-terminal polkit-gnome pipewire pipewire-audio pipewire-pulse thunar thunar-archive-plugin engrampa gvfs xdg-user-dirs mousepad ristretto rofi swaync nwg-look network-manager-applet nwg-panel blueman gammastep openssh swaybg swayidle swaylock playerctl wl-clipboard xdg-desktop-portal-gtk xdg-desktop-portal-wlr
```

### Auto start Niri when logging on TTY1

```bash
vim ~/.bash_profile # Append the following
```

```text
# Autostart Niri
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
        export XDG_CURRENT_DESKTOP=niri
        export XDG_SESSION_DESKTOP=niri
        export XDG_SESSION_TYPE=wayland
        export QT_QPA_PLATFORM=wayland
        export SDL_VIDEODRIVER=wayland
        exec niri-session -l
fi
```

### Download Niri config

```bash
mkdir -p ~/.config/niri && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Niri/niri-config.kdl -o ~/.config/niri/config.kdl
```

## Reboot (should start Niri automatically after logging)

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

### Disable PipeWire HSP/HFP profile

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

```bash
sudo mkdir -p /run/media/antiz/data
sudo chown antiz: /run/media/antiz/data
sudo chmod 755 /run/media/antiz/data
sudo mount -a
sudo systemctl daemon-reload
```

## Install additional packages

- Main packages:

```bash
sudo pacman -S abuild atools-go capitaine-cursors ccid discord distrobox fastfetch firefox firefoxpwa firejail htop keepassxc mpv noto-fonts-emoji orchis-theme plocate podman powerline-fonts protonmail-bridge rsync speedcrunch steam systray-x tela-circle-icon-theme-blue thunderbird tmux otf-font-awesome vim-devicons vim-nerdtree virt-viewer wireguard-tools wl-clip-persist xwayland-satellite yubico-piv-tool zathura zathura-pdf-poppler
paru -S arch-update nerdtree-git-plugin-git onlyoffice-bin oniri ventoy-bin zaman
sudo pacman -S --asdeps gnome-keyring gnu-free-fonts nvchecker python-packaging qt5-wayland systemd-resolvconf ttf-dejavu ttf-nerd-fonts-symbols xdg-utils # Optional dependencies I need for the above packages
systemctl --user enable --now arch-update.timer ssh-agent.service
sudo systemctl enable --now pcscd
```

- Laptop only packages:

```bash
sudo pacman -S nwg-displays
```

## Setup keyd (if needed)

`keyd` is a key remapping daemon I use on devices where the keyboard lacks keys I need or if they are not placed like I'm used to (which is usually the case on laptops). Here's how I remap the `sysrq` and `pause` keys (key names can be obtained via the `sudo keyd monitor` command) to act like the `home` and `end` keys respectively for instance:

```bash
sudo pacman -S keyd
sudo systemctl enable --now keyd
sudoedit /etc/keyd/default.conf
```

```text
[ids]

*

[main]

sysrq = home
pause = end
```

```bash
sudo keyd reload
```

## Bash Theme

<https://github.com/speedenator/agnoster-bash>

```bash
cd $HOME
mkdir -p .bash/themes/agnoster-bash
git clone https://github.com/speedenator/agnoster-bash.git .bash/themes/agnoster-bash
```

## Dotfiles

- Niri / Shell scripts

```bash
mkdir -p ~/Pictures/Niri && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/lock.png -o ~/Pictures/Niri/lock.png && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/shutdown.svg -o ~/Pictures/Niri/shutdown.svg && mkdir -p ~/Documents/Scripts && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/power-menu.sh -o ~/Documents/Scripts/power-menu.sh && chmod +x ~/Documents/Scripts/power-menu.sh && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Niri/swayidle.sh -o ~/Documents/Scripts/swayidle.sh && chmod +x ~/Documents/Scripts/swayidle.sh
```

- Dynamic wallpaper script and systemd units

```bash
mkdir -p ~/Pictures/wallpapers && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/island-morning.jpg -o ~/Pictures/wallpapers/island-morning.jpg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/island-day.jpg -o ~/Pictures/wallpapers/island-day.jpg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/island-evening.jpg -o ~/Pictures/wallpapers/island-evening.jpg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/island-night.jpg -o ~/Pictures/wallpapers/island-night.jpg && mkdir -p ~/Documents/Scripts && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/dynamic-wallpaper.sh -o ~/Documents/Scripts/dynamic-wallpaper.sh && chmod +x ~/Documents/Scripts/dynamic-wallpaper.sh && mkdir -p ~/.config/systemd/user && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/dynamic-wallpaper.service -o ~/.config/systemd/user/dynamic-wallpaper.service && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Wallpapers/dynamic-wallpaper.timer -o ~/.config/systemd/user/dynamic-wallpaper.timer && systemctl --user enable --now dynamic-wallpaper.timer
```

- Nwg-panel config and resources

```bash
mkdir -p ~/.config/nwg-panel && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Niri/nwg-panel-config -o ~/.config/nwg-panel/config && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Niri/nwg-panel-style.css -o ~/.config/nwg-panel/style.css && mkdir -p ~/Pictures/nwg-panel && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/Arch_Panel.svg -o ~/Pictures/nwg-panel/Arch_Panel.svg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/restart-panel.svg -o ~/Pictures/nwg-panel/restart-panel.svg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/caffeine-cup-empty.svg -o ~/Pictures/nwg-panel/caffeine-cup-empty.svg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/caffeine-cup-full.svg -o ~/Pictures/nwg-panel/caffeine-cup-full.svg && cp -f ~/Pictures/nwg-panel/caffeine-cup-empty.svg ~/Pictures/nwg-panel/autolock.svg
```

- Tmux config

```bash
mkdir -p ~/.config/tmux/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/tmux.conf -o ~/.config/tmux/tmux.conf
```

- Fastfetch config

```bash
mkdir -p ~/.config/fastfetch/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/fastfetch-config -o ~/.config/fastfetch/config.jsonc
```

- MPV config

```bash
mkdir -p ~/.config/mpv/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/mpv.conf -o ~/.config/mpv/mpv.conf
```

- Zathura config

```bash
mkdir -p ~/.config/zathura/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/zathurarc -o ~/.config/zathura/zathurarc && xdg-mime default org.pwmt.zathura.desktop application/pdf
```

- Swaync config

```bash
mkdir -p ~/.config/swaync/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Niri/swaync_style.css -o ~/.config/swaync/style.css
```

- GNUPG config

```bash
mkdir -p ~/.gnupg/ && chmod 700 ~/.gnupg && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/scdaemon.conf -o ~/.gnupg/scdaemon.conf
```

- Abuild config

```bash
sudo usermod -aG abuild "${USER}" && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/abuild.conf -o /etc/abuild.conf
```

- Vimrc

```bash
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
```

- Git config

```bash
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/gitconfig -o ~/.gitconfig && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/gitconfig-arch -o ~/.gitconfig-arch
```

- XFCE Terminal config

```bash
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/xfce4-terminal.xml -o ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
```

- Rofi config

```bash
mkdir -p ~/.config/rofi/ && curl https://raw.githubusercontent.com/newmanls/rofi-themes-collection/master/themes/spotlight-dark.rasi -o ~/.config/rofi/spotlight-dark.rasi && sed -i s/border-radius:\ \ 8/border-radius:\ \ 0/ ~/.config/rofi/spotlight-dark.rasi && sed -i "/\bplaceholder\b/d" ~/.config/rofi/spotlight-dark.rasi && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/rofi-config -o ~/.config/rofi/config.rasi
```

- Pacman mirrorlist

```bash
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/pacman-mirrorlist -o /etc/pacman.d/mirrorlist
```

- Firejail config and resources

```bash
sudo mkdir -p /etc/pacman.d/hooks && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/firejail.hook -o /etc/pacman.d/hooks/firejail.hook && mkdir -p ~/.config/firejail && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/mpv.profile -o ~/.config/firejail/mpv.profile && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/ristretto.local -o ~/.config/firejail/ristretto.local && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/ssh.profile -o ~/.config/firejail/ssh.profile && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Firejail/zathura.local -o ~/.config/firejail/zathura.local && sudo sed -i "s/#\ browser-allow-drm\ no/browser-allow-drm\ yes/g" /etc/firejail/firejail.config && sudo sed -i "s/#\ arg-max-count\ 128/arg-max-count\ 512/g" /etc/firejail/firejail.config && sudo apparmor_parser -r /etc/apparmor.d/firejail-default
```

- System-backup script and systemd units

```bash
sudo mkdir -p /usr/local/bin && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/system-backup.sh -o /usr/local/bin/system-backup && sudo chmod +x /usr/local/bin/system-backup && sudo mkdir -p /usr/local/lib/systemd/system && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/system-backup.service -o /usr/local/lib/systemd/system/system-backup.service && sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/system-backup.timer -o /usr/local/lib/systemd/system/system-backup.timer && sudo systemctl enable --now system-backup.timer
```

- Bashrc

```bash
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Bashrc/Arch -o ~/.bashrc && source ~/.bashrc
```
