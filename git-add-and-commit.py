#!/usr/bin/env python3

import argparse
import subprocess
import datetime
import os


def repo_home():
    p = subprocess.Popen(
        ["git", "rev-parse", "--show-toplevel"], stdout=subprocess.PIPE
    )
    p.wait()
    return p.stdout.read().decode().strip()


def get_uncommit_changes():
    p = subprocess.Popen(["git", "status", "--porcelain"], stdout=subprocess.PIPE)
    p.wait()
    return p.stdout.read().decode().strip()


def update_version():
    version_template = """
return {{
  version = function()
    return "{}.{:02d}.{:02d}"
  end,
}}
"""
    now = datetime.datetime.now()
    version_str = version_template.format(now.year, now.month, now.day)
    with open(os.path.join(repo_home(), "lua/dotvim/version.lua"), "w") as fp:
        fp.write(version_str)


parser = argparse.ArgumentParser(description="Update version and commit changes")
parser.add_argument("message", help="Commit message")
parser.add_argument("-y", "--yes", action="store_true", help="Skip confirmation prompt")
args = parser.parse_args()


update_version()
uncommit_changes = get_uncommit_changes().splitlines()
if not uncommit_changes:
    print("Working tree is clean...")
else:
    now = datetime.datetime.now()
    print("   Today: {}.{}.{}".format(now.year, now.month, now.day))
    print(" Changes:")
    for c in uncommit_changes:
        print(c)
    if not args.yes:
        continue_ask = input("Continue? [y/N] ")
        if continue_ask != "y":
            print("Abort")
            exit(1)
    subprocess.run(["git", "add", "--all"])
    subprocess.run(["git", "commit", "-m", args.message])
