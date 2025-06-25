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

### Configuring system language

```bash
sudo vim /etc/locale.gen # Uncomment the locale (for me: en_US.UTF-8 UTF-8)
sudo locale-gen # Generate the locale
sudo vim /etc/locale.conf # Set the LANG variable accordingly in this file (for me: LANG=en_US.UTF-8)
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
sudo pacman -Syu base-devel man bash-completion openssh inetutils dnsutils traceroute rsync zip unzip diffutils git tmux plocate htop fastfetch docker distrobox pacman-contrib powerline-fonts ttf-nerd-fonts-symbols vim-devicons vim-nerdtree wl-clipboard # Install main packages from the repo
cd /tmp # Change directory to tmp to clone paru AUR sources
git clone https://aur.archlinux.org/paru.git # Clone paru AUR sources
cd paru # Change directory to the cloned sources
makepkg -si # Build and install paru
paru -S certificate-ripper-bin arch-update nerdtree-git-plugin-git # Install AUR packages
sudo systemctl enable --now docker paccache.timer # Enable systemd services
```

### Bash Theme

<https://github.com/speedenator/agnoster-bash>

```bash
cd $HOME
mkdir -p .bash/themes/agnoster-bash
git clone https://github.com/speedenator/agnoster-bash.git .bash/themes/agnoster-bash
```

### Install Nerd font on Windows

[Download](https://www.nerdfonts.com/font-downloads) and install the "Hack Nerd Font" (it's the only one that works well with `vim-devicons` on WSL from my experience). Then set it in the Windows terminal under "Settings" --> "Profiles" --> "Defaults" --> "Appearance" --> "Font face" (might need a reboot after installing the font for it to appear in there).

### Download dotfiles

```bash
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Bashrc/Arch-WSL -o ~/.bashrc
sudo curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/pacman-mirrorlist -o /etc/pacman.d/mirrorlist
mkdir -p ~/.config/tmux/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/tmux.conf -o ~/.config/tmux/tmux.conf
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
source ~/.bashrc
```

Uncomment the "copy / paste" option for WSL and comment the one for Linux in `~/.config/tmux/tmux.conf`

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
