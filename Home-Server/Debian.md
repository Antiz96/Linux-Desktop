# Debian

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

- /storage --> All free space (0% reserver block) - ext4


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
sudo apt install vim man bash-completion openssh-server mlocate htop curl telnet firewalld chrony neofetch
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
ssh-keygen -t rsa -b 4096 #Choose a relevant name to remember on which server you use this key. Also, set a strong passphrase for encryption.
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

Also, be aware that from now you'll need to specify the port and the private key to connect to ssh, like so : `ssh -p "port" -i "/path/to/privatekey" "user"@"server"`.  
Be aware that you can create a config file in "~/.ssh" to avoid having to specify the port, the user and/or the ssh key each time :

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
sudo firewall-cmd --reload
```

## Download my .bashrc

```
curl https://raw.githubusercontent.com/Antiz96/Linux-Configuration/main/Dotfiles/General/bashrc%20\(Debian-Ubuntu%20Based%20Distro%20SERVER%20-%20WSL\) -o ~/.bashrc
vim ~/.bashrc #(delete all tmux part and flatpak in the fullupgrade alias)
source ~/.bashrc
```
