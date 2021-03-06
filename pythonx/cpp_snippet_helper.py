def short_nameset_parse(s):
    def p(*args):
        if len(args) == 2:
            tp = 'std::pair<{}>'
        else:
            tp = 'std::tuple<{}>'
        return tp.format(", ".join(args))

    simple_types = ['i', 'u', 's']
    long_name_types = {
        'i': 'int32_t',
        'u': 'uint32_t',
        'ii': 'int64_t',
        'uu': 'uint64_t',
        's': 'std::string',
        'i8': 'int8_t',
        'i16': 'int16_t',
        'i32': 'int32_t',
        'i64': 'int64_t',
        'u8': 'uint8_t',
        'u16': 'uint16_t',
        'u32': 'uint32_t',
        'u64': 'uint64_t'
    }

    def cpp_type_fullname(s):
        return long_name_types.get(s, s)

    gbl = {}
    gbl['p'] = p
    for k1 in simple_types:
        for k2 in simple_types:
            gbl['p{}{}'.format(k1, k2)] = p(cpp_type_fullname(k1),
                                            cpp_type_fullname(k2))

    gbl.update(long_name_types)

    try:
        return eval(s, gbl)
    except:
        return s


def underscore_to_big_camel_case(s):
    return "".join([i.capitalize() for i in s.split('_')])

def function_helpers(s, snip):
    gbl = {}
    def namespace_generator(*args):
        nonlocal snip
        lines = []
        args = list(args)
        for name in args:
            lines.append(f'namespace {name} ' + '{')
        lines.append('${0: /* body */}')
        args.reverse()
        for name in args:
            lines.append('}' + f'  // namespace {name}')
        return "\n".join(lines)

    gbl['ns'] = namespace_generator

    try:
        snip.rv = eval(s, gbl)
    except:
        snip.rv = s

def expand_anon(snip):
    import vim
    anon = []
    for i in range(snip.snippet_start[0], snip.snippet_end[0] + 1):
        anon.append(snip.buffer[i])
    old_line = snip.snippet_start[0]
    # delete these lines
    snip.buffer[snip.snippet_start[0]:snip.snippet_end[0] + 1] = ['']
    vim.current.window.cursor = (old_line, 0)
    snip.expand_anon('\n'.join(anon))

def cpp_c_style_header_guard(filename):
    import os
    def find_project_home(cur):
        if cur == '/':
            return None
        f_path = os.path.join(cur, '.git')
        if os.path.exists(f_path):
            return cur
        return find_project_home(os.path.dirname(cur))

    def to_upper_style(n):
        return n.replace('\\', '_').replace('/', '_').upper()

    d, f = os.path.split(filename)
    project_home = find_project_home(d)

    template = """#ifndef {GUARD}_H_
#define {GUARD}_H_

{RES}

#endif  // {GUARD}_H_"""

    if project_home is None:
        filepath = f
    else:
        filepath = os.path.relpath(filename, project_home)
    basename, ext = os.path.splitext(filepath)
    return template.format(GUARD=to_upper_style(basename),
                           RES='${0:/* body */}')


def simple_namespace_generate(s, snip):
    lines = []

    def gen_namespace(names):
        nonlocal lines
        if names:
            name = names[0]
            lines.append(f'namespace {name} ' + '{')
            gen_namespace(names[1:])
            lines.append('}' + f'  // namespace {name}')
        else:
            lines.append('')
            lines.append('${0: /* body */}')
            lines.append('')

    gen_namespace(s.split('::'))
    for line in lines:
        snip += line


def simple_int_types(base_type, length, snip):
    if base_type == 'i':
        int_base_type = 'int'
    elif base_type == 'u':
        int_base_type = 'uint'

    suffix = '_t'

    snip.rv = f'{int_base_type}{length}{suffix}'


_POSTFIX_TEMPLATES = {
    "for": """for (auto&& item : {0}) {{
  ${{0:/* body */}}
}}""",
    "fori": """for (auto i = 0u; i < {0}; ++i) {{
  ${{0:/* body */}}
}}""",
    "if": """if ({0}) {{
  ${{0:/* body */}}
}}""",
    "be": """std::begin({0}), std::end({0})""",
}

def postfix_templates(key, s, snip):
    snip.rv = _POSTFIX_TEMPLATES.get(key, "{0}").format(s)

