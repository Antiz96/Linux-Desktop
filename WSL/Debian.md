# Debian WSL

<https://wiki.debian.org/InstallingDebianOn/Microsoft/Windows/SubsystemForLinux>

## Download and installation

```PowerShell
wsl --install Debian # From an admin PowerShell prompt
```

## Configuration

### Update the system

```bash
sudo apt update && sudo apt full-upgrade
```

### Enable systemd support

```bash
sudo vim /etc/wsl.conf
```

> [boot]  
> systemd=true

```PowerShell
wsl --terminate Debian # Terminate my current session to apply the default user switch (should be executed from a PowerShell prompt)
```

### Install main packages

```bash
sudo apt install vim curl man bash-completion openssh-server socat dnsutils traceroute rsync zip unzip diffutils git tmux plocate htop fastfetch distrobox wl-clipboard podman
```

### Mount root directory with rshared propagation

This is required to run docker / podman containers in WSL:

```bash
sudo vim /etc/systemd/system/mount-root-rshared.service
```

```text
[Unit]
Description=Remount / with shared propagation
Requires=-.mount
After=-.mount

[Service]
Type=oneshot
ExecStart=/bin/mount --make-rshared /

[Install]
WantedBy=local-fs.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now mount-root-rshared.service
```

### Bash Theme

<https://github.com/speedenator/agnoster-bash>

```bash
cd /tmp
git clone https://github.com/powerline/fonts.git fonts
cd fonts
sh install.sh
cd $HOME
mkdir -p .bash/themes/agnoster-bash
git clone https://github.com/speedenator/agnoster-bash.git .bash/themes/agnoster-bash
```

### Install Nerd font on Windows

[Download](https://www.nerdfonts.com/font-downloads) and install the "Hack Nerd Font" (it's the only one that works well with `vim-devicons` on WSL from my experience). Then set it in the Windows terminal under "Settings" --> "Profiles" --> "Defaults" --> "Appearance" --> "Font face" (might need a reboot after installing the font for it to appear in there).

### Download dotfiles

```bash
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Bashrc/Debian-Ubuntu-WSL -o ~/.bashrc
mkdir -p ~/.config/tmux/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/tmux.conf -o ~/.config/tmux/tmux.conf
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
source ~/.bashrc
```

Uncomment the copy/paste option for WSL and comment the one for Linux in ~/.config/tmux/tmux.conf

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
