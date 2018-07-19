## backup-permissions

This script will back up the ownership and permissions in the backup directory
recursively. It will obtain files/directories permissions inside the job
path and it will save them in a single file (`permissions.facl`), which will
be stored into the job backup directory's root.

Benefits:
 - Preserve ownership
 - Permissions changelog

#### Caution
This script will generate a temporary file (`permissions.facl`) in the job path, into the client host. This text file contains a list of file paths and it's permissions. By default this file will be deleted in the post-script level. Anyway, you need to know that if your directory is a publickly accessible path (i.e. apache webroot, samba share, etc), anyone could access this file during the backup process.

Workaround: change the `ACLFILE` path to a different directory (i.e. /etc/elkarbackup/permissions.facl). You will need create a new backup job for this directory (/etc/elkarbackup).

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
