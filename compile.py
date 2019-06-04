#!/usr/bin/env python3

import sys
import os
import functools
import re
import subprocess
import fcntl
import select
import chardet

@functools.lru_cache(maxsize=8)
def media_build_root():
    cur = os.getcwd()

    def check_directory(d):
        if d == '/':
            return None
        if os.path.exists(os.path.join(d, 'BLADE_ROOT')):
            return d
        return check_directory(os.path.split(d)[0])

    return check_directory(cur)


class bcolors:
    """
    Terminal Colors
    """
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def make_async(fd):
    """
    Helper function to add the O_NONBLOCK flag to a file descriptor
    """
    fcntl.fcntl(fd, fcntl.F_SETFL, fcntl.fcntl(fd, fcntl.F_GETFL) | os.O_NONBLOCK)

def read_async(fd):
    """
    Helper function to read some data from a file descriptor, ignoring EAGAIN errors
    """
    try:
        return fd.read()
    except IOError as e:
        if e.errno != errno.EAGAIN:
            raise e
    else:
        return ''

pattern = re.compile(r'^([\w/.]+?\.(?:cpp|h|cc|hh)):', re.M)
pattern2 = re.compile(r'(\s+from )([\w/.]+?\.(?:cpp|h|cc|hh)):', re.M)

def repl1(m):
    p = os.path.join(media_build_root(), m.group(1))
    if os.path.exists(p):
        return p + ':'
    return m.group(1) + ':'

def repl2(m):
    p = os.path.join(media_build_root(), m.group(2))
    return "{}{}:".format(m.group(1), p if os.path.exists(p) else m.group(2))

# repl = r'{}/\1'.format(media_build_root())
# repl2 = r'\1{}/\2'.format(media_build_root())

def run_command(cmd, cwd=None, silence=False):
    """
    Run command, get stdout and stderr
    """
    print("Run command:", cmd, ", with cwd:", cwd)
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)

    make_async(process.stdout)
    make_async(process.stderr)

    return_code = None

    while True:
        # Wait data to become avaliable
        rs, _, _ = select.select([process.stdout, process.stderr], [], [])

        for r in rs:
            piece = read_async(r)
            if piece:
                piece = piece.decode(chardet.detect(piece)['encoding'])
                piece = re.sub(pattern, repl1, piece)
                piece = re.sub(pattern2, repl2, piece)

                print(piece, end="")
                sys.stdout.flush()

        return_code = process.poll()

        if return_code != None:
            if return_code != 0:
                print("Compile failed...", end="")
                exit(0)
            return

def main():
    root = media_build_root()
    if root is None:
        print('not in media_build project...')
        return

    run_command(['fish', '-c', 'drun_for_vim make'], cwd=media_build_root())


if __name__ == '__main__':
    main()

