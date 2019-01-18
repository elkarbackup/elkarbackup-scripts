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
Path: /home/elkar/DB (for instance)
Description: PostgreSQL dumps
Pre-script enabled: backup-PostgreSQL.sh

```

PostgreSQL dumps will be copied to the "Path" field (example: /root/backups/PostgreSQL) and ElkarBackup will save this directory. If "Path" directory doesn't exist, it will be created on first execution.


### Login to PostgreSQL without password (.pgpass)


To run "psql" and "pg_dump" without password prompt, This script needs (~/.pgpass) files with this format:

`"localhost:5432:*:username:password"`


Important: this file must have 400 permissions:

`chmod 0400 ~/.pgpass`
