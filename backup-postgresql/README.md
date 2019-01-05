## backup-postgresql.sh

This script backups all your client's PostgreSQL databases in individual files.
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
Name: PostgreSQL
Path: /root/backups/PostgreSQL (for instance)
Description: PostgreSQL dumps
Pre-script enabled: backup-PostgreSQL.sh

```

PostgreSQL dumps will be copied to the "Path" field (example: /root/backups/PostgreSQL) and ElkarBackup will save this directory. If "Path" directory doesn't exist, it will be created on first execution.


### In non-debian based distributions


This script logs in PostgreSQL thanks to /etc/PostgreSQL/debian.cnf file. In non-debian based distributions follow next steps.

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
