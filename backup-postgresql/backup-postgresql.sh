#!/bin/bash

#
# Name: backup-postgresql.sh
# Description: This script backups all your local postgresql databases in individual files
#              It will copy to Elkarbackup only the modified databases.
# Use:  JOB level -> Pre-Script
#

#ELKARBACKUP_URL = user@serverip:/path
URL=`echo $ELKARBACKUP_URL | cut -d ":" -f1`    # user@serverip
USER="${URL%@*}"                                # user
HOST="${URL#*@}"                                # host
DIR=`echo $ELKARBACKUP_URL | cut -d ":" -f2`    # path
TMP=/tmp/ebpgdump
PSQL="/usr/bin/psql"
PG_DUMP="/usr/bin/psql"
SSHPARAMS='-i /var/lib/elkarbackup/.ssh/id_rsa -o StrictHostKeyChecking=no'

TEST=`ssh $SSHPARAMS $USER@$HOST "test -f $PSQL && echo $?"`

if [ ! ${TEST} ]
then
	echo "[ERROR] PostgreSQL config file doesn't exist $PSQL"
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
	if [ ! ${TEST} ]
	then
		echo "[INFO] Backup directory $DIR doesn't exist. Creating..."
		ssh $SSHPARAMS $USER@$HOST "mkdir -p $DIR"
	fi
fi

