# Ansible & Jenkins

This is the server I use to automate long and/or repetitive tasks.  
It uses ansible playbooks to perform the various tasks and Jenkins to ochestrate them and automate their executions (if necessary).  

## Ansible

### Installation

**Arch :**  

```
pacman -S ansible
```

**Debian :**  

```
apt install ansible
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

### Configuring ansible itself

```
vim /etc/ansible/ansible.cfg
```
> [defaults]  
> host_key_checking = False #Disable ssh key checking when connection to a new host   
> retry_files_enabled = True #Enable retry files in case of a failure during a playbook execution

### Playbooks

My ansible playbooks are available [here](https://github.com/Antiz96/Linux-Configuration/tree/main/Server/ansible).

## Jenkins

### Installation

**Arch :**  

```
pacman -S jenkins fontconfig #Installing jenkins and its dependencies. Installing fontconfig is necessary to make jenkins work on a Arch server (that might be Arch specific ?).
```

**Debian :**  

```
apt install jenkins
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
  
This allows me to set permissions per user, either globally or directly on projects.
