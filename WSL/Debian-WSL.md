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

### Install my needed packages

```
sudo apt install vim curl man bash-completion openssh-server inetutils-tools dnsutils traceroute rsync zip unzip diffutils git tmux mlocate htop neofetch ddgr
```
  
### Download my config files 
  
```
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/bashrc_Debian-Ubuntu-WSL.txt -o ~/.bashrc
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/tmux.conf -o ~/.tmux.conf
source ~/.bashrc
```

**Uncomment the copy/paste option for WSL and comment the one for Linux in ~/.tmux.conf** 

### Setup my DNS config for VPN :
  
https://github.com/Antiz96/Linux-Configuration/blob/main/WSL/Resolve_DNS_Using_VPN.md
