#! /bin/bash
set -e

#source "$(dirname "$0")/lib/eb-debug.sh"
source "$(dirname "$0")/lib/eb-remote.sh"

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
