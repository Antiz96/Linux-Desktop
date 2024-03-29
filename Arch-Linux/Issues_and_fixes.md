# Issues and fix

A list of issues I encountered during my Arch-Linux journey and how I fixed them.

## Bluetooth USB Dongle (asus BT500) not working correctly

<https://www.reddit.com/r/linuxquestions/comments/hy5mx2/bluetooth_adapter_asus_usbbt500_not_working_or/>

```bash
sudo vi /etc/modprobe.d/bluetooth-blacklist.conf
```

> blacklist btrtl  
> blacklist btintel  
> blacklist btbcm

Then install bluetooth USB Dongle Driver (and potentially reboot)

## Touch gestures not working out of the box on bluetooth headset

```bash
sudo pacman -S bluez-utils
sudo mkdir -p /usr/local/lib/systemd/user
sudo -e /usr/local/lib/systemd/user/mpris-proxy.service
```

> [Unit]  
> Description=Forward bluetooth media controls to MPRIS  
>
> [Service]  
> Type=simple  
> ExecStart=/usr/bin/mpris-proxy  
>
> [Install]  
> WantedBy=default.target

```bash
systemctl --user daemon-reload
systemctl --user enable --now mpris-proxy
```

## Switch audio/microphone source on standalone window manager

<https://bbs.archlinux.org/viewtopic.php?pid=1921917#p1921917/>

As I'm using a standalone window manager, I do not have a graphical setting panel to switch between my sound cards profiles (in order to make my microphone to work for instance).  
This means that I have to do it manually with the pulseaudio "pacmd" command.  
*This is just a quick reminder for me.*

### Enable microphone on my bluetooth headset

List available sound cards to find my bluetooth sound card (this command also shows the active profile and the available other profiles for each sound card):

```bash
pacmd list-cards
```

```text
> [...]
> > name: <bluez_card.38_18_4C_E9_85_B4>
> > driver: <module-bluez5-device.c>
> > owner module: 26
> > properties:
> > > device.description = "WH-1000XM3"
```

Switch between profiles (**a2dp_sink = only sound and handsfree_head_unit = both sound and microphone**):

```bash
pacmd set-card-profile bluez_card.38_18_4C_E9_85_B4 a2dp_sink
pacmd set-card-profile bluez_card.38_18_4C_E9_85_B4 handsfree_head_unit
```

### Enable microphone on my Logitech sound card

List available sound cards to find my Logitech sound card (this command also shows the active profile and the available other profiles for each sound card):

```bash
pacmd list-cards
```

```text
> [...]
> > name: <alsa_card.usb-Logitech_Logitech_G430_Gaming_Headset-00>
> > driver: <module-alsa-card.c>
> > owner module: 7
> > properties:
> > > alsa.card_name = "Logitech G430 Gaming Headset"
```

Switch between profiles (**output:iec958-ac3-surround-51 = only sound and output:iec958-ac3-surround-51+input:mono-fallback = both sound and microphone**):

```bash
pacmd set-card-profile alsa_card.usb-Logitech_Logitech_G430_Gaming_Headset-00 output:iec958-ac3-surround-51
pacmd set-card-profile alsa_card.usb-Logitech_Logitech_G430_Gaming_Headset-00 output:iec958-ac3-surround-51+input:mono-fallback
```

## LightDM not starting correctly at boot (black screen or only displays TTY output)

<https://wiki.archlinux.org/title/LightDM#LightDM_does_not_appear_or_monitor_only_displays_TTY_output>

```bash
sudo vi /etc/lightdm/lightdm.conf #[LightDM] section
```

> [...]  
> logind-check-graphical=true

## GDM not starting correctly at boot (black screen with blinking white cursor)

<https://wiki.archlinux.org/index.php/GDM#GDM_shows_black_screen_with_blinking_white_cursor>

```bash
sudo vi /usr/lib/systemd/system/gdm.service
```

> [...]  
> [Service]  
> ExecStartPre=/bin/sleep 2

## Steam font problem

<https://steamcommunity.com/app/221410/discussions/0/864961175388383181/>

```bash
cd ~/.fonts/ #(create the folder if it doesn't exists)
curl https://support.steampowered.com/downloads/1974-YFKL-4947/SteamFonts.zip -o SteamFonts.zip
unzip SteamFonts.zip && rm SteamFonts.zip
```

## Gnome terminal font problem

Preferences --> Profil --> Colors --> Uncheck "Use the system theme colors"

## Lutris wine doesn't work correctly on 32bits games

```bash
sudo pacman -S wine
sudo pacman -S lib32-lcms2
```

## Using old SSH key types

Arch has the latest version of OpenSSH which disable some "old" key types.  
It makes using SSH on older machines that doesn't have that version yet impossible:

```bash
journalctl -xe
```

> févr. 09 18:10:35 pihole sshd[1185]: Unable to negotiate with 192.168.1.100 port 59724: no matching host key type found. Their offer: ssh-rsa,ssh-dss [preauth]  

In order to be able to connect to use those old SSH key types with Arch Linux, we need to authorize them:

- As a SSH server:

```bash
sudo vim /etc/ssh/sshd_config
```

> [...]  
> HostKeyAlgorithms +ssh-rsa,ssh-dss

- As a SSH client:

```bash
vi ~/.ssh/config
```

> Host *  
> >  HostKeyAlgorithms +ssh-rsa

## Yay not showing diffs correctly

Yay was showing diffs as if I was installing a package for the first time (showing my the entire PKGBUILD instead of diffs between the new and the local version).  
Issue raised here: <https://github.com/Jguer/yay/issues/1109>

Fix:

```bash
for dir in ~/.cache/yay/*; do git -C "$dir" update-ref AUR_SEEN HEAD ; done
```
