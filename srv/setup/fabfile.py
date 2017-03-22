#!/usr/bin/env python

"""
Fabric tasks for Saltstack minion hosts initialize

Pre-env:
1. salt-call state.highstate on local-repo&&salt-master server;

Functions:
1. config the local repo on minion hosts;
2. install saltstack common, minion pkgs on minion hosts;
3. config saltstack minion: "/etc/salt/minion";
4. salt-key manage on salt-master server;
5. run state.highstate on minion hosts;
6. clean minion cache: salt 'minionid' saltutil.clear_cache;
7. sync all salt data on certain minion: salt "minionid" saltutil.sync_all;
"""

import os
import sys
import json
from fabric.api import *
from fabric.contrib.files import sed, contains


env.roledefs = {
    'master': ['localhost'],
}

REPORT = {
    'tasks': [],
    'commands': [],
    'successful': [],
    'failed': []
}

TRUE_VALUES = [True, "True", "true", "yes", 1]


# === Utility functions ===
def _get_os():
    """TODO: add docstring"""
    if os.uname()[0] == 'Darwin':
        return 'mac'
    return 'linux'


def _get_user():
    """TODO: add docstring"""
    user = os.environ.get('USER')
    return user


def _run(command, **kwargs):
    """TODO: add docstring"""
    res = sudo(command, **kwargs)
    env.report['commands'].append(res.command)
    if res.failed:
        env.report['failed'].append('%s >> %s' % (res.command, res))
    else:
        env.report['successful'].append(res.command)
    return res


def _report(name=''):
    """TODO: add docstring"""
    print '========================='
    print 'TASKS REPORT:', name
    print '-------------------------'
    print 'Total tasks:', env.report['tasks'].__len__()
    print 'Total commands:', env.report['commands'].__len__()
    print 'Successful:', env.report['successful'].__len__()
    print 'Failed:', env.report['failed'].__len__()
    if len(env.report['failed']) > 0:
        print '-------------------------'
        print 'ERRORS:'
        for command in env.report['failed']:
            print ' * ', command
    print '========================='


# === Environments ===
