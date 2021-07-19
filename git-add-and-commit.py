#!/usr/bin/env python3

import subprocess

def get_uncommit_changes():
  p = subprocess.Popen(['git', 'status', '--porcelain'], stdout=subprocess.PIPE)
  p.wait()
  return p.stdout.read().decode()

print(get_uncommit_changes())

# vim: sw=2 ts=2
