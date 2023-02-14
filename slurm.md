---
layout: default
title: Slurm
navorder: 5
---

# Slurm - workload menager

SLURM is a system for queuing tasks on distributed clusters and allocating resources. 
Each user can ask for any amount of resources (estimated operating time, number of processors, 
number of GPUs (we probably do not have dedicated ones), the amount of RAM and the amount of temporary memory (on the disk)

[Slurm documentation](https://slurm.schedmd.com/documentation.html)

## Access

```bash
ssh <USER>@slurm.matinf.uj.edu.pl
```

* Use your faculty account username and password.
* It is not possible to log in directly from outside of the faculty network 
  (you must first connect to other computer in the Faculty network e.g. `staff.matinf.uj.edu.pl`).

### Access from the outside of UJ

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
 
## Architecture

* *node* - compute resource e.g. server
* *partition* - logical set of nodes (partitons can overlap). Partition can be seen as job queque with given parmeters: job time and memory limit, who has access to it.

| partition| node | threads| 
| ----  |---- | ---- |
| cpu | huawei | 448 |
| cpu | test01 | 16 |
| kmo | rysy-1 | 144 |

Currently, both partitions have a single task timeout of 7 days. 
Hence, it is important that our programs save partial results from time to time, from which you can "restart" long-term calculations.

## Commands to get information 

### `sinfo` reports the state of partitions and nodes

```bash
sinfo             # basic information 
sinfo -l -N       # more info 
sinfo -o "%all"   # a lot of information in the table
```

### `squeue` reports the state of jobs 

By default, it reports the running jobs in priority order and then the pending jobs in priority order.

```bash
squeue                # displays all active tasks
squeue -u {user-name} # displays the tasks of the given user
```

### `scontrol`  displays the cluster configuration. 

```bash
scontrol show partitions        # info about partitions
scontrol show node              # show info about all nodes
scontrol show node "huawei"     # info about node huawei
```

### `sacctmgr` 

sacctmgr show qos - displays information about Quality of Serivce (types of tasks and their priority). You can limit the amount of information displayed:

```bash
sacctmgr show qos format=name,priority
````

Currently, there are three types of qos (served to srun or sbatch with -q falga):

| Name  | maximum time | other restrictions | priority|
|---- |---- |----- |----- | 
| normal | 1-00:00:00| | 10| 
| test | 0-01:00:00 | cpus:4,mem:16G |100|
| big  | 7-00:00:00 | cpus:256 | 1 |

The higher the priority value, the faster the task should get to run (i.e. the test is the fastest priority, because it has 100 and these tasks should be favored by the scheduler). However, determining the final priority of a task is not only based on priority, but on other factors, e.g. task size, availability of cores, etc.

