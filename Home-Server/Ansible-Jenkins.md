# Ansible & Jenkins

This is the server I use to automate long and/or repetitive tasks.  
It uses ansible playbooks to perform the various tasks and Jenkins to ochestrate them and automate their executions (if necessary).  
  
This server is a VM running on my [Proxmox instance](https://github.com/Antiz96/Linux-Configuration/blob/main/Home-Server/Proxmox.md) that has been cloned from my [Arch-Linux Server Template](https://github.com/Antiz96/Linux-Configuration/blob/main/VMs/Arch-Linux_Server_Template.md).  
  
In that sense, the base installation and configuration of the VM is not covered here (see the link above).

## Ansible

### Installation

```
pacman -S ansible
```

### Configuring the user

I use the [ansible user](https://github.com/Antiz96/Linux-Configuration/blob/main/VMs/Arch-Linux_Server_Template.md#create-and-configure-the-ansible-user) I created during the template installation.

```
rm /home/ansible/.ssh/authorized_keys #Delete the public key which is only needed for ansible client
vim /home/ansible/.ssh/config #Create the ssh config according to my ssh configuration
```
> Host \*.domain
> > User ansible
> > Port X #Replace X by the port you configured SSH with
> > IdentityFile ~/.ssh/id_rsa_ansible 
  
```
vim /home/ansible/.ssh/id_rsa_ansible
```
> Copy the ansible SSH private key here

### Creating the working directories

I create one directory for playbooks dedicated to the configuration of new machines cloned from my various templates and one directory for playbooks dedicated to the global maintenance of my servers.  
  
```
mkdir -p /opt/ansible/{template,maintenance}
chown -R ansible: /opt/ansible
```

### Playbooks

My ansible playbooks are available [here]()

## Jenkins

### Installation

```
pacman -S jenkins fontconfig #Installing jenkins and its dependencies. Installing fontconfig is necessary to make jenkins work on a Arch server (that might be Arch specific ?).
```

### Configuration

```
firewall-cmd --add-port=8090/tcp --permanent #Opening the needed port to access the jenkins web interface
firewall-cmd --reload
sed -i '/JAVA=/c\JAVA=/usr/bin/java' /etc/conf.d/jenkins #Modify the jenkin's conf to point the default and current version of java
systemctl enable --now jenkins #Start and enable the jenkins service
vim /etc/sudoers.d/jenkins #Give the jenkins user the necessary permissions to run ansible-playbooks as the "ansible" user
```
> jenkins ALL=(ansible) NOPASSWD:/usr/bin/ansible-playbook
  
You can then connect to the Jenkins web interface via `http://HOSTNAME:8090` to configure it.
  
From there, I install the suggested plugins but you can manually select the ones you want if needed.  
  
After I created my user from the initial setup, I change the jenkins security like so :  
  
- Administrate Jenkins --> Configure global security --> Matrix authorization policy based on project --> Add my user with the "Administrate" global permission.
  
That allows me to set permissions per user, either globally or directly on projects.
