#!/bin/bash

#
# Name: backup-virsh.sh
# Author: justinas@eofnet.lt
# Description: Backups virsh xml machines on target host, It will copy to Elkarbackup only the modified xml files.
# Use: JOB level -> Pre-Script
#

URL=`echo $ELKARBACKUP_URL | cut -d ":" -f1`    # user@serverip
USER="${URL%@*}"                                # user
HOST="${URL#*@}"                                # host
DIR=`echo $ELKARBACKUP_URL | cut -d ":" -f2`    # path
TMP=/tmp/ebvirshbackup

SSHPARAMS="-i /var/lib/elkarbackup/.ssh/id_rsa -o StrictHostKeyChecking=no $ELKARBACKUP_SSH_ARGS"

TEST=`ssh $SSHPARAMS $USER@$HOST "test -f /usr/bin/virsh && echo $?"`

if [ ! ${TEST} ]; then
    echo "[ERROR] virsh binary doesn't exist /usr/bin/virsh on target machine"
    exit 1
fi

if [ "$ELKARBACKUP_LEVEL" != "JOB" ]
then
    echo "Only allowed at job level" >&2
    exit 1
fi


if [ "$ELKARBACKUP_EVENT" == "PRE" ]
then
    # If backup directory doesn't exist, create it
    TEST=`ssh $SSHPARAMS $USER@$HOST "test -d $DIR && echo $?"`
    if [ ! ${TEST} ]; then
        echo "[INFO] Backup directory $DIR doesn't exist. Creating..."
        ssh $SSHPARAMS $USER@$HOST "mkdir -p $DIR"
    fi
    # If tmp directory doesn't exist, create it
    TEST=`ssh $SSHPARAMS $USER@$HOST "test -d $TMP && echo $?"`
    if [ ! ${TEST} ]; then
        echo "[INFO] TMP directory $TMP doesn't exist. Creating..."
        ssh $SSHPARAMS $USER@$HOST "mkdir -p $TMP"
    fi
    # Get all virsh instances
    instances=`ssh $SSHPARAMS $USER@$HOST "/usr/bin/virsh list --all --name"`
    RESULT=$?
       if [ $RESULT -ne 0 ]; then
           echo "ERROR: $instances"
           exit 1
       else
          for dom in $instances; do
          # Doing dump
          ssh $SSHPARAMS $USER@$HOST "/usr/bin/virsh dumpxml $dom > \"$TMP/$dom.xml\""
          # If we already have an old version...
          TEST=`ssh $SSHPARAMS $USER@$HOST "test -f $DIR/$dom.xml && echo $?"`
            if [ ${TEST} ]; then
                # Diff
                #echo "making a diff"
                TEST=`ssh $SSHPARAMS $USER@$HOST "diff -q <(cat $TMP/$dom.xml|head -n -1) <(cat $DIR/$dom.xml|head -n -1) > /dev/null && echo $?"`
                #echo "diff result: [$TEST]"
                # If Diff = false, copy tmp dump file
                if [ ! ${TEST} ]; then
                    ssh $SSHPARAMS $USER@$HOST "cp $TMP/$dom.xml $DIR/$dom.xml"
                    echo "[$dom.xml] Changes detected. New dump saved."
                else
                    echo "[$dom.xml] No changes detected. Nothing to save."
                fi
            else
                echo "[$dom.xml] First dump created!"
                ssh $SSHPARAMS $USER@$HOST "cp $TMP/$dom.xml $DIR/$dom.xml"
            fi

          done
       fi
fi


exit 0
