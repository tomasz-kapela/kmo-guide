---
layout: default
title: SLURM @ WMiI
nav_order: 5
---

# Slurm - workload manager at WMiI

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
3. **RECOMENDED** Set up ssh proxy using one of the gateways and connect password-less with ssh keys ([more info](capdnet-docs.md)). 
   Under linux add the following lines to `~/.ssh/config` file

   ```bash
   Host matinf
	   user <facultyUserName>
	   hostname staff.matinf.uj.edu.pl

   Host slurm 
     hostname slurm.matinf.uj.edu.pl 
     user <facultyUserName> 
     ProxyCommand ssh -q -W %h:%p matinf
   ```
 
## Architecture

* *node* - compute resource e.g. server
* *partition* - logical set of nodes (partitons can overlap). Partition can be seen as job queque with given parmeters: job time and memory limit, who has access to it.

| partition| node | threads| RAM |max task RAM | 
| ----  |---- | ---- | --- | --- |
| cpu | huawei | 448 | 6TB | 2TB |
| cpu | test01 | 16 | 6TB | 16GB |
| kmo | rysy-1 | 144 | 1TB| 900GB |

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

By default, [squeque](https://slurm.schedmd.com/squeue.html) 
reports the running jobs in priority order and then the pending jobs in priority order.

```bash
squeue                # displays all active tasks
squeue -u {user-name} # displays the tasks of the given user
# taks with allocated cpus and memory
squeue -o"%.7i %.9P %.8j %.8u %.2t %.12M %.6D %.6C %10m %L"
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

Currently, there are three types of qos (passed to `srun` or `sbatch` with `-q` flag):

| Name  | maximum time | other restrictions | priority|
|---- |---- |----- |----- | 
| normal | 1-00:00:00| | 10| 
| test | 0-01:00:00 | cpus:4,mem:16G |100|
| big  | 7-00:00:00 | cpus:256 | 1 |

The higher the priority value, the faster the task should get to run (i.e. the test is the fastest priority, because it has 100 and these tasks should be favored by the scheduler). However, determining the final priority of a task is not only based on priority, but on other factors, e.g. task size, availability of cores, etc.
 
## Commands to schedule a job


`srun -p {queue} job` 

* calculations in an interactive mode, 
* the output from programs is connected to our current console, 
* the input is connected to the keyboard, 
* we can kill the task by double pressing `ctrl + C` 

`sbatch -p {queue} job`

* sends a "batch" job to given queue, slurm gives us the job **ID**, and we immediately regain control over the terminal,
* *std{out,err}* are redirected to file *slurm-ID.out* in the current directory,   
* the status of the task can be read using `squeue`.

### Parameters

If we do not give other arguments, our task will probably get one physical core for calculations (usually 2 logical in our case).


| Parameter | Description|
|---- |---- |
| `-p {queue}`| *(required)* the partition (queue) |
| job    | *(required)* the job to be scheduled (usually script that starts with `#!` followed by the path to an interpreter e.g. `#!/bin/sh`|
| `--cpus-per-task {n}` |number of computational threads we request |
| `--mem {n}[G]` | the amount of RAM in megabytes (gigabytes with G postfix) |
| `--time {minutes}`  | how much time we anticipate to complete the task.  |
| `--time {hours}:{minutes}:{seconds}` | |
| `--time {days}-{hours}` | if program may not stop for some reason (infinite loops) one can set up time limit.| 
| `-q {QoS}` | a type of Quality of Service (QoS) in {normal, test, big} |

## Interactive jobs `srun`

A variation on the `srun` command is:

```bash
srun -p {queue} --pty bash
```

Which basically allows us to log in to one of the cluster machines (node) and execute commands interactively, from an active terminal. 
We can stop job with the usual exit command or `ctrl+D`.

This can be useful when: testing programs before running the sbatch task or compiling programs, or using with singularity.

```bash
slurmaccess> srun --cpus-per-task 10 -p kmo --pty bash
srun: slurm_job_submit: checking szczelir with partition kmo
rysy1> singularity shell debian.sif
Singularity> hostname
rysy1
Singularity> exit
rysy1> exit
slurmaccess>
```

## Sending job to a calculation queue

To send a file in batch mode, you need to create a script file that starts with `#!` followed by the path to an interpreter (e.g. `#!/bin/bash`, `#!/usr/bin/perl`, etc.) and then send it to the cluster

```bash
sbatch –p kmo --mem 10G --cpus-per-task 32 ./myScript.sh
```

Output from the script is redirected to a file **slurm-{jobID}.out** ( *.err for errors and *.log slurm logs)  

To tack execution of the program you can view these files eg. with `tail` command

```bash
tail -n 200 -f slurm-307.out         
#  it prints last 200 lines and then follows 
#  (i.e. outputs any appended data as the file grows) util `ctrl+C` is pressed.  
```

### Example: Bash script

File `./myScript.sh`:  sample BASH script.

```bash
#!/bin/bash
date 
hostname 
cat /proc/cpuinfo > info-about-processors.txt 
cat /proc/meminfo > info-about-ram.txt 
date
```

By executing this file you will get information about available processors and RAM.

### Example: Perl script

File `script.pl` 

```perl
#!/usr/bin/perl

print( "Hello\n");
exec(ls);
```
### Example: sbatch parameters in the script file

You can include `sbatch` parameters in the task file (./scriptWithParams.sh):

```bash
#!/bin/bash 
#SBATCH --time=12:00:00        # I expect task to finish in 12 hours 
#SBATCH --cpus-per-task=10 
#SBATCH --mem=1G 
#SBATCH –-output=my-file-name.%j.txt   # %j means job-id 
#SBATCH –-error=Very-bad-errors.%j.txt

date 
hostname 
cat /proc/cpuinfo > info-processors.txt 
cat /proc/meminfo > info-memory.txt date
```

Scheduling job is now much simplier:

```bash
sbatch –p kmo ./scriptWithParams.sh
```

At the following link you can read about various other parameters and hash variables {$VARIABLE} 
that appear when executing scripts on the cluster. 
They can be used to e.g. generate file names, etc.:

[https://www.nrel.gov/hpc/eagle-batch-jobs.html](https://www.nrel.gov/hpc/eagle-batch-jobs.html)

## Command to stop a task

```bash
scancel {job-id}
```

If you do not remember what our task number is, you can check it:

```bash
squeue –u {our-username}
```
## Sending series of tasks with different parameters

The `sbatch` accepts only name of the script (parameters has to be encoded inside script). To avoid writing separate script for each set of parameters yous can use script [send_task.sh](utils/send_task.sh)

```bash
#!/bin/bash
HELP=<<EOH
USAGE:
  ./send_task queque script [arg1 arg2 ...]
Sends script with given parameters to slurm queque 
EOH

echo "Sending task: ${@:2}"
echo "to queque: $1"

if [ $# -lt 2 ]; then
	echo $HELP
        exit 0
fi

sbatch -p $1 <<EOT
#!/bin/bash

date
echo "TASK ${@:2}"
echo "------------------"

time ${@:2}

exit 0
EOT
```
You can simply run any command with paramers e.g. `ls -la *.cpp` on slurm queque `kmo` by 

```bash
./send_task.sh queque command [arg1 arg2 ...]
./send_tash.sh kmo ls -la *.cpp
```


