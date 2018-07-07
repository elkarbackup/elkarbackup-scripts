#! /usr/bin/env python3

import os
import json
from datetime import *

LOGFILE = "/var/log/elkarbackup/elkarbackup.log.json"

def getEnvars():
    envars = {}
    for key in os.environ:
        if key.startswith('ELKARBACKUP'):
            value = os.environ.get(key)
            envars[key] = value
    return envars

def getFulltimestamp():
    return datetime.now(timezone.utc).isoformat()

if __name__ == '__main__':
    data = getEnvars()
    data['time'] = getFulltimestamp()
    
    # Save it to json logfile
    with open(LOGFILE, 'a') as logfile:
        json.dump(data, logfile)
        logfile.write('\n')