## report-nagios

Report to Nagios via NSCA the backup job result

[Download URL](https://github.com/elkarbackup/elkarbackup-scripts/raw/master/report-nagios/report-nagios.sh)

### Configuration

Steps for setting up:

 - Install and configure NSCA service in Nagios server (Debian nsca package)
 - Install and configure NSCA client in Elkarbackup server (Debian send_nsca package)
 - Be sure to configure the same password and cipher in both client and server NSCA
 - Configure services in Nagios:
  * Accept passive checks
  * service_description MUST be $ELKARBACKUP_URL, ie: <client_url>:<task_path>
 - Configure CFG_* parameter in this script

This script sends as output log $ELKARBACKUP_PATH
