# Ansible  
  
Those are my ansible playbooks.  
I have one directory for each purposes (see the table of contents below).  
  
Each directories have their associated playbooks at root and a sub-directory named "roles" that contains the roles launched by the playbooks themself.    
The tasks list that each roles contain are readeable in "roles/'name_of_the_role'/tasks/main.yml".  
  
All the playbook are launched and orchestrated by a [Jenkins instance](https://github.com/Antiz96/Linux-Configuration/blob/main/Home-Server/Ansible-Jenkins.md).   
All the playbooks variables' values are collected through Jenkins as well and transmitted to ansible via [extra vars](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#defining-variables-at-runtime).

* [Template - Playbooks that concern my template configuration](https://github.com/Antiz96/Linux-Configuration/tree/main/Home-Server/ansible/template)
* [Server - Playbooks that concern my VM Servers' maintenance](https://github.com/Antiz96/Linux-Configuration/tree/main/Home-Server/ansible/server)
* [Proxmox - Playbook that concern my Proxmox Servers' maintenance](https://github.com/Antiz96/Linux-Configuration/tree/main/Home-Server/ansible/proxmox)
