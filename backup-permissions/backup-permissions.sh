#! /bin/bash
set -e

#############################################################################
## SSH functions
#############################################################################

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

############################################################################

# Requirements
GETFACL="$(ssh_exec_output "which getfacl")"

# Settings
DIR=`echo $ELKARBACKUP_URL | cut -d ":" -f2`
ACLFILE="$DIR/permissions.facl"

# Delete host local acl file after backup job
delete_local_aclfile=true

if [ -z "$GETFACL" ]
then
    echo "Cannot find ACL utilities. You can install it with the following command: apt-get install acl"
    exit 1
fi

if [ "$ELKARBACKUP_LEVEL" == "JOB" ]
then
    if [ "$ELKARBACKUP_EVENT" == "PRE" ]
    then
        cmd="$GETFACL -R $DIR > $ACLFILE"
        r=$(ssh_exec "$cmd" && echo $?)
        
        if [ $r -ne 0 ]
        then
            echo "ERROR: Permissions backup finished with errors"
            exit 1
        fi
    elif [ "$ELKARBACKUP_EVENT" == "POST" ]
    then
        if [ "$delete_local_aclfile" = true ]
        then
            cmd="rm $ACLFILE"
            r=$(ssh_exec "$cmd" && echo $?)
            
            if [ $r -ne 0 ]
            then
                echo "ERROR: Error deleting local permissions file $ACLFILE"
                exit 1
            fi
        fi
    fi
fi
