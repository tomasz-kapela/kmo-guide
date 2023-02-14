---
layout: default
title: Slurm
navorder: 5
---

# Slurm - workload menager

SLURM is a system for queuing tasks on distributed clusters and allocating resources. 
Each user can ask for any amount of resources (estimated operating time, number of processors, 
number of GPUs (we probably do not have dedicated ones), the amount of RAM and the amount of temporary memory (on the disk)

## Access

```bash
ssh <USER>@slurm.matinf.uj.edu.pl
```

* Use your faculty account username and password.
* It is not possible to log in directly from outside of the faculty network 
  (you must first connect to other computer in the Faculty network e.g. `staff.matinf.uj.edu.pl`).

### Access from the outside  

1. Connect first to one of the gateways e.g. `staff.matinf.uj.edu.pl`, `elf.ii.uj.edu.pl`
2. Set up VPN connection. See [VPN instruction](https://intra.matinf.uj.edu.pl/intra,23). 
3. **RECOMENDED** Set up [ssh proxy using capdnet](capdnet-docs.md) and connect password-less with ssh keys. 
   Under linux add the following lines to `~/.ssh/config` file

   ```bash
   Host access-1 
     user <capdnetUserName> 
     hostname access-1.capdnet.ii.uj.edu.pl
     
   Host slurm 
     hostname slurm.matinf.uj.edu.pl 
     user <facultyUserName> 
     ProxyCommand ssh -q -W %h:%p access-1
  ```
 
 
