# Virtual Box Tips


## Video memory

You can actually go up to 256MB video memory from the sum up of your VM compared to only 128MB in the actual settings of the VM.  

## Copy-Paste/Drag-n-drop

### Install the VBox utilities

- Arch :  

```
sudo pacman -S virtualbox-guest-utils
```

- Debian/Ubuntu :  

```  
sudo apt install virtualbox-guest-utils
```

- Fedora/RHEL :  

```
sudo dnf install virtualbox-guest-utils
```

Then, enable "Bidirectionnal copy-paste/drag-n-drop" in the peripherals settings of Virtual Box.  

### Autolaunch at boot for IceWM (and standalone Window Manager in general)

```
vim ~/.icewm/startup
```

> [...]  
> #VirtualBox Copy-Paste/Drag-n-Drop  
> /usr/bin/VBoxClient --clipboard &  
> /usr/bin/VBoxClient --seamless &  
> /usr/bin/VBoxClient --draganddrop &  


## Install the VBox Guest Additions (for auto scale screen resolution)

### Insert the addons CD

- Peripherals --> insert the addons CD

### Execute the run script

```
sudo /path/to/the/script/VBoxLinuxAdditions.run #(you can actually drag & drop it from a file manager to the terminal)
```

### Reboot to apply

```
reboot
```
