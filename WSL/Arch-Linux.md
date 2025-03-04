# Arch Linux WSL

<https://gitlab.archlinux.org/archlinux/archlinux-wsl>  
<https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL>

## Download and installation

```PowerShell
wsl --install archlinux # From an admin PowerShell prompt
```

## Configuration

### Creating and configuring my user

```bash
passwd # Change Root password
useradd -m antiz # Create my user
passwd antiz # Change its password
usermod -aG wheel antiz # Put it in the wheel group
pacman -Syu vim sudo # Update the system and install vim & sudo
EDITOR=/usr/bin/vim visudo # Uncomment line that allows wheel group members to use sudo on any command
vim /etc/wsl.conf # Set my user as the default one
```

> [...]  
> [user]  
> default=antiz

```PowerShell
wsl --terminate archlinux # Terminate my current session to apply the default user switch (should be executed from a PowerShell prompt)
```

### Configuring pacman

```bash
sudo vim /etc/pacman.conf
```

> [...]  
> Color  
> #NoProgressBar  
> CheckSpace  
> VerbosePkgLists  
> ParallelDownloads = 10  
> [...]

### Install main packages

```bash
sudo pacman -Syu base-devel man bash-completion openssh inetutils dnsutils traceroute rsync zip unzip diffutils git tmux plocate htop fastfetch docker distrobox pacman-contrib powerline-fonts # Install main packages from the repo
cd /tmp # Change directory to tmp to clone paru AUR sources
git clone https://aur.archlinux.org/paru.git # Clone paru AUR sources 
cd paru # Change directory to the cloned sources
makepkg -si # Build and install paru
paru -S certificate-ripper-bin arch-update # Install AUR packages
sudo systemctl enable --now docker paccache.timer # Enable systemd services
```

### Bash Theme

<https://github.com/speedenator/agnoster-bash>

```bash
cd $HOME
mkdir -p .bash/themes/agnoster-bash
git clone https://github.com/speedenator/agnoster-bash.git .bash/themes/agnoster-bash
```

### Download dotfiles

```bash
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Bashrc/Arch-WSL -o ~/.bashrc
mkdir -p ~/.config/tmux/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/tmux.conf -o ~/.config/tmux/tmux.conf
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
source ~/.bashrc
```

Uncomment the "copy / paste" option for WSL and comment the one for Linux in `~/.config/tmux/tmux.conf`

### Create symlinks for WSLg

Required to run graphical applications (X11 and Wayland)

```bash
ln -svf /mnt/wslg/.X11-unix /tmp/
ln -svf /mnt/wslg/runtime-dir/wayland-0* /run/user/1000/
```

### Setup my DNS config for VPN

<https://github.com/Antiz96/Linux-Desktop/blob/main/WSL/Resolve_DNS_Using_VPN.md>

### Setup Openssh to accept rsa keys

Starting from `8.8p1-1`, openssh doesn't accept some type of ssh keys judged too old & insecured.  
To force it to accept such key types, you can either specify the type of key in your command like so : `ssh -oHostKeyAlgorithms=+ssh-rsa user@host` or add the following snippet in your ssh config file:

```bash
vim ~/.ssh/config
```

> Host *  
> >  HostKeyAlgorithms +ssh-rsa
