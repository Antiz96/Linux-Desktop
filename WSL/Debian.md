# Debian WSL

## Download

https://docs.microsoft.com/en-us/windows/wsl/install-manual#downloading-distributions

## Installation

Launch the AppxBundle and click "Install".  
Then follow the instruction to create a user.

## Configuration

### Update the machine

```
sudo apt update && sudo apt full-upgrade
```

### Enable systemd support

```
sudo vi /etc/wsl.conf
```

> [boot]  
> systemd=true

### Install my needed packages

```
sudo apt install vim curl man bash-completion openssh-server inetutils-tools dnsutils traceroute rsync zip unzip diffutils git tmux mlocate htop neofetch codespell
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh #Install distrobox
sudo apt remove docker docker-engine docker.io #Install Docker
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
```
  
### Download my config files 
  
```
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/Bashrc/Debian-Ubuntu-WSL -o ~/.bashrc
mkdir -p ~/.config/tmux/ && curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/tmux.conf -o ~/.config/tmux/tmux.conf
curl https://raw.githubusercontent.com/Antiz96/Linux-Desktop/main/Dotfiles/General/vimrc -o ~/.vimrc && mkdir -p ~/.vim/colors && curl https://raw.githubusercontent.com/vv9k/vim-github-dark/master/colors/ghdark.vim -o ~/.vim/colors/ghdark.vim
source ~/.bashrc
```

**Uncomment the copy/paste option for WSL and comment the one for Linux in ~/.config/tmux/tmux.conf**  

### Setup my DNS config for VPN :
  
https://github.com/Antiz96/Linux-Desktop/blob/main/WSL/Resolve_DNS_Using_VPN.md
