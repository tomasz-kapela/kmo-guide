---
layout: default
title: CAPDNET
nav_order: 3
---
# CAPDNET Cloud Documentation


## SSH

Our machines do not have open port on public network. 
Instead of that we have an internal network(s), so you need to have a special configuration of SSH or VPN. 
Only certain machines are available over the Internet as gateways.


### Linux/OSX (unix like os)

#### Configuration

Add to `~/.ssh/config` following directives (do not forget to replace `<USERNAME>` with your account name):

```Bash
# Gateway to capdnet
Host access-1
     user <USERNAME>
     hostname access-1.capdnet.ii.uj.edu.pl

# Proxy for all hosts in the capdnet
Host *.capdnet
   user <USERNAME>
   ProxyCommand ssh -q -W %h:%p access-1
   
# Shorter name and proxy for one host
Host rysy
   hostname rysy-capd-debian-8.capdnet
   user <USERNAME>
   ProxyCommand ssh -q -W %h:%p access-1
```

#### Connection

With the above configuration you are able to use `access-1` host as a gateway to our internal network. 
As an example, to open a connection type in the terminal:
```Bash
ssh repos.capdnet
ssh rysy
```
You can use any host known for you inside the capdnet network.

It is worth to note that other services based on SSH also use this configuration (scp, sftp, git, svn).

#### SSH Keys

Please use **SSH Keys!!!** protected by **pass-phase**. Without them you need to provide password twice. 

You can follow this [sample tutorial](https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication/).

To generate a key pair (private and public) (by default stored as ~/.ssh/id_rsa[.pub]) and copy it to capdnet invoke

```bash
ssh-keygen
ssh-copy-id access-1
```

To be prompted for key password only once per session add the following to ``~/.ssh/config`

```bash
Host *
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_rsa
    UseKeyChain yes
```

### Windows
Read about ProxyCommand equivalent for your SSH client.


## User directories

Each user has a home directory exported as a NFS resource. The directory is mounted 
to capdnet servers so that you can access your files everywhere.

Each user has also *local* directory on each server. 
It can be usefull if your programm uses files intensively.
You can access it using path `/mnt/users/$USER/local/`. 
You can also access local files from another server, 
e.g. to access local files from *nosal* on *truten* use `/mnt/users/$USER/local_nosal`.

## Repositories

### CAPD repositories - read-write accesss

For read-write access to CAPD repositories you need to apply our **SSH** configuration. Then you can use following URL syntax (use your `<USERNAME>`)

```Bash
svn co svn+ssh://<USERNAME>@repos.capdnet/var/svn-repos/capd
```

The same way you can access any other repository placed in

* SVN : `/var/svn-repos/*`
* GIT : `/var/git-repos/*`

### CAPD repositiories - read-only over http

Anyone can use following URL for read-only access to capdnet repositiories 

```
https://svn.capdnet.ii.uj.edu.pl/REPOSITORY_NAME
```

Please ignore security warning (we do not have confirmed SSL certificates).


### User repositories

Please put your private repositories in `~/repos/git` or `~/repos/svn` (on any server in `capdnet` except `repos.capdnet`) and access them using URL

```bash
<USERNAME>@repos.capdnet:/var/user_repos/<USERNAME>/git
<USERNAME>@repos.capdnet:/var/user_repos/<USERNAME>/svn
```

#### Changing remote repository URL

If you already have working copy on your computer you can change remote repository location by typing

```bash
git remote set-url origin <USERNAME>@repos.capdnet:/var/user_repos/<USERNAME>/git/RepositoryName
[SVN 1.7] svn relocate <USERNAME>@repos.capdnet/var/user_repos/<USERNAME>/svn/RepositoryName
[SVN 1.6] svn switch --relocate svn+ssh://old.server/and/path/RepositoryName svn+ssh://<USERNAME>@repos.capdnet/var/user_repos/<USERNAME>/svn/RepositoryName
```

To change git-svn repositories follow [link](http://stackoverflow.com/questions/5975667/how-to-switch-svn-repositories-using-git-svn)


## `public_html` - HTTP access for users

If you want to access your files via HTTP you can add them to `~/public_html` and use following URL:

```
http://users.capdnet.ii.uj.edu.pl/~<USERNAME>/
```

Your files need to be at least with read access for `others`.
