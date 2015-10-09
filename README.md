elkarbackup-scripts
===================

Official Pre-scripts and Post-scripts for [Elkarbackup](http://github.com/elkarbackup/elkarbackup) backup software

  * [MySqlDumpAllDatabases.sh](https://github.com/elkarbackup/elkarbackup-scripts/blob/master/MySqlDumpAllDatabases/README.md)
  * [Nagios.sh](https://github.com/elkarbackup/elkarbackup-scripts/blob/master/Nagios/README.md)
  * [ebReport](https://github.com/elkarbackup/elkarbackup-scripts/blob/master/ebReport/README.md)
  * Example: [My-eb-script.py](https://github.com/elkarbackup/elkarbackup-scripts/blob/master/Examples/Python/README.md)


## Create your own script
### Available environment variables in scripts

You can use `My-eb-script.py` for testing purposes. It will create a file in `/tmp` directory with the output of all available environment variables. Example:

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
