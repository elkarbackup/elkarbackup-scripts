#! /usr/bin/env python

import os
import json

# Mapped vars
DATA = {
    'id':       'ELKARBACKUP_ID',
    'status':   'ELKARBACKUP_STATUS',
    'cname':    'ELKARBACKUP_CLIENT_NAME',
    'jname':    'ELKARBACKUP_JOB_NAME',
    'oemail':   'ELKARBACKUP_OWNER_EMAIL',
    'rlist':    'ELKARBACKUP_RECIPIENT_LIST',
    'ctsize':   'ELKARBACKUP_CLIENT_TOTAL_SIZE',
    'jtsize':   'ELKARBACKUP_JOB_TOTAL_SIZE',
    'jrsize':   'ELKARBACKUP_JOB_RUN_SIZE',
    'cstime':   'ELKARBACKUP_CLIENT_STARTTIME',
    'cetime':   'ELKARBACKUP_CLIENT_ENDTIME',
    'jstime':   'ELKARBACKUP_JOB_STARTTIME',
    'jetime':   'ELKARBACKUP_JOB_ENDTIME',

}

# Data to send in each event type
CLIENT_PRE = {'id','cname'}
CLIENT_POST = {'id','status','cname','ctsize','cstime', 'cetime'}
JOB_PRE = {'id','cname','jname','jtsize'}
JOB_POST = {'id','status','cname','jname','oemail','ctsize','jtsize','jrsize','jstime', 'jetime'}

# Defined event types. Variables variables - do not edit
ETYPE = {
    'CLIENT_PRE': CLIENT_PRE,
    'CLIENT_POST': CLIENT_POST,
    'JOB_PRE': JOB_PRE,
    'JOB_POST': JOB_POST,
}

def createJson(level, event):
    if not level or not event:
        print 'ERROR: unknown level or event'
        exit(1)

    sdata = {} # selected data
    sdata['level'] = level
    sdata['event'] = event
    for var in ETYPE['%s_%s' % (level, event)]:
        if os.environ.get(DATA[var]):
            sdata[var] = os.environ.get(DATA[var])
        else:
            print 'WARNING: unknown value for %s' % var

    json_data = json.dumps(sdata)
    return json_data

if __name__ == '__main__':
    '''
    # Uncomment to TEST the script outside elkarbackup
    os.environ['ELKARBACKUP_LEVEL'] = 'JOB'
    os.environ['ELKARBACKUP_EVENT'] = 'POST'
    os.environ['ELKARBACKUP_ID'] = '2'
    os.environ['ELKARBACKUP_CLIENT_STARTTIME'] = '4434234'
    '''

    json = createJson(os.environ.get('ELKARBACKUP_LEVEL'),
                      os.environ.get('ELKARBACKUP_EVENT'))
    # For now, print json
    # TODO: send json to somewhere
    print json
