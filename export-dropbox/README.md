## export-dropbox

This script will sync your Dropbox directory. You don't need a script to do
that, but this script will manage the daemon and will avoid to run Dropbox
when you don't need it.
 - The Dropbox daemon will be started
 - The Dropbox directory will be synchronized with the cloud
 - The Dropbox daemon will be stopped

It can be specially useful in combination to the [export-encrypted](https://github.com/elkarbackup/elkarbackup-scripts/tree/master/export-encrypted) script.

[Download URL](https://github.com/elkarbackup/elkarbackup-scripts/raw/master/export-dropbox/export-dropbox.sh)

### Configuration

Script level configuration:

| Script              | Enabled  |
| ------------------- | -------- |
| CLIENT PRE-SCRIPT   |  NO      |
| CLIENT POST-SCRIPT  |  __YES__ | 
| JOB PRE-SCRIPT      |  NO      |
| JOB POST-SCRIPT     |  __YES__ |

If you are using it in combination with `export-encrypted.sh` script, make sure that the
`export-dropbox.sh` is executed after the `export-encrypted.sh`.

### Instructions

Download Dropbox:

```bash
su - elkarbackup
# Download the daemon (will be stored at ~/.dropbox-dist)
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# Download the CLI utility
wget -O ~/.dropbox-dist/dropbox.py "https://www.dropbox.com/download?dl=packages/dropbox.py && chmod 755 ~/.dropbox-dist/dropbox.py"
```

Link your Dropbox account to the computer:

```bash
# Start the daemon and follow the instructions to link
# the account and your computer
./dropbox-dist/dropboxd &
```

Once done that, /var/lib/elkarbackup/Dropbox will be created and will start syncing.
