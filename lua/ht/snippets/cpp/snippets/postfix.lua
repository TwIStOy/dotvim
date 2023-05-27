local ht_snippet = require("ht.snippets.snippet")
local snippet = ht_snippet.build_snippet
local quick_expand = ht_snippet.quick_expand
local postfix = require("ht.snippets.cpp.postfix").postfix
local i = ht_snippet.insert_node
local ls = require("luasnip")
local f = ls.function_node

return {
  -- postfixes
  postfix("be", {
    f(function(_, parent)
      return ("std::begin(%s), std::end(%s)"):format(
        parent.snippet.env.POSTFIX_MATCH,
        parent.snippet.env.POSTFIX_MATCH
      )
    end, {}),
  }),
  postfix("mv", {
    f(function(_, parent)
      return ("std::move(%s)"):format(parent.snippet.env.POSTFIX_MATCH)
    end, {}),
  }),
  postfix("fwd", {
    f(function(_, parent)
      return ("std::forward<decltype(%s)>(%s)"):format(
        parent.snippet.env.POSTFIX_MATCH,
        parent.snippet.env.POSTFIX_MATCH
      )
    end, {}),
  }),
  postfix("val", {
    f(function(_, parent)
      return ("std::declval<%s>()"):format(parent.snippet.env.POSTFIX_MATCH)
    end, {}),
  }),
  postfix("uu", {
    f(function(_, parent)
      return ("(void)%s;"):format(parent.snippet.env.POSTFIX_MATCH)
    end, {}),
  }),
  postfix("dt", {
    f(function(_, parent)
      return ("decltype(%s)"):format(parent.snippet.env.POSTFIX_MATCH)
    end, {}),
  }),
}
