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
        snip.rv = eval(s,gbl)
        # UltiSnips_Manager.expand_anon(tmp)
    except:
        snip.rv = s

def expand_anon(snip):
    print(snip.snippet_start, snip.snippet_end)
    anon = []
    for i in range(snip.snippet_start[0], snip.snippet_end[0] + 1):
        anon.append(snip.buffer[i])
    snip.buffer[snip.snippet_start[0]:snip.snippet_end[0] + 1] = ['']
    snip.expand_anon('\n'.join(anon))
