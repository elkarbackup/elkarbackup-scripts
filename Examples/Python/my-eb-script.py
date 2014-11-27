#! /usr/bin/env python

import os

FILE = '/tmp/my-eb-script.out'

def getEnvVars():
  env = {
    'level': str(os.environ['ELKARBACKUP_LEVEL']),
    'event': str(os.environ['ELKARBACKUP_EVENT']),
    'url': str(os.environ['ELKARBACKUP_URL']),
    'id': str(os.environ['ELKARBACKUP_ID']),
    'path': str(os.environ['ELKARBACKUP_PATH']),
    'status': str(os.environ['ELKARBACKUP_STATUS']),
    'user': str(os.environ['USER'])
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
