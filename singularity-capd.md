# Singularity image with preinstalled CAPD library


## Run capd image

```bash
singularity run library://capdnet/capd/capd
```

## Make your own Singularity image based on capd

Prepare `myImage.def` file starting from this template

```singularity
BootStrap: library
From: capdnet/capd/capd:latest

%file
  # files to copy 

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

