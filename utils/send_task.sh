#!/bin/bash
HELP=<<EOH
USAGE:
  ./send_task queue script [arg1 arg2 ...]
Sends script with given parameters to slurm queue 
EOH

if [ $# -lt 2 ]; then
	echo $HELP
        exit 0
fi
if [ "$1" != "kmo" ] && [ "$1" != "cpu" ]; then
	echo "Slurm queue name has to be kmo or cpu."
	exit 1
fi	

echo "Sending task: ${@:2}"
echo "to queue: $1"

sbatch -p $1 <<EOT
#!/bin/bash

date
echo "TASK ${@:2}"
echo "------------------"

time ${@:2}

exit 0
EOT
