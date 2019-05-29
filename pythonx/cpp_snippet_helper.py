def cpp_type_fullname(s):
    return {
        'i': 'int32_t',
        'u': 'uint32_t',
        'ii': 'int64_t',
        'uu': 'uint64_t',
        's': 'std::string',
    }.get(s, s)

# pii
# piu
# puu
# psu
# pus
# pii
# p(u,s)
# p(i,i)
# p(i, i)
# p(pii,i)
def short_nameset_parse(s):
    import re
    def simple(ss):
        return 'std::pair<{}, {}>'.format(cpp_type_fullname(ss[0]),
                                          cpp_type_fullname(ss[1]))
    if len(s) == 2:
        return simple(s)

    args = re.compile('\((.*)\)').match(s).group(1)
    args = [item.strip() for item in args.split(',')]
    args = [simple(item[1:]) if len(item) == 3 and item[0] == 'p'
            else cpp_type_fullname(item) for item in args]

    return "{}<{}>".format( 'std::pair' if len(args) == 2 else 'std::tuple',
                           ", ".join(args))

