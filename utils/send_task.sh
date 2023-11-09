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
