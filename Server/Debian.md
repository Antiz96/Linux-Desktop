# Debian

https://www.debian.org/  
  
**If it's the very first install, remember to enable the intel virtualization technology (for Proxmox) and disable secure boot in the BIOS.** 
https://rog.asus.com/us/support/FAQ/1043786  
https://techzillo.com/how-to-disable-or-enable-secure-boot-for-asus-motherboard/ 
  
I do perform a **minimal installation**.  
I do not select anything during the installation process (no DE, no standard or additionnal packages, etc...)

## Partitioning :

**System Disk :**  

- ESP   --> 550 MB
- Swap  --> 4 GB
- /     --> 25 GB (0% reserved block) - ext4
- /data --> Left free space (0% reserved block) - ext4
  
**Secondary Disk :**

- /storage --> All free space (0% reserved block) - ext4

## Install sudo and give sudo privileges to the regular user

As root (**only for this part**) :

```
apt install sudo
usermod -aG sudo rcandau
```

## Setup a static IP Address (if not done already during the installation process)

```
sudo vi /etc/network/interfaces
```
> [...]  
> iface enp0s3 inet static  
> > address 192.168.1.2/24  
> > gateway 192.168.1.254  
> > dns-nameservers 192.168.1.1

```
sudo systemctl restart networking
```

## Update the server and install useful packages

```
sudo apt update && sudo apt full-upgrade
sudo apt install vim man bash-completion openssh-server dnsutils traceroute rsync zip unzip diffutils firewalld mlocate htop curl openssl telnet chrony parted wget postfix
```

## Secure SSH connexions

### Change the default SSH port

```
sudo vim /etc/ssh/sshd_config
```
> [...]  
> Port **"X"** *#Where "X" is the port you want to set*  
> [...]

### Disable ssh connexion for the root account

```
sudo vim /etc/ssh/sshd_config
```
> [...]  
> PermitRootLogin no  
> [...]  

### Creating a SSH key on the client, copying the public key to the server and restrict SSH connexions method to public key authentication

**On the client :**

```
ssh-keygen -t rsa -b 4096 #Choose a relevant name to remember on which server/service/entity you use this key. Also, set a strong passphrase for encryption.
ssh-copy-id -i ~/.ssh/"keyfile_name".pub "user"@"server" #Change "keyfile_name", "user" and "server" according to your environment
```
  
**On the Server :**

```
sudo vim /etc/ssh/sshd_config
```
> [...]  
> PasswordAuthentication no  
> AuthenticationMethods publickey

### Restart the SSH service to apply changes

**If you already have a firewall service running, be sure you opened the port you've set earlier for SSH before restarting the service, otherwise you won't be able to log back to your server.**  
At that point, I do not have a firewall service running, but I'll take care of that in the next step.

```
sudo systemctl restart sshd
```

Also, be aware that, from now, you'll need to specify the port and the private key to connect to ssh, like so : `ssh -p "port" -i "/path/to/privatekey" "user"@"server"`.  
However, you can create a config file in "~/.ssh" to avoid having to specify the port, the user and/or the ssh key each time :

```
vim ~/.ssh/config
```
> Host **"Host alias"**  
> > User **"Username"**  
> > Port **"SSH port"**  
> > IdentityFile **"Path to the keyfile"**  
> > Hostname **"Hostname of the server"**

## Configure and start the firewall 

```
sudo systemctl enable --now firewalld
sudo firewall-cmd --add-port=X/tcp --permanent #Open the port we've set for SSH (replace "X" by the port)
sudo firewall-cmd --remove-service="ssh" --permanent #Close the default SSH port
sudo firewall-cmd --remove-service="dhcpv6-client" --permanent #Close the dhcpv6-client port as I don't use it
sudo firewall-cmd --reload
```

## Enable Wake On Lan

https://www.asus.com/support/FAQ/1045950/  
https://wiki.debian.org/WakeOnLan

### Enable Wake On Lan in the BIOS

DEL Key at startup to go to the BIOS  
Advanced Section --> APM Configuration --> Power On By PCI-E --> Enabled

### Enable Wake On Lan in Debian (manually)

```
sudo apt install ethtool
sudo ethtool -s enp3s0 wol g
sudo ethtool enp3s0
```

### Enable Wake On Lan in Debian (persistently)

```
sudo vim /etc/network/interfaces
```
> [...]  
> auto enp3s0 
> iface enp3s0 inet manual  
> > **post-up /sbin/ethtool -s enp3s0 wol g**  
> > **post-down /sbin/ethtool -s enp3s0 wol g** 
> 
> [...]


### Using Wake On Lan

https://wiki.debian.org/WakeOnLan#Using_WOL

#### Instal wakeonlan on the client

```
yay -S wakeonlan
```

#### Get the network card's mac address of the server

```
ip a
```
> [...]  
> 2: enp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast maaster vmbr0 state UP group default qlen 1000  
> link/ether **7c:10:c9:8c:88:9d** brd ff:ff:ff:ff:ff:ff  
> [...]

#### Power on the server remotely from the client

```
wakeonlan 7c:10:c9:8c:88:9d
```

## Download my .bashrc

```
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/bashrc_Debian-Ubuntu-Server.txt -o ~/.bashrc
source ~/.bashrc
```
