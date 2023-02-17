# Singularity image with preinstalled CAPD library

Project [capd-singularity-img](https://github.com/tomasz-kapela/capd-singularity-img) 
creates Singularity images with preinstalled CAPD library. Visit project webpage for more details.

CAPD images are available from oficial Singularity image library. Visit project [https://cloud.sylabs.io/library/capdnet](https://cloud.sylabs.io/library/capdnet) for available images.  


## Run capd image

```bash
singularity shell library://capdnet/capd/capd
```

## Run capd image with slurm

```bash
user@slurmaccess:~$ srun -p cpu --cpus-per-task 40 --mem 20G --pty bash
user@huawei:~$ singularity exec library://capdnet/capd/capd bash
Singularity> 
```


## Make your own Singularity image based on capd

Prepare `myImage.def` file starting from this template

```
BootStrap: library
From: capdnet/capd/capd:latest

%files
  # files to copy: source destination 
  # /path/to/local/file  /path/in/image
  
%post 
  # Installing your favourite software e.g. gdb
  apt-get update
  apt-get install -y gdb
	
  # Your image tunning...  

```

Build your Singularity image

```bash
singularity build myImage.sif myImage.def
```

