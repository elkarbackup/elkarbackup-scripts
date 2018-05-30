## export-encrypted

This ElkarBackup post-script will keep an encrypted copy of a custom client/job backup files. It can be useful to upload it to a non-secure cloud storage (Dropbox, Google Drive, OneDrive, etc).

[EncFS](https://en.wikipedia.org/wiki/EncFS) will be used to encrypt files.

Data will be duplicated (encrypted) in the destination directory. Be sure you have enough free disk space.

[Download URL](https://github.com/elkarbackup/elkarbackup-scripts/raw/master/export-encrypted/export-encrypted.sh)

### Configuration

Script level configuration:

| Script              | Enabled  |
| ------------------- | -------- |
| CLIENT PRE-SCRIPT   |  NO      |
| CLIENT POST-SCRIPT  |  __YES__ | 
| JOB PRE-SCRIPT      |  NO      |
| JOB POST-SCRIPT     |  __YES__ |

### Instructions

Install EncFS:

```bash
apt-get install encfs
```

Create your encrypted virtual filesystem in your preferred destination:

```bash
mkdir /var/lib/elkarbackup/Dropbox/elkarbackup
encfs /var/lib/elkarbackup/Dropbox/elkarbackup /mnt
#- select "standard" mode (ENTER)
#- type a password for your encrypted volume
umount /mnt
```

Edit the `export-encrypted.sh` script preferences:

```bash
# Destination directory (EncFS volume)
VOLUME_PATH=/var/lib/elkarbackup/Dropbox/elkarbackup
# EncFS password
VOLUME_PASSWD="qwerty"
```

Upload the script to the ElkarBackup web interface and enable it under a client or a job.
