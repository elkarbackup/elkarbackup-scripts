#! /bash/bin
set -e

#ELKARBACKUP_URL = user@serverip:/path
URL=`echo $ELKARBACKUP_URL | cut -d ":" -f1`    # user@serverip
USER="${URL%@*}"                                # user
HOST="${URL#*@}"                                # host
SSHPARAMS='-i /var/lib/elkarbackup/.ssh/id_rsa -o StrictHostKeyChecking=no'

# Run a commmand via SSH and return the exit code
function ssh_exec {
    cmd="$1"
    output="$(ssh $SSHPARAMS $USER@$HOST $cmd && echo $?)"
    return $output
}

# Run a command via SSH and return the output
function ssh_exec_output {
    cmd="$1"
    output="$(ssh $SSHPARAMS $USER@$HOST $cmd)"
    echo "$output"
}