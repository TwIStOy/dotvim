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

_POSTFIX_STD_FORWARD_VALUE = 'std::forward<${1}>(`!p snip.rv = match.group(1)`)${0}'

_POSTFIX_STD_DECLVAL_VALUE = 'std::declval<`!p snip.rv = match.group(1)`>()${0}'

_POSTFIX_IGNORE_UNUSED_VALUE = '(void)`!p snip.rv = match.group(1)`;${0}'

_POSTFIX_RETURN_VALUE = 'return `!p snip.rv = match.group(1)`;${0}'

_POSTFIX_REQUIRE_VALUE = 'REQUIRE(`!p snip.rv = match.group(1)`);'


def register_postfix_snippets():
  import vim
  if vim.vars.get('cpp_postfix_snippets_added', 0) > 0:
    return
  vim.vars['cpp_postfix_snippets_added'] = 1

  postfix_mappings = {
    "for":  [ _POSTFIX_FOR_LOOP_VALUE, "for-loop" ],
    'fori': [ _POSTFIX_FOR_I_LOOP_VALUE, "for-i-loop"],
    'if':   [ _POSTFIX_IF_VALUE, "if-expr"],
    'be':   [ _POSTFIX_BEGIN_END_VALUE, "begin-end"],
    'mv':   [ _POSTFIX_STD_MOVE_VALUE, "std::move"],
    'fwd':  [ _POSTFIX_STD_FORWARD_VALUE, "std::forward"],
    'dv':   [ _POSTFIX_STD_DECLVAL_VALUE, "std::declval"],
    'uu':   [ _POSTFIX_IGNORE_UNUSED_VALUE, "ignore unused value"],
    'rt':   [ _POSTFIX_RETURN_VALUE, "return"],
    'rq':   [ _POSTFIX_REQUIRE_VALUE, "REQUIRE(catch.hpp)"],
  }

  for postfix, action in postfix_mappings.items():
    UltiSnips_Manager.add_snippet(EXPR_REGEX + r'\.' + postfix, action[0],
                                  f"Postfix {action[1]}", 'r', 'cpp', -49)


# vim: et sw=2 ts=2
