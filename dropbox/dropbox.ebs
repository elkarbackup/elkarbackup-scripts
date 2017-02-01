#! /bin/bash

HOME="/var/lib/elkarbackup/"
PYTHON_BIN=`which python`
#DROPBOX_BIN="$HOME/.dropbox-dist/dropboxd"
DROPBOX_CLI="$PYTHON_BIN $HOME/.dropbox-dist/dropbox.py"
updated=0

# Start Dropbox daemon
$DROPBOX_CLI start

# Check the status
while [ $($DROPBOX_CLI running; echo $?) -ne 0 ]
do
  # Check the status
  if [ "$($DROPBOX_CLI status)" == "Up to date" ]
  then
    updated=1
    break
  fi
done

if [ $updated -ne 1 ]
then
  echo "[ERROR] Dropbox daemon stopped unexpectedly"
  exit 1
else
  echo "[OK] Dropbox synchronized successfully"
  $DROPBOX_CLI stop && exit 0
fi
