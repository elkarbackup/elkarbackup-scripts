#!/bin/bash

#
# Name:MySqlDumpAllDatabases.sh
# Description: This script backups all your local MySQL databases in individual files
#              It will copy to Elkarbackup only the modified databases.
# Use:  JOB level -> Pre-Script
#       Will only work with Debian/Ubuntu MySQL servers (MYSQLCNF=/etc/mysql/debian.cnf)
#       In other distributions, you have to create "/root/.my.cnf" file (chmod 400) and change MYSQLCNF path
#

#ELKARBACKUP_URL = user@serverip:/path
URL=`echo $ELKARBACKUP_URL | cut -d ":" -f1`    # user@serverip
USER="${URL%@*}"                                # user
HOST="${URL#*@}"                                # host
DIR=`echo $ELKARBACKUP_URL | cut -d ":" -f2`    # path
TMP=/tmp/ebmysqldump

SSHPARAMS='-i /var/lib/elkarbackup/.ssh/id_rsa -o StrictHostKeyChecking=no'

MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
MYSQLCNF=/etc/mysql/debian.cnf
#MYSQLCNF=/root/.my.cnf

TEST=`ssh $SSHPARAMS $USER@$HOST "test -f $MYSQLCNF && echo $?"`
if [ ! ${TEST} ]; then
    echo "[ERROR] mysql config file doesn't exist $MYSQLCNF"
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

    # Get all databases list
    databases=`ssh $SSHPARAMS $USER@$HOST "$MYSQL --defaults-file=$MYSQLCNF -e \"SHOW DATABASES;\"" | grep -Ev "(Database|information_schema)"`
    RESULT=$?
    if [ $RESULT -ne 0 ]; then
        echo "ERROR: $databases"
        exit 1
    else

    for db in $databases; do
        # Dump it!
        ssh $SSHPARAMS $USER@$HOST "$MYSQLDUMP --defaults-file=$MYSQLCNF --force --opt --databases $db --single-transaction > \"$TMP/$db.sql\""
        # If we already have an old version...
        TEST=`ssh $SSHPARAMS $USER@$HOST "test -f $DIR/$db.sql && echo $?"`
        if [ ${TEST} ]; then
            # Diff
            #echo "making a diff"
            TEST=`ssh $SSHPARAMS $USER@$HOST "diff -q <(cat $TMP/$db.sql|head -n -1) <(cat $DIR/$db.sql|head -n -1) > /dev/null && echo $?"`
            #echo "diff result: [$TEST]"
            # If Diff = false, copy tmp dump file
            if [ ! ${TEST} ]; then
                ssh $SSHPARAMS $USER@$HOST "cp $TMP/$db.sql $DIR/$db.sql"
                echo "[$db.sql] Changes detected. New dump saved."
            else
                echo "[$db.sql] No changes detected. Nothing to save."
            fi
        else
            echo "[$db.sql] First dump created!"
            ssh $SSHPARAMS $USER@$HOST "cp $TMP/$db.sql $DIR/$db.sql"
        fi
    done
fi

exit 0
