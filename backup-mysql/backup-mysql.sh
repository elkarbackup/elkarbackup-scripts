#! /usr/bin/env bash

#ELKARBACKUP_URL = user@serverip:/path
URL=`echo $ELKARBACKUP_URL | cut -d ":" -f1`    # user@serverip
USER="${URL%@*}"                                # user
HOST="${URL#*@}"                                # host
DIR=`echo $ELKARBACKUP_URL | cut -d ":" -f2`    # path
SSHPARAMS='-i /var/lib/elkarbackup/.ssh/id_rsa -o StrictHostKeyChecking=no'

FILE=mysqldump.sql

function ssh_exec {
    cmd="$1"
    output="$(ssh $SSHPARAMS $USER@$HOST $cmd && echo $?)"
    return $output
}

if [ "$ELKARBACKUP_EVENT" == "PRE" ]
then
    ssh_exec "mkdir -p $DIR"
    if ssh_exec "mysqldump --all-databases > $DIR/$FILE"
    then
        echo "MySQL dump created successfully: $DIR/$FILE"
        exit 0
    else
        echo "ERROR generating the MySQL dump"
        exit 1
    fi
fi

if [ "$ELKARBACKUP_EVENT" == "POST" ]
then
    if ssh_exec "rm $DIR/$FILE"
    then
        echo "MySQL dump removed: $DIR/$FILE"
        exit 0
    else
        echo "ERROR deleting MYSQL dump file: $DIR/$FILE"
        exit 1
    fi
fi
