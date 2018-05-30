elkarbackup-scripts
===================

Official scripts for [Elkarbackup](http://github.com/elkarbackup/elkarbackup):

| Name           | Description            |
| -------------- | ---------------------- |
| [dropbox.sh](https://github.com/elkarbackup/elkarbackup-scripts/blob/master/dropbox/) | Upload your files to Dropbox |
| [encrypt.sh](https://github.com/elkarbackup/elkarbackup-scripts/blob/master/encrypt/) | Encrypt your backup files (with EncFS) |
| [json-report.py](https://github.com/elkarbackup/elkarbackup-scripts/blob/master/json-report/) | Print backup result in json format |
| [mysqldump.sh](https://github.com/elkarbackup/elkarbackup-scripts/blob/master/mysqldump/) | Dump all the MySQL databases from the client's host |
| [nagios.sh](https://github.com/elkarbackup/elkarbackup-scripts/blob/master/nagios/) | Report the backup job result to Nagios (via NSCA) |
| [permissions.sh](https://github.com/elkarbackup/elkarbackup-scripts/tree/master/permissions) | Back up permissions/ownership in a file (with getfacl) |  


## Create your own script
### Available environment variables in scripts

You can use [My-eb-script.py](https://github.com/elkarbackup/elkarbackup-scripts/blob/master/Examples/Python/README.md) for testing purposes. It will create a file in `/tmp` directory with the output of all available environment variables. Example:

```py
status: 0
job-total-size: 268
job-name: tmp
level: JOB
url: vagrant@192.168.33.10:/tmp
client-start-time: 0
job-start-time: 1430387642
client-name: srv01
id: 1
recipient-list:
client-total-size: 268
owner-email: example@gmail.com
client-end-time: 0
job-end-time: 1430387643
path: /var/spool/elkarbackup/backups/0001/0001
user: root
event: POST
job-run-size: 40
```

Some of these variables can be empty depending on the context (pre/post or client/job).
