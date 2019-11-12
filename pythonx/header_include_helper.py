import os
import re
import typing
import itertools

# find '.git' file
def _find_project_home(cur):
    root, _ = os.path.split(cur)
    if root == cur:
        return None

    checking_file = os.path.join(cur, '.git')
    if os.path.exists(checking_file):
        return cur

    return _find_project_home(root)

def _check_file_exists(*args):
    p = os.path.join(*args)
    return os.path.exists(p) and os.path.isfile(p)

def _flat_list(item, out):
    if isinstance(item, typing.Iterable) and not isinstance(item, str):
        for i in item:
            _flat_list(i, out)
    else:
        out.append(item)

def _replace_path(path, old, new):
    parts = os.path.normpath(path).split(os.sep)
    parts = [i if i else '/' for i in parts]
    parts.reverse()
    new_parts = []
    found = False
    for i in parts:
        if i == old and not found:
            found = True
            new_parts.append(new)
        else:
            new_parts.append(i)

    new_parts.reverse()

    parts = []
    _flat_list(new_parts, parts)

    return os.path.join(*parts)

def generate_cpp_header_filename(vim):
    path = vim.eval('expand("%:p")')

    headers = {
        '.cpp': ['.h', '.hpp'],
        '.cc': ['.hh'],
        '.cxx': ['.hxx']
    }

    include_path_replace = [
        ('src', 'include'),
        ('src', 'include/**'),
        ('src', '../include')
    ]

    dirname, filename = os.path.split(path)
    basename, ext = os.path.splitext(filename)

    project_home = _find_project_home(dirname)
    if project_home is None:
        project_home = vim.eval('getcwd()')

    header_ext = headers.get(ext, None)
    if header_ext is None:
        return f"// invalid cpp source file ext... [{ext}]"

    header_filename_candidates = [f"{basename}{e}" for e in header_ext]
    folder_candidates = [dirname]

    if re.match(r'\bsrc\b', dirname):
        folder_candidates.append(_replace_path(dirname, 'src', 'include'))
        folder_candidates.append(_replace_path(dirname, 'src',
                                               ['..', 'include']))

    selected = [
        os.path.join(candidate[1], candidate[0])
        for candidate in itertools.product(header_filename_candidates,
                                           folder_candidates)
        if _check_file_exists(os.path.join(candidate[1], candidate[0]))
    ]

    if not selected:
        return '// no header files...'

    relp = os.path.relpath(selected[0], project_home)
    # print('Selected:', selected[0], home_path, 'Relp:', relp)

    return f'#include "{relp}"'

