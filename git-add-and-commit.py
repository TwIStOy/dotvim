#!/usr/bin/env python3

import subprocess
import datetime
import os
import sys

def repo_home():
  p = subprocess.Popen(['git', 'rev-parse', '--show-toplevel'], stdout=subprocess.PIPE)
  p.wait()
  return p.stdout.read().decode().strip()


def get_uncommit_changes():
  p = subprocess.Popen(['git', 'status', '--porcelain'], stdout=subprocess.PIPE)
  p.wait()
  return p.stdout.read().decode().strip()


def update_version():
  version_template = '''
return {{
  version = function()
    return "{}.{:02d}.{:02d}"
  end,
}}
'''
  now = datetime.datetime.now()
  version_str = version_template.format(now.year, now.month, now.day)
  with open(os.path.join(repo_home(), 'lua/dotvim/version.lua'), 'w') as fp:
    fp.write(version_str)


if len(sys.argv) <= 1:
  print('Require commit message!')
  exit(1)


uncommit_changes = get_uncommit_changes().splitlines()
if not uncommit_changes:
  print('Working tree is clean...')
else:
  now = datetime.datetime.now()
  print('   Today: {}.{}.{}'.format(now.year, now.month, now.day))
  print(' Changes:')
  for c in uncommit_changes:
    print(c)
  continue_ask = input('Continue? [y/N] ')
  if continue_ask != 'y':
    print('Abort')
    exit(1)
  else:
    update_version()
    subprocess.run(['git', 'add', '--all'])
    subprocess.run(['git', 'commit', '-m', sys.argv[1]])

# vim: sw=2 ts=2
