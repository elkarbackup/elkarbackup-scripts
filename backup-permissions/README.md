## backup-permissions

This script will back up the ownership and permissions in the backup directory
recursively. It will obtain files/directories permissions inside the job
path and it will save them in a single file (`permissions.facl`), which will
be stored into the job backup directory's root.

Benefits:
 - Preserve ownership
 - Permissions changelog

### Requirements

You need to have ACL utilities installed in the client host: `apt-get install acl` (Debian based distributions)

### Installation

[Download URL](https://github.com/elkarbackup/elkarbackup-scripts/raw/master/backup-permissions/backup-permissions.sh)

### Configuration

Script level configuration:

| Script              | Enabled  |
| ------------------- | -------- |
| CLIENT PRE-SCRIPT   |  NO      |
| CLIENT POST-SCRIPT  |  NO      | 
| JOB PRE-SCRIPT      |  __YES__ |
| JOB POST-SCRIPT     |  __YES__ |

- To enable the JOB POST-SCRIPT it's optional. When you enable it, the script removes
the `permissions.facl` file from the client after upload it to the ElkarBackup server


### Permissions restore

If you need to restore the permissions, you can use the following command:

```bash
cd /mydatadir
setfacl --restore=permissions.facl
```

More info about getfacl: http://man7.org/linux/man-pages/man1/getfacl.1.html
