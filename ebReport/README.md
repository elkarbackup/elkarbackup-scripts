## ebReport-script

It creates a report with all the available environment variables from the running backup job. Output is in JSON format.

[Download URL](https://github.com/elkarbackup/elkarbackup-scripts/raw/master/ebReport/ebReport-script.py)

### Configuration

Script level configuration:

```
CLIENT PRE-SCRIPT:    YES
CLIENT POST-SCRIPT:   YES
JOB PRE-SCRIPT:       YES
JOB POST-SCRIPT:      YES
```

Currently, you only can see the JSON output in the logs.

![Logs screenshot with ebReport script output](https://cloud.githubusercontent.com/assets/1846038/10399072/d2f616ce-6eb0-11e5-8f63-5f1ba2abcebc.png)
