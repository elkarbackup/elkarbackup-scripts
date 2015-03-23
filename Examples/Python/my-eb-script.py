#! /usr/bin/env python

import os

FILE = '/tmp/my-eb-script.out'

def getEnvVars():
  env = {
    'level': str(os.environ.get('ELKARBACKUP_LEVEL')),
    'event': str(os.environ.get('ELKARBACKUP_EVENT')),
    'url': str(os.environ.get('ELKARBACKUP_URL')),
    'id': str(os.environ.get('ELKARBACKUP_ID')),
    'path': str(os.environ.get('ELKARBACKUP_PATH')),
    'status': str(os.environ.get('ELKARBACKUP_STATUS')),
    'client-name': str(os.environ.get('ELKARBACKUP_CLIENT_NAME')),
    'job-name': str(os.environ.get('ELKARBACKUP_JOB_NAME')),
    'owner-email': str(os.environ.get('ELKARBACKUP_OWNER_EMAIL')),
    'recipient-list': str(os.environ.get('ELKARBACKUP_RECIPIENT_LIST')),
    'client-total-size': str(os.environ.get('ELKARBACKUP_CLIENT_TOTAL_SIZE')),
    'job-total-size': str(os.environ.get('ELKARBACKUP_JOB_TOTAL_SIZE')),
    'job-run-size': str(os.environ.get('ELKARBACKUP_JOB_RUN_SIZE')),
    'user': str(os.environ.get('USER'))
  }
  return env

def writeToFile(data):
  try:
    f = open(FILE, 'a')
    f.write('---\n')
    for key,value in data.iteritems():
      f.write('%s: %s\n' % (key, value))
    f.close()
  except IOError:
    print 'Error writing file'

if __name__ == '__main__':
  env = getEnvVars()
  writeToFile(env)
  print ('Created file: ' + FILE)
