#!/bin/bash

#
# Name: backup-postgresql.sh
# Description: This script backups all your local postgresql databases in individual files
#              It will copy to Elkarbackup only the modified databases.
# Use:  JOB level -> Pre-Script
# User which runs this script should have access to psql binary without password prompt.
#

#ELKARBACKUP_URL = user@serverip:/path
URL=$(echo $ELKARBACKUP_URL | cut -d ":" -f1)    # user@serverip
USER="${URL%@*}"                                # user
HOST="${URL#*@}"                                # host
DIR=$(echo $ELKARBACKUP_URL | cut -d ":" -f2)    # path
TMP="/tmp/ebpgdump"
PSQL="/usr/bin/psql"
PG_DUMP="/usr/bin/pg_dump"
SSHPARAMS='-i /var/lib/elkarbackup/.ssh/id_rsa -o StrictHostKeyChecking=no'

TEST=$(ssh $SSHPARAMS $USER@$HOST "test -f ~/.pgpass && echo $?")

if [ ! ${TEST} ]
then
	echo "[ERROR] PostgreSQL .pgpass credentials not found"
#	exit 1
fi

PSQL_USER=$(ssh $SSHPARAMS $USER@$HOST "cat ~/.pgpass | cut -d: -f4")

TEST=$(ssh $SSHPARAMS $USER@$HOST "psql -U $PSQL_USER -h127.0.0.1 postgres -c \"\l\" | grep -o \"^ postgres\"")
if [ "$TEST" == "" ]
then
	echo "[ERROR] Connecting to the PostgreSQL with $PSQL_USER user failed."
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
	TEST=$(ssh $SSHPARAMS $USER@$HOST "test -d $DIR && echo $?")
	if [ ! ${TEST} ]
	then
		echo "[INFO] Backup directory $DIR doesn't exist. Creating..."
		ssh $SSHPARAMS $USER@$HOST "mkdir -p $DIR"
	fi

# If tmp directory doesn't exist, create it
TEST=`ssh $SSHPARAMS $USER@$HOST "test -d $TMP && echo $?"`
if [ ! ${TEST} ]; then
	echo "[INFO] TMP directory $TMP doesn't exist. Creating..."
	ssh $SSHPARAMS $USER@$HOST "mkdir -p $TMP"
fi

# Get all databases list
databases=$(ssh $SSHPARAMS $USER@$HOST "psql -U $PSQL_USER -h 127.0.0.1 postgres -c '\l' | tail -n+4|cut -d'|' -f 1|sed -e '/^ *$/d'|sed -e '$d' | sed 's/^ //g' | grep -Ev '^template[0-9]|\('")
RESULT=$?
if [ $RESULT -ne 0 ]; then
	echo "ERROR: $databases"
	exit 1
else
	# If Sucess
        for db in $databases
	do
	# Dump it!
	ssh $SSHPARAMS $USER@$HOST "$PG_DUMP --no-owner -h 127.0.0.1 -U $PSQL_USER $db > \"$TMP/$db.psql\""
	# If we already have an old version...
	TEST=`ssh $SSHPARAMS $USER@$HOST "test -f $DIR/$db.psql && echo $?"`
	if [ ${TEST} ]
	then
		# Diff
		TEST=`ssh $SSHPARAMS $USER@$HOST "diff -q <(cat $TMP/$db.psql|head -n -1) <(cat $DIR/$db.psql|head -n -1) > /dev/null && echo $?"`
		#echo "diff result: [$TEST]"
		# If Diff = false, copy tmp dump file
		if [ ! ${TEST} ]
		then
			ssh $SSHPARAMS $USER@$HOST "cp $TMP/$db.psql $DIR/$db.psql"
			echo "[$db.psql] Changes detected. New dump saved."
		else
			echo "[$db.psql] No changes detected. Nothing to save."
		fi
	else
		echo "[$db.psql] First dump created!"
		ssh $SSHPARAMS $USER@$HOST "cp $TMP/$db.psql $DIR/$db.psql"
	fi
	done
    fi
fi
exit 0
