## backup-permissions.sh

This script will back up file ownership and permissions in the backup directory
recursively.

It requires ACL utilities in the client host. You can install the package with the following
command: `apt-get install acl` (Debian based distributions)

[Download URL](https://github.com/elkarbackup/elkarbackup-scripts/raw/master/permissions/backup-permissions.sh)

The scripts uses `eb-remote.sh` library. You can [download it](https://github.com/elkarbackup/elkarbackup-scripts/raw/master/permissions/eb-remote.sh)
and save it in your _uploads/lib_ directory:

```sh
cd /var/spool/elkarbackup/uploads
mkdir lib && cd lib
wget https://github.com/elkarbackup/elkarbackup-scripts/raw/master/permissions/eb-remote.sh
```

### Configuration

Script level configuration:

```
CLIENT PRE-SCRIPT:    NO
CLIENT POST-SCRIPT:   NO
JOB PRE-SCRIPT:       YES
JOB POST-SCRIPT:      YES
```


### Permissions restore

You can restore the permissions with the following command:

```bash
setfacl --restore=permissions.facl
```
