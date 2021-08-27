# SSH-Team-Keys
Setup a single SSH account and give different levels of access to specific ssh auth keys. 

## Team Keys: SSH multi user access

 When working within a single UN*X SSH account and on single or multiple domains and or subdomains and in a growing diverse environment, brings with it the need for multiple team member to work on one project or projects together without giving too much access to the overall account to any one member.  The UNIX file system permission settings for this setup quickly become limited and lacking in security and increasing in confusion. The SSH daemon has an answer to this and its use multiple keys with scripts that can be attached to each for restrictions, limitation and granting access to system resources.


## The SSH Protocol

 Widely used to login remotely from one system into another, and its strong encryption makes it ideal to carry out tasks such as issuing remote commands and remotely managing network infrastructure and other vital system components. This is especially important in the era of cloud infrastructure and remote work. To use the SSH protocol, a couple pieces of software need to be installed. The remote systems need to have a piece of software called an SSH daemon, and the system used to issue commands and manage the remote servers needs to have a piece of software called the SSH client. 


## Unix Shell setup

*For general restricted bash shell access*
vim /etc/shells
*#add these lines*
/bin/rbash

cp /bin/bash /bin/rbash

*For optional custom ssh key file.* 

*Add an additional file for SSH to search for auth keys in. This will make it easier to managing keys and not mess with the primary key file.* 
vim /etc/ssh/sshd_config

    AuthorizedKeysFile .ssh/authorized_keys .ssh/authorized_group_keys

## Authorized keys: define who can access each system

"Keep Note The Following:"

The key method to get shell restriction working is that it uses different passwords.
Which means,if someone knows the standard account password, they can use it to gain full access.
The custom hostname refrenced in client config file is just that, this is only known to client

*Setup of base directory restriction system:*

*When limiting a key to use git versioning system functions you will need to add a directory for git function limitation .* 
* mkdir -p /home/dyount/git-shell-commands
*In this directory make soft links to programs that the user will be limited to use.* 
* ln -s /usr/bin/git  /home/dyount/git-shell-commands
* ln -s /usr/bin/git-upload-pack /home/dyount/git-shell-commands
* etc.. etc..

*If using rbash to limit shell access to a limited set of shell programs.* 

* mkdir -p /home/dyount/programs
* ln -s /usr/bin/date /home/dyount/programs
* ln -s /usr/bin/ps /home/dyount/programs
* ln -s /usr/bin/kill /home/dyount/programs
* ln -s /usr/local/bin/composer /home/dyount/programs
* ln -s /usr/local/bin/node /home/dyount/programs
* ln -s /usr/local/bin/npm /home/dyount/programs
* ln -s /usr/local/bin/npx /home/dyount/programs
* etc.. etc..

## Create SSH custom alias key for client
Generate key

    ssh-keygen -t rsa -C "factorf2@yahoo.com" -f '/home/factor/.ssh/id_rsa_test'

Copy key to server. (To add key to ssh keys,manually copy it to remote file,dont use this method. Need to make a client script.)

    ssh-copy-id -i /home/dyount/.ssh/id_rsa_test.pub dyount@69.167.171.208


*Example Unix client config file settings for ssh.* 
*This will let the client access the correct key auth according to alias host name.*
* vim /home/factor/.ssh/config
* 

    #Test Git  
    Host spotcheckit_test  
    HostName spotcheckit.org  
    User dyount  
    IdentitiesOnly yes  
    IdentityFile ~/.ssh/id_rsa_test

## Custom Server SSH Auth Key Restriction Setup

* vim /home/dyount/.ssh/authorized_group_keys

*For git:*

The below addition to front of each ssh auth key will restrict the ssh key to specific use. 
Example 1: ssh cant port forward and will only work with git directory commands. 

    restrict,command="/usr/bin/git-shell -c \"$SSH_ORIGINAL_COMMAND\"" ssh-rsa < SSH AUTH KEY > factorf2@yahoo.com

*Example client command to use git to clone a repo with custom auth key.*
NOTE: The host name is an alias name to use separate key and password while using the same ssh user.  

    git clone ssh://dyount@spotcheckit_test/home/dyount/userspace.spotcheckit.org

*For scp*

*To remove ssh access and only grants scp up and download access only.*

    command="if [[ \"$SSH_ORIGINAL_COMMAND\" =~ ^scp.? ]]; then $SSH_ORIGINAL_COMMAND ; else echo Access Denied; fi"
    Example scp command using restricted key


Example client command:

    scp dyount@spotcheckit_test:/home/dyount/userspace.spotcheckit.org/* ./
    


*For rbash*

*log in with restricted bash, the only command access outside of rbash are the softlinked programs in /home/dyount/programs/.*
*This will let you run PHP composer and nodeJS installs updates, if change to specific site root directory and add to programs dir.*

SSH Team Key command:(cd to specific dir, as restriction will not let them change directory after this.)

    command="cd /home/dyount/userspace.spotcheckit.org && export PATH=/home/dyount/programs/ && /bin/rbash"  

Example client command:

    scp dyount@spotcheckit_test
    composer -V
    Composer version 2.1.5 2021-07-23 10:35:47


SSH Team Key command:(PATH can be different if you need to separate out commands even further per key.)

    command="cd /home/dyount/nodjsapp && export PATH=/home/dyount/programs/ && /bin/rbash"  

Example client command:

    scp dyount@spotcheckit_test
    node app.js
    Server running at http://127.0.0.1:3000/


Will provide more robust examples later. Still working out and testing resitrctions and grants of each. But Team Keys with rbash will let you limit a key to a specific directory and specific commands. Would like to make the gui able to customize a key with the variables as options to managers. Need to look into ssh-agent for time out connection, if not logged out correctly. 




*TODO: Need to make a gui plugin (cPanel / WHM) to control these so managers can easily grant or limit access to team members for ssh /git / shell.
