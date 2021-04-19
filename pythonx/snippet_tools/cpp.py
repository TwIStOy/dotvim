#####################
#  Postfix Section  #
#####################
from UltiSnips import UltiSnips_Manager

EXPR_REGEX = r'(?P<expr>(?P<id_expr>(?P<id>[*]?[\w_][\d\w_:]*)(?P<tpl>\<((?P<id_num>(?P<num>(0x)?[1-9]\d*)|(?P&id))(,\s*(?P&id_num))*)?\>)?(?P<init>{(?P<arg_list>(?P&expr)(,\s(?P&expr))*)?})?(?P<args>\((?P&arg_list)?\))?((->|\.)(?P&id_expr))?)|(?P&num))'

_POSTFIX_FOR_LOOP_VALUE = """for (auto&& item : `!p snip.rv = match.group(1)`) {
  ${0:/* body */}
}"""

_POSTFIX_FOR_I_LOOP_VALUE = """for (auto i = 0u; i < `!p snip.rv = match.group(1)`; ++i) {
  ${0:/* body */}
}"""

_POSTFIX_IF_VALUE = """if (`!p snip.rv = match.group(1)`) {
  ${0:/* body */}
}"""

_POSTFIX_BEGIN_END_VALUE = 'std::begin(`!p snip.rv = match.group(1)`), std::end(`!p snip.rv = match.group(1)`)${0}'

_POSTFIX_STD_MOVE_VALUE = 'std::move(`!p snip.rv = match.group(1)`)${0}'

_POSTFIX_IGNORE_UNUSED_VALUE = '(void)`!p snip.rv = match.group(1)`${0}'

_POSTFIX_RETURN_VALUE = 'return `!p snip.rv = match.group(1)`;${0}'



def register_postfix_snippets():
  UltiSnips_Manager.add_snippet(EXPR_REGEX + r'\.for', _POSTFIX_FOR_LOOP_VALUE,
                                "Postfix for-loop", 'r', 'cpp', -49)
  UltiSnips_Manager.add_snippet(EXPR_REGEX + r'\.fori', _POSTFIX_FOR_I_LOOP_VALUE,
                                "Postfix for-i-loop", 'r', 'cpp', -49)
  UltiSnips_Manager.add_snippet(EXPR_REGEX + r'\.if', _POSTFIX_IF_VALUE,
                                "Postfix if-expr", 'r', 'cpp', -49)
  UltiSnips_Manager.add_snippet(EXPR_REGEX + r'\.be', _POSTFIX_BEGIN_END_VALUE,
                                "Postfix begin-end", 'r', 'cpp', -49)
  UltiSnips_Manager.add_snippet(EXPR_REGEX + r'\.mv', _POSTFIX_STD_MOVE_VALUE,
                                "Postfix std::move", 'r', 'cpp', -49)
  UltiSnips_Manager.add_snippet(EXPR_REGEX + r'\.uu', _POSTFIX_IGNORE_UNUSED_VALUE,
                                "Postfix ignore unused value", 'r', 'cpp', -49)
  UltiSnips_Manager.add_snippet(EXPR_REGEX + r'\.rt', _POSTFIX_RETURN_VALUE,
                                "Postfix return", 'r', 'cpp', -49)


# vim: et sw=2 ts=2
