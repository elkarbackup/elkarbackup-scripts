## backup-mysql.sh

This script backups all your client's MySQL databases in individual files.
After the first copy, only modified databases will be copied.

[Download URL](https://github.com/elkarbackup/elkarbackup-scripts/raw/master/backup-mysql/backup-mysql.sh)

### Configuration

Script level configuration:

| Script              | Enabled  |
| ------------------- | -------- |
| CLIENT PRE-SCRIPT   |  NO      |
| CLIENT POST-SCRIPT  |  NO      | 
| JOB PRE-SCRIPT      |  __YES__ |
| JOB POST-SCRIPT     |  NO      |

Create a New Job:

```
Name: mysql
Path: /root/backups/mysql (for instance)
Description: MySQL dumps
Pre-script enabled: backup-mysql.sh

```

MySQL dumps will be copied to the "Path" field (example: /root/backups/mysql) and ElkarBackup will save this directory. If "Path" directory doesn't exist, it will be created on first execution.


### In non-debian based distributions


This script logs in MySQL thanks to /etc/mysql/debian.cnf file. In non-debian based distributions follow next steps.

Generate file /root/.my.cnf:

```
[mysql]
user=root
password=1234

[mysqldump]
user=root
password=1234
```

Important: this file must have 400 permissions:

`chmod 0400 /root/.my.cnf`

### If you use docker

If you use docker image you need to change path to .ssh/id_rsa in script.  
Change line: `SSHPARAMS="-i /var/lib/elkarbackup/.ssh/id_rsa -o StrictHostKeyChecking=no $ELKARBACKUP_SSH_ARGS"`  
to line: `SSHPARAMS="-i /app/.ssh/id_rsa -o StrictHostKeyChecking=no $ELKARBACKUP_SSH_ARGS"`
