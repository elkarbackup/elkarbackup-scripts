## report-json

It creates a report with all the available environment variables from the running backup job. Output is in JSON format.

[Download URL](https://github.com/elkarbackup/elkarbackup-scripts/raw/master/report-json/report-json.py)

### Configuration

Script level configuration:

| Script              | Enabled  |
| ------------------- | -------- |
| CLIENT PRE-SCRIPT   |  __YES__ |
| CLIENT POST-SCRIPT  |  __YES__ | 
| JOB PRE-SCRIPT      |  __YES__ |
| JOB POST-SCRIPT     |  __YES__ |

Currently, you only can see the JSON output in the logs, but would be easy to send de JSON to a log server for instance.

![Screenshot log](https://cloud.githubusercontent.com/assets/1846038/10399072/d2f616ce-6eb0-11e5-8f63-5f1ba2abcebc.png)
