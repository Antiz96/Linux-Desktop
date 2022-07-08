# Issues and fix

A list of issues I encountered during my Arch-Linux journey and how to fix them

## Bluetooth USB Dongle (asus BT500) not working correctly

https://www.reddit.com/r/linuxquestions/comments/hy5mx2/bluetooth_adapter_asus_usbbt500_not_working_or/  

```
sudo vi /etc/modprobe.d/bluetooth-blacklist.conf
```

> blacklist btrtl  
> blacklist btusb  
> blacklist btintel  
> blacklist btbcm  

Then install bluetooth USB Dongle Driver (and potentially reboot)

## Microphone not working/not detected on standalone window manager

https://bbs.archlinux.org/viewtopic.php?pid=1921917#p1921917/  

As I'm using a standalone window manager (IceWM), I do not have a graphical setting panel to switch between my sound cards profiles (in order to make my microphone to work for instance).  
This means that I have to do it manually with the pulseaudio "pacmd" command.  
*This is just a quick reminder for me.*

### Enable microphone on my bluetooth headset

List available sound cards to find my bluetooth sound card (this command also shows the active profile and the available other profiles for each sound card) :    

```
pacmd list-cards
```

> [...]   
> > name: <bluez_card.38_18_4C_E9_85_B4>  
> > driver: <module-bluez5-device.c>  
> > owner module: 26  
> > properties:  
> > > device.description = "WH-1000XM3"  

Switch between profiles (**a2dp_sink = only sound | handsfree_head_unit = both sound and microphone**) :  

```
pacmd set-card-profile bluez_card.38_18_4C_E9_85_B4 a2dp_sink
pacmd set-card-profile bluez_card.38_18_4C_E9_85_B4 handsfree_head_unit

```

### Enable microphone on my Logitech sound card

List available sound cards to find my Logitech sound card (this command also shows the active profile and the available other profiles for each sound card) :  

```
pacmd list-cards
```
> [...]  
> > name: <alsa_card.usb-Logitech_Logitech_G430_Gaming_Headset-00>  
> > driver: <module-alsa-card.c>  
> > owner module: 7  
> > properties:  
> > > alsa.card_name = "Logitech G430 Gaming Headset"  

Switch between profiles (**output:iec958-ac3-surround-51 = only sound | output:iec958-ac3-surround-51+input:mono-fallback = both sound and microphone**) :  

```
pacmd set-card-profile alsa_card.usb-Logitech_Logitech_G430_Gaming_Headset-00 output:iec958-ac3-surround-51 
pacmd set-card-profile alsa_card.usb-Logitech_Logitech_G430_Gaming_Headset-00 output:iec958-ac3-surround-51+input:mono-fallback
```

## LightDM not starting correctly at boot (black screen or only displays TTY output)

https://wiki.archlinux.org/title/LightDM#LightDM_does_not_appear_or_monitor_only_displays_TTY_output  

```
sudo vi /etc/lightdm/lightdm.conf #[LightDM] section
```
> [...]  
> logind-check-graphical=true  

## GDM not starting correctly at boot (black screen with blinking white cursor)

https://wiki.archlinux.org/index.php/GDM#GDM_shows_black_screen_with_blinking_white_cursor

```
sudo vi /usr/lib/systemd/system/gdm.service
```
> [...]  
> [Service]  
> ExecStartPre=/bin/sleep 2  


## Steam font problem

https://steamcommunity.com/app/221410/discussions/0/864961175388383181/  

```
cd ~/.fonts/ #(create the folder if it doesn't exists)
curl https://support.steampowered.com/downloads/1974-YFKL-4947/SteamFonts.zip -o SteamFonts.zip
unzip SteamFonts.zip && rm SteamFonts.zip 
```

## Gnome terminal font problem

Preferences ---> Profil ---> Colors ---> Uncheck "Use the system theme colors"


## Lutris wine doesn't work correctly on 32bits games

```
sudo pacman -S wine
sudo pacman -S lib32-lcms2
```

## Bluetooth not working anymore after Kernel update (happens only when using USB Bluetooth Dongle)

https://bbs.archlinux.org/viewtopic.php?id=265071  

```
sudo modprobe btusb
sudo systemctl restart bluetooth
install_bluetooth_driver #Reinstalling my bluetooth driver (this is a personal alias that calls a script I wrote to install/reinstall my bluetooth driver. Link to the script : https://github.com/Antiz96/Bash-Scripts/blob/main/install_bluetooth_driver.sh)
```

## Installing spotify via AUR gets a "GPG Key not found" error

**Permanently fixed, this error doesn't exist anymore.**

```
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -
```